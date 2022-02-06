//.mjs = module js file, drand-client requires module imports
const hre = require("hardhat");
const starknet = hre.starknet;

const DiceContractAddress = "";

async function main() {
  const Dice = await starknet.getContractFactory("dice");
  const DiceDeployed = await Dice.getContractAt(DiceContractAddress);

  console.log("Calling dice contract ", DiceDeployed.address);
  let txId = await DiceDeployed.invoke("request_rng");
  let rollResult = BigInt("0");

  while (rollResult === "0n") {
    setTimeout(() => {
      rollResult = DiceDeployed.call("get_roll_result", { id: txId });
    }, 60000);
  }

  console.log("roll result is ", rollResult);
  console.log("for txId ", txId);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
