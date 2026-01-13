{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  programs.cava.enable = true;

  programs.spicetify = {
    enable = true;
    customColorScheme = "mocha";
    theme = {
      name = "catppuccin";
      src = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "spicetify";
        rev = "1ec645c4cf7f42f9792b9eeb1bb7930f94593277";
        hash = "sha256-VK9JpXYFuLMkIuMftFkkMy6Y5+ttuxDUYoIiAPlx6YY=";
      };

      injectCss = true;
      injectThemeJs = true;
      replaceColors = true;
      overwriteAssets = true;
    };
  };
}
