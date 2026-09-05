{
  pkgs,
  lib,
  config,
  ...
}: {
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
          "-W 2560"
          "-H 1440"
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
        ethtool
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
          settings."control+alt".q = "command(${pkgs.util-linux}/bin/logger -t steam-exit combo fired, killing gamescope; ${pkgs.procps}/bin/pkill -x gamescope || ${pkgs.procps}/bin/pkill -x .gamescope-wrap)";
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

    # Sunshine probes encoders once at startup; give gamescope time to take DRM
    # and modeset the Dummy Plug first, or probing fails until Sunshine restarts
    systemd.user.services.sunshine = {
      wantedBy = ["nixos-fake-graphical-session.target"];
      after = ["nixos-fake-graphical-session.target"];
      serviceConfig.ExecStartPre = "${pkgs.coreutils}/bin/sleep 10";
    };
  };
}
