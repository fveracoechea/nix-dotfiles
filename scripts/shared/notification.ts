export const icons = {
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

export function toMenuItem(item) {
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
