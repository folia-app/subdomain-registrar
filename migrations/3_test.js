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
            const subdomainRegistrar = await SubdomainRegistrar.deployed()

            // var foo = await subdomainRegistrar.confirmNode(101, "alladvantage")
            // console.log({foo})
            // var tx = await subdomainRegistrar.registerSubdomain("alice", 101)
            // console.log({tx})
            // var tx = await subdomainRegistrar.unregister("baz", 101)
            // console.log({tx})
            // var tx = await subdomainRegistrar.unregister("test2", 101)
            // console.log({tx})
            // var tx = await subdomainRegistrar.unregister("alice", 101)
            // console.log({tx})


            var tx = await subdomainRegistrar.registerSubdomain("billy", 201)
            console.log({tx})


            var tx = await subdomainRegistrar.registerSubdomain("billy", 101)
            console.log({tx})

    });
};


/*

petsdotcom.eth = 001
alladvantage.eth = 002
- 201–215
bidland.eth = 003
- 301–320
bizbuyer.eth = 004
- 401–420


*/