// Run `hyprctl monitors` and get the output
const monitorsOutput = execSync("hyprctl monitors").toString();

const resolution = "3840x2160@120"

// Check if DP-2 is currently at 3840x2160@120
if (monitorsOutput.includes("DP-2") && monitorsOutput.includes(resolution)) {
  // Switch to highrr mode
  execSync('hyprctl keyword monitor "DP-2, highrr, auto, auto, cm, hdr, vrr, 1"');
  console.log("Switched to highrr mode");
} else {
  // Switch to 3840x2160@120
  execSync('hyprctl keyword monitor "DP-2, 3840x2160@120, auto, auto, cm, hdr, vrr, 1"');
  console.log("Switched to 3840x2160@120");
}
