## NFT Whitelist + 721A + Public Mint API

Установить количество токенов на продажу

```
function setLimit(uint256 _limit)
```

Установить цену. Цена указывается в WEI

```
function setPrice(uint256 _price)
```

Открыть/закрыть сейл (true/false)

```
function setSaleActive(bool _saleActive)
```

Забрать все BNB/ETH с контракта

```
function extractValue()
```

Забрать token токен с контракта в количество amount

```
function extractToken(uint256 amount, address token)
```

Забрать NFT с ID NFTID с адресом token с контракта

```
function extractNFT(uint256 NFTID, address token)
```

## Env

.env file:

```
DEPLOYER_PRIVATE_KEY={Your private key for deployments}
INFURA_PROJECT_ID={Infura public key for sending TXs}
ETHERSCAN_API={Etherscan.io API key for verifying contracts}
```

## Deploy

В скобках указаны возможные сети

```
yarn install
npx hardhat deploy --tags NFT --network [ropsten | bsctestnet | bscmainnet | ethmainnet]
```
