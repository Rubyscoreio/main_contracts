# Solidity API

## RubyScoreVeraxPortal

_RubyScoreVeraxPortal is a smart contract that handles the attestation process for RubyScore certificates.
It manages fees, signatures based on specific schemas._

### bulkStatus

```solidity
bool bulkStatus
```

### feeStatus

```solidity
bool feeStatus
```

### certificates

```solidity
mapping(bytes32 => bool) certificates
```

### attestationFees

```solidity
mapping(bytes32 => uint256) attestationFees
```

### InvalidCertificateId

```solidity
error InvalidCertificateId()
```

### ArrayLengthMismatch

```solidity
error ArrayLengthMismatch()
```

### InvalidAttestationFee

```solidity
error InvalidAttestationFee()
```

### ZeroAddressCheck

```solidity
error ZeroAddressCheck()
```

### WithdrawFail

```solidity
error WithdrawFail()
```

### FeesSet

```solidity
event FeesSet(bytes32[] schemaIds, uint256[] attestationFees)
```

### constructor

```solidity
constructor(address[] modules, address router) public
```

_Contract constructor._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| modules | address[] | List of modules to use for the portal. |
| router | address | The Router's address. |

### pause

```solidity
function pause() public
```

### unpause

```solidity
function unpause() public
```

### checkFee

```solidity
function checkFee(bytes32 schemaId, uint256 _value) public view
```

_Check if the provided value meets the attestation fee requirement._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| schemaId | bytes32 | The schemaId for which to check the fee. |
| _value | uint256 | The value sent for the attestation. |

### setCheckStatuses

```solidity
function setCheckStatuses(bool fee, bool bulk) external
```

_Set the fee, signature, and issuance statuses._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| fee | bool | Fee status. |
| bulk | bool |  |

### addModule

```solidity
function addModule(address module) external
```

_Add a new module to the list of modules._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| module | address | The address of the new module. |

### removeModules

```solidity
function removeModules() external
```

_Remove all modules from the list of modules._

### setFees

```solidity
function setFees(bytes32[] schemaIds, uint256[] _attestationFees) public
```

_Set the fees for specific schemaIds._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| schemaIds | bytes32[] | The schemaIds to set the fee for. |
| _attestationFees | uint256[] | The fees required to attest. |

### setUpCertificates

```solidity
function setUpCertificates(bytes32[] schemaIds, bool[] certificateStatuses) public
```

_Set up certificate mappings for schemaIds._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| schemaIds | bytes32[] | The schemaIds for which to set up certificates. |
| certificateStatuses | bool[] | The corresponding certificate statuses. |

### attestRubyscore

```solidity
function attestRubyscore(struct AttestationPayload attestationPayload, bytes[] validationPayload) external payable
```

_Attest a score with a given attestation payload and validation payloads._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| attestationPayload | struct AttestationPayload | The payload of the attestation. |
| validationPayload | bytes[] | The validation payload required for the module. |

### withdraw

```solidity
function withdraw(address payable to, uint256 amount) external
```

_Withdraw ETH from the contract._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| to | address payable | The address to which the ETH will be withdrawn. |
| amount | uint256 | The amount of ETH to withdraw. |

### _onAttest

```solidity
function _onAttest(struct AttestationPayload attestationPayload, address attester, uint256 value) internal
```

Optional method run before a payload is attested

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| attestationPayload | struct AttestationPayload | the attestation payload supposed to be attested |
| attester | address | the address of the attester |
| value | uint256 | the value sent with the attestation |

### _onBulkAttest

```solidity
function _onBulkAttest(struct AttestationPayload[] attestationsPayloads, bytes[][] validationPayloads) internal
```

Optional method run when attesting a batch of payloads

### _onReplace

```solidity
function _onReplace(bytes32 attestationId, struct AttestationPayload attestationPayload, address attester, uint256 value) internal
```

Optional method run when an attestation is replaced

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| attestationId | bytes32 | the ID of the attestation being replaced |
| attestationPayload | struct AttestationPayload | the attestation payload to create attestation and register it |
| attester | address | the address of the attester |
| value | uint256 | the value sent with the attestation |

### _onBulkReplace

```solidity
function _onBulkReplace(bytes32[] attestationIds, struct AttestationPayload[] attestationsPayloads, bytes[][] validationPayloads) internal
```

