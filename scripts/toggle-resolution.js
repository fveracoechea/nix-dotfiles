const { execSync } = require("node:child_process");
// Run `hyprctl monitors` and get the output
const monitorsOutput = execSync("hyprctl monitors").toString();

const resolution = "3840x2160@60.00Hz"

// Check if DP-2 is currently at 3840x2160@60
if (monitorsOutput.includes("DP-3") && monitorsOutput.includes(resolution)) {
  // Switch to highrr mode
  execSync('hyprctl keyword monitor "DP-3, highrr, auto, auto, cm, hdr, vrr, 1"');
  console.log("Switched to highrr mode");
} else {
  execSync(`hyprctl keyword monitor "DP-3, ${resolution}, auto, auto, cm, hdr, vrr, 1"`);
  console.log(`Switched to ${resolution}`);
}
