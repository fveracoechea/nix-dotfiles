
const http = require('http');
const httpProxy = require('http-proxy');

// Create a proxy server
const proxy = httpProxy.createProxyServer({
  target: 'https://pmwand4.prounlimited.com',
  changeOrigin: true,
  secure: false // if you want to verify SSL certificates
});

// Create a server which uses the proxy
const server = http.createServer((req, res) => {
  console.log(req.url)
  proxy.web(req, res);
});

// Listen to port 8080
console.log("Proxy server listening on port 8081");
server.listen(8081);

