import { exec } from "node:child_process";

const menu = [
  { icon: "", label: "Lock", exec: "hyprlock" },
  { icon: "", label: "Logout", exec: "hyprctl dispatch exit" },
  { icon: "", label: "Suspend", exec: "systemctl suspend" },
  { icon: "", label: "Reboot", exec: "systemctl reboot" },
  { icon: "", label: "Shutdown", exec: "systemctl poweroff -i"}
];

const menuItems = menu.map(m => `${m.icon} \t${m.label}`).join('\n');

const args = `-a top-right --y-margin 8 --x-margin 16 -w 15 -l 5 -p "" --placeholder \"Power Menu\"`;

exec(`echo -en "${menuItems}" | fuzzel ${args} --dmenu `, (error, stdout) => {

  if (error) {
    exec(`notify-send "${error}"`);
    return;
  }

  if (!stdout) return;

  const item = menu.find(m => stdout.toLowerCase().includes(m.label.toLowerCase()))

  if (!item) {
    exec(`notify-send "No menu item was found."`);
    return;
  }

  exec(item.exec);
});
