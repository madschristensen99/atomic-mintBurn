# wsXMR - Wrapsynth Protocol

**Status: Live on Monad Testnet** ✅

## 🚀 Testnet Deployment (Monad)

**Network:** Monad Testnet (Chain ID: 10143)  
**Deployed:** March 3, 2026

| Contract | Address | Explorer |
|----------|---------|----------|
| wsXMR Token | `0xb694120Ecdc69fbbEe3Ae21831d7B76ab8a9169B` | [View](https://testnet.monadvision.com/address/0xb694120Ecdc69fbbEe3Ae21831d7B76ab8a9169B) |
| VaultManager | `0x6ABAEB70c9BA9EA497Ff5e20D08bd20Ca1E02139` | [View](https://testnet.monadvision.com/address/0x6ABAEB70c9BA9EA497Ff5e20D08bd20Ca1E02139) |
| XMR/USD Oracle | `0x9B8d1851bCc06ac265c1c1ACaBD0F71E69DD312c` | [View](https://testnet.monadvision.com/address/0x9B8d1851bCc06ac265c1c1ACaBD0F71E69DD312c) |
| ETH/USD Oracle | `0x15bb9ba8236De055090a262F45a7e213F6040320` | [View](https://testnet.monadvision.com/address/0x15bb9ba8236De055090a262F45a7e213F6040320) |

**Try it:** Get testnet MON from [Monad Faucet](https://faucet.monad.xyz/)

---

## Overview

This repository contains the **wsXMR (Wrapsynth Monero)** protocol - a CDP (Collateralized Debt Position) vault system that enables trustless wrapping of Monero (XMR) into an ERC-20 token on EVM chains. The protocol builds upon the cryptographic foundations of the original ETH-XMR atomic swap implementation.

### Key Features

- **Overcollateralized Vaults**: Liquidity Providers (LPs) lock 150% collateral (ETH or stablecoins) to back wsXMR issuance
- **Trust-Minimized**: Leverages cryptographic proofs (adaptor signatures/DLEQ) from atomic swaps
- **Liquidation Protection**: Automated liquidation at 120% collateralization ratio
- **Stateful Protocol**: Persistent vault system replacing ephemeral atomic swaps
- **Penalty Mechanism**: LPs are slashed if they fail to fulfill burn requests within 24 hours

## Architecture

### Smart Contracts (`/ethereum/contracts/`)

- **`wsXMR.sol`**: ERC-20 token contract (8 decimals to match XMR)
- **`VaultManager.sol`**: Core CDP vault system managing:
  - LP vault registration and collateral management
  - Mint/burn request state machines
  - Price oracle integration (Chainlink)
  - Liquidation mechanics
- **`Secp256k1.sol`**: Cryptographic proof verification (inherited from atomic swaps)
- **`AggregatorV3Interface.sol`**: Chainlink price oracle interface

### Protocol Roles

1. **User**: Mints wsXMR by locking XMR, burns wsXMR to redeem XMR
2. **LP (Vault Operator)**: Locks EVM collateral, facilitates XMR transfers on Monero chain
3. **Liquidator**: Monitors vaults and liquidates undercollateralized positions

---

## Original ETH-XMR Atomic Swaps

This codebase was originally an implementation of ETH-XMR atomic swaps. It consists of `swapd` and `swapcli` binaries, the swap daemon and swap CLI tool respectively, which allow for nodes to discover each other over the p2p network, to query nodes for their current available offers, and the ability to make and take swap offers and perform the swap protocol. The `swapd` program has a JSON-RPC endpoint which the user can use to interact with it. `swapcli` is a command-line utility that interacts with `swapd` by performing RPC calls. 

## Swap instructions

### Trying it on mainnet

To try the swap on Ethereum and Monero mainnet, follow the instructions [here](./docs/mainnet.md).

### Trying it on Monero's stagenet and Ethereum's Sepolia testnet

To try the swap on Stagenet/Sepolia, follow the instructions [here](./docs/stagenet.md).

### Trying it locally

To try the swap locally with two nodes (maker and taker) on a development environment, follow the instructions [here](./docs/local.md).

## wsXMR Protocol Flows

### Minting Flow (XMR → wsXMR)

1. **LP Setup**: LP deposits collateral (≥150% of intended backing) into `VaultManager`
2. **Initiate Mint**: User calls `initiateMint(lpVault, xmrAmount, claimCommitment, timeout)`
   - State: `MintPending`
3. **Lock XMR**: User locks XMR on Monero chain using adaptor signatures
4. **LP Confirms Lock**: LP verifies XMR lock on Monero and calls `setMintReady(requestId)`
   - State: `MintReady`
   - **Security**: Prevents "free wsXMR" exploit where user could finalize without locking XMR
5. **LP Claims XMR**: LP daemon claims XMR on Monero, revealing secret `s`
6. **Finalize Mint**: User (or relayer) submits `s` via `finalizeMint(requestId, secret)`
   - Contract verifies proof using `Secp256k1.mulVerify()`
   - Mints wsXMR to user
   - Increases LP vault debt
   - State: `MintComplete`

### Burning Flow (wsXMR → XMR)

1. **Initiate Burn**: User calls `initiateBurn(wsxmrAmount, lpVault, refundCommitment)`
   - wsXMR is burned immediately
   - 24-hour EVM deadline starts
   - State: `BurnPending`
2. **LP Sends XMR**: LP daemon locks XMR on Monero with PTLC (refund timelock < 12h)
   - **Security**: Monero refund must expire BEFORE EVM deadline to prevent griefing
3. **User Claims XMR**: User claims XMR on Monero chain, revealing secret `s2`
4. **Finalize Burn**: LP daemon submits `s2` via `finalizeBurn(requestId, secret)`
   - Contract verifies proof
   - Reduces LP vault debt
   - Unlocks collateral
   - State: `BurnComplete`
5. **Penalty Path**: If LP fails to complete within 24h:
   - User calls `claimSlashedCollateral(requestId)`
   - User receives 150% of wsXMR value in EVM collateral
6. **Griefing Protection**: If user refuses to claim Monero:
   - LP waits for Monero refund timelock (12h)
   - LP recovers their XMR on Monero
   - LP loses EVM collateral but keeps XMR (net zero loss)

### Liquidation

Any keeper can liquidate an LP vault if:
- Collateral ratio < 120% (liquidation threshold)
- Liquidator burns wsXMR to clear debt
- Receives collateral at 110% ratio (10% bonus)
- **Security**: Bonus (110%) < Threshold (120%) prevents partial liquidation death spiral

## Price Oracles

The protocol uses Chainlink price feeds:
- **XMR/USD**: For calculating wsXMR value
- **ETH/USD** (or other collateral/USD): For calculating collateral value
- **Staleness Check**: Prices older than 1 hour are rejected

## Original Atomic Swap Protocol

Please see the [protocol documentation](docs/protocol.md) for how the original atomic swap works.

## Additional documentation

### Developer instructions

Please see the [developer docs](docs/developing.md).

### RPC API

The swap process comes with a HTTP JSON-RPC API as well as a Websockets API. You can find the documentation [here](./docs/rpc.md).

## Contributions

If you'd like to contribute, feel free to fork the repo and make a pull request. Please make sure the CI is passing - you can run `make build`, `make lint`, and `make test` to make sure the checks pass locally. Please note that any contributions you make will be licensed under LGPLv3.

## Contact
 
- [Matrix room](https://matrix.to/#/#ethxmrswap:matrix.org)

## Donations

The work on this project has been funded previously by community grants. It is currently not funded; if you'd like to donate, you can do so at the following address:
- XMR `8AYdE4Tzq3rQYh7QNHfHz8HqcgT9kcTcHMcRHL1LhVtqYwah27zwPYGdesBgK5PATvGBAd4BC1t2NfrqKQqDguybQrC1tZb`
- ETH `0x39D3b8cc9D08fD83360dDaCFe054b7D6e7f2cA08`

## GPLv3 Disclaimer 

THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MODIFIES AND/OR CONVEYS THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
