import { parse } from "https://deno.land/std@0.200.0/flags/mod.ts";

Deno.serve(async (request) => {
  const { target = "https://10.1.80.166:8543", name = "Proxy" } = parse(
    Deno.args,
  );

  const { pathname, search } = new URL(request.url);
  const url = new URL(pathname + search, target);

  const response = await fetch(url, request);
  console.log(name, url, response.status);
  return response;
});
