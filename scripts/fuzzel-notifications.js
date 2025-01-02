// @ts-check
const { exec } = require("node:child_process");

const excludedApps = ["notify-send"];

exec("makoctl history", (error, stdout, stderr) => {
  if (stderr) {
    exec(`notify-send "Error loading notifications" "''${stderr}"`);
    return;
  }

  const data = JSON.parse(stdout).data[0];
  const inboxIcon = `\\0icon\\x1finbox`;

  if (!data || data.length < 1) {
    exec(
      `echo -en "No notifications found.''${inboxIcon}" | fuzzel -w 40 -p "" --placeholder "Notifications" --dmenu`,
    );
    return;
  }

  const notifications = data
    .map((item) => {
      const app = item["app-name"].data.trim();
      const icon = item["app-icon"].data.trim();
      const title = item.summary.data.trim();
      const body = item.body.data.trim();

      let notification = title;
      if (body) notification += `   ---   ''${body}`;
      if (icon) notification += `\\0icon\\x1f''${icon}`;
      else if (app && !excludedApps.includes(app))
        notification += `\\0icon\\x1f''${app.toLowerCase()}`;
      else notification += inboxIcon;

      return notification;
    })
    .join("\n");

  const args = `-w 40 -p "" --placeholder "Notifications"`;

  exec(`echo -en "''${notifications}" | fuzzel ''${args} --dmenu`);
});
