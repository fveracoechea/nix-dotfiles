// @ts-check
const util = require("node:util");
const exec = util.promisify(require("node:child_process").exec);

const args = `-a top-left --y-margin 8 --x-margin 16 -w 15 -l 5 -p "" --placeholder \"Power Menu\" --dmenu`;

(async function () {
  const menu = [
    { icon: "", label: "Lock", exec: "hyprlock" },
    { icon: "", label: "Logout", exec: "hyprctl dispatch exit" },
    { icon: "", label: "Suspend", exec: "systemctl suspend" },
    { icon: "", label: "Reboot", exec: "systemctl reboot" },
    { icon: "", label: "Shutdown", exec: "systemctl poweroff -i" },
  ];

  const menuItems = menu.map((m) => `${m.icon} \t${m.label}`).join("\n");

  const { stdout } = await exec(`echo -en "${menuItems}" | fuzzel ${args}`);
  if (!stdout) return;

  const item = menu.find((m) => stdout.toLowerCase().includes(m.label.toLowerCase()));

  if (!item) {
    await exec(`notify-send "No menu item was found."`);
    return;
  }

  await exec(item.exec);
})();
