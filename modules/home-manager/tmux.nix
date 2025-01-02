{
  pkgs,
  lib,
  ...
}: let
  theme = import ../../utils/catppuccin.nix;
  mapScriptsToPackages = lib.attrsets.mapAttrsToList (pkgs.writeShellScriptBin);
in {
  home.packages =
    (mapScriptsToPackages {
      os-icon-tmux =
        # sh
        ''
          case "$(uname -s)" in
              Darwin) OS_ICON=" " ;;
              Linux)
                  case "$(awk -F= '/^ID=/{print $2}' /etc/os-release | tr -d '\"')" in
                      ubuntu) OS_ICON=" " ;;
                      fedora) OS_ICON=" " ;;
                      arch) OS_ICON=" " ;;
                      pop) OS_ICON=" " ;;
                      nixos) OS_ICON=" " ;;
                      centos) OS_ICON=" " ;;
                      alpine) OS_ICON=" " ;;
                      *) OS_ICON=" " ;;
                  esac
                  ;;
              CYGWIN*|MINGW*|MSYS*) OS_ICON=" " ;;
              *) OS_ICON=" " ;;
          esac
          echo "$OS_ICON"
        '';
      uptime-tmux =
        # sh
        ''
          uptime |
          	awk -F, '{print $1,$2}' |
          	sed 's/:/h /g;s/^.*up *//; s/ *[0-9]* user.*//;s/[0-9]$/&m/;s/ day. */d /g'
        '';
      git-tmux =
        # sh
        ''
          if [ -d .git ]; then
          	git fetch
          	branch=$(git rev-parse --abbrev-ref HEAD)
          	ahead=$(git rev-list --count origin/"$branch".."$branch")
          	behind=$(git rev-list --count "$branch"..origin/"$branch")
          	echo "$branch $ahead $behind"
          else
          	echo "N/A"
          fi
        '';
    })
    ++ [
      (pkgs.writers.writeJSBin "tmux-os-icon" {} (lib.fileContents ../../scripts/tmux-os-icon.js))
    ];

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    mouse = true;
    terminal = "screen-256color";
    baseIndex = 1;

    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.yank
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig =
          # sh
          ''
            set -g @resurrect-strategy-nvim 'session'
          '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig =
          # sh
          ''
            set -g @continuum-save-interval '5'
          '';
      }
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig =
          # tmux
          ''
            set -g @catppuccin_flavour 'mocha'

            ## Window configuration (default)
            set -g @catppuccin_window_left_separator ""
            set -g @catppuccin_window_right_separator " "
            set -g @catppuccin_window_middle_separator " "

            set -g @catppuccin_window_default_fill "all"
            set -g @catppuccin_window_default_color "${theme.overlay1}"
            set -g @catppuccin_window_default_text "#[bold]#W"

            ## Right statusline modules
            set -g @catppuccin_status_modules_right "session gitmux uptime host"
            set -g @catppuccin_status_left_separator  " "
            set -g @catppuccin_status_right_separator ""
            set -g @catppuccin_status_fill "icon"
            set -g @catppuccin_status_connect_separator "no"

            ## Window configuration (current)
            set -g @catppuccin_window_current_fill "all"
            set -g @catppuccin_window_current_color "${theme.blue}"
            set -g @catppuccin_window_current_text "#[bold]#W"

            ## Modules
            ### Session
            set -g @catppuccin_session_icon ""
            set -g @catppuccin_session_color "#{?client_prefix,${lib.toLower theme.peach},${lib.toLower theme.mauve}}"
            ### Git
            set -g @catppuccin_gitmux_icon ""
            set -g @catppuccin_gitmux_color "${theme.pink}"
            set -g @catppuccin_gitmux_text "#(git-tmux)"
            ### Updatime
            set -g @catppuccin_uptime_color "${theme.flamingo}"
            set -g @catppuccin_uptime_text "#(uptime-tmux)"
            ### Hostname
            set -g @catppuccin_host_color "${theme.rosewater}"
            set -g @catppuccin_host_icon "#(os-icon-tmux)"
          '';
      }
    ];

    extraConfig =
      # tmux
      ''
         # Terminal color
         set-option -ga terminal-overrides ",xterm-256color:Tc"

         # Set status bar on the top
         set-option -g status-position top

         # Reset default command
         set-option -g default-command ""

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
