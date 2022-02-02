const { expect } = require("chai");
const { BigNumber } = require("ethers");
const { ethers } = require("hardhat");

describe("RNG Operator", function () {
  it("Should deploy operator", async function () {
    const RNGOperatorFactory = await starknet.getContractFactory(
      "rng-operator"
    );
    await RNGOperatorFactory.deploy({ arg: 1 });
  });

  it("Should recieve rng requests", async function () {
    const RNGOperatorFactory = await starknet.getContractFactory(
      "rng-operator"
    );
    const RNGOperator = await RNGOperatorFactory.deploy({ arg: 1 });

    const RNGConsumerFactory = await starknet.getContractFactory(
      "rng-operator"
    );
    console.log(RNGOperator.address.slice(2));
    const RNGConsumer = await RNGConsumerFactory.deploy({
      op_address: RNGOperator.address.slice(2),
    });

    RNGConsumer.invoke("request_rng");
  });

  it("Should recieve random payload", async function () {
    const RNGOperatorFactory = await starknet.getContractFactory(
      "rng-operator"
    );
    const RNGOperator = await RNGOperatorFactory.deploy({ arg: 1 });

    const high = BigNumber.from("0x" + "260c2421e6a10852940fbc264d1e7ded");
    const low = BigNumber.from("0x" + "0fe7c6320e7075c4ab95293f27a589f7");
    const randomUint = {
      high,
      low,
    };
    console.log(randomUint);
    RNGOperator.invoke("recieve_rng", {
      rng: { randomness: randomUint },
    });
  });
});
