{...}: {
  services.karabiner-elements.enable = true;

  xdg.enable = lib.mkDefault true;
  xdg.configFile."karabiner/karabiner.json".source = ../../config/karabiner/karabiner.json;
}
