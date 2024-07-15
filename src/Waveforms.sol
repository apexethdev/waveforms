// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721A} from "ERC721A/ERC721A.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {Base64} from "./base64.sol";
import {WaveData} from "./WaveData.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

/**
* @title Waveforms - Fully Onchain NFT of your Ethereum address
* @dev --- Apex777.eth
* @notice https://waveforms.apexdeployer.xyz/
* @notice X: https://x.com/apex_ether
* @notice Warpcast: https://warpcast.com/apex777
*/


/// IERC4906 Metadata Update Event - When called emits an event to signal that the metadata for a token has been updated.
/// This is how Opensea knows to update the metadata for a token as soon as it changes.
interface IERC4906 {
    event MetadataUpdate(uint256 _tokenId);
}

// importing the usual suspects but also the WaveData contract and IERC4906
contract Waveforms is Ownable, ReentrancyGuard, ERC721A, IERC4906, WaveData {
    using Strings for uint256;

    address public deployer;
    uint256 public mintPrice = 0.001 ether;
    bool public mintEnabled = false;

    // this mapping is used to store the address of the person who minted the token
    mapping(uint256 => address) public mintedBy;

    constructor() Ownable(msg.sender) ERC721A("Waveforms", "WAVE") {
        deployer = msg.sender;
    }

    /// First token will start at 1 instead of 0
    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function mint(uint256 quantity) external payable {
        uint256 cost = mintPrice;

        require(mintEnabled, "Mint not started");
        require(msg.value == quantity * cost, "Please send the exact ETH amount");
        require(quantity > 0, "Quantity must be greater than 0");

        /// As we are storing the minter for each token, and if people mint multiple tokens at once we need to store the minter for each token
        uint256 startTokenID = _startTokenId() + _totalMinted();
        uint256 mintUntilTokenID = quantity + startTokenID;

        /// this is where the storage of the minter happens
        for (uint256 tokenId = startTokenID; tokenId < mintUntilTokenID; tokenId++) {
            mintedBy[tokenId] = msg.sender;
        }

        /// actual minting of the tokens
        _safeMint(msg.sender, quantity);
    }

    /// This is the function marketplaces / dapps call when a token is minted to get the metadata
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Token does not exist");

        // Get image data of the svg, this is the main function that generates the svg
        string memory image = buildSVG(tokenId);

        // convert the image to base64
        string memory base64Image = Base64.encode(bytes(image));

        // Build JSON metadata => name, description, attributes, image etc
        string memory json = string(
            abi.encodePacked(
                '{"name":"Waveforms #',
                Strings.toString(tokenId),
                '","description":"Visualize your Ethereum address fully Onchain in a Waveform","attributes":[',
                _getMetadata(tokenId),
                '],"image":"data:image/svg+xml;base64,',
                base64Image,
                '"}'
            )
        );

        // Encode JSON data to base64 - inside this is also the image base64
        string memory base64Json = Base64.encode(bytes(json));

        // Construct final URI and tell the caller its a json and its base64 encoded
        return string(abi.encodePacked("data:application/json;base64,", base64Json));
    }

    /// doesn't need to be public, but it is for testing purposes
    function buildSVG(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "Token does not exist");

        // get the owner of the token
        address holder = ownerOf(tokenId);

        /// this is where we call the WaveData contract...
        string memory svg = addressToSVG(holder);

        return svg;
    }

    function _getMetadata(uint256 tokenId) internal view returns (string memory) {
        return string(
            abi.encodePacked(
                '{"trait_type":"Waveform for","value":"',
                Strings.toHexString(uint256(uint160(ownerOf(tokenId))), 20),
                '"},',
                '{"trait_type":"Minted By","value":"',
                Strings.toHexString(uint256(uint160(mintedBy[tokenId])), 20),
                '"}'
            )
        );
    }

    /// When a Waveform is transferred (and also minted) we want to tell opensea to update the image
    /// event is called here for each token that is transferred if there are multiple
    function _afterTokenTransfers(address, address, uint256 startTokenId, uint256 quantity) internal virtual override {
        for (uint256 i = 0; i < quantity; i++) {
            emit MetadataUpdate(startTokenId + i);
        }
    }

    // turn on and off minting
    function toggleMinting() external onlyOwner {
        mintEnabled = !mintEnabled;
    }

    // withdraw funds from contract - only owner
    function withdraw() external onlyOwner nonReentrant {
        (bool success,) = msg.sender.call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }
}
