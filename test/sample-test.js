const { expect } = require("chai");
const { BigNumber } = require("ethers");
const { ethers } = require("hardhat");

describe("RNG Operator", function () {
  it("Should recieve random payload", async function () {
    const RNGOperator = await starknet.getContractFactory("rng-operator");
    const RNGOperatorDeployed = await RNGOperator.deploy();

    const high = BigNumber.from("0x" + "260c2421e6a10852940fbc264d1e7ded");
    const low = BigNumber.from("0x" + "0fe7c6320e7075c4ab95293f27a589f7");
    const randomUint = {
      high,
      low,
    };
    console.log(randomUint);
    RNGOperatorDeployed.invoke("recieve_rng", {
      rng: { randomness: randomUint },
    });
  });
});
