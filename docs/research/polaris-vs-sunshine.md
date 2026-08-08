# Polaris vs Sunshine for the NixOS Steam Session streaming setup

Research date: 2026-08-08. Polaris version researched: master @ v1.3.7 (released 2026-08-07).
Evaluated against this repo's setup (ADR 0006): gamescope 3.16 Steam Session on an HDMI dummy
plug, Sunshine with `capture = kms` + VAAPI 10-bit HEVC, 3840x2160@120 true HDR10, Moonlight TV
on LG C3 webOS, fully declarative NixOS flake management.

## TL;DR verdict

Polaris is not a better fit than Sunshine for this setup today. The one configuration that
preserves the current architecture (keep the Ly-launched gamescope Steam Session, capture the
dummy plug through KMS) exists in Polaris only as inherited, undocumented Sunshine code: Polaris
docs steer all users to its own managed runtimes instead. The intended Polaris replacement
architecture (Polaris-owned idle gamescope at 4K120, portal/PipeWire capture, HDR through the
vendored gamescope patch stack) is a genuine architectural match for "stream only an isolated
Steam session", but its true-HDR path is still being productized under an open issue (#152), was
demonstrated only at 4K60 on NVIDIA, has no AMD validation, and the AMD VAAPI DMA-BUF capture path
shipped a crash-class use-after-free until v1.3.7 (2026-08-07, one day before this research).
Combined with a 4-month-old project, a single maintainer authoring ~97% of commits, and a design
that puts the web UI (not the config file) in charge of settings, Polaris trades away this setup's
proven HDR pipeline and declarative model for features this setup does not need. Revisit when
issue #152 closes with AMD evidence.

## Comparison against hard requirements

