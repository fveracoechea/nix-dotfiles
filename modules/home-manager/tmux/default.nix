{
  pkgs,
  inputs,
  lib,
  system,
  ...
}: let
  tmux-powerkit = inputs.tmux-powerkit.packages.${system}.default.overrideAttrs (old: {
    postInstall =
      (old.postInstall or "")
      + ''
        find $out/share/tmux-plugins/tmux-powerkit -name "*.sh" -o -name "*.tmux" | while read f; do
          substituteInPlace "$f" \
            --replace-fail '#!/usr/bin/env bash' '#!${pkgs.bash}/bin/bash' || true
        done
      '';
  });
in {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    terminal = "tmux-256color";
    mouse = true;
    baseIndex = 1;
    focusEvents = true;
    historyLimit = 50000;
    shell = "${pkgs.zsh}/bin/zsh";
    extraConfig = lib.fileContents ./tmux.conf;
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      {
        plugin = tmux-powerkit;
        extraConfig = lib.fileContents ./tmux.powerkit.conf;
      }
    ];
  };
}
