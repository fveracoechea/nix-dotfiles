{pkgs, ...}: {
  hardware = {
    graphics.enable = true;
    graphics.enable32Bit = true;

    cpu.amd.updateMicrocode = true;
    amdgpu.initrd.enable = true;

    # Support for the xbox accessories
    xone.enable = true;

    # Open-source Vulkan driver from AMD
    amdgpu.amdvlk = {
      enable = true;
      support32Bit.enable = true;
    };
  };

  programs = {
    steam.enable = true;
    steam.extraCompatPackages = [pkgs.proton-ge-bin];
    steam.gamescopeSession.enable = true;

    gamemode.enable = true;

    gamescope.enable = true;
    gamescope.capSysNice = true;
    gamescope.args = [
      "--adaptive-sync" # VRR support
      "--hdr-enabled" # HDR
      "--rt" # Real time scheduling
      "--force-grab-cursor"
      "-e"
      "-f" # fullscreen
      "-W 3840"
      "-H 2160"
      "-r 120" # refresh rate
      # "-O HDMI-A-1" # Monitor
    ];
  };

  environment = {
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    };

    systemPackages = with pkgs; [
      mesa-demos
      ethtool
      protonup
      amdgpu_top
      mangohud
      lact
      (lutris.override {
        extraPkgs = pkgs: [
          wineWowPackages.waylandFull
          winetricks
          gamemode
          mangohud
        ];
      })
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
    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };

  networking.interfaces."eno1".wakeOnLan.enable = true;

  # Enable openrgb
  services.hardware.openrgb.enable = true;
}
