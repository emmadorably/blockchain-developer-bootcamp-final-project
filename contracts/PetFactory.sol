pragma solidity ^0.5.16;

import "./Pet.sol";


contract PetFactory is ERC721Mintable, ERC721Burnable  {


    event LogPetGenerate(address indexed petOwner, uint petId);
    event LogPetCheck(address indexed petOwner, uint petId, string status, uint nextFeed);
    event LogPetFeed(address indexed petOwner, uint petId, string status, uint nextFeed);
    event LogPetKill(address indexed petOwner, uint petId);

    enum PetStatus {Alive, Dead}

    struct PetInfo {
        uint petId;
        PetStatus petStatus;
        uint nextFeed;
        
    }


    mapping(address=>PetInfo) petList;
    uint petCount;

    function generatePet() public returns (uint256) {
        

        uint256 petId = petCount;
        petCount += 1;

        PetInfo memory petInfo;
        petInfo.petId = petId;
        petInfo.petStatus = PetStatus.Alive;
        petInfo.nextFeed = block.timestamp; // one week

        petList[msg.sender] = petInfo;

        new Pet(petId, petInfo.nextFeed);
        safeMint(msg.sender, petId);

        return petId;
    }

    function killPet() internal {
        uint petId = petList[msg.sender].petId;
        petList[msg.sender].petStatus = PetStatus.Dead;
        burn(petId);
    }

    function feedPet(uint time) public {

        if (1==1 ) {
            PetInfo memory pi = petList[msg.sender];
            pi.nextFeed = time + 604800;
            delete petList[msg.sender];

            petList[msg.sender] = pi;
        } else {
            killPet();
        }


        string memory petStatus;
        if (petList[msg.sender].petStatus == PetStatus.Alive) {
            petStatus = 'Alive';
        } else {
            petStatus = 'Dead';
        }

        emit LogPetFeed(msg.sender, petList[msg.sender].petId, petStatus, petList[msg.sender].nextFeed);

    }

    function checkPetInfo() public returns (string memory petStatus, uint nextFeed) {
        if (petList[msg.sender].nextFeed < block.timestamp ) {
            killPet();
        }


        if (petList[msg.sender].petStatus == PetStatus.Alive) {
            petStatus = 'Alive';
        } else {
            petStatus = 'Dead';
        }

        emit LogPetCheck(msg.sender, petList[msg.sender].petId, petStatus, petList[msg.sender].nextFeed);
        return (petStatus, petList[msg.sender].nextFeed);
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