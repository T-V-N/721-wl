//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-solidity/contracts/access/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/utils/cryptography/ECDSA.sol";

import "openzeppelin-solidity/contracts/token/ERC721/IERC721.sol";

interface NFTI {
    function safeMint(address to, uint256 quantity) external;
}

contract PublicSale is Ownable {
    using ECDSA for bytes32;

    uint256 public sold = 0;
    uint256 public limit = 1000;
    uint256 public price = 0.05 ether;
    bool public saleActive = true;
    bool public wlActive = true;
    uint256 public buyLimit = 3;

    address public manager;

    mapping(address => uint256) bought;
    mapping(address => bool) wl;

    NFTI public NFT;

    constructor(address _NFT, address _manager) {
        NFT = NFTI(_NFT);
        manager = _manager;
    }

    function buyToken(bytes memory signature) public payable {
        require(saleActive, "Sale not active");
        require(sold <= limit, "Sale goal reached");
        require(bought[msg.sender] < buyLimit, "Already bought all available tokens");
        require(msg.value == price, "Not enough ether paid");
        require(verifySig(address(msg.sender), signature), "Wrong signature!");

        if (wlActive) {
            require(wl[msg.sender], "Not whitelisted");
        }

        NFT.safeMint(msg.sender, 1);
        sold += 1;
        bought[msg.sender] += 1;
    }

    //control functions
    function setNFT(address _NFT) external onlyOwner {
        NFT = NFTI(_NFT);
    }

    function setBuyLimit(uint256 _limit) external onlyOwner {
        buyLimit = _limit;
    }

    function setManager(address _manager) external onlyOwner {
        manager = _manager;
    }

    function setLimit(uint256 _limit) external onlyOwner {
        limit = _limit;
    }

    function setWhitelist(address[] memory _addresses, bool isWl) external onlyOwner {
        for (uint256 i = 0; i < _addresses.length; i++) {
            wl[_addresses[i]] = isWl;
        }
    }

    function setWhitelistActive(bool isActive) external onlyOwner {
        wlActive = isActive;
    }

    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
    }

    function setSaleActive(bool _saleActive) external onlyOwner {
        saleActive = _saleActive;
    }

    // Emergency functions
    function extractValue() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function extractToken(uint256 amount, address token) external onlyOwner {
        IERC20(token).transfer(msg.sender, amount);
    }

    function extractNFT(uint256 NFTID, address token) external onlyOwner {
        IERC721(token).transferFrom(address(this), msg.sender, NFTID);
    }

    //helpers
    function verifySig(address who, bytes memory signature) public view returns (bool) {
        return keccak256(abi.encodePacked(who, address(this))).toEthSignedMessageHash().recover(signature) == manager;
    }
}
