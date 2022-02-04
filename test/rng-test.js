const { expect } = require("chai");
const { BigNumber } = require("ethers");
const { ethers } = require("hardhat");

describe("RNG Operator", function () {
  this.timeout(30_000);

  let RNGOperator;
  let RNGConsumer;

  beforeEach(async () => {
    const RNGOperatorFactory = await starknet.getContractFactory("rng_oracle");
    RNGOperator = await RNGOperatorFactory.deploy({ arg: 1 });

    const RNGConsumerFactory = await starknet.getContractFactory(
      "rng_consumer"
    );

    RNGConsumer = await RNGConsumerFactory.deploy({
      op_address: BigNumber.from(RNGOperator.address),
    });
  });

  it("Should deploy operator", async function () {
    const RNGOperatorFactory = await starknet.getContractFactory("rng_oracle");
    await RNGOperatorFactory.deploy({ arg: 1 });
  });

  it("Should deploy consumer", async function () {
    const RNGConsumerFactory = await starknet.getContractFactory(
      "rng_consumer"
    );
    await RNGConsumerFactory.deploy({ op_address: 1 });
  });

  it("Should recieve rng requests", async function () {
    const { res: rngRequests } = await RNGOperator.call("get_request_index");
    expect(rngRequests).to.equal(BigInt(0));
    await RNGConsumer.call("request_rng");
    const { res: updatedRNGRequests } = await RNGOperator.call(
      "get_request_index"
    );
    expect(updatedRNGRequests).to.equal(BigInt(1));
  });

  it("Should recieve random payload", async function () {
    const high = BigNumber.from("0x" + "260c2421e6a10852940fbc264d1e7ded");
    const low = BigNumber.from("0x" + "0fe7c6320e7075c4ab95293f27a589f7");
    const randomUint = {
      high,
      low,
    };
    RNGOperator.invoke("recieve_rng", {
      rng: { randomness: randomUint },
    });
  });
});
