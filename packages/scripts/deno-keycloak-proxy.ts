const PORT = 8080;
const TARGET = "https://pmwand4-iam.prounlimited.com";

function onListen() {
  console.log("Proxy server listening on http://localhost:8080");
}

async function handle(req: Request) {
  const url = new URL(req.url);
  const targetUrl = new URL(req.url, TARGET);
  console.log(url.pathname);

  const proxyRes = await fetch(targetUrl.toString(), {
    method: req.method,
    headers: req.headers,
    body: req.body,
    redirect: "manual",
  });

  // Return the proxied response
  return new Response(proxyRes.body, {
    status: proxyRes.status,
    headers: proxyRes.headers,
  });
}

Deno.serve({ onListen, port: PORT }, handle);
