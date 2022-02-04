//.mjs = module js file, drand-client requires module imports

// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const starknet = hre.starknet;

import Client, { HTTP } from "drand-client";
import fetch from "node-fetch";
import AbortController from "abort-controller";
import { uint256 } from "starknet";
import { BigNumber } from "ethers";
const { bnToUint256, isUint256 } = uint256;
global.fetch = fetch;
global.AbortController = AbortController;

const chainHash =
  "8990e7a9aaed2ffed73dbd7092123d6f289930540d7651336225dc172e51b2ce"; // (hex encoded)
const urls = ["https://api.drand.sh", "https://drand.cloudflare.com"];

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const Oracle = await starknet.getContractFactory("rng_oracle");
  const OracleDeployed = await Oracle.deploy({ val: 1 });

  console.log("Oracle deployed to:", OracleDeployed.address);

  const options = { chainHash };
  const client = await Client.wrap(HTTP.forURLs(urls, chainHash), options);

  // e.g. use the client to get the latest randomness round:
  for await (const res of client.watch()) {
    const rng_high = "0x" + res.randomness.slice(0, 32);
    const rng_low = "0x" + res.randomness.slice(32, 64);
    const randomUint = {
      high: rng_high,
      low: rng_low,
    };
    await OracleDeployed.invoke("resolve_rng_requests", {
      rng_high: BigNumber.from(rng_high),

      rng_low: BigNumber.from(rng_low),
    });
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
