import {
  Notification,
  toMenuItem,
} from 'https://raw.githubusercontent.com/fveracoechea/nix-dotfiles/refs/heads/main/scripts/shared/notification.ts?1';

import util from 'node:util';
import childProcess from 'node:child_process';

const exec = util.promisify(childProcess.exec);

const { stdout, stderr } = await exec('makoctl history');

if (stderr) {
  await exec(`notify-send "Error loading notifications" "${stderr}"`);
  Deno.exit();
}

const data = JSON.parse(stdout).data[0] as Notification[];
const inboxIcon = `\\0icon\\x1finbox`;

if (!data || data.length < 1) {
  const fuzzel = `fuzzel -w 50 -p "" --placeholder "Notifications" --dmenu`;
  await exec(`echo -en "No notifications found.${inboxIcon}" | ${fuzzel}`);
  Deno.exit();
}

const notifications = data.map(toMenuItem).join('\n');

const fuzzel = `fuzzel -w 50 -p "" --placeholder "Notifications" --dmenu`;

try {
  await exec(`echo -en "${notifications}" | ${fuzzel}`);
} catch {
  // no errors
}

Deno.exit();
