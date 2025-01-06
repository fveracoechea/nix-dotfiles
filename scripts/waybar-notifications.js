// @ts-check
const util = require('node:util');
const exec = util.promisify(require('node:child_process').exec);

const icons = {
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

function log(value) {
  value.class = value.alt;
  value.tooltip = value.tooltip.filter(Boolean).join('\r');
  console.log(JSON.stringify(value));
}

function toTooltip(item) {
  const appName = item['app-name'].data.trim().toLowerCase();
  const appIcon = item['app-icon'].data.trim().toLowerCase();
  const title = item.summary.data.trim();
  const body = item.body.data.replace(/(\n\s*)+/g, ' ').trim();

  const icon = icons[appIcon] || icons[appName] || icons.default;

  let notification = `${icon}  ${title}`;
  if (body) notification += `  -  ${body}`;
  return notification;
}

(async function () {
  const [list, history] = await Promise.all([
    exec('makoctl list'),
    exec('makoctl history'),
  ]);

  if (list.stderr || history.stderr) {
    exec(`notify-send "Error loading notifications" "${list.stderr || history.stderr}"`);
    return;
  }

  const data = {
    list: JSON.parse(list.stdout).data[0],
    history: JSON.parse(history.stdout).data[0],
  };

  const result = {
    alt: 'none',
    text: 'No notifications',
    tooltip: [''],
  };

  const hasList = data.list && data.list.length > 0;
  const hasHistory = data.history && data.history.length > 0;

  if (!hasList && !hasHistory) {
    log(result);
    return;
  }

  if (hasHistory) {
    result.alt = 'default';
    result.tooltip = ['History:', ' ', ...data.history.map(toTooltip)];
    result.text = 'Notifications';
  }

  if (hasList) {
    result.alt = 'active';
    result.tooltip = [
      'Unread:',
      ' ',
      ...data.list.map(toTooltip),
      hasHistory ? ' ' : '',
      ...result.tooltip,
    ];
    result.text = `${data.list.length} Unread`;
  }

  log(result);
})();