| Requirement | Sunshine (current) | Polaris v1.3.7 | Verdict |
|---|---|---|---|
| 3840x2160@120 | Working today | gamescope_stream defaults to 3840x2160@120 (`nix/modules/options.nix`); labwc headless applies client-requested mode (changelog v1.3.5). No documented 4K120 validation on AMD; the only demonstrated HDR stack was 4K60 on NVIDIA (issue #152) | Partial, unproven on AMD |
| TRUE HDR10 with real metadata | Working today (gamescope `--hdr-enabled` writes `HDR_OUTPUT_METADATA`, Sunshine kmsgrab reads it) | KMS path reads `HDR_OUTPUT_METADATA` identically (`src/platform/linux/kmsgrab.cpp`). Documented true-HDR path is KMS/DRM only. Headless labwc/wlroots is "honest SDR" (docs/runtime.md). gamescope portal/PipeWire HDR exists in master code (`portal_grab.cpp` `is_hdr()`/`get_hdr_metadata()`, `pipewire_capture.cpp` 10-bit PQ negotiation) but is mid-productization (issue #152 open; maintainer 2026-08-06: "what do we need now is... phase 4. The HDR piece") | Regressed or unproven, depending on path |
| AMD VAAPI hardware encode | Working today, mature in nixpkgs package | Supported but "expanding validation"; NVIDIA/NVENC is the best-tested path (README compatibility matrix). RDNA4 VAAPI DMA-BUF UAF fixed in v1.3.7 (2026-08-07); open AMD stutter issue #92 (RX 9060 XT); open AMD HDR/Main10 color issue #35 | Weaker |
| KMS capture of existing external gamescope session | Yes, this is the current design | Code retained (kmsgrab + `capture = kms` config honored in `misc.cpp`), but no documented flow for capturing an external session; docs only mention KMS for the Headless Dongle path and Bazzite. Intended model is Polaris-owned runtimes | Possible in code, unsupported in docs |
| NixOS packaging | nixpkgs `sunshine` package + NixOS module, mature | Not in nixpkgs (the nixpkgs `polaris` is an unrelated music server). First-party flake with overlay, `polaris-stream` package, NixOS + home-manager + hjem modules, CI-built since v1.3.7. Rough edges: stale references to `github:luxus/polaris`, package version string `0-unstable-2026-07-28`, `meta.maintainers = [ ]` | Present, young |
| Declarative config | Working today (home-manager owns sunshine.conf; web UI edits do not persist) | Docs: "Polaris is designed to be configured from the web UI first" (docs/configuration.md). HM module only seeds `polaris.conf` when missing; "web UI owns later edits" (`nix/modules/options.nix`). Managing the file declaratively is possible but fights the designed flow; read-only tolerance undocumented | Weaker by design |
| Moonlight TV (webOS) client | Working today | Standard Moonlight protocol with manual PIN pairing claimed (README, docs/faq.md). No webOS-specific reports found in issues or docs (searched 2026-08-08) | Claimed, no webOS evidence |
| Maturity / bus factor | Org-owned (LizardByte), 100+ contributors, ~40k stars, since 2021 | 1 maintainer with 559 of ~577 commits (97%), 6 contributors total, 283 stars, created 2026-04-06, 30 releases in ~3.5 months | Much weaker |

## 1. Architecture and lineage

Documented fact:

- Polaris "builds on Apollo and Sunshine under GPLv3 lineage, and remains compatible with
  Moonlight clients" (https://github.com/papi-ux/polaris/blob/master/README.md, License section).
  License is GPLv3 (https://github.com/papi-ux/polaris/blob/master/LICENSE).
- It is Linux-only by design; Windows/macOS host ports are explicitly not planned (README).
- It speaks the GameStream/Moonlight protocol: "Polaris speaks the Moonlight protocol. Any
  Moonlight client can connect" (docs/faq.md). Standard clients get "core pairing, app launch,
  and streaming"; the richer launch-mode/watch-mode UX requires the companion Android client Nova
  (https://github.com/papi-ux/nova) (README, "For Sunshine, Apollo, and Moonlight Users").
- Pairing for standard clients: manual PIN, plus optional Trusted Pair (TOFU on trusted subnets)
  and QR for Nova (README, docs/faq.md). So "Moonlight TV" on webOS, being a standard unmodified
  Moonlight client, should pair by PIN and stream.

WebOS-specific reports: none found. Searches of the issue tracker for "webos", "moonlight tv",
and "lg tv" (2026-08-08) returned no real webOS client reports, and no docs mention webOS or
Moonlight TV. Compatibility for webOS is therefore an inference from the protocol claim, not
evidence.

Architectural difference from Sunshine: Polaris is built around owning the stream runtime. Its
documented launch modes (README, "Launch Modes Explained"; docs/stream-paths.md) are Private
Headless Stream (own labwc compositor), Gamescope Stream (own or attached gamescope), Host
Virtual Display, Mirror Desktop (stream the existing desktop), Watch Stream. The design center is
"capture a runtime Polaris spawned", not "capture an arbitrary existing display".

## 2. NixOS packaging

Sources: https://github.com/papi-ux/polaris/blob/master/flake.nix ,
https://github.com/papi-ux/polaris/blob/master/nix/README.md ,
https://github.com/papi-ux/polaris/blob/master/nix/packages/polaris-stream/default.nix

Documented fact:

- `polaris-stream` is not in nixpkgs. `search.nixos.org` matches for "polaris" are an unrelated
  self-hosted music server (checked 2026-08-08).
- The upstream flake exposes:
  - `overlays.default`: `gamescope-polaris` (with `gamescope-hdr` back-compat alias),
    `xdg-desktop-portal-gamescope`, `polaris-stream`.
  - `packages.x86_64-linux` / `aarch64-linux` (default = `polaris-stream`).
  - `nixosModules.polaris`: host plumbing only (udev rules, `uinput`/`uhid`, avahi, firewall
    ports 47984/47989/47990/48010 TCP + 47998/47999/48000/48010 UDP, user groups). No service and
    no `cap_sys_admin` grant at NixOS level.
  - `homeModules.polaris` / `hjemModules.polaris`: the per-user units: `polaris.service`,
    `polaris-gamescope-idle.service`, `polaris-portal-dbus.service`,
    `polaris-portal-gamescope.service`, `polaris-portal.service` (a private D-Bus bus plus a
    private xdg-desktop-portal with the gamescope ScreenCast backend), plus a one-time
    `polaris.conf` seed (`nix/modules/home-manager.nix`).
  - Shared defaults in `nix/modules/options.nix`: `streamMode = "gamescope_stream"`,
    width/height/refresh = 3840/2160/120, `sdrContentNits = 203`, optional `preferVkDevice`.
- CI builds the nix packages and verifies the gamescope patch stacks since v1.3.7
  (docs/changelog.md; nix/README.md CI table).
- Runtime dependency model (`polaris-stream/default.nix`): cmake build against system boost,
  LizardByte prebuilt ffmpeg (same pattern as nixpkgs sunshine), PipeWire, PulseAudio, libva,
  libdrm/gbm, avahi; wrapper PATH adds `grim`, `labwc`, `wlr-randr`, `xwayland`, `xdpyinfo`,
  `xdg-utils`; CUDA/NVENC on by default (disable with `cudaSupport = false` for a pure AMD host).
  Note: cage is legacy naming (`linux_use_cage_compositor`); the current private runtime is labwc
  (docs/runtime.md).

Realistic NixOS install (inference from the module sources):

```nix
inputs.polaris.url = "github:papi-ux/polaris";
# system: nixpkgs.overlays = [ inputs.polaris.overlays.default ];
#         imports = [ inputs.polaris.nixosModules.polaris ]; services.polaris.users = [ "..." ];
# user:   imports = [ inputs.polaris.homeModules.polaris ]; services.polaris.enable = true;
```

Caveats observed in packaging (facts): nix/README.md's example input URL still points at
`github:luxus/polaris` (the contributor who upstreamed the nix work); `polaris-stream` reports
version `0-unstable-2026-07-28` rather than the v1.3.7 tag; `meta.maintainers = [ ]`; the
home-manager module is explicitly "not CI-tested here" (nix/README.md). The flake builds the repo
checkout itself (`polarisSrc = cleanSource self`), so it tracks master, not release tags.

## 3. HDR (critical)

Sources: https://github.com/papi-ux/polaris/blob/master/docs/runtime.md (HDR and Main10),
https://github.com/papi-ux/polaris/blob/master/docs/configuration.md (Linux HDR and Main10),
https://github.com/papi-ux/polaris/issues/152 , plus source files cited inline.

Documented fact:

- Polaris gates true HDR on real metadata from the active capture path: "Polaris only advertises
  true HDR when the active capture path reports HDR display metadata. Today that means a KMS/DRM
  display path with an HDR-capable output reporting `HDR_OUTPUT_METADATA`, plus a client HDR
  request and a 10-bit-capable encoder" (docs/runtime.md). `hdr_mode = 2` forcing without
  metadata "does not create a true HDR source ... and may produce incorrect colors on some VAAPI
  stacks" (docs/configuration.md).
- Headless labwc/wlroots sessions are "intentionally treated as SDR until the headless display
  path can truthfully provide HDR metadata" (docs/configuration.md, docs/runtime.md, docs/faq.md).
- The KMS capture backend does read `HDR_OUTPUT_METADATA` from the connector and exposes it via
  `get_hdr_metadata` (`src/platform/linux/kmsgrab.cpp`, lines ~735-841). This is the same
  mechanism the current Sunshine setup relies on with gamescope `--hdr-enabled` on the dummy
  plug. Inference: if Polaris is run with `capture = kms` against the existing dummy-plug
  session, the HDR metadata path is byte-for-byte the Sunshine one. This configuration is not a
  documented Polaris flow.
- The gamescope portal/PipeWire HDR chain exists in master code but is mid-productization:
  - The vendored `gamescope-polaris` offers 10-bit BT.2020/PQ formats over PipeWire and paints PQ
    when negotiated (patch `10-pipewire-offer-10-bit-BT2020-PQ.patch`;
    https://github.com/papi-ux/polaris/blob/master/nix/patches/gamescope/README.md ).
  - Host side: `portal_grab.cpp` `is_hdr()` returns true only when the client requested HDR, a
    runtime "force HDR" flag restarted the idle gamescope with `--hdr-enabled`
    (`scripts/install/lib/polaris-gamescope-idle.sh`), and the negotiated PipeWire format is
    xBGR/xRGB_210LE; `get_hdr_metadata()` then synthesizes BT.2020 primaries, D65, 1000/1 nits,
    MaxCLL 1000 / MaxFALL 400. `pipewire_capture.cpp` negotiates 10-bit PQ pods when
    `prefer_hdr_formats` is set from the client dynamic range request.
  - Status: open issue #152 "Productize true-headless HDR through Gamescope Portal/PipeWire
    capture". Maintainer comment 2026-08-06: Phase 1 (portal/PipeWire foundation) and Phase 3
    (gamescope stream path) are on master; "the honest answer to what do we need now is...
    phase 4. The HDR piece where session intent, the negotiated 10-bit format/colorimetry, and
    the encoder metadata all have to actually agree" (maintainer comment on
    https://github.com/papi-ux/polaris/issues/152 dated 2026-08-06).
  - The only end-to-end demonstration was downstream (luxus patch stack) at "stable 4K60
    HDR/10-bit" on NVIDIA (issue #152 body). No AMD run of this stack is documented anywhere.

Answer to "is there any path today where Polaris streams true HDR10 on AMD": the documented,
supported answer is the KMS/DRM path with an HDR-capable output (which this host's dummy plug
plus gamescope `--hdr-enabled` provides under Sunshine today, and Polaris's kmsgrab reads the
same blob). The Polaris-native headless path (gamescope portal/PipeWire HDR) is code-present but
officially unfinished, NVIDIA-demonstrated only, and 4K60-demonstrated only. For AMD VAAPI the
docs recommend validating SDR first (`encoder = vaapi`, `hdr_mode = 0`) before any Main10 or HDR
attempts (docs/configuration.md).

## 4. Capture model

Sources: https://github.com/papi-ux/polaris/blob/master/docs/stream-paths.md ,
https://github.com/papi-ux/polaris/blob/master/docs/runtime.md ,
`src/platform/linux/misc.cpp`, `src/platform/linux/stream_path.cpp`,
`src/platform/linux/kmsgrab.cpp` (all in the Polaris repo).

Documented fact:

- Stream paths are (runtime x capture x topology): `headless_stream` (labwc + wlroots),
  `windowed_stream`, `desktop_display` (no private runtime + portal; "Mirror Desktop / external
  gamescope"), `host_virtual_display`, `gamescope_stream` (gamescope + portal), `headless_dongle`
  (swap the desktop onto a dummy-plug connector; "portal (default; kms optional)").
- "Mirror Desktop" (`desktop_display`) streams "the existing desktop/session" (README launch
  modes; docs/configuration.md: "stream the visible host desktop session"). For this repo's host
  that existing desktop session is Hyprland, which is intentionally never streamed. Mirror
  Desktop is the wrong tool for reaching the gamescope Steam Session.
- `gamescope_stream` attaches to an idle `gamescope-0` Wayland socket or spawns its own headless
  gamescope, then wraps app launches into it (docs/stream-paths.md, "Relation to gamescope";
  `scripts/install/lib/polaris-gamescope-idle.sh`). It does not attach to an arbitrary running
  gamescope such as the Ly-greeter Steam Session; "idle" is enforced through a lock/marker
  protocol owned by Polaris's own scripts.
- The raw KMS capture backend survives from Sunshine: `capture = kms` in `polaris.conf` enables
  the KMS source at platform init (`misc.cpp`), enumerates active planes/CRTs as numeric display
  names, and requires `cap_sys_admin` (`kmsgrab.cpp`; the log line points at
  `sudo setcap cap_sys_admin+ep ...`). `--enable-kms` on `sudo -H polaris --setup-host` only runs
  that setcap (`src/entry_handler.cpp`). README warning: "Only grant cap_sys_admin ... when you
  actually need DRM/KMS capture."
- Inference (not documented): with `capture = kms` + `output_name` selecting the dummy-plug
  connector index, Polaris's kmsgrab would capture the existing external gamescope session
  exactly the way Sunshine does today, including HDR metadata (section 3). What Polaris does not
  document is which stream mode should own the session in that arrangement; `desktop_display`
  plus `capture = kms` is the closest mapping. The nix modules do not model this at all: they
  model `gamescope_stream` only, and the NixOS module grants no `cap_sys_admin`, so a KMS setup
  would need a hand-rolled `security.wrappers` setcap wrapper.

So: Polaris can capture an existing external session via KMS only by stepping outside its
documented paths. Its supported model replaces the Ly/gamescope/dummy-plug session with a
Polaris-owned gamescope.

## 5. Headless runtime limits

- The Polaris-owned gamescope idle runtime runs `gamescope --backend headless --expose-wayland
  --steam --xwayland-count 2 -W $W -H $H -r $R` with defaults 3840x2160@120
  (`scripts/install/lib/polaris-gamescope-idle.sh`; same defaults in `nix/modules/options.nix`).
  4K120 is the designed default for this path, on any GPU.
- labwc headless: applies "the session's requested resolution and refresh when preparing the
  streaming display" (changelog v1.3.5). No documented maximum resolution or refresh. Validated
  examples in the changelog are handheld-class (1920x1080x60 for Shield, v1.0.18).
- VRR / adaptive sync: not documented anywhere in docs or nix. The idle gamescope script does not
  pass `--adaptive-sync`. Nothing equivalent to the current `--adaptive-sync --rt` gamescope
  arguments appears in the managed runtime. Treat VRR as absent from the supported model.
- Known open robustness issues for headless: #111 "Headless Streaming not Working Unless Physical
  Monitor is On", #211 "screen tearing with headless display", #234 "Fullscreen Proton/Wine games
  always render to the physical monitor" (all open as of 2026-08-08).

## 6. AMD / VAAPI maturity

Sources: https://github.com/papi-ux/polaris/blob/master/docs/changelog.md , issue tracker.

Documented facts:

- README compatibility matrix: "NVIDIA/NVENC: Best-tested"; "AMD / VAAPI: Supported, expanding
  validation ... needs broader real-hardware coverage before claiming parity."
- v1.3.7 (2026-08-07): fixed a use-after-free at the VAAPI DMA-BUF import boundary, "reachable,
  not theoretical" on DRM/KMS capture and the non-cage wlroots VRAM path, "which is what AMD
  hosts have been running" (docs/changelog.md). This was issue #212 "RDNA4 VAAPI GPU-native
  capture crashes at stream start" (closed).
- Other AMD-specific tracker evidence: #92 open "AMD headless labwc stutter / high host
  processing on RX 9060 XT"; #124 closed "black screen ... RX 9060 XT - AV1 VA-API Slice Error";
  #31 closed "Inverted blue/red colors on RX 9070 XT"; #35 open "AMD Ryzen AI Max+ 395: ... HDR/
  Main10 color issue"; #172 closed "GPU-Native Stream preference is not applied on AMD/VAAPI".
  v1.0.9 fixed AMD SHM color channel handling; v1.0.14 added AMD GPU telemetry and headless
  DMA-BUF handling.
- v1.3.6 added `vaapi_vendor` to crash reporting "so a crash report names the driver generation",
  and PipeWire format negotiation "so 10-bit PQ cannot feed an SDR encode".

Assessment: AMD VAAPI encode itself is inherited Sunshine code with Main10 support
(`vaapi.cpp`, `VAProfileHEVCMain10`) and is fine; the immaturity concentrates in the GPU-native
DMA-BUF capture paths Polaris is adding, where AMD hosts have been the crash reporters. The
trajectory is active (fixes landing) but the state one day before this research was "crash-class
bug just fixed".

## 7. Gamescope interop (vendored patch stacks)

Source: https://github.com/papi-ux/polaris/blob/master/nix/patches/gamescope/README.md and
https://github.com/papi-ux/polaris/blob/master/nix/packages/gamescope-polaris/default.nix

`gamescope-polaris` tracks Valve gamescope master (pinned rev ff6b924f, 2026-08-01), with
`enableWsi = true`, plus this live patch stack:

| Patch | Purpose | Upstream fate |
|---|---|---|
| 10 `pipewire-offer-10-bit-BT2020-PQ` | Offer SPA 10-bit BT.2020/PQ PipeWire formats; paint switches on negotiated format. This is the HDR-capture foundation | Drop when upstream HDR PW formats land |
| 11 `pipewire-composite-cursor` | Optional `--pipewire-composite-cursor` | Drop when upstream lands |
| 12 `polaris-stamp-version-polhdrN` | Banner `+polhdr2` capability stamp; Polaris negotiates against this stamp (changelog v1.3.7) | Polaris-only |
| 02 `headless-hdr-colorimetry` | Headless real SDR vs HDR EDID/expose | Held until proven redundant with 10 |
| 03 `pipewire-prefer-dmabuf` | Advertise DmaBuf/MemFd/MemPtr | Held until portal path no longer needs multi-type |
| 06 `prefer-discrete-gpu-2217` | Headless prefers discrete GPU if unpinned | ValveSoftware/gamescope#2217 |

Retired (in `archive/`): 01 xBGR_210LE (gamescope PR #2270), 04 color-mgmt, 07 EOTF_PQ paint,
all folded into patch 10. CI applies the stack to the pinned rev on every nix change and builds
the compositor; a patch that stops applying fails CI (v1.3.7).

Purpose in one sentence: make a headless gamescope a truthful HDR capture source over PipeWire
(10-bit PQ formats, colorimetry, dGPU selection), because upstream gamescope cannot do that yet.

## 8. Project health and bus factor

GitHub API, 2026-08-08:

| Metric | Polaris (papi-ux/polaris) | Sunshine (LizardByte/Sunshine) |
|---|---|---|
| Repo created | 2026-04-06 | 2021-12-15 |
| Stars / forks | 283 / 15 | 39,994 / 2,007 |
| Contributors | 6; papi-ux authored 559 of ~577 commits (97%); luxus 9; rest <= 5 | 100+ (first page); top humans: ReenigneArcher 1032, cgutman 421 |
| Releases | 30 since v1.0.0 (2026-04-20); v1.3.5, v1.3.6, v1.3.7 all shipped on 2026-08-07 | steady multi-year cadence |
| Open issues / PRs | 7 issues, 2 PRs (both by the maintainer) | 126 issues |
| License | GPLv3 | GPLv3 |

Interpretation: extremely high commit cadence from one person, community patch flow is one
contributor (luxus, the nix/HDR work). High responsiveness (issues routinely closed within days)
but bus factor 1 and high churn: three releases in one day, fast-moving master, and the nix flake
tracks master rather than tags. For a host the user wants to rebuild declaratively for years,
this is the single largest structural risk after HDR.

## 9. Config management

Sources: https://github.com/papi-ux/polaris/blob/master/docs/configuration.md ,
`nix/modules/options.nix`, `nix/modules/home-manager.nix`.

- Files: `~/.config/polaris/polaris.conf` (host settings), `apps.json` (library),
  `polaris_state.json` (UI/session state). Same layout philosophy as Sunshine.
- Documented stance: "Polaris is designed to be configured from the web UI first. The config file
  is still useful when you want to script setup, review current values, or recover from a broken
  UI state" (docs/configuration.md).
- The web UI writes the config: v1.3.3 "stripped response-only ... metadata before configuration
  saves"; the nix options description says the module's `streamMode` is "seeded into
  ~/.config/polaris/polaris.conf when missing (web UI owns later edits)". The HM module copies a
  seed file only when none exists.
- Declarative management is therefore possible the same way this repo manages Sunshine today
  (home-manager owns `polaris.conf`, web UI edits get reverted on the next switch), but it is
  against the documented grain: GPU selection is web-UI-owned (`adapter_name`; nix/README: "No
  hybrid nvidia pin rewrite of conf"), and several settings exist only as web UI concepts.
- Whether the daemon tolerates a read-only or externally-rewritten `polaris.conf` is not
  documented. Unknown; needs testing. `apps.json` and `polaris_state.json` are inherently
  runtime-mutated (pairing, library imports), same as Sunshine's `apps.json`.

## 10. Audio and input

- Audio: PulseAudio/PipeWire virtual stream sink, same model as Sunshine. `audio.cpp` locates the
  PipeWire socket and tags the session sink (`POLARIS_SESSION_AUDIO_SINK=`). v1.0.10/v1.0.11:
  isolated headless audio routing so the host desktop default sink is not left redirected;
  v1.3.6: "claims the stream sink as the session default while streaming, and releases that claim
  only from the session that took it".
- Input: virtual keyboard/mouse/gamepads via uinput/uhid with bundled udev rules
  (docs/configuration.md "Linux client-gamepad access boundary"); optional seat isolation
  (`seat-polaris`) for client devices; `headless_gamepad_isolation` hides host controllers from
  the private stream; the private labwc session generates an `rc.xml` that disables physical
  host devices. The NixOS module enables `hardware.uinput`, loads `uhid`, and adds users to
  `input`/`uinput`/`video`/`render`/`audio`. Open input bugs of note for this setup: #222 "Not
  all Controller inputs working in Headless Stream" (open).

## Unknowns / would need testing

1. Whether a read-only (home-manager-owned) `polaris.conf` breaks the daemon or web UI saves, and
   whether runtime state files coexist cleanly with that model.
2. Whether `capture = kms` + `output_name` = dummy plug + `encoder = vaapi` actually negotiates
   4K120 HDR10 from the existing Ly/gamescope session under Polaris (code says the pieces exist;
   nothing documents or tests this flow; a setcap wrapper must be hand-built on NixOS).
3. Whether the gamescope_stream + patched gamescope HDR path produces true HDR10 on an AMD RDNA3
   host at 4K120 (only NVIDIA 4K60 is demonstrated; phase 4 productization is open as #152).
4. webOS "Moonlight TV" pairing and streaming (protocol-compatible by claim; zero webOS reports
   found).
5. VRR behavior in any Polaris-managed runtime (undocumented; `--adaptive-sync` is not wired into
   the shipped scripts).
6. labwc headless at 3840x2160@120 (no documented ceiling; validated examples are 1080p60-class).
7. Long-term stability of the master-tracking flake: release-to-master drift, stale pins
   (`0-unstable-2026-07-28` string at v1.3.7), and the `luxus/polaris` vs `papi-ux/polaris`
   references suggest the nix packaging is still settling.
8. Hyprland coexistence of the portal stack: the HM module runs a private D-Bus bus plus private
   portal to avoid interfering with the host session; interaction with this repo's uwsm-managed
   Hyprland session is untested upstream.
