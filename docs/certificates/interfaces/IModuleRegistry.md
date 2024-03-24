# Solidity API

## IModuleRegistry

### router

```solidity
function router() external view returns (contract IRouter)
```

### modules

```solidity
function modules(address moduleAddress) external view returns (struct Module)
```

### moduleAddresses

```solidity
function moduleAddresses(uint256 index) external view returns (address)
```

### initialize

```solidity
function initialize() external
```

### updateRouter

```solidity
function updateRouter(address _router) external
```

### isContractAddress

```solidity
function isContractAddress(address contractAddress) external view returns (bool)
```

### onlyIssuers

```solidity
function onlyIssuers(address issuer) external view
```

### register

```solidity
function register(string name, string description, address moduleAddress) external
```

### runModules

```solidity
function runModules(address[] modulesAddresses, struct AttestationPayload attestationPayload, bytes[] validationPayloads, uint256 value) external
```

### bulkRunModules

```solidity
function bulkRunModules(address[] modulesAddresses, struct AttestationPayload[] attestationsPayloads, bytes[][] validationPayloads) external
```

### getModulesNumber

```solidity
function getModulesNumber() external view returns (uint256)
```

### isRegistered

```solidity
function isRegistered(address moduleAddress) external view returns (bool)
```

