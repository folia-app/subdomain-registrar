require('babel-register');

module.exports = {
  compilers: {
    solc: {
      version: "pragma"
    }
  },
/*  networks: {
    test: {
      host: "127.0.0.1",
      port: 9545,
      network_id: "*"
    }
  }*/
};
