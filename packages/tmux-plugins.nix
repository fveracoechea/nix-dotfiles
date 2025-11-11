{
  fetchFromGitHub,
  tmuxPlugins,
  ...
}: {
  catppuccin = tmuxPlugins.mkTmuxPlugin {
    pluginName = "catppuccin";
    # https://github.com/catppuccin/tmux/commits/main/
    version = "Commits on Sep 28, 2025";
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "tmux";
      rev = "8b0b9150f9d7dee2a4b70cdb50876ba7fd6d674a";
      hash = "sha256-godCgBMgqzim+W3O2sHcgw91h7sHsKHjd02BdLuazZ8=";
    };
    postInstall = ''
      sed -i -e 's|''${PLUGIN_DIR}/catppuccin-selected-theme.tmuxtheme|''${TMUX_TMPDIR}/catppuccin-selected-theme.tmuxtheme|g' $target/catppuccin.tmux
    '';
  };
}
