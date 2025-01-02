const { stdout, stderr } = await exec('makoctl history');

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

const notifications = data.map(toMenuItem).join('\n');

const fuzzel = `fuzzel -w 50 -p "" --placeholder "Notifications" --dmenu`;
await exec(`echo -en "${notifications}" | ${fuzzel}`);
