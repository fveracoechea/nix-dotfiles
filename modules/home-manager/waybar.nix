{pkgs, ...}: let
  c = import ../../utils/catppuccin.nix;
  icon = icon: ''<span size="large">${icon}</span>'';
  button = icon: text: ''<span size="large">${icon} </span> ${text}'';
in {
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

        "custom/settings" = let
          settings = pkgs.gnome-control-center;
        in {
          format = icon "";
          on-click = "env XDG_CURRENT_DESKTOP=gnome ${settings}/bin/gnome-control-center";
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
            "custom/discord"
            "custom/spotify"
          ];
        };

        cpu = {
          format = button "" "{usage}%";
        };

        temperature = {
          format = button "" "{temperatureC}󰔄";
        };

        memory = {
          format = button "" "{used:0.1f}G/{total:0.1f}G";
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
          format = button "{icon}" "{volume}%";
          format-bluetooth = button "{icon}" "{volume}";
          format-muted = button "" "muted";
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
          format-disconnected = button "󰖪" "0%";
          format-ethernet = button "" "{bandwidthTotalBits}";
          format-linked = "{ifname} (No IP)";
          format-wifi = button "" "{signalStrength}%";
          tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
          on-click = "nm-connection-editor";
        };

        "clock#time" = {
          format = button "󰥔" "{:%I:%M %p}";
          on-click = "gnome-calendar";
          tooltip = false;
        };

        "clock#date" = {
          format = button "" "{:%A %b %d}";
          on-click = "gnome-calendar";
          tooltip = false;
        };

        "hyprland/window" = {
          format = "{title}";
          separate-outputs = true;
          icon = true;
          rewrite = {
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

          tray = {
            icon-size = 32;
            spacing = 12;
            show-passive-items = true;
          };

          persistent-workspaces = {
            "*" = 5;
          };
        };

        modules-left = [
          "group/quick-links"
          "group/screenshot"
          "hyprland/workspaces"
          "tray"
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
          margin: 0px;
          padding: 0px;
        }

        window#waybar {
          background-color: transparent;
        }

        tooltip {
          border-radius: 5px;
          background-color: ${c.mantle};
          padding: 4px 18px;
          border: 2px solid ${c.overlay1};
          margin: 0px;
          color: ${c.text};
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
        #workspaces {
          border-radius: 1em;
          transition: background-color 300ms ease, color 300ms ease;
          background-color: ${c.base};
          padding: 4px 10px;
          color: ${c.text};
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
          color: ${c.text};
          padding: 1px 15px 1px 9px;
          border-radius: 1em;
        }

        #window {
          color: ${c.blue};
        }

        #custom-powermenu {
          color: ${c.red};
        }

        #custom-settings,
        #custom-nautilus,
        #custom-discord,
        #custom-spotify {
          color: ${c.flamingo};
        }

        #custom-ssmonitor,
        #custom-sswindow,
        #custom-ssregion {
          color: ${c.rosewater};
        }

        #workspaces button {
          border-radius: 1.2em;
          transition: all 300ms ease;
          padding: 0 10px;
          margin: 0;
          color: ${c.blue};
        }

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
          background-color: ${c.surface1};
        }

        #workspaces button.active {
          color: ${c.mantle};
          background-color: ${c.blue};
        }

        #cpu,
        #temperature,
        #memory {
          border-radius: 1em;
          padding: 1px 8px 1px 5px;
        }

        #tray menu {
          border-radius: 8px;
          padding: 6px;
          border: 2px solid ${c.surface2};
        }
      '';
  };
}
