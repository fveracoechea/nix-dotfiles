{pkgs, ...}: {
  stylix.targets.yazi.enable = false;

  programs.yazi = let
    theme = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "yazi";
      rev = "1a8c939e47131f2c4bd07a2daea7773c29e2a774";
      hash = "sha256-hjqmNxIr/KCN9k5ZT7O994BeWdp56NP7aS34+nZ/fQQ=";
    };
    themePath =
      theme + "/themes/mocha/catppuccin-mocha-blue.toml";
  in {
    enable = true;
    enableZshIntegration = true;

    theme =
      builtins.fromTOML (builtins.readFile themePath);

    settings = {
      "plugin.prepend_fetchers" = [
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
