{pkgs, ...}: let
  theme = import ../../utils/catppuccin.nix;
  icon = icon: ''<span size="large">${icon}</span>'';
  themeIcon = color: icon: ''<span color="${color}" size="large">${icon}</span>'';
  button = color: icon: text: ''<span color="${color}" size="large">${icon} </span> ${text}'';
in {
  home.packages = [
    (pkgs.helpers.nodeJsScript "waybar-notifications")
  ];

  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        spacing = 12;
        margin-top = 12;
        margin-left = 12;
        margin-right = 12;

        "custom/settings" = {
          format = icon "";
          on-click = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome-control-center}/bin/gnome-control-center";
          tooltip-format = "System Settings";
        };

        "custom/nautilus" = {
          format = icon "";
          on-click = "nautilus";
          tooltip-format = "Open File Manager";
        };

        "custom/spotify" = {
          format = icon "";
          on-click = "spotify";
          tooltip-format = "Spotify";
        };

        "custom/discord" = {
          format = icon "";
          on-click = "vesktop";
          tooltip-format = "Discord";
        };

        "custom/powermenu" = {
          format = icon "";
          tooltip-format = "Power menu";
          on-click = "fuzzel-powermenu";
        };

        "group/quick-links" = {
          orientation = "horizontal";
          modules = [
            "custom/powermenu"
            "custom/settings"
            "custom/nautilus"
            "custom/ssmonitor"
            "custom/sswindow"
            "custom/ssregion"
          ];
        };

        cpu = {
          format = button theme.rosewater "" "{usage}%";
        };

        temperature = {
          format = button theme.rosewater "" "{temperatureC}󰔄";
        };

        memory = {
          format = button theme.rosewater "" "{used:0.1f}G/{total:0.1f}G";
        };

        "group/stats" = {
          orientation = "horizontal";
          modules = [
            "cpu"
            "temperature"
            "memory"
          ];
        };

        "custom/ssmonitor" = {
          format = icon "󰹑";
          tooltip-format = "Take screenshot of the entire monitor.";
          on-click = "hyprshot -m output";
        };

        "custom/sswindow" = {
          format = icon "";
          tooltip-format = "Take screenshot of a window.";
          on-click = "hyprshot -m window";
        };

        "custom/ssregion" = {
          format = icon "󰩭";
          tooltip-format = "Take screenshot of selected region.";
          on-click = "hyprshot -m region";
        };

        "group/screenshot" = {
          orientation = "horizontal";
          modules = [
            "custom/ssmonitor"
            "custom/sswindow"
            "custom/ssregion"
          ];
        };

        pulseaudio = {
          scroll-step = 2;
          on-click = "pavucontrol";
          format = button theme.pink "{icon}" "{volume}%";
          format-bluetooth = button theme.pink "{icon}" "{volume}";
          format-muted = button theme.pink "" "muted";
          format-icons = {
            "alsa_output.pci-0000_00_1f.3.analog-stereo" = "";
            "alsa_output.pci-0000_00_1f.3.analog-stereo-muted" = "";
            headphone = "";
            headset = "󰋎";
            phone = "";
            phone-muted = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
        };

        network = {
          interval = 30;
          format-disconnected = button theme.flamingo "󰖪" "0%";
          format-ethernet = button theme.flamingo "" "{bandwidthTotalBits}";
          format-linked = "{ifname} (No IP)";
          format-wifi = button theme.flamingo "" "{signalStrength}%";
          tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
          on-click = "nm-connection-editor";
        };

        "clock#time" = {
          format = button theme.blue "󰥔" "{:%I:%M %p}";
          on-click = "gnome-calendar";
          tooltip = false;
        };

        "clock#date" = {
          format = button theme.mauve "" "{:%A %b %d}";
          on-click = "gnome-calendar";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = ''<span color="${theme.mauve}"><b>{}</b></span>'';
              days = ''<span color="${theme.text}">{}</span>'';
              weeks = ''<span color="${theme.rosewater}">W{}</span>'';
              weekdays = ''<span color="${theme.flamingo}"><b>{}</b></span>'';
              today = ''<span color="${theme.red}"><b>{}</b></span>'';
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        "hyprland/window" = {
          format = "{title}";
          separate-outputs = true;
          icon = true;
          rewrite = {
            "" = "Nixos - Hyprland";
            "(.*) - Google Chrome" = "$1";
            "(.*) - nvim" = "$1 - Neovim";
          };
        };

        "hyprland/workspaces" = {
          on-scroll-up = "hyprctl dispatch workspace r-1";
          on-scroll-down = "hyprctl dispatch workspace r+1";
          on-click = "activate";
          active-only = false;
          all-outputs = true;
          format = "{}";
          format-icons = {
            "urgent" = "";
            "active" = "";
            "default" = "";
          };
          persistent-workspaces = {
            "*" = 5;
          };
        };

        tray = {
          icon-size = 22;
          spacing = 8;
          show-passive-items = true;
        };

        "custom/notifications" = {
          format = "{icon}   {}";
          return-type = "json";
          interval = 5;
          exec = "waybar-notifications";
          on-click = "makoctl dismiss -a";
          format-icons = {
            active = themeIcon theme.peach "󰂞";
            default = themeIcon theme.mauve "󰂚";
            none = themeIcon theme.overlay2 "󰂛";
          };
        };

        modules-left = [
          "group/quick-links"
          # "group/screenshot"
          "tray"
          "custom/notifications"
          "hyprland/workspaces"
        ];

        modules-center = [
          "hyprland/window"
        ];

        modules-right = [
          "clock#time"
          "clock#date"
          "pulseaudio"
          "network"
          "group/stats"
        ];
      };
    };

    style =
      #css
      ''
        * {
          font-family: "Fira Sans", sans-serif;
          font-weight: 500;
          font-size: 16px;
          border: none;
          border-radius: 0px;
        }

        window#waybar {
          background-color: transparent;
        }

        tooltip, #tray menu {
          padding: 6px 12px;
          border-radius: 1em;
          background-color: ${theme.mantle};
          border: 3px solid ${theme.overlay1};
          color: ${theme.text};
        }

        #custom-music,
        #tray,
        #backlight,
        #clock,
        #battery,
        #bluetooth,
        #pulseaudio,
        #custom-lock,
        #gamemode,
        #network,
        #gamemode,
        #stats,
        #window,
        #quick-links,
        #screenshot,
        #custom-notifications,
        #workspaces {
          border-radius: 1.2em;
          transition: background-color 300ms ease, color 300ms ease;
          background-color: ${theme.base};
          padding: 4px 10px;
          color: ${theme.text};
          border: 3px solid ${theme.surface2};
        }

        #workspaces, #quick-links, #screenshot, #stats {
          padding: 4px;
        }

        #custom-powermenu,
        #custom-settings,
        #custom-nautilus,
        #custom-spotify,
        #custom-discord,
        #custom-ssmonitor,
        #custom-sswindow,
        #custom-ssregion {
          transition: all 300ms ease;
          color: ${theme.text};
          padding: 1px 15px 1px 9px;
          border-radius: 1em;
        }

        #window {
          color: ${theme.text};
        }

        #custom-powermenu {
          color: ${theme.red};
        }

        #custom-settings,
        #custom-nautilus,
        #custom-discord,
        #custom-ssmonitor,
        #custom-sswindow,
        #custom-ssregion,
        #custom-spotify {
          color: ${theme.subtext0};
        }

        #workspaces button {
          border-radius: 1.2em;
          transition: all 300ms ease;
          padding: 0 10px;
          margin: 0;
          color: ${theme.blue};
        }

        #custom-notifications:hover,
        #custom-nautilus:hover,
        #custom-settings:hover,
        #custom-spotify:hover,
        #custom-discord:hover,
        #custom-powermenu:hover,
        #custom-ssmonitor:hover,
        #custom-sswindow:hover,
        #custom-ssregion:hover,
        #pulseaudio:hover,
        #clock:hover,
        #cpu:hover,
        #temperature:hover,
        #memory:hover,
        #workspaces button:hover {
          color: ${theme.text};
          background-color: ${theme.surface1};
        }

        #workspaces button.active {
          color: ${theme.mantle};
          background-color: ${theme.blue};
        }

        #cpu,
        #temperature {
          border-radius: 1em;
          padding: 1px 10px 1px 5px;
        }

        #memory {
          border-radius: 1em;
          padding: 1px 6px;
        }
      '';
  };
}
