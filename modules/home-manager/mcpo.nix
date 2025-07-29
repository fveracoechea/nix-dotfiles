{
  pkgs,
  customPkgs,
  inputs,
  config,
  utils,
  ...
}: let
  mcpConfig = utils.mcpServers {
    inherit pkgs inputs config;
  };
in {
  home.packages = [
    customPkgs.mcpo
  ];

  xdg.configFile."mcpo/config.json".source = mcpConfig;
}
