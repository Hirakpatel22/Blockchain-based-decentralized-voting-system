require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  networks: {
    hardhat: {
    },
    // Add other networks as needed
    // sepolia: {
    //   url: `https://sepolia.infura.io/v3/YOUR-PROJECT-ID`,
    //   accounts: [process.env.PRIVATE_KEY]
    // }
  }
}; 