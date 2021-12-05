pragma solidity ^0.5.0;

import "./AbstractSubdomainRegistrar.sol";
import "@ensdomains/ens/contracts/Deed.sol";
import "@ensdomains/ens/contracts/Registrar.sol";
import "./DeadDotComSeance.sol";
/**
 * @dev Implements an ENS registrar that sells subdomains on behalf of their owners.
 *
 * Users may register a subdomain by calling `register` with the name of the domain
 * they wish to register under, and the label hash of the subdomain they want to
 * register. They must also specify the new owner of the domain, and the referrer,
 * who is paid an optional finder's fee. The registrar then configures a simple
 * default resolver, which resolves `addr` lookups to the new owner, and sets
 * the `owner` account as the owner of the subdomain in ENS.
 *
 * New domains may be added by calling `configureDomain`, then transferring
 * ownership in the ENS registry to this contract. Ownership in the contract
 * may be transferred using `transfer`, and a domain may be unlisted for sale
 * using `unlistDomain`. There is (deliberately) no way to recover ownership
 * in ENS once the name is transferred to this registrar.
 *
 * Critically, this contract does not check one key property of a listed domain:
 *
 * - Is the name UTS46 normalised?
 *
 * User applications MUST check these two elements for each domain before
 * offering them to users for registration.
 *
 * Applications should additionally check that the domains they are offering to
 * register are controlled by this registrar, since calls to `register` will
 * fail if this is not the case.


 * Dead DotCom Seance Logic
  - There are X ENS names that are each associated with a group of NFTs.
  - If someone owns one of the NFTs associated with the ENS name, they can register a subdomain of that ENS name
  - If they transfer that NFT, the new owner can register a new subdomain of the ENS name.
  - When a new



 */
