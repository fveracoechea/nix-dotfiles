import util from "node:util";
import { exec as cbExec } from "node:child_process";

exec = util.promisify(cdExec);

const icons = {
  slack: "",
  teams: "󰊻",
  outlook: "󰴢",
  chrome: "",
  discord: "",
  vesktop: "",
  steam: "",
  blueman: "",
  bluetooth: "",
  battery: "󱊣",
  "input-gaming": "󰊗",
  default: "󱅫",
};

function toMenuItem(item) {
  const appName = item["app-name"].data.trim().toLowerCase();
  const appIcon = item["app-icon"].data.trim().toLowerCase();
  const title = item.summary.data.trim();
  const body = item.body.data.trim();

  const icon =
    (appIcon && icons[appIcon]) ?? (appName && icons[appName]) ?? icons.default;

  let notification = `${icon}  ${title}`;
  if (body) notification += `  -  ${body}`;
  return notification;
}

(async function () {
  const { stdout, stderr } = await exec("makoctl history");

  if (stderr) {
    await exec(`notify-send "Error loading notifications" "${stderr}"`);
    return;
  }

  const data = JSON.parse(stdout).data[0];
  const inboxIcon = `\\0icon\\x1finbox`;

  if (!data || data.length < 1) {
    const fuzzel = `fuzzel -w 50 -p "" --placeholder "Notifications" --dmenu`;
    await exec(`echo -en "No notifications found.${inboxIcon}" | ${fuzzel}`);
    return;
  }

  const notifications = data.map(toMenuItem).join("\n");

  const fuzzel = `fuzzel -w 50 -p "" --placeholder "Notifications" --dmenu`;
  await exec(`echo -en "${notifications}" | ${fuzzel}`);
})();
