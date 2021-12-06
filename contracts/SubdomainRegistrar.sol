pragma solidity ^0.5.0;

import "./AbstractSubdomainRegistrar.sol";
import "@ensdomains/ens/contracts/Deed.sol";
import "@ensdomains/ens/contracts/Registrar.sol";
import "./DeadDotComSeance.sol";

/**
    Subdomain Registrar is heavily modified from 
    https://github.com/ensdomains/subdomain-registrar
 */

contract SubdomainRegistrar is AbstractSubdomainRegistrar {

    modifier onlyOwner() {
        require(msg.sender == oowner);
        _;
    }

    event NewSubdomain(string domain, string subdomain, uint256 tokenId, address tokenOwner, string oldSubdomain);

    Resolver resolver;
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

        domains[keccak256(bytes("petsdotcom"))]= "petsdotcom";
        idToDomain.push(keccak256(bytes("petsdotcom")));

        domains[keccak256(bytes("alladvantage"))]= "alladvantage";
        idToDomain.push(keccak256(bytes("alladvantage")));

        domains[keccak256(bytes("bidland"))]= "bidland";
        idToDomain.push(keccak256(bytes("bidland")));

        domains[keccak256(bytes("bizbuyer"))]= "bizbuyer";
        idToDomain.push(keccak256(bytes("bizbuyer")));

        domains[keccak256(bytes("capacityweb"))]= "capacityweb";
        idToDomain.push(keccak256(bytes("capacityweb")));

        domains[keccak256(bytes("cashwars"))]= "cashwars";
        idToDomain.push(keccak256(bytes("cashwars")));

        domains[keccak256(bytes("ecircles"))]= "ecircles";
        idToDomain.push(keccak256(bytes("ecircles")));

        domains[keccak256(bytes("efanshop"))]= "efanshop";
        idToDomain.push(keccak256(bytes("efanshop")));

        domains[keccak256(bytes("ehobbies"))]= "ehobbies";
        idToDomain.push(keccak256(bytes("ehobbies")));

        domains[keccak256(bytes("elaw"))]= "elaw";
        idToDomain.push(keccak256(bytes("elaw")));

        domains[keccak256(bytes("exchangepath"))]= "exchangepath";
        idToDomain.push(keccak256(bytes("exchangepath")));

        domains[keccak256(bytes("financialprinter"))]= "financialprinter";
        idToDomain.push(keccak256(bytes("financialprinter")));

        domains[keccak256(bytes("funbug"))]= "funbug";
        idToDomain.push(keccak256(bytes("funbug")));

        domains[keccak256(bytes("heavenlydoor"))]= "heavenlydoor";
        idToDomain.push(keccak256(bytes("heavenlydoor")));

        domains[keccak256(bytes("iharvest"))]= "iharvest";
        idToDomain.push(keccak256(bytes("iharvest")));

        domains[keccak256(bytes("misterswap"))]= "misterswap";
        idToDomain.push(keccak256(bytes("misterswap")));

        domains[keccak256(bytes("netmorf"))]= "netmorf";
        idToDomain.push(keccak256(bytes("netmorf")));

        domains[keccak256(bytes("popularpower"))]= "popularpower";
        idToDomain.push(keccak256(bytes("popularpower")));

        domains[keccak256(bytes("stickynetworks"))]= "stickynetworks";
        idToDomain.push(keccak256(bytes("stickynetworks")));

        domains[keccak256(bytes("thirdvoice"))]= "thirdvoice";
        idToDomain.push(keccak256(bytes("thirdvoice")));

        domains[keccak256(bytes("wingspanbank"))]= "wingspanbank";
        idToDomain.push(keccak256(bytes("wingspanbank")));
    }

    // admin

    function updateOwner(address newOwner) public onlyOwner {
        oowner = newOwner;
    }
    function updateResolver(Resolver _resolver) public onlyOwner {
        require(msg.sender == oowner);
        resolver = _resolver;
    }

    // meat and potatoes

    function registerSubdomain(string calldata subdomain, uint256 tokenId) external not_stopped payable {
        // make sure msg.sender is the owner of the NFT tokenId
        address subdomainOwner = deadDotComSeance.ownerOf(tokenId);
        require(subdomainOwner == msg.sender, "cant register a subdomain for an NFT you dont own");

        // make sure that the tokenId is correlated to the domain
        uint256 workId = tokenId / 100;

        // guille works are all part of workId 0
        if (workId == 0) {
            workId = tokenId % 100;
        }

        bytes32 label = idToDomain[workId - 1];

        bytes32 domainNode = keccak256(abi.encodePacked(TLD_NODE, label));
        bytes32 subdomainLabel = keccak256(bytes(subdomain));
        bytes32 subnode = keccak256(abi.encodePacked(domainNode, subdomainLabel));

        // Subdomain must not be registered already.
        require(ens.owner(subnode) == address(0), "subnode already owned");

        // if subdomain was previously registered, delete it
        string memory oldSubdomain = idToSubdomain[tokenId];
        if (bytes(oldSubdomain).length != 0) {
            bytes32 oldSubdomainLabel = keccak256(bytes(oldSubdomain));
            undoRegistration(domainNode, oldSubdomainLabel, resolver);
        }

        doRegistration(domainNode, subdomainLabel, subdomainOwner, resolver);
        idToSubdomain[tokenId] = subdomain;

        emit NewSubdomain(domains[label], subdomain, tokenId, subdomainOwner, oldSubdomain);
    }

    // admin

    function unregister(string calldata subdomain, uint256 tokenId) external onlyOwner {
        uint256 workId = tokenId / 100;

        if (workId == 0) {
            workId = tokenId % 100;
        }
        bytes32 label = idToDomain[workId - 1];
        bytes32 domainNode = keccak256(abi.encodePacked(TLD_NODE, label));
        bytes32 _subdomain = keccak256(bytes(subdomain));
        undoRegistration(domainNode, _subdomain, resolver);
    }

    // Don't want to modify too much of the inherited ENS stuff.
    // Everything below is just to satisfy interface and might be used for ENS frontent.

    function register(bytes32 label, string calldata subdomain, address owner, address resolver) external payable {
        revert("nope");
    }
    function payRent(bytes32 label, string calldata subdomain) external payable {
        revert("nope");
    }
    function configureDomainFor(string memory name, address payable _owner, address _transfer) public owner_only(keccak256(bytes(name))) {
        revert("nope");
    }
    function deed(bytes32 label) internal view returns (Deed) {
        (, address deedAddress,,,) = Registrar(registrar).entries(label);
        return Deed(deedAddress);
    }
    function owner(bytes32 label) public view returns (address) {
        return address(this);
    }
    function query(bytes32 label, string calldata subdomain) external view returns (string memory domain) {
        bytes32 node = keccak256(abi.encodePacked(TLD_NODE, label));
        bytes32 subnode = keccak256(abi.encodePacked(node, keccak256(bytes(subdomain))));
        if (ens.owner(subnode) != address(0x0)) {
            return ("");
        }
        return domains[label];
    }
}
