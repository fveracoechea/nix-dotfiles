
const http = require("node:http");
const https = require("node:https");
const { URL } = require('node:url');
const os = require("node:os");

const PORT = 3331;

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


const TARGET_URL = 'https://pmwand4.prounlimited.com';

const server = http.createServer((req, res) => {
  const targetUrl = new URL(TARGET_URL + req.url);

   const options = {
        hostname: targetUrl.hostname,
        path: targetUrl.pathname + targetUrl.search,
        method: req.method,
        headers: req.headers,
        rejectUnauthorized: false,  // Bypass SSL verification (use cautiously)
        ciphers: 'DEFAULT:@SECLEVEL=0', // Allow weaker SSL ciphers if needed
    };

    const proxyReq = https.request(options, (proxyRes) => {
        res.writeHead(proxyRes.statusCode, proxyRes.headers);
        proxyRes.pipe(res);
    });
    
    proxyReq.on('error', (err) => {
        res.writeHead(500, { 'Content-Type': 'text/plain' });
        res.end('Proxy error: ' + err.message);
    });
    
    req.pipe(proxyReq);
});

const localIp = getLocalIp();

server.listen(PORT, () => {
  console.log(`VMS Proxy server running on http://${localIp}:${PORT}`);
});

