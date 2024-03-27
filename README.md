## Rubyscore Smart Contracts

This repo will have a code of Rubyscore Smart Contracts.

## Deployed Contract Addresses

### Contracts

#### Optimism

| Name | Mainnet  | Testnet                                               |
| ---- |----------|-------------------------------------------------------|
| Rubyscore_Achievement | 0xB9cC0Bb020cF55197C4C3d826AC87CAdba51f272 | 0xc35C6497D6eDEf0D288236Ca5aDf63299e3AAD3b   |
| Rubyscore_Vote | 0x009dbfee9e155766af434ed1652ca3769b05e76f | 0x81C55bbA5d5D05a0C02f4B561B560194f34a6D07                        |

#### Linea

| Name | Mainnet  | Testnet                                    |
| ---- |----------|--------------------------------------------|
| Rubyscore_Achievement | 0xbDB018e21AD1e5756853fe008793a474d329991b | 0x2A1000293467a221F5d4cA98F4b7912c4c9c22b3 |
| Rubyscore_Vote | 0xe10Add2ad591A7AC3CA46788a06290De017b9fB4 |                                            |
|RubyScoreVeraxPortal|0xB9cC0Bb020cF55197C4C3d826AC87CAdba51f272|                                            |
|RubyscoreSignCheckModule|0xEAcf8B19E104803cfCD2557D893D6a407E4994F0|                                            |

#### Base

| Name | Mainnet  | Testnet                                               |
| ---- |----------|-------------------------------------------------------|
| Rubyscore_Achievement | 0xbDB018e21AD1e5756853fe008793a474d329991b | 0x0A1B739ea1230dB33B7F6dce9f77Fcc0901a49f0   |
| Rubyscore_Vote | 0xe10Add2ad591A7AC3CA46788a06290De017b9fB4 |                         |

#### zkEVM

| Name | Mainnet  | Testnet                                               |
| ---- |----------|-------------------------------------------------------|
| Rubyscore_Achievement | 0xF57Cb671D50535126694Ce5Cc3CeBe3F32794896 | 0x2A1000293467a221F5d4cA98F4b7912c4c9c22b4   |
| Rubyscore_Vote | 0xe10Add2ad591A7AC3CA46788a06290De017b9fB4 |                         |

#### Scroll

| Name | Mainnet  | Testnet                                               |
| ---- |----------|-------------------------------------------------------|
| Rubyscore_Achievement | 0xDC3D8318Fbaec2de49281843f5bba22e78338146 | 0x81C55bbA5d5D05a0C02f4B561B560194f34a6D07   |
| Rubyscore_Vote | 0xe10Add2ad591A7AC3CA46788a06290De017b9fB4 |                         |

#### Manta

| Name | Mainnet  | Testnet                                               |
| ---- |----------|-------------------------------------------------------|
| Rubyscore_Achievement | 0xbDB018e21AD1e5756853fe008793a474d329991b |    |
| Rubyscore_Vote | 0xF57Cb671D50535126694Ce5Cc3CeBe3F32794896 |                         |

#### Zora

| Name | Mainnet  | Testnet                                               |
| ---- |----------|-------------------------------------------------------|
| Rubyscore_Achievement | 0xbDB018e21AD1e5756853fe008793a474d329991b | 0x2A1000293467a221F5d4cA98F4b7912c4c9c22b4   |
| Rubyscore_Vote | 0xDC3D8318Fbaec2de49281843f5bba22e78338146 |                         |

## Setting project

### Install dependencies

```sh
npm install
```

---

## config

```
DEPLOYER_KEY = ""
INFURA_KEY = ""
ETHERSCAN_API_KEY = ""
POLYGONSCAN_API_KEY = ""
BSCSCAN_API_KEY = ""
```

### Setup config

Create and fill _.env_ file.

```sh
cp .env.example .env
```

---

### Compile contracts

```sh
npm run compile
```

---

### Migrate contracts

```sh
npm run migrate:<NETWORK> (mainnet, goerli, polygon, polygonMumbai, bsc, bscTestnet)
```

---

### Verify contracts

To verify the contract, you must specify the names of the contracts for verification through "," WITHOUT SPACES

```sh
npm run verify:<NETWORK> <NAME_CONTRACT_FIRST>,<NAME_CONTRACT_SECOND>
```

---

### Tests contracts

```sh
# Run Tests
npm run test

# Run test watcher
npm run test:watch
```

---

### Node hardhat(Localfork)

NOTE:// To work with a node or fork, you need to run the node in a separate console

```sh
# Run Node hardhat (For run localfork setting config { FORK_ENABLED: true, FORK_PROVIDER_URI: "https://...."})
npm run node

# Run test watcher
npm run test:node
```

---

### Coverage

```sh
npm run coverage
```

---

### Gas reporter

You can start the gas reporter either through a separate gas reporter script through "**npm run**" or by changing the variable in the config "**GAS_REPORTER.ENABLED**" when running tests

```sh
# Native gas reporter
npm run gas-reporter

# GAS_REPORTER.ENABLED = true
npm run test
```

---

### Clean

```sh
# Rm artifacts, cache, typechain-types
npm run clean

# Rm deployments for choose network
npm run clean:deployments <NETWORK>
```

---

### Linter

```sh
# Checking code style for .ts, .sol
npm run lint

# Run fix code style for .ts, .sol
npm run lint:fix

# Checking code style for .ts
npm run lint:ts

# Run fix code style for .ts
npm run lint:ts:fix

# Checking code style for .sol
npm run lint:sol

# Run fix code style for .sol
npm run lint:sol:fix
```

---

## Auto audit with slither

To run the analyzer, you must first install it globally

To audit all contracts, use the command :

```sh
slither .
```

To exclude warnings in subsequent audits, use :

```sh
slither . --triage
```

---
