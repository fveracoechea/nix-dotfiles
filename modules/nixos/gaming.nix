{
  pkgs,
  lib,
  ...
}: {
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
    steam.gamescopeSession.enable = true;
    steam.extraCompatPackages = [pkgs.proton-ge-bin];

    gamemode.enable = true;
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

  # GDM monitor configuration
  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${lib.fileContents ../../monitors.xml}"
  ];

  services = {
    sunshine = {
      enable = true;
      autoStart = false;
      capSysAdmin = true;
      openFirewall = true;
    };
  };

  networking.interfaces."eno1".wakeOnLan.enable = true;

  # Enable openrgb
  services.hardware.openrgb.enable = true;
}
