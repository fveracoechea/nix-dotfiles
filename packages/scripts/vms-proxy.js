
const http = require("node:http");
const https = require("node:https");
const os = require("node:os");

const TARGET_HOST = "https://pmwand4.prounlimited.com";
const TARGET_PORT = 3331;

/**
 * Get the local IP address of the machine.
 * Prioritizes IPv4 addresses that are not internal loopback (127.0.0.1).
 */
function getLocalIp() {
  const interfaces = os.networkInterfaces();
  for (const iface of Object.values(interfaces)) {
    for (const info of iface ?? []) {
      if (info.family === "IPv4" && !info.internal) {
        return info.address;
      }
    }
  }
  return "Unknown";
}

const server = http.createServer((req, res) => {
  console.log("VMS PROXY ", req.url);

  const options = {
    hostname: TARGET_HOST,
    path: req.url || "/",
    method: req.method,
    headers: req.headers,
    rejectUnauthorized: false, // Ignore SSL certificate issues
  };

  const proxyReq = https.request(options, (proxyRes) => {
    res.writeHead(proxyRes.statusCode ?? 500, proxyRes.headers);
    proxyRes.pipe(res);
  });

  proxyReq.on("error", (err) => {
    res.writeHead(500);
    res.end(`Error: ${err.message}`);
  });

  req.pipe(proxyReq);
});

const localIp = getLocalIp();

server.listen(TARGET_PORT, () => {
  console.log(`VMS Proxy server running on http://${localIp}:${TARGET_PORT}`);
});
