# Solidity API

## RubyScorePortalClean

This contract aims to provide a default portal

_This Portal does not add any logic to the AbstractPortal_

### schema

```solidity
bytes32 schema
```

### constructor

```solidity
constructor(address[] modules, address router) public
```

Contract constructor

_This sets the addresses for the AttestationRegistry, ModuleRegistry and PortalRegistry_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| modules | address[] | list of modules to use for the portal (can be empty) |
| router | address | the Router's address |

### setSchema

```solidity
function setSchema(bytes32 _schema) external
```

### addModule

```solidity
function addModule(address module) external
```

### removeModules

```solidity
function removeModules() external
```

### AttestationRequestData

```solidity
struct AttestationRequestData {
  uint256 level;
  bool onchain;
}
```

### attestScoreSimple

```solidity
function attestScoreSimple(uint64 level, bool onchain, bytes signature) public payable
```

### attestScore

```solidity
function attestScore(struct RubyScorePortalClean.AttestationRequestData attestationRequestData, bytes[] validationPayload) internal
```

### bulkAttest0xScore

```solidity
function bulkAttest0xScore(struct RubyScorePortalClean.AttestationRequestData[] attestationsRequests, bytes[] validationPayload) public
```

### withdraw

```solidity
function withdraw(address payable to, uint256 amount) external
```

Optional method to withdraw funds from the Portal

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| to | address payable | the address to send the funds to |
| amount | uint256 | the amount to withdraw |

