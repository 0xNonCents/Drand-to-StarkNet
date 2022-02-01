require("@nomiclabs/hardhat-waffle");
require("@shardlabs/starknet-hardhat-plugin");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  paths: {},
  networks: {
    myNetwork: {
      url: "http://localhost:5000",
    },
  },
  mocha: {
    // Used for deployment in Mocha tests
    // Defaults to "alpha" (for Alpha testnet), which is preconfigured even if you don't see it under `networks:`
    starknetNetwork: "myNetwork",
  },
  solidity: "0.8.4",
};
