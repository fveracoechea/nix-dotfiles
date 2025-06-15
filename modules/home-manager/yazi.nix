{pkgs, ...}: let
  theme = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "yazi";
    rev = "1a8c939e47131f2c4bd07a2daea7773c29e2a774";
    hash = "sha256-hjqmNxIr/KCN9k5ZT7O994BeWdp56NP7aS34+nZ/fQQ=";
  };
  themePath =
    theme + "/themes/mocha/catppuccin-mocha-blue.toml";
in {
  stylix.targets.yazi.enable = false;
  home.packages = [pkgs.mediainfo];

  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    enableZshIntegration = true;

    theme =
      builtins.fromTOML (builtins.readFile themePath);

    settings = {
      mgr = {
        show_hidden = true;
        sort_dir_first = true;
      };

      plugin = {
        # TODO: Not Working at the moment, check if this is a bug in yazi
        # prepend_preloaders = [
        #   {
        #     mime = "{audio,video,image}/*";
        #     run = "mediainfo";
        #   }
        #   {
        #     mime = "application/subrip";
        #     run = "mediainfo";
        #   }
        # ];
        # prepend_previewers = [
        #   {
        #     mime = "{audio,video,image}/*";
        #     run = "mediainfo";
        #   }
        #   {
        #     mime = "application/subrip";
        #     run = "mediainfo";
        #   }
        # ];
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

    plugins = {
      git = pkgs.yaziPlugins.git;
      yatline = pkgs.yaziPlugins.yatline;
      yatline-catppuccin = pkgs.yaziPlugins.yatline-catppuccin;
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
  };
}
