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

interface IERC4906 {
    event MetadataUpdate(uint256 _tokenId);
}

contract Waveforms is Ownable, ReentrancyGuard, ERC721A, IERC4906, WaveData {
    using Strings for uint256;

    address public deployer;
    address public safe = payable(0x3415CD5FcAa35F986c8129c7a80E3AF75e5cF262);
    uint256 public mintPrice = 0.001 ether;
    bool public mintEnabled = false;

    mapping(uint256 => address) public mintedBy;

    constructor() Ownable(msg.sender) ERC721A("Waveforms", "WAVE") {
        deployer = msg.sender;
    }

    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function mint(uint256 quantity) external payable {
        uint256 cost = mintPrice;

        require(mintEnabled, "Mint not started");
        require(msg.value == quantity * cost, "Please send the exact ETH amount");
        require(quantity > 0, "Quantity must be greater than 0");
        uint256 startTokenID = _startTokenId() + _totalMinted();
        uint256 mintUntilTokenID = quantity + startTokenID;

        for (uint256 tokenId = startTokenID; tokenId < mintUntilTokenID; tokenId++) {
            mintedBy[tokenId] = msg.sender;
        }
        _safeMint(msg.sender, quantity);

        // Transfer the ETH to safe
        (bool success,) = safe.call{value: msg.value}("");
        require(success, "Transfer failed.");
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Token does not exist");

        // Get image
        string memory image = buildSVG(tokenId);

        // Encode SVG data to base64
        string memory base64Image = Base64.encode(bytes(image));

        // Build JSON metadata
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

        // Encode JSON data to base64
        string memory base64Json = Base64.encode(bytes(json));

        // Construct final URI
        return string(abi.encodePacked("data:application/json;base64,", base64Json));
    }

    function buildSVG(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "Token does not exist");

        address holder = ownerOf(tokenId);
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

    function _afterTokenTransfers(address, address, uint256 startTokenId, uint256 quantity) internal virtual override {
        for (uint256 i = 0; i < quantity; i++) {
            emit MetadataUpdate(startTokenId + i);
        }
    }

    function toggleMinting() external onlyOwner {
        mintEnabled = !mintEnabled;
    }

    function withdraw() external onlyOwner nonReentrant {
        (bool success,) = msg.sender.call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }
}
