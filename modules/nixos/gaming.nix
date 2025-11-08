{pkgs, ...}: {
  hardware = {
    graphics.enable = true;
    graphics.enable32Bit = true;
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
    gamescope.package = pkgs.gamescope-wsi;
    gamescope.capSysNice = true;
  };

  environment = {
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    };
    systemPackages = with pkgs; [
      mesa-demos
      ethtool
      protonup-ng
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
    hardware.openrgb.enable = true;
    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
      package = pkgs.sunshine;
    };
  };
}
