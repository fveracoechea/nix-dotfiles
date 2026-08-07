{
  lib,
  config,
  ...
}: {
  options.dotfiles.darwin-system-config.enable = lib.mkEnableOption "macOS system defaults";

  config = lib.mkIf config.dotfiles.darwin-system-config.enable {
    system.defaults = {
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        KeyRepeat = 3; # fast key repeat
        InitialKeyRepeat = 15; # short delay before repeat
        AppleShowAllExtensions = true;
      };

      # mouseDriverCursorSize cannot be managed here: com.apple.universalaccess
      # is SIP-protected and only writable by processes holding Full Disk
      # Access, so nix-darwin activation always fails on it. Set it by hand:
      # System Settings > Accessibility > Pointer Control > Pointer size (1.5).

      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        ShowExternalHardDrivesOnDesktop = true;
        FXPreferredViewStyle = "Nlsv"; # list view by default
        CreateDesktop = false; # clean desktop
      };

      dock = {
        autohide = true;
        # No autohide-delay: on macOS 26 a 0.0 delay stops hover-to-reveal
        # working entirely instead of revealing instantly.
        mru-spaces = false;
        show-recents = false;
        largesize = 65;
        tilesize = 50;
        magnification = true;
        mineffect = "genie";
        orientation = "bottom";
      };
    };
  };
}
