//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import {ERC721} from "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-solidity/contracts/access/Ownable.sol";
import "./opensea/DefaultOperatorFilterer.sol";

contract NFT is ERC721, Ownable, DefaultOperatorFilterer {
    address public manager;
    string public _baseTokenURI;
    uint256 public minted = 0;

    modifier onlyManager() {
        require(manager == _msgSender(), "Only manager can mint");
        _;
    }

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {
        manager = msg.sender;
    }

    function safeMint(address to, uint256 qty) external onlyManager {
        for (uint i = 0; i < qty; i++) {
            _safeMint(to, minted);
            minted++;
        }
    }

    function getPrice(uint256 tier) public pure returns (uint256) {
        if (tier == 0) return 0.1 ether;
        if (tier == 1) return 0.2 ether;
        if (tier == 2) return 0.4 ether;
        if (tier == 3) return 1 ether;
        return 1 ether;
    }

    function mintPublic(address to, uint256 quantity) external {
        _safeMint(to, quantity);
    }

    function setManager(address to) external onlyOwner {
        manager = to;
    }

    function setBaseURI(string calldata baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
        super.setApprovalForAll(operator, approved);
    }

    function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
        super.approve(operator, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
        super.safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override onlyAllowedOperator(from) {
        super.safeTransferFrom(from, to, tokenId, data);
    }
}
