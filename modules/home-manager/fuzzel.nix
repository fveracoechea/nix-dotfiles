{
  pkgs,
  lib,
  ...
}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        match-mode = "fzf";
        match-counter = "yes";
        layer = "overlay";
        icon-theme = "Papirus-Dark";
        icons-enabled = "yes";
        horizontal-pad = 20;
        vertical-pad = 12;
        line-height = 22;
        prompt = ''"❯  "'';
        placeholder = "Apps";
      };

      border = {
        width = 3;
        radius = 8;
      };

      key-bindings = {
        delete-line-forward = "none";
        next = "Control+j";
        prev = "Control+k";
      };
    };
  };

  home.packages = [
    (pkgs.writers.writeJSBin "fuzzel-powermenu" {} (lib.fileContents ../../scripts/fuzzel-powermenu.js))
    (pkgs.writers.writeJSBin "fuzzel-notifications" {} (lib.fileContents ../../scripts/fuzzel-notifications.js))
  ];
}
