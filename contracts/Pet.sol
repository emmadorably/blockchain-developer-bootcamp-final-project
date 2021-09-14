pragma solidity ^0.5.16;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721Mintable.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721Burnable.sol";


contract Pet is ERC721Full{

    enum PetStatus {Alive, Dead}

    struct PetInfo {
        uint  petId;
        PetStatus petStatus;
        uint nextFeed;
        
    }

    PetInfo public petInfo;

    constructor(uint _petId, uint nextFeed) ERC721Full("Pet", "PET") public {
        petInfo.petId=_petId;
        petInfo.petStatus=PetStatus.Alive;
        petInfo.nextFeed=nextFeed;
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