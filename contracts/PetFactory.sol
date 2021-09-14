pragma solidity ^0.5.16;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721Mintable.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721Burnable.sol";
import "./DateTime.sol";


contract PetFactory is ERC721Full, ERC721Mintable, ERC721Burnable {

    address private owner;

    constructor() ERC721Full("Pet", "PET") public {
        owner = msg.sender;
    }

    modifier isOwner(){
        require(msg.sender == owner);
        _;
    }

    enum PetStatus {Alive, Dead}

    struct PetInfo {
        uint petId;
        PetStatus petStatus;
        uint nextFeed;
        
    }

    mapping(address=>PetInfo) petList;
    uint petCount;

    function generatePet(address petOwner, string memory tokenURI) public isOwner returns (uint256) {
        

        uint256 petId = petCount;
        petCount += 1;

        PetInfo memory petInfo;
        petInfo.petId = petId;
        petInfo.petStatus = PetStatus.Alive;
        petInfo.nextFeed = block.timestamp + 604800; // one week

        petList[petOwner] = petInfo;

        _mint(petOwner, petId);
        _setTokenURI(petId, tokenURI);

        return petId;
    }

    function killPet(address petOwner) internal isOwner {
        uint petId = petList[petOwner].petId;
        petList[petOwner].petStatus = PetStatus.Dead;
        _burn(petId);

    }

    function feedPet(address petOwner) public isOwner {

        if (petList[petOwner].nextFeed > block.timestamp ) {
            petList[petOwner].nextFeed = block.timestamp + 604800;
        } else {
            killPet(petOwner);
        }

    }

    function checkPetInfo(address petOwner) public returns (string memory petStatus, uint nextFeed) {
        if (petList[petOwner].nextFeed < block.timestamp ) {
            killPet(petOwner);
        }


        if (petList[petOwner].petStatus == PetStatus.Alive) {
            petStatus = 'Alive';
        } else {
            petStatus = 'Dead';
        }

        return (petStatus, petList[petOwner].nextFeed);
    }
    
}



// ideas: state machines, delegate calls, event logs, 
// interfaces, oracles, factory pattern,
// role based access control, ERC20, ERC20Detailed, ERC20Mintable
// gnosis multi-sig wallet, upgradeable contracts (registry vs forwarding relay)
// diamond standard for unlimited size, diamond storage pattern
// mutex openzepp ReentrancyGuard
// SafeMath

// look into: erc1400, erc998, erc 1155, 