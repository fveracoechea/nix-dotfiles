{...}: {
  # Darwin System settings
  system.defaults = {
    finder = {
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
      ShowExternalHardDrivesOnDesktop = true;
    };

    universalaccess = {
      reduceTransparency = true;
      mouseDriverCursorSize = 2.5;
    };

    dock = {
      autohide = false;
      autohide-delay = 0.0;
      mru-spaces = false;
      show-recents = false;
      largesize = 65;
      tilesize = 50;
      magnification = true;
      mineffect = "genie";
      orientation = "bottom";
    };
  };
}
