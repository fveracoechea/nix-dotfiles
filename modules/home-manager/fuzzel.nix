{
  lib,
  customUtils,
  ...
}: let
  toHex = color: "${lib.substring 1 6 (lib.strings.toLower color)}ff";
in {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        width = 38;
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
        font = "Fira Sans:style=Regular:size=12";
      };

      border = {
        width = 3;
        radius = 8;
      };

      key-bindings = {
        delete-line-forward = "none";
        next = "Control+n";
        prev = "Control+p";
      };

      colors = {
        background = toHex customUtils.catppuccin.base;
        text = toHex customUtils.catppuccin.text;
        prompt = toHex customUtils.catppuccin.subtext1;
        placeholder = toHex customUtils.catppuccin.overlay1;
        input = toHex customUtils.catppuccin.text;
        match = toHex customUtils.catppuccin.blue;
        selection = toHex customUtils.catppuccin.surface2;
        selection-text = toHex customUtils.catppuccin.text;
        selection-match = toHex customUtils.catppuccin.blue;
        counter = toHex customUtils.catppuccin.overlay1;
        border = toHex customUtils.catppuccin.blue;
      };
    };
  };
}
