{
  pkgs,
  inputs,
  ...
}: {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    terminal = "tmux-256color";
    mouse = true;
    baseIndex = 1;
    focusEvents = true;
    historyLimit = 50000;
    shell = "${pkgs.zsh}/bin/zsh";

    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      {
        plugin = inputs.tmux-powerkit.packages.${pkgs.system}.default;
        extraConfig = ''
          set -g @powerkit_plugins "git,github,cpu,netspeed,uptime"

          set -g @powerkit_theme "catppuccin"
          set -g @powerkit_theme_variant "mocha"

          set -g @powerkit_separator_style "rounded"
          set -g @powerkit_edge_separator_style "rounded:all"

          set -g @powerkit_transparent "true"

          set -g @powerkit_status_order "session,plugins,windows"

          set -g @powerkit_lazy_loading "true"
        '';
      }
    ];

    extraConfig =
      #bash
      ''
        set -g allow-passthrough on
        set -ga update-environment TERM
        set -ga update-environment TERM_PROGRAM
        set -ag terminal-overrides ",xterm-256color:RGB"

        # set-environment -g COLORTERM "truecolor"
        set-option -g status-position top

        # Reset default command
        set-option -g default-command ""

        # Renumber all windows when any window is closed
        set -g renumber-windows on

      '';
  };
}
