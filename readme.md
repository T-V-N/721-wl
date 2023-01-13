## NFT Whitelist + 721 + Public Mint API

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

Включить/выключить вайтлист (true/false)

```
function setWhitelistActive(bool isActive)
```

Дать/убрать юзерам addresses вайтлист (true/false)

```
setWhitelist(address[] memory _addresses, bool isWl)
```

## Механизм работы покупки и подписи

Покупка осуществляется функцией

```
function buyToken(bytes memory signature)
```

У бекенда есть публичный и приватный ключи. Для удобства, можно в любом ethereum кошельке создать адрес и получить его приватник. В этом случае сам адрес будет публичным ключем, а его приватник - приватным ключом.
Контракт тоже хранит публичный ключ в поле manager. Manager задается при создании контракта.

В приложении бекенду передается адрес кошелька, с которого юзер хочет минтить токен. Дальше бекенд подписывает приватным ключем адрес кошелька и отдает юзеру. Юзер вызывает метод buyToken у контракта и передает туда подпись. Контракт внутри проверяет валидна ли подпичь (соответствует ли публичному ключу ака значению поля manager). Если все ок, то происходит минтинг

Пример создания подписи на js.

```
const signerAcc = new Wallet(DEPLOYER_PRIVATE_KEY);
const { Wallet } = require("@ethersproject/wallet");

const types = ['address', 'address'];
const values = [
    deployer.toLowerCase(),
    SALEC.address.toLowerCase()
];
const mesGenerated = ethers.utils.solidityKeccak256(types, values);

const signature = await signerAcc.signMessage(ethers.utils.arrayify(mesGenerated));
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
