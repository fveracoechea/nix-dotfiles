export type AttributeData = {
  type: string;
  data: string;
};

export type Notification = {
  'app-name': AttributeData;
  'app-icon': AttributeData;
  'summary': AttributeData;
  'body': AttributeData;
};

export const icons: Record<string, string> = {
  slack: '',
  teams: '󰊻',
  outlook: '󰴢',
  chrome: '',
  discord: '',
  vesktop: '',
  steam: '',
  blueman: '',
  bluetooth: '',
  battery: '󱊣',
  'input-gaming': '󰊗',
  default: '󱅫',
};

export function toMenuItem(item: Notification) {
  const appName = item['app-name'].data.trim().toLowerCase();
  const appIcon = item['app-icon'].data.trim().toLowerCase();
  const title = item.summary.data.trim();
  const body = item.body.data.trim();

  const icon = (appIcon && icons[appIcon]) ?? (appName && icons[appName]) ??
    icons.default;

  console.log('icon', icon);

  let notification = `${icon}  ${title}`;
  if (body) notification += `  -  ${body}`;
  return notification;
}
