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
        line-height = 22;
        prompt = ''"❯  "'';
        placeholder = "Apps";
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
    (pkgs.writers.writeJSBin "fuzzel-powermenu" {}
      # javascript
      ''
        const { exec } = require("node:child_process");

        const menu = [
          { icon: "", label: "Lock", exec: "hyprlock" },
          { icon: "", label: "Logout", exec: "hyprctl dispatch exit" },
          { icon: "", label: "Suspend", exec: "systemctl suspend" },
          { icon: "", label: "Reboot", exec: "systemctl reboot" },
          { icon: "", label: "Shutdown", exec: "systemctl poweroff -i"}
        ];

        const menuItems = menu.map(m => `''${m.icon} \t''${m.label}`).join('\n');

        const args = `-a top-right --y-margin 8 --x-margin 16 -w 15 -l 5 -p "" --placeholder \"Power Menu\"`;

        exec(`echo -en "''${menuItems}" | fuzzel ''${args} --dmenu `, (error, stdout) => {

          if (!stdout) return;

          const item = menu.find(m => stdout.toLowerCase().includes(m.label.toLowerCase()))

          if (!item) {
            exec(`notify-send "No menu item was found."`);
            return;
          }

          exec(item.exec);
        });
      '')

    (pkgs.writers.writeJSBin "fuzzel-notifications" {}
      # javascript
      ''
        const { exec } = require("node:child_process");

        const excludedApps = ['notify-send'];

        exec('makoctl history', (error, stdout, stderr)=> {
          if (stderr) {
            exec(`notify-send "Error loading notifications" "''${stderr}"`);
            return;
          }

          const data = JSON.parse(stdout).data[0];
          const inboxIcon = `\\0icon\\x1finbox`;

          if (!data || data.length < 1) {
            exec(`echo -en "No notifications found.''${inboxIcon}" | fuzzel -w 40 -p "" --placeholder "Notifications" --dmenu`);
            return;
          }

          const notifications = data
            .map(item => {
              const app = item['app-name'].data.trim();
              const icon = item['app-icon'].data.trim();
              const title = item.summary.data.trim();
              const body = item.body.data.trim();

              let notification = title;
              if (body) notification += `   ---   ''${body}`;
              if (icon) notification += `\\0icon\\x1f''${icon}`;
              else if (app && !excludedApps.includes(app))  notification += `\\0icon\\x1f''${app}`;
              else notification += inboxIcon;

              return notification
            })
            .join('\n')

          const args = `-w 40 -p "" --placeholder "Notifications"`

          exec(`echo -en "''${notifications}" | fuzzel ''${args} --dmenu`);
        })
      '')
  ];
}
