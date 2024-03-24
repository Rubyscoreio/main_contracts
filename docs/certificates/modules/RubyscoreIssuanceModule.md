# Solidity API

## RubyscoreIssuanceModule

This module can be used for issues NFT certificates .

### portal

```solidity
address portal
```

### certificateNFT

```solidity
contract IRubyscore_Certificates certificateNFT
```

### certificates

```solidity
mapping(bytes32 => uint256) certificates
```

### ArrayLengthMismatch

```solidity
error ArrayLengthMismatch()
```

Error thrown when an array length mismatch occurs

### InvalidCertificateId

```solidity
error InvalidCertificateId()
```

### ZeroAddressCheck

```solidity
error ZeroAddressCheck()
```

### onlyPortal

```solidity
modifier onlyPortal()
```

### constructor

```solidity
constructor(address initialOwner, address _portal, contract IRubyscore_Certificates _certificateNFT) public
```

Contract constructor sets the portal registry

### setUpCertificates

```solidity
function setUpCertificates(bytes32[] schemaIds, uint256[] certificateIds) external
```

### setPortal

```solidity
function setPortal(address _portal) external
```

### run

```solidity
function run(struct AttestationPayload _attestationPayload, bytes, address _txSender, uint256) public
```

The main method for the module, running the check

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _attestationPayload | struct AttestationPayload |  |
|  | bytes |  |
| _txSender | address | Sender of transaction |
|  | uint256 |  |

