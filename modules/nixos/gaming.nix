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
    steam.gamescopeSession.enable = true;
    steam.extraCompatPackages = [pkgs.proton-ge-bin];

    gamescope.enable = true;
    gamescope.capSysNice = true;
    gamescope.args = [
      "-w"
      "3840"
      "-h"
      "2160"
      "-r"
      "120"
      "--adaptive-sync" # VRR support
      "--hdr-enabled"
      "--rt"
    ];
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

  services = {
    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
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
          Exec=gamescope -e -- steam -pipewire-dmabuf -tenfoot
          Type=Application
        '';
      })
    ];
  };

  networking.interfaces."eno1".wakeOnLan.enable = true;

  # Enable openrgb
  services.hardware.openrgb.enable = true;
}
