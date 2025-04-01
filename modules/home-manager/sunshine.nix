{pkgs, ...}: {
  home.packages = [
    (pkgs.writers.writeBashBin "sunshine-gamescope-session"
      # bash
      ''
        sunshine &> ~/sunshine-output.txt &
        gamescope -- steam -gamepadui -pipewire-dmabuf -tenfoot -steamos
      '')
  ];

  xdg.configFile."sunshine/apps.json".text = builtins.toJSON {
    env = {
      "PATH" = "$(PATH):$(HOME)/.local/bin";
    };
    apps = [
      {
        name = "Steam 4K";
        image-path = "steam.png";
      }
    ];
  };

  services = {
    sunshine = {
      enable = true;
      autoStart = false;
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
          Exec=sunshine-gamescope-session
          Type=Application
        '';
      })
    ];
  };
}
