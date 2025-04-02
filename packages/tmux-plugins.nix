{
  fetchFromGitHub,
  tmuxPlugins,
  ...
}: {
  catppuccin = tmuxPlugins.mkTmuxPlugin rec {
    pluginName = "catppuccin";
    version = "2.1.3";
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "tmux";
      rev = "v${version}";
      hash = "sha256-Is0CQ1ZJMXIwpDjrI5MDNHJtq+R3jlNcd9NXQESUe2w=";
    };
    postInstall = ''
      sed -i -e 's|''${PLUGIN_DIR}/catppuccin-selected-theme.tmuxtheme|''${TMUX_TMPDIR}/catppuccin-selected-theme.tmuxtheme|g' $target/catppuccin.tmux
    '';
  };
}
