const tryVerify = require("./utils/tryVerify");
const { ethers } = require("hardhat");
const { Wallet } = require("@ethersproject/wallet");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const { DEPLOYER_PRIVATE_KEY } = process.env;
  const signerAcc = new Wallet(DEPLOYER_PRIVATE_KEY);

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
    NFT.address,
    deployer
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

  const types = ['address', 'address'];
  const values = [
      deployer.toLowerCase(),
      SALEC.address.toLowerCase()
  ];
  const mesGenerated = ethers.utils.solidityKeccak256(types, values);

  const signature = await signerAcc.signMessage(ethers.utils.arrayify(mesGenerated));

  console.log("Signature is: ", signature)
  };

module.exports.tags = ["NFT"];
