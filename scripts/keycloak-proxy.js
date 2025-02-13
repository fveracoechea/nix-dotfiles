const http = require('http');
const https = require('https');

const TARGET_HOST = '10.1.80.166';
const TARGET_PORT = 8543;
const TARGET_PATH = '/auth';

const server = http.createServer((req, res) => {

  console.log('KEYCLOAK PROXY', req.url);

  const options = {
    hostname: TARGET_HOST,
    port: TARGET_PORT,
    path: TARGET_PATH + req.url,
    method: req.method,
    headers: req.headers,
    rejectUnauthorized: false, // Ignore SSL certificate issues
  };

  const proxyReq = https.request(options, (proxyRes) => {
    res.writeHead(proxyRes.statusCode, proxyRes.headers);
    proxyRes.pipe(res);
  });

  proxyReq.on('error', (err) => {
    res.writeHead(500);
    res.end(`Error: ${err.message}`);
  });

  req.pipe(proxyReq);
});

server.listen(TARGET_PORT, () => {
  console.log(`Proxy server running on http://localhost:${TARGET_PORT}`);
});
