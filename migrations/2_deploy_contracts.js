var HashRegistrar = artifacts.require("HashRegistrar");
var TestResolver = artifacts.require("TestResolver");
// var ENS = artifacts.require("@ensdomains/ens/contracts/ENSRegistry.sol");
var ENS = artifacts.require("ENS");
var SubdomainRegistrar = artifacts.require("SubdomainRegistrar");
var DotComSeance = artifacts.require("DotComSeance");
var BaseRegistrarImplementation = artifacts.require("BaseRegistrarImplementation");

var namehash = require('eth-ens-namehash');
var sha3 = require('js-sha3').keccak_256;
var Promise = require('bluebird');

// var apollo = require('@apollo/client')
// var ApolloClient = apollo.ApolloClient
// var InMemoryCache = apollo.InMemoryCache
// var gql = apollo.gpl

// import { ApolloClient, InMemoryCache, gql } from '@apollo/client'
// import { createClient } from 'urql'
const fetch = require('isomorphic-unfetch')
var ur = require('urql')
var createClient = ur.createClient
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

            const dotComSeance = '';
            await deployer.deploy(SubdomainRegistrar, ens.address, dotComSeance, resolver);

            const registrar = await SubdomainRegistrar.deployed();

            // @todo figure out why this doesn't work
            // return Promise.map(domainnames, async function(domain) {
            //     if(domain.registrar !== undefined) return;
            //     await dhr.setSubnodeOwner('0x' + sha3(domain.name), accounts[0]);
            //     await dhr.transfer('0x' + sha3(domain.name), registrar.address);
            //     await registrar.configureDomain(domain.name);
            // });

        } else {
            const ens = await ENS.deployed(); // artifacts same for rinkeby and mainnet
            const baseRegistrarImplementation = await BaseRegistrarImplementation.deployed(); // artifacts same for rinkeby and mainnet

            console.log({ens: ens.address})
            const dotComSeance = await DotComSeance.deployed(); // make sure it was moved from other project
            console.log({dotComSeance: dotComSeance.address})

            const rinkebyResolver = '0xf6305c19e814d2a75429Fd637d01F7ee0E77d615';
            const mainnetResolver = '0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41';
            const resolver = network == 'rinkeby' ? rinkebyResolver : mainnetResolver
            console.log({resolver, rinkebyResolver, mainnetResolver})
            await deployer.deploy(SubdomainRegistrar, ens.address, dotComSeance.address, resolver);

            const subdomainRegistrar = await SubdomainRegistrar.deployed()

            var names = [
                'petsdotcom.eth',
                'alladvantage.eth',
                'bidland.eth',
                'bizbuyer.eth',
                'capacityweb.eth',
                'cashwars.eth',
                'ecircles.eth',
                'efanshop.eth',
                'ehobbies.eth',
                'elaw.eth',
                'exchangepath.eth',
                'financialprinter.eth',
                'funbug.eth',
                'heavenlydoor.eth',
                'iharvest.eth',
                'mrswap.eth',
                'netmorf.eth',
                'popularpower.eth',
                'stickynetworks.eth',
                'thirdvoice.eth',
                'wingspanbank.eth'
            ]

            const APIURL = 'https://api.thegraph.com/subgraphs/name/ensdomains/ens'

            for (var i = 0; i < names.length; i++) {
                var name = names[i]
                const query = `
                    {
                        domains(where: {name:"${name}"}) {
                        id
                        name
                        labelName
                        labelhash
                        }
                    }
                    `
                // console.log({query})

                const client = createClient({
                    url: APIURL,
                })
                
                const data = await client.query(query).toPromise()
                // console.log({data: data.data.domains[0].labelhash})
                const labelhash = data.data.domains[0].labelhash
                storedName = await subdomainRegistrar.domains(labelhash)

                if (name.substring(0, name.length - 4) !== storedName) {
                    new Error(`${name} and ${storedName} don't match`)
                } else {
                    console.log(`nice, ${name} is same as ${storedName} (${data})`)
                }

                await baseRegistrarImplementation.reclaim(labelhash, subdomainRegistrar.address)
            }

            // alladvantage.eth
            // await baseRegistrarImplementation.reclaim("73221999359359550706391122416363156849372066579048440949532785510888433287718", subdomainRegistrar.address)
            
        }
    });
};
