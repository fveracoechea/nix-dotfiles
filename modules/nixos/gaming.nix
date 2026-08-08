{
  pkgs,
  lib,
  config,
  ...
}: let
  # Sunshine probes encoders once at startup; the Dummy Plug must have an active
  # mode owned by gamescope. A bare modeset is not enough: the boot console also
  # modesets HDMI-A-1, and starting Sunshine that early races gamescope's own DRM
  # acquisition (gamescope: "Could not take device", backend failure, black stream).
  wait-for-stream-output = pkgs.writeShellApplication {
    name = "wait-for-stream-output";
    runtimeInputs = [pkgs.gnugrep pkgs.coreutils pkgs.procps];
    text = ''
      for _ in $(seq 1 40); do
        if pgrep -x gamescope >/dev/null \
          && compgen -G "''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/gamescope-*" >/dev/null \
          && grep -qs "^enabled" /sys/class/drm/card*-HDMI-A-1/enabled; then
          sleep 2
          exit 0
        fi
        sleep 0.5
      done
      exit 1
    '';
  };
in {
  options.dotfiles.gaming.enable = lib.mkEnableOption "gaming suite (steam, gamescope, sunshine, openrgb, AMD tools)";

  config = lib.mkIf config.dotfiles.gaming.enable {
    hardware = {
      graphics.extraPackages = [pkgs.gamescope-wsi];
      cpu.amd.updateMicrocode = true;
      amdgpu.initrd.enable = true;
      xone.enable = true;
    };

    programs = {
      steam.enable = true;
      steam.protontricks.enable = true;
      steam.extraCompatPackages = [pkgs.proton-ge-bin];
      steam.gamescopeSession = {
        enable = true;
        env = {
          DXVK_HDR = "1";
          ENABLE_HDR = "1";
        };
        args = [
          "--adaptive-sync" # VRR support
          "--hdr-enabled" # HDR
          "--hdr-itm-enable"
          "--rt" # Real time scheduling
          "-W 3840"
          "-H 2160"
          "-r 120" # Refresh rate
          "-f" # Fullscreen
          "-O HDMI-A-1" # Output display (dummy plug, sunshine capture target)
        ];
      };

      gamemode.enable = true;
      gamescope.enable = true;
      gamescope.capSysNice = false;
    };

    environment = {
      sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
      };
      systemPackages = with pkgs; [
        # lutris
        mesa-demos
        ethtool
        protonup-ng
        amdgpu_top
        lact
      ];
    };

    systemd.services.lact = {
      enable = true;
      description = "AMDGPU Control Daemon";
      after = ["multi-user.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = "${pkgs.lact}/bin/lact daemon";
      };
    };

    services = {
      hardware.openrgb.enable = true;

      # Super+Alt+Q blindly ends the Steam Session (kills gamescope,
      # session script exits, Ly greeter returns). evdev-level, works in any session
      keyd = {
        enable = true;
        keyboards.default = {
          ids = ["*"];
          settings."meta+alt".q = "command(${pkgs.util-linux}/bin/logger -t steam-exit combo fired, killing gamescope; ${pkgs.procps}/bin/pkill -x gamescope)";
        };
      };

      sunshine = {
        enable = true;
        # Started via nixos-fake-graphical-session.target (Steam Session only);
        # Hyprland is uwsm-managed and never activates that target
        autoStart = false;
        capSysAdmin = true;
        openFirewall = true;
      };
    };

    systemd.user.services.sunshine = {
      wantedBy = ["nixos-fake-graphical-session.target"];
      after = ["nixos-fake-graphical-session.target"];
      serviceConfig.ExecStartPre = lib.getExe wait-for-stream-output;
    };
  };
}
