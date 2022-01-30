import Client, { HTTP } from "drand-client";

import fetch from "node-fetch";
import AbortController from "abort-controller";

global.fetch = fetch;
global.AbortController = AbortController;

const chainHash =
  "8990e7a9aaed2ffed73dbd7092123d6f289930540d7651336225dc172e51b2ce"; // (hex encoded)
const urls = ["https://api.drand.sh", "https://drand.cloudflare.com"];

async function main() {
  const options = { chainHash };

  const client = await Client.wrap(HTTP.forURLs(urls, chainHash), options);

  // e.g. use the client to get the latest randomness round:
  for await (const res of client.watch()) {
    console.log(res);
  }
}

main();
