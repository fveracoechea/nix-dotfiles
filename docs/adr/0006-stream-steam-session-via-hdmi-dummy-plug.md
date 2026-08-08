# Stream the Steam Session via the HDMI Dummy Plug

Status: accepted

On `nixos-desktop`, Moonlight streaming serves the Steam Session only. Gamescope renders Steam Big Picture onto the Dummy Plug (HDMI-A-1, 3840x2160@120 HDR) and Sunshine captures that connector via KMS (`capture = kms`, `output_name = HDMI-A-1`, `encoder = vaapi`; `capSysAdmin` grants the KMS grab while gamescope is DRM master). Hyprland is never streamed: HDMI-A-1 stays disabled there and Sunshine does not run in that session.

The hard requirement: Sunshine must start its encoder probing only after gamescope has modeset the Dummy Plug. Probing happens once at startup, and a probe against a modeless connector permanently yields no working encoder, which surfaces to Moonlight as `503: failed to initialize video capture/encoding`. Enforcement lives in `modules/nixos/gaming.nix`: `services.sunshine.autoStart = false`, plus a drop-in making the unit `wantedBy`/`after` `nixos-fake-graphical-session.target` and gating its start with an `ExecStartPre` that waits for `/sys/class/drm/card*-HDMI-A-1/enabled`. The fake target is started by the display manager only for non-systemd-aware sessions (the Steam Session); uwsm-managed Hyprland never activates it, which is what keeps Sunshine exclusive to the Steam Session.

## Rejected alternatives

- **Streaming from Hyprland (pre-dummy-plug design)** - captured the physical monitor (DP-1), which couples streaming to the desktop session and to monitor state. The Dummy Plug decouples both.
- **wlr screencopy capture** - the Steam Session compositor is gamescope, which does not implement `zwlr_screencopy_manager_v1`; KMS is the only capture path there.
