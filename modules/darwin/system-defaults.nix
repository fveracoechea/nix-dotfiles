{...}: {
  # Currently not working as a system service - using homebrew instead
  services.karabiner-elements.enable = false;

  security.pam.enableSudoTouchIdAuth = true;

  # Darwin System settings
  system.defaults = {
    finder.AppleShowAllExtensions = true;
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      mru-spaces = false;
      largesize = 65;
      tilesize = 35;
      magnification = true;
      mineffect = "genie";
      orientation = "bottom";
    };
  };
}
