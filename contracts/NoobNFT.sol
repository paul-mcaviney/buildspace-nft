// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import OpenZeppelin Contracts
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// import helper functions from the Base64.sol contract
import { Base64 } from "./libraries/Base64.sol";


// Inherit the imported contract to have access to its methods
contract NoobNFT is ERC721URIStorage {
    // Keep track of tokenIds
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // The SVG code, just need to change the words that are displayed
    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    // Three arrays with random words
    string[] firstWords = ["Lazy ", "Smelly ", "Strange ", "Gigantic ", "Puny ", "Invincible ", "Lovely ", "Bashful ", "Romantic ", "Thirsty ", "Normal ", "Tasty ", "Sticky ", "moist ", "Soft ", "Greasy ", "Hairy ", "Bossy ", "Angry ", "EAGERLY "];
    string[] secondWords = ["Running ", "Sleeping ", "Eating ", "Flying ", "Swimming ", "Breathing ", "Rolling ", "Sneaking ", "Resting ", "Fighting ", "Defecating ", "Drinking ", "Laughing ", "Sneezing ", "Clenching ", "Farting ", "Seeing ", "Loving ", "Falling ", "LEARNING "];
    string[] thirdWords = ["Aardvark", "Elephant", "Tiger", "Kitty", "Puppy", "HUMAN", "Mouse", "Robot", "Hedghog", "Whale", "Koala", "Kangaroo", "Tardigrade", "Mushroom", "Rabbit", "Centipede", "Toucan", "Parrot", "Dolphin", "Programmer"];


    // Pass the name of our NFT token and its symbol
    constructor() ERC721 ("NoobNFT", "NOOB"){
        console.log("This is slightly better NFT contract... WIP");
    }


    // Randomly pick a word from each array
    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        // Seed the random generator
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        // Make sure number isn't larger than length of the array
        rand = rand % firstWords.length;
        return firstWords[rand];
    }


    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }


    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }


    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }


    // function that allows the user to mint their NFT
    function makeNFT() public {
        // Get the current tokenId, starts at 0
        uint256 newItemId = _tokenIds.current();

        // Randomly grab one word from each of the arrays
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));

        // concatenate it all together and close the <text and <svg> tags
        string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));
        
        // Get all the JSON metadata in place and base64 encode it
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // add data:image/svg+xml;base64 and then append and base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // prepend data:application/json;base64 to data
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n---------------------\n");
        console.log(finalTokenUri);
        console.log("\n---------------------\n");

        // Actually mint the NFT to the sender using msg.sender
        _safeMint(msg.sender, newItemId);

        //Set the NFTs data
        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();

        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    }
}