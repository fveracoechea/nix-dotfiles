{pkgs, ...}: let
  customPkgs = import ../../packages pkgs;
in {
  home.packages = [
    customPkgs.scripts.tmux-uptime
    customPkgs.scripts.tmux-os-icon
    customPkgs.scripts.tmux-git-status
  ];

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    terminal = "tmux-256color";
    mouse = true;
    baseIndex = 1;

    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.yank
      {
        plugin = customPkgs.tmuxPlugins.catppuccin;
        # config before loading this plugin
        extraConfig =
          #bash
          ''
            set -g @catppuccin_flavor "mocha"
            set -g @catppuccin_window_status_style "rounded"

            set -g @catppuccin_window_text " #W"
            set -g @catppuccin_window_current_text " #W"

            set -g @catppuccin_gitmux_icon " "
            set -g @catppuccin_session_icon " "
            set -g @catppuccin_session_color "#{?client_prefix,#{E:@thm_peach},#{E:@thm_blue}}"
          '';
      }
    ];

    extraConfig =
      #bash
      ''
        # Catppuccin config after loading the plugin
        set-option -g status-style bg=default
        set -gF @catppuccin_status_background "none"

        set -g allow-passthrough on
        set -ga update-environment TERM
        set -ga update-environment TERM_PROGRAM

        set -g @catppuccin_gitmux_text " #(tmux-git-status)"
        set -g @catppuccin_uptime_text " #(tmux-uptime)"
        set -g @catppuccin_host_icon "#(tmux-os-icon) "

        set -g status-right "#{E:@catppuccin_status_session}"
        set -ag status-right "#{E:@catppuccin_status_gitmux}"
        set -ag status-right "#{E:@catppuccin_status_uptime}"
        set -ag status-right "#{E:@catppuccin_status_host}"

        set -g status-right-length 100
        set -g status-left-length 100
        set -g status-left ""

        set-environment -g COLORTERM "truecolor"
        set-option -g status-position top

        # Reset default command
        set-option -g default-command ""

        # Renumber all windows when any window is closed
        set -g renumber-windows on

        # Enable dynamic titles
        set-option -g set-titles on
        set-option -g set-titles-string "#(echo #{pane_current_path} | sed 's#$HOME#~#g') - #W"

        set-option -g history-limit 100000

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

        # Enable focus-events
        set-option -g focus-events on
      '';
  };
}
