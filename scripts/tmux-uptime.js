// @ts-check
const os = require('os');

const seconds = os.uptime();
const days = Math.floor(seconds / 86400);
const hours = Math.floor((seconds % 86400) / 3600);
const minutes = Math.floor((seconds % 3600) / 60);

let result = "";
if (hours > 0) result += ` ${hours}h`;
if (days > 0) result += ` ${days}d`;
result += ` ${minutes}m`;

console.log(result.trim());


