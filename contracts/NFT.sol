//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "erc721a/contracts/ERC721A.sol";
import "openzeppelin-solidity/contracts/access/Ownable.sol";

contract NFT is ERC721A, Ownable {
    address public manager;
    string public _baseTokenURI;

    modifier onlyManager() {
        require(manager == _msgSender(), "Only manager can mint");
        _;
    }

    constructor(string memory name_, string memory symbol_) ERC721A(name_, symbol_) {
        manager = msg.sender;
    }

    function safeMint(address to, uint256 quantity) external onlyManager {
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
}
