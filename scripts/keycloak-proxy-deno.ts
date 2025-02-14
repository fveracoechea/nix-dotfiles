import { parse } from "https://deno.land/std@0.200.0/flags/mod.ts";

function getIp() {
  for (const net of Deno.networkInterfaces()) {
    if (net.family === "IPv4" && !net.address.includes("127.0.0.1")) {
      return net.address;
    }
  }
}

const { target = "https://10.1.80.166:8543", name = "Proxy", port = 8543 } =
  parse(
    Deno.args,
  );

Deno.serve({ port }, async (request) => {
  const { pathname, search } = new URL(request.url);
  const url = new URL(pathname + search, target);

  const response = await fetch(url, request);
  console.log(name, url, response.status);
  return response;
});

console.log(`${name} running on ${getIp()}:${port}`);
