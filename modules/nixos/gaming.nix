{pkgs, ...}: let
  gamescopeArgs = builtins.concatStringsSep " " [
    "-e" # Emmbed mode for steam integration
    "--adaptive-sync" # VRR support
    "--hdr-enabled" # HDR
    "--hdr-itm-enable"
    "--rt" # Real time scheduling
    "-W 2560"
    "-H 1440"
    "-r 120" # Refresh rate
    "-f" # Fullscreen
    "-O DP-1" # Output display
  ];
in {
  # Virtual 4K 120Hz headless display
  # boot.kernelParams = ["video=card1-DP-2:3840x2160R@120D"];

  hardware = {
    graphics.enable = true;
    graphics.enable32Bit = true;
    graphics.extraPackages = [pkgs.gamescope-wsi];
    cpu.amd.updateMicrocode = true;
    amdgpu.initrd.enable = true;
    xone.enable = true;
  };

  programs = {
    steam.enable = true;
    steam.protontricks.enable = true;
    steam.extraCompatPackages = [pkgs.proton-ge-bin];
    steam.gamescopeSession.enable = true;

    gamemode.enable = true;

    gamescope.enable = true;
    gamescope.capSysNice = true;
  };

  environment = {
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    };
    systemPackages = with pkgs; [
      lutris
      mesa-demos
      ethtool
      protonup-ng
      amdgpu_top
      mangohud
      lact
      (writers.writeBashBin "sunshine-gamescope-session"
        # bash
        ''
          export DXVK_HDR=1
          export ENABLE_HDR=1
          export ENABLE_HDR_WSI=1
          # Enable Steam Deck features
          export STEAM_GAMESCOPE_COLOR_MANAGED=1
          export STEAM_GAMESCOPE_HDR_SUPPORTED=1
          # SDL/Input optimization
          # export SDL_VIDEODRIVER=wayland
          sunshine &
          gamescope ${gamescopeArgs} -- steam -gamepadui -steamos
        '')
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
    sunshine = {
      enable = true;
      autoStart = false;
      capSysAdmin = true;
      openFirewall = true;
      package = pkgs.sunshine;
    };

    displayManager.sessionPackages = [
      (pkgs.writeTextFile {
        name = "gamescope-steam.desktop";
        destination = "/share/wayland-sessions/gamescope-steam.desktop";
        checkPhase = ''${pkgs.buildPackages.desktop-file-utils}/bin/desktop-file-validate "$target"'';
        derivationArgs = {passthru.providedSessions = ["gamescope-steam"];};
        text = ''
          [Desktop Entry]
          Name=Gamescope Steam
          Comment=Launch Gamescope with Steam Big Picture Mode
          Exec=sunshine-gamescope-session
          Type=Application
        '';
      })
    ];
  };
}
