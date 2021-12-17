require('babel-register');
require('dotenv').config()
const HDWalletProvider = require('truffle-hdwallet-provider')

module.exports = {
  compilers: {
    // solc: {
    //   version: ">=0.4.0 <=0.7.0"
    // }
  },
  networks: {
    test: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*"
    },
    rinkeby: {
      skipDryRun: true,
      provider() {
        return new HDWalletProvider(
          process.env.TESTNET_MNEMONIC,
          'https://rinkeby.infura.io/v3/' + process.env.INFURA_API_KEY,
          0,
          10
        )
      },
      network_id: 4,
      // gas: 4700000,
      gasPrice: 5000000000 // 5 GWEI
    },
    mainnet: {
      skipDryRun: true,
      provider() {
        return new HDWalletProvider(
          process.env.TESTNET_MNEMONIC,
          'https://mainnet.infura.io/v3/' + process.env.INFURA_API_KEY,
          0,
          10
        )
      },
      network_id: 1,
      // gas: 4700000,
      gasPrice: 65000000000 // 65 GWEI
    },
  }
};
