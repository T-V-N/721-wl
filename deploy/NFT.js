const tryVerify = require("./utils/tryVerify");
const { ethers } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const { SIGNERPK } = process.env;

  const tokenArgs = [
    "TestNFT",
    "NFT",
  ];

  const NFT = await deploy("NFT", {
    from: deployer,
    args: tokenArgs,
    log: true,
  });

  const saleArgs = [
    NFT.address
  ];

  const SALE = await deploy("PublicSale", {
    from: deployer,
    args: saleArgs,
    log: true,
  });

  const NFTC = await ethers.getContractAt("NFT", NFT.address);
  const SALEC = await ethers.getContractAt("PublicSale", SALE.address);

  console.log(
    `Addresses \n NFT ${NFT.address}\n SALE:${SALE.address}`
  );

  await tryVerify(
    NFT.address,
    tokenArgs,
    "contracts/NFT.sol:NFT"
  );

  await tryVerify(
    SALE.address,
    saleArgs,
    "contracts/PublicSale.sol:PublicSale"
  );

  await NFTC.setManager(SALE.address);
  };

module.exports.tags = ["NFT"];
