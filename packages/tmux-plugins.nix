{
  fetchFromGitHub,
  tmuxPlugins,
  ...
}: {
  catppuccin = tmuxPlugins.mkTmuxPlugin {
    pluginName = "catppuccin";
    version = "Commits on Aug 6, 2025";
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "tmux";
      rev = "9d21d7ccd50df82bd732be2850ce2798e78b6391";
      hash = "sha256-Xk3LogY3B2bZbUWyTHa2nap4Rn0bU2QgYlHlkngMPsk=";
    };
    postInstall = ''
      sed -i -e 's|''${PLUGIN_DIR}/catppuccin-selected-theme.tmuxtheme|''${TMUX_TMPDIR}/catppuccin-selected-theme.tmuxtheme|g' $target/catppuccin.tmux
    '';
  };
}
