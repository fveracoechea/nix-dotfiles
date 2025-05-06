import http from "node:http";
import httpProxy from "npm:http-proxy";

// Create a proxy server
const proxy = httpProxy.createProxyServer({
  target: "https://pmwand4-iam.prounlimited.com",
  changeOrigin: true,
  secure: false, // if you want to verify SSL certificates
});

// Create a server which uses the proxy
const server = http.createServer((req, res) => {
  console.log(req.url);
  proxy.web(req, res);
});

// Listen to port 8080
console.log("Proxy server listening on port 8080");
server.listen(8080);
