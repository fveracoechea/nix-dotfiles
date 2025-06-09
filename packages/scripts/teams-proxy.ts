import http from "node:http";
import httpProxy from "npm:http-proxy";

const port = 8081;

// Create a proxy server
const proxy = httpProxy.createProxyServer({
  target: "https://teams.microsoft.com",
  changeOrigin: true,
  secure: false, // if you want to verify SSL certificates
});

// Create a server which uses the proxy
const server = http.createServer((req, res) => {
  console.log(req.url);
  proxy.web(req, res);
});

console.log(`Proxy server listening on port ${port}`);
server.listen(port);
