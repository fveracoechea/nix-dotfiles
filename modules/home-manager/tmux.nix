{
  pkgs,
  lib,
  ...
}: let
  theme = import ../../utils/catppuccin.nix;
in {
  home.packages = [
    (pkgs.helpers.nodeJsScript "tmux-uptime")
    (pkgs.helpers.nodeJsScript "tmux-os-icon")
    (pkgs.helpers.nodeJsScript "tmux-git-status")
  ];

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    mouse = true;
    terminal = "tmux-256color";
    baseIndex = 1;

    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.yank
      {
        plugin = myTmuxPackages.catppuccin;
        extraConfig =
          # bash
          ''
            set -g @catppuccin_flavour 'mocha'
          '';
        #
        #     ## Window configuration (default)
        #     set -g @catppuccin_window_left_separator ""
        #     set -g @catppuccin_window_right_separator " "
        #     set -g @catppuccin_window_middle_separator " "
        #
        #     set -g @catppuccin_window_default_fill "all"
        #     set -g @catppuccin_window_default_color "${theme.overlay1}"
        #     set -g @catppuccin_window_default_text "#[bold]#W"
        #
        #     ## Right statusline modules
        #     set -g @catppuccin_status_modules_right "session gitmux uptime host"
        #     set -g @catppuccin_status_left_separator  " "
        #     set -g @catppuccin_status_right_separator ""
        #     set -g @catppuccin_status_fill "icon"
        #     set -g @catppuccin_status_connect_separator "no"
        #
        #     ## Window configuration (current)
        #     set -g @catppuccin_window_current_fill "all"
        #     set -g @catppuccin_window_current_color "${theme.blue}"
        #     set -g @catppuccin_window_current_text "#[bold]#W"
        #
        #     ## Modules
        #     ### Session
        #     set -g @catppuccin_session_icon ""
        #     set -g @catppuccin_session_color "#{?client_prefix,${lib.toLower theme.peach},${lib.toLower theme.mauve}}"
        #     ### Git
        #     set -g @catppuccin_gitmux_icon ""
        #     set -g @catppuccin_gitmux_color "${theme.pink}"
        #     set -g @catppuccin_gitmux_text "#(tmux-git-status)"
        #     ### Updatime
        #     set -g @catppuccin_uptime_color "${theme.flamingo}"
        #     set -g @catppuccin_uptime_text "#(tmux-uptime)"
        #     ### Hostname
        #     set -g @catppuccin_host_color "${theme.rosewater}"
        #     set -g @catppuccin_host_icon "#(tmux-os-icon)"
        #   '';
      }
    ];

    extraConfig =
      # bash
      ''
         # Set status bar on the top
         set-option -g status-position top

         # Reset default command
        kset-option -g default-command ""

         # Renumber all windows when any window is closed
         set -g renumber-windows on

         # Enable dynamic titles
         set-option -g set-titles on
         set-option -g set-titles-string "#(echo #{pane_current_path} | sed 's#$HOME#~#g') - #W"

         # Split horizontally with |
         unbind %
         bind '\' split-window -h

         # Split vertically with -
         unbind '"'
         bind '-' split-window -v

         # Source config using R
         unbind r
         bind r source-file "$XDG_CONFIG_HOME/tmux/tmux.conf"

        # Resize panes
         bind -r j resize-pane -D 5
         bind -r k resize-pane -U 5
         bind -r l resize-pane -R 5
         bind -r h resize-pane -L 5

         # Maximize pane toggle using m
         bind -r m resize-pane -Z

         # Adds spacing to the tmux status bar
         set -g status 2
         set -g status-format[1] ""
      '';
  };
}
