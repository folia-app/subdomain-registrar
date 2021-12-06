var HashRegistrar = artifacts.require("HashRegistrar");
var TestResolver = artifacts.require("TestResolver");
// var ENS = artifacts.require("@ensdomains/ens/contracts/ENSRegistry.sol");
var ENS = artifacts.require("ENS");
var SubdomainRegistrar = artifacts.require("SubdomainRegistrar");
var DeadDotComSeance = artifacts.require("DeadDotComSeance");
var BaseRegistrarImplementation = artifacts.require("BaseRegistrarImplementation");

var namehash = require('eth-ens-namehash');
var sha3 = require('js-sha3').keccak_256;
var Promise = require('bluebird');

var domainnames = require('../app/js/domains.json');

module.exports = function (deployer, network, accounts) {
    return deployer.then(async () => {
        if (network == "test") {

            await deployer.deploy(ENS);

            const ens = await ENS.deployed();

            await deployer.deploy(HashRegistrar, ens.address, namehash.hash('eth'), 1493895600);
            await deployer.deploy(TestResolver);

            await ens.setSubnodeOwner('0x0', '0x' + sha3('eth'), accounts[0]);
            await ens.setSubnodeOwner(namehash.hash('eth'), '0x' + sha3('resolver'), accounts[0]);

            const resolver = await TestResolver.deployed();
            await ens.setResolver(namehash.hash('resolver.eth'), resolver.address);

            const dhr = await HashRegistrar.deployed();

            await ens.setSubnodeOwner('0x0', '0x' + sha3('eth'), dhr.address);

            const deadDotComSeance = '';
            await deployer.deploy(SubdomainRegistrar, ens.address, deadDotComSeance, resolver);

            const registrar = await SubdomainRegistrar.deployed();

            // @todo figure out why this doesn't work
            // return Promise.map(domainnames, async function(domain) {
            //     if(domain.registrar !== undefined) return;
            //     await dhr.setSubnodeOwner('0x' + sha3(domain.name), accounts[0]);
            //     await dhr.transfer('0x' + sha3(domain.name), registrar.address);
            //     await registrar.configureDomain(domain.name);
            // });

        } else {
            const ens = await ENS.deployed();
            const baseRegistrarImplementation = await BaseRegistrarImplementation.deployed();

            console.log({ens: ens.address})
            const deadDotComSeance = await DeadDotComSeance.deployed();
            console.log({deadDotComSeance: deadDotComSeance.address})
            const rinkebyResolver = '0xf6305c19e814d2a75429Fd637d01F7ee0E77d615';
            const mainnetResolver = '0x004976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41';
            await deployer.deploy(SubdomainRegistrar, ens.address, deadDotComSeance.address, rinkebyResolver);

            const subdomainRegistrar = await SubdomainRegistrar.deployed()
            // petsdotcom.eth
            await baseRegistrarImplementation.reclaim("108350481691301844584283756747981115641741054191609884149132907110757544526360", subdomainRegistrar.address)
            // alladvantage.eth
            await baseRegistrarImplementation.reclaim("73221999359359550706391122416363156849372066579048440949532785510888433287718", subdomainRegistrar.address)
            
        }
    });
};
