{pkgs, ...}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        match-mode = "fzf";
        match-counter = "yes";
        layer = "overlay";
        icon-theme = "Papirus-Dark";
        icons-enabled = "yes";
        horizontal-pad = 20;
        vertical-pad = 12;
        line-height = 18;
      };

      border = {
        width = 3;
        radius = 8;
      };

      key-bindings = {
        delete-line-forward = "none";
        next = "Control+j";
        prev = "Control+k";
      };
    };
  };

  home.packages = [
    (pkgs.writeShellScriptBin
      "fuzzel-powermenu"
      # sh
      ''
        entries=" \tLock \n  \t Logout \n  \t Suspend \n  \t Reboot \n  \t Shutdown "
        selected=$(echo -e "$entries" | fuzzel --dmenu -a top-right --y-margin 8 --x-margin 16 -w 15 -l 5 --cache /dev/null | awk '{print tolower($2)}')

        case $selected in
        logout)
          exec hyprctl dispatch exit
          ;;
        suspend)
          exec systemctl suspend
          ;;
        reboot)
          exec systemctl reboot
          ;;
        shutdown)
          exec systemctl poweroff -i
          ;;
        lock)
          exec hyprlock
          ;;
        esac
      '')
  ];
}