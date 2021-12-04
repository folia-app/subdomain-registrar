var HashRegistrar = artifacts.require("HashRegistrar");
var TestResolver = artifacts.require("TestResolver");
var ENS = artifacts.require("@ensdomains/ens/contracts/ENSRegistry.sol");
var SubdomainRegistrar = artifacts.require("SubdomainRegistrar");

var namehash = require('eth-ens-namehash');
var sha3 = require('js-sha3').keccak_256;
var Promise = require('bluebird');

var domainnames = require('../app/js/domains.json');

module.exports = function (deployer, network, accounts) {
    return deployer.then(async () => {
            const subdomainRegistrar = SubdomainRegistrar.deployed()
            
    });
};
