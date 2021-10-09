// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import OpenZeppelin Contracts
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";


// Inherit the imported contract to have access to its methods
contract NoobNFT is ERC721URIStorage {
    // Keep track of tokenIds
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Pass the name of our NFT token and its symbol
    constructor() ERC721 ("NoobNFT", "NOOB"){
        console.log("This is slightly better NFT contract... WIP");
    }

    // function that allows the user to mint their NFT
    function makeNFT() public {
        // Get the current tokenId, starts at 0
        uint256 newItemId = _tokenIds.current();

        // Actually mint the NFT to the sender using msg.sender
        _safeMint(msg.sender, newItemId);

        //Set the NFTs data
        _setTokenURI(newItemId, "https://jsonkeeper.com/b/JB8J");

        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        // Increment the counter for when the next NFT gets minted
        _tokenIds.increment();
    }
}