# Stream the Steam Session via the HDMI Dummy Plug

Status: accepted

On `nixos-desktop`, Moonlight streaming serves the Steam Session only. Gamescope renders Steam Big Picture onto the Dummy Plug (HDMI-A-1, 3840x2160@120 HDR) and Sunshine captures it via KMS (`capture = kms`, `encoder = vaapi`; `capSysAdmin` grants the KMS grab while gamescope is DRM master). Hyprland is never streamed: HDMI-A-1 stays disabled there and Sunshine does not run in that session.

`output_name` is deliberately unset. Name-based monitor selection resolves connector names by correlating against Wayland monitors, and the Steam Session exposes no reachable Wayland display to the Sunshine service, so a configured name degrades to an unresolvable numeric ID and probing fails with `Couldn't find monitor [<id>]`. With no name configured, the KMS backend selects the first active plane across all cards, which in the Steam Session is the Dummy Plug (verified empirically: on this GPU the HDMI-A-1 plane sorts before DP-1's, and the iGPU card has no connected outputs).

The hard requirement: Sunshine must start its encoder probing only after gamescope has modeset the Dummy Plug. Probing happens once at startup, and a probe against a modeless connector permanently yields no working encoder, which surfaces to Moonlight as `503: failed to initialize video capture/encoding`. Enforcement lives in `modules/nixos/gaming.nix`: `services.sunshine.autoStart = false`, plus a drop-in making the unit `wantedBy`/`after` `nixos-fake-graphical-session.target` and gating its start with an `ExecStartPre` that waits for `/sys/class/drm/card*-HDMI-A-1/enabled`. The fake target is started by the display manager only for non-systemd-aware sessions (the Steam Session); uwsm-managed Hyprland never activates it, which is what keeps Sunshine exclusive to the Steam Session.

## Rejected alternatives

- **Streaming from Hyprland (pre-dummy-plug design)** - captured the physical monitor (DP-1), which couples streaming to the desktop session and to monitor state. The Dummy Plug decouples both.
- **wlr screencopy capture** - the Steam Session compositor is gamescope, which does not implement `zwlr_screencopy_manager_v1`; KMS is the only capture path there.
