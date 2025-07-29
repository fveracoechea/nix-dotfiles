{
  pkgs,
  customPkgs,
  sharedMcpConfig,
  ...
}: {
  home.packages = [
    customPkgs.mcpo
  ];

  xdg.configFile."mcpo/config.json".source = sharedMcpConfig.mcpoConfig;
}
