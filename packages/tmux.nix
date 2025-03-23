{
  fetchFromGitHub,
  mkTmuxPlugin,
}: {
  catppuccin = mkTmuxPlugin {
    pluginName = "catppuccin";
    version = "2.1.3";
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "tmux";
      rev = "b2f219c00609ea1772bcfbdae0697807184743e4";
      hash = "sha256-Is0CQ1ZJMXIwpDjrI5MDNHJtq+R3jlNcd9NXQESUe2w=";
    };
    postInstall = ''
      sed -i -e 's|''${PLUGIN_DIR}/catppuccin-selected-theme.tmuxtheme|''${TMUX_TMPDIR}/catppuccin-selected-theme.tmuxtheme|g' $target/catppuccin.tmux
    '';
  };
}
