var HashRegistrar = artifacts.require("HashRegistrar");
var TestResolver = artifacts.require("TestResolver");
var ENS = artifacts.require("@ensdomains/ens/contracts/ENSRegistry.sol");
var SubdomainRegistrar = artifacts.require("SubdomainRegistrar");
var BaseRegistrarImplementation = artifacts.require("BaseRegistrarImplementation");

var namehash = require('eth-ens-namehash');
var sha3 = require('js-sha3').keccak_256;
var Promise = require('bluebird');

var domainnames = require('../app/js/domains.json');

module.exports = function (deployer, network, accounts) {
    return deployer.then(async () => {
            const subdomainRegistrar = await SubdomainRegistrar.deployed()
            const baseRegistrarImplementation = await BaseRegistrarImplementation.deployed();
            
            // // petsdotcom.eth
            // await baseRegistrarImplementation.reclaim("108350481691301844584283756747981115641741054191609884149132907110757544526360", subdomainRegistrar.address)
            // // alladvantage.eth
            // await baseRegistrarImplementation.reclaim("73221999359359550706391122416363156849372066579048440949532785510888433287718", subdomainRegistrar.address)
            

            // var foo = await subdomainRegistrar.confirmNode(101, "alladvantage")
            // console.log({foo})
            // var tx = await subdomainRegistrar.registerSubdomain("alice", 101)
            // console.log({tx})
            // var tx = await subdomainRegistrar.unregister("baz", 101)
            // console.log({tx})
            // var tx = await subdomainRegistrar.unregister("test2", 101)
            // // console.log({tx})
            // var tx = await subdomainRegistrar.unregister("alice", 201)
            // console.log({tx})
            var tx = await subdomainRegistrar.unregister("asfasf", 1)
            console.log({tx})


            // var tx = await subdomainRegistrar.registerSubdomain("alice", 201)
            // console.log({tx})


            // var tx = await subdomainRegistrar.registerSubdomain("billy", 1)
            // console.log({tx})

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