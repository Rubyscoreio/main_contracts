# Solidity API

## IRubyscore_Certificates

_IRubyscore_Certificates is an interface for Rubyscore_Certificates contract_

### BaseURISet

```solidity
event BaseURISet(string newBaseURI)
```

Emitted when the base URI for token metadata is updated.

_This event is triggered when the contract operator updates the base URI
for retrieving metadata associated with tokens. The 'newBaseURI' parameter represents
the updated base URI._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newBaseURI | string | The new base URI that will be used to construct token metadata URIs. |

### Minted

```solidity
event Minted(address userAddress, uint256 nftId)
```

Emitted when NFTs are minted for a user.

_This event is emitted when new NFTs are created and assigned to a user.
It includes the user's address, and the ID of the minted NFT for transparency._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| userAddress | address | The address of the user receiving the NFTs. |
| nftId | uint256 | NFT IDs that were minted. |

### BatchMinted

```solidity
event BatchMinted(address userAddress, uint256[] nftIds)
```

Emitted when NFTs are minted for a user.

_This event is emitted when new NFTs are created and assigned to a user.
It includes the user's address and the IDs of the minted NFTs for transparency._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| userAddress | address | The address of the user receiving the NFTs. |
| nftIds | uint256[] | NFT IDs that were minted. |

### TokenURISet

```solidity
event TokenURISet(uint256 tokenId, string newTokenURI)
```

Emitted when the URI for a specific token is updated.

_This event is emitted when the URI for a token is modified, providing transparency
when metadata URIs are changed for specific tokens._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token for which the URI is updated. |
| newTokenURI | string | The new URI assigned to the token. |

### name

```solidity
function name() external view returns (string)
```

Get token name.

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | Token name. |

### symbol

```solidity
function symbol() external view returns (string)
```

Get token symbol.

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | Token symbol. |

### uri

```solidity
function uri(uint256 tokenId) external view returns (string)
```

Get the URI of a token.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | The URI of the token. |

### tokenURI

```solidity
function tokenURI(uint256 tokenId) external view returns (string)
```

Get the token URI for a given tokenId.

_Diblicate for uri() method_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | The URI of the token. |

### setTokenURI

```solidity
function setTokenURI(uint256 tokenId, string newTokenURI) external
```

Set the URI for a token.

_Requires the MINTER_ROLE._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token. |
| newTokenURI | string | The new URI to set for the token. |

### setBatchTokenURI

```solidity
function setBatchTokenURI(uint256[] tokenIds, string[] newTokenURIs) external
```

Set the URIs for multiple tokens in a batch.

_Requires the MINTER_ROLE.
Requires that the tokenIds and newTokenURIs arrays have the same length._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenIds | uint256[] | An array of token IDs to set URIs for. |
| newTokenURIs | string[] | An array of new URIs to set for the tokens. |

### setBaseURI

```solidity
function setBaseURI(string newBaseURI) external
```

Set the base URI for all tokens.

_Requires the OPERATOR_ROLE._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newBaseURI | string | The new base URI to set. |

### safeMint

```solidity
function safeMint(address to, uint256 id) external payable
```

Safely mints NFT for a user.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| to | address | The NFT recipient. |
| id | uint256 | The NFT id. |

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) external view returns (bool)
```

Check if a given interface is supported by this contract.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| interfaceId | bytes4 | The interface identifier to check for support. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | Whether the contract supports the specified interface. |

