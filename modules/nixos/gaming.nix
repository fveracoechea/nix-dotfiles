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
      "-f" # Fullscreen
      "-e" # Steam integration with Gamescope
      "--adaptive-sync" # VRR support
      "--hdr-enabled" # HDR
      "--hdr-debug-force-output"
      "--rt" # Real time scheduling
      "--force-grab-cursor"
      "--xwayland-count 2"
      "-W 3840"
      "-H 2160"
      "-r 120" # Refresh rate
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
      package = pkgs.sunshine;
    };
  };

  networking.interfaces."eno1".wakeOnLan.enable = true;

  # Enable openrgb
  services.hardware.openrgb.enable = true;
}