contract SubdomainRegistrar is AbstractSubdomainRegistrar {

    modifier new_registrar() {
        require(ens.owner(TLD_NODE) != address(registrar));
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == oowner);
        _;
    }

    function owner(bytes32 label) public view returns (address) {
        // if (domains[label].owner != address(0x0)) {
            return address(this);
            // return domains[label].owner;
        // }

        // return BaseRegistrar(registrar).ownerOf(uint256(label));
    }

    event TransferAddressSet(bytes32 indexed label, address addr);
    // Resolver resolver = 0x004976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41; // mainnet
    Resolver resolver;// = Resolver(0x00b14fdee4391732ea9d2267054ead2084684c0ad8); // rinkeby
    
    DeadDotComSeance deadDotComSeance;
    address oowner;
    mapping (uint256 => string) idToSubdomain;
    bytes32[] idToDomain;

    mapping (bytes32 => uint256) labelToId;
    mapping (bytes32 => string) public domains;

    constructor(ENS ens, DeadDotComSeance _deadDotComSeance, Resolver _resolver) AbstractSubdomainRegistrar(ens) public {
        resolver = _resolver;
        deadDotComSeance = _deadDotComSeance;
        oowner = msg.sender;

        domains[keccak256(bytes("petsdotcom"))]= Domain("petsdotcom", 0);
        idToDomain.push(keccak256(bytes("petsdotcom")));

        domains[keccak256(bytes("alladvantage"))]= Domain("alladvantage", 15);
        idToDomain.push(keccak256(bytes("alladvantage")));

        domains[keccak256(bytes("bidland"))]= Domain("bidland", 20);
        idToDomain.push(keccak256(bytes("bidland")));

        domains[keccak256(bytes("bizbuyer"))]= Domain("bizbuyer", 20);
        idToDomain.push(keccak256(bytes("bizbuyer")));

        domains[keccak256(bytes("capacityweb"))]= Domain("capacityweb", 21);
        idToDomain.push(keccak256(bytes("capacityweb")));

        domains[keccak256(bytes("cashwars"))]= Domain("cashwars", 26);
        idToDomain.push(keccak256(bytes("cashwars")));

        domains[keccak256(bytes("ecircles"))]= Domain("ecircles", 22);
        idToDomain.push(keccak256(bytes("ecircles")));

        domains[keccak256(bytes("efanshop"))]= Domain("efanshop", 28);
        idToDomain.push(keccak256(bytes("efanshop")));

        domains[keccak256(bytes("ehobbies"))]= Domain("ehobbies", 16);
        idToDomain.push(keccak256(bytes("ehobbies")));

        domains[keccak256(bytes("elaw"))]= Domain("elaw", 19);
        idToDomain.push(keccak256(bytes("elaw")));

        domains[keccak256(bytes("exchangepath"))]= Domain("exchangepath", 29);
        idToDomain.push(keccak256(bytes("exchangepath")));

        domains[keccak256(bytes("financialprinter"))]= Domain("financialprinter", 15);
        idToDomain.push(keccak256(bytes("financialprinter")));

        domains[keccak256(bytes("funbug"))]= Domain("funbug", 29);
        idToDomain.push(keccak256(bytes("funbug")));

        domains[keccak256(bytes("heavenlydoor"))]= Domain("heavenlydoor", 32);
        idToDomain.push(keccak256(bytes("heavenlydoor")));

        domains[keccak256(bytes("iharvest"))]= Domain("iharvest", 40);
        idToDomain.push(keccak256(bytes("iharvest")));

        domains[keccak256(bytes("misterswap"))]= Domain("misterswap", 17);
        idToDomain.push(keccak256(bytes("misterswap")));

        domains[keccak256(bytes("netmorf"))]= Domain("netmorf", 25);
        idToDomain.push(keccak256(bytes("netmorf")));

        domains[keccak256(bytes("popularpower"))]= Domain("popularpower", 22);
        idToDomain.push(keccak256(bytes("popularpower")));

        domains[keccak256(bytes("stickynetworks"))]= Domain("stickynetworks", 24);
        idToDomain.push(keccak256(bytes("stickynetworks")));

        domains[keccak256(bytes("thirdvoice"))]= Domain("thirdvoice", 16);
        idToDomain.push(keccak256(bytes("thirdvoice")));

        domains[keccak256(bytes("wingspanbank"))]= Domain("wingspanbank", 54);
        idToDomain.push(keccak256(bytes("wingspanbank")));
    }

    function updateOwner(address newOwner) public {
        require(msg.sender == oowner);
        oowner = newOwner;
    }

    function updateResolver(Resolver _resolver) public {
        require(msg.sender == oowner);
        resolver = _resolver;
    }

    // /**
    //  * @dev Configures a domain, optionally transferring it to a new owner.
    //  * @param name The name to configure.
    //  * @param _owner The address to assign ownership of this domain to.
    //  * @param _transfer The address to set as the transfer address for the name
    //  *        when the permanent registrar is replaced. Can only be set to a non-zero
    //  *        value once.
    //  */
    function configureDomainFor(string memory name, address payable _owner, address _transfer) public owner_only(keccak256(bytes(name))) {
        // bytes32 label = keccak256(bytes(name));
        // Domain storage domain = domains[label];

        // if (BaseRegistrar(registrar).ownerOf(uint256(label)) != address(this)) {
        //     BaseRegistrar(registrar).transferFrom(msg.sender, address(this), uint256(label));
        //     BaseRegistrar(registrar).reclaim(uint256(label), address(this));
        // }

        // if (domain.owner != _owner) {
        //     domain.owner = _owner;
        // }

        // if (keccak256(bytes(domain.name)) != label) {
        //     // New listing
        //     domain.name = name;
        // }

        // emit DomainConfigured(label);
    }

    // /**
    //  * @dev Returns information about a subdomain.
    //  * @param label The label hash for the domain.
    //  * @param subdomain The label for the subdomain.
    //  * @return domain The name of the domain, or an empty string if the subdomain
    //  *                is unavailable.
    //  */
    function query(bytes32 label, string calldata subdomain) external view returns (string memory domain) {
        bytes32 node = keccak256(abi.encodePacked(TLD_NODE, label));
        bytes32 subnode = keccak256(abi.encodePacked(node, keccak256(bytes(subdomain))));

        if (ens.owner(subnode) != address(0x0)) {
            return ("");
        }

        Domain storage data = domains[label];
        return (data.name);
    }
    // function queryByName(string calldata name, string calldata subdomain) external view returns (uint256 id) {
    //     bytes32 label = keccak256(bytes(name));
    //     bytes32 node = keccak256(abi.encodePacked(TLD_NODE, label));
    //     bytes32 subnode = keccak256(abi.encodePacked(node, keccak256(bytes(subdomain))));
    //     return labelToId[subnode];
    // }

    // /**
    //  * @dev Returns information about a subdomain.
    //  * @param label The label hash for the domain.
    //  * @param subdomain The label for the subdomain.
    //  * @return domain The name of the domain, or an empty string if the subdomain
    //  *                is unavailable.
    //  */
    function queryById(uint256 id) external view returns (string memory subdomain) {
        return idToSubdomain[id];
    }
    function register(bytes32 label, string calldata subdomain, address owner, address resolver) external payable {
        revert("nope");
    }
    function registerSubdomain(string calldata subdomain, uint256 tokenId) external not_stopped payable {

        // make sure msg.sender is the owner of the NFT tokenId
        address subdomainOwner = deadDotComSeance.ownerOf(tokenId);
        require(subdomainOwner == msg.sender, "can't register a subdomain for an NFT you don't own");

        // make sure that the tokenId is correlated to the domain
        uint256 workId = tokenId / 100;
        uint256 editionId = tokenId % 100;

        if (workId == 0) {
            workId = editionId;
        }

        bytes32 label = idToDomain[workId - 1];
        Domain storage domain = domains[label];

        bytes32 domainNode = keccak256(abi.encodePacked(TLD_NODE, label));
        bytes32 subdomainLabel = keccak256(bytes(subdomain));
        bytes32 subnode = keccak256(abi.encodePacked(domainNode, subdomainLabel));

        // Subdomain must not be registered already.
        require(ens.owner(subnode) == address(0), "subnode already owned");

        // if subdomain was previously registered, delete it
        string memory _subdomain = idToSubdomain[tokenId];
        if (bytes(_subdomain).length != 0) {
            bytes32 _subdomainLabel = keccak256(bytes(_subdomain));
            // bytes32 _subnode = keccak256(abi.encodePacked(domainNode, _subdomainLabel));
            undoRegistration(domainNode, _subdomainLabel, resolver);
        }

        doRegistration(domainNode, subdomainLabel, subdomainOwner, resolver);
        idToSubdomain[tokenId] = subdomain;
        // labelToId[subnode] = tokenId;

        emit NewRegistration(label, subdomain, subdomainOwner);
    }

    // function unregister(string calldata subdomain, uint256 tokenId) external {
    //     uint256 workId = tokenId / 100;
    //     bytes32 label = idToDomain[workId];
    //     Domain storage domain = domains[label];
    //     bytes32 domainNode = keccak256(abi.encodePacked(TLD_NODE, label));
    //     bytes32 _subdomain = keccak256(bytes(subdomain));
    //     undoRegistration(domainNode, _subdomain, resolver);
    // }

    // /**
    //  * @dev Upgrades the domain to a new registrar.
    //  * @param name The name of the domain to transfer.
    //  */
    // function upgrade(string memory name) public owner_only(keccak256(bytes(name))) new_registrar {
    //     bytes32 label = keccak256(bytes(name));
    //     address transfer = domains[label].transferAddress;

    //     require(transfer != address(0x0));

    //     delete domains[label];

    //     Registrar(registrar).transfer(label, address(uint160((transfer))));
    //     emit DomainTransferred(label, name);
    // }

    // /**
    //  * @dev Migrates the domain to a new registrar.
    //  * @param name The name of the domain to migrate.
    //  */
    // function migrate(string memory name) public owner_only(keccak256(bytes(name))) {
    //     require(stopped);
    //     require(migration != address(0x0));

    //     bytes32 label = keccak256(bytes(name));
    //     Domain storage domain = domains[label];

    //     Registrar(registrar).transfer(label, address(uint160((migration))));

    //     SubdomainRegistrar(migration).configureDomainFor(
    //         domain.name,
    //         domain.owner,
    //         domain.transferAddress
    //     );

    //     delete domains[label];

    //     emit DomainTransferred(label, name);
    // }

    function payRent(bytes32 label, string calldata subdomain) external payable {
        revert();
    }

    function deed(bytes32 label) internal view returns (Deed) {
        (, address deedAddress,,,) = Registrar(registrar).entries(label);
        return Deed(deedAddress);
    }
}
