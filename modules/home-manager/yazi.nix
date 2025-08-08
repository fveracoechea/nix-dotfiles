{pkgs, ...}: let
  theme = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "yazi";
    rev = "043ffae14e7f7fcc136636d5f2c617b5bc2f5e31";
    hash = "sha256-zkL46h1+U9ThD4xXkv1uuddrlQviEQD3wNZFRgv7M8Y=";
  };
  themePath =
    theme + "/themes/mocha/catppuccin-mocha-blue.toml";
in {
  stylix.targets.yazi.enable = false;
  home.packages = with pkgs; [mediainfo];

  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    enableZshIntegration = true;

    theme =
      builtins.fromTOML (builtins.readFile themePath);

    plugins = with pkgs.yaziPlugins; {
      inherit git yatline yatline-catppuccin smart-enter smart-filter mediainfo piper;
    };

    initLua =
      # lua
      ''
        require("git"):setup();
        local mocha = require("yatline-catppuccin"):setup("mocha");
        require("yatline"):setup({
          theme = mocha,
        });
      '';

    settings = {
      mgr = {
        show_hidden = true;
        sort_dir_first = true;
        ratio = [1 1 2];

        prepend_keymap = [
          {
            on = "F";
            run = "plugin smart-filter";
            desc = "Smart Filter";
          }
          {
            on = "l";
            run = "plugin smart-enter";
            desc = "Enter the child directory, or open the file";
          }
        ];
      };

      plugin = {
        prepend_preloaders = [
          {
            mime = "{audio,video,image}/*";
            run = "mediainfo";
          }
          {
            mime = "application/subrip";
            run = "mediainfo";
          }
        ];
        prepend_previewers = [
          {
            mime = "{audio,video,image}/*";
            run = "mediainfo";
          }
          {
            mime = "application/subrip";
            run = "mediainfo";
          }
          {
            name = "*/";
            run = ''piper -- eza -TL=3 --git-ignore --color=always --icons=always --group-directories-first --no-quotes "$1"'';
          }
        ];
        prepend_fetchers = [
          {
            id = "git";
            name = "*";
            run = "git";
          }
          {
            id = "git";
            name = "*/";
            run = "git";
          }
        ];
      };
    };
  };
}
