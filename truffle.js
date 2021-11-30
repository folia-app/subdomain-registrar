require('babel-register');

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
    }
  }
};
