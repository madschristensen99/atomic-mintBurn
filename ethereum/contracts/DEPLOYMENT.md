# wsXMR Protocol Deployment Guide

## ✅ Compilation Status

The wsXMR protocol contracts **compile successfully** using Solidity 0.8.19.

### Compiled Contracts

- **wsXMR.sol** - ERC-20 wrapped Monero token (8 decimals)
- **VaultManager.sol** - CDP vault system with mint/burn/liquidation logic

## Prerequisites

### Required Tools

1. **Docker** - For Solidity compilation
2. **Foundry** (optional) - For deployment scripts
3. **Go 1.20+** - For Go bindings generation

### Required Information

Before deployment, you need:

1. **XMR/USD Oracle Address** - Chainlink price feed for XMR/USD
2. **ETH/USD Oracle Address** - Chainlink price feed for ETH/USD (or your collateral asset)
3. **Deployer Private Key** - Account with sufficient ETH for gas
4. **RPC Endpoint** - Ethereum node URL

## Compilation

### Using Docker (Recommended)

The local `solc` binary has issues, so we use Docker:

```bash
# Compile both contracts
./scripts/compile-wsxmr.sh
```

This generates:
- `ethereum/abi/wsXMR.abi` - Contract ABI
- `ethereum/abi/VaultManager.abi` - Contract ABI
- `ethereum/bin/wsXMR.bin` - Bytecode
- `ethereum/bin/VaultManager.bin` - Bytecode

### Manual Compilation

```bash
# Compile wsXMR
docker run --rm \
    -v $(pwd):/workspace \
    -w /workspace \
    ethereum/solc:0.8.19 \
    --optimize --optimize-runs=200 \
    --base-path ethereum/contracts \
    --abi --bin ethereum/contracts/wsXMR.sol \
    -o /workspace/ethereum/abi/ --overwrite

# Compile VaultManager
docker run --rm \
    -v $(pwd):/workspace \
    -w /workspace \
    ethereum/solc:0.8.19 \
    --optimize --optimize-runs=200 \
    --base-path ethereum/contracts \
    --abi --bin ethereum/contracts/VaultManager.sol \
    -o /workspace/ethereum/abi/ --overwrite
```

## Deployment Options

### Option 1: Using Foundry (Recommended)

```bash
# Set environment variables
export XMR_USD_ORACLE=0x... # Chainlink XMR/USD feed
export ETH_USD_ORACLE=0x... # Chainlink ETH/USD feed
export DEPLOYER_ADDRESS=0x... # Your address
export PRIVATE_KEY=0x... # Your private key
export RPC_URL=https://... # Your RPC endpoint

# Deploy
forge script script/DeployWsXMR.s.sol:DeployWsXMR \
    --rpc-url $RPC_URL \
    --private-key $PRIVATE_KEY \
    --broadcast
```

### Option 2: Using Go Deployment Tool

```bash
# Build the deployment tool
go build -o bin/deploy-wsxmr ./cmd/deploy-wsxmr

# Deploy
./bin/deploy-wsxmr \
    --rpc http://localhost:8545 \
    --key YOUR_PRIVATE_KEY_HEX \
    --xmr-oracle 0x... \
    --eth-oracle 0x... \
    -v
```

### Option 3: Using Remix IDE

1. Open [Remix IDE](https://remix.ethereum.org)
2. Create new files and paste contract code:
   - `wsXMR.sol`
   - `VaultManager.sol`
   - All dependencies from `@openzeppelin/contracts/`
3. Compile with Solidity 0.8.19
4. Deploy in order:
   - Deploy `wsXMR(deployerAddress)`
   - Deploy `VaultManager(wsxmrAddress, xmrOracleAddress, ethOracleAddress, deployerAddress)`
   - Call `wsXMR.setVaultManager(vaultManagerAddress)`

## Chainlink Oracle Addresses

### Mainnet

- **XMR/USD**: Check [Chainlink Data Feeds](https://docs.chain.link/data-feeds/price-feeds/addresses)
- **ETH/USD**: `0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419`

### Sepolia Testnet

- **ETH/USD**: `0x694AA1769357215DE4FAC081bf1f309aDC325306`
- **XMR/USD**: May need to deploy a mock oracle

### Mock Oracle for Testing

If XMR/USD feed doesn't exist on your network, deploy a mock:

```solidity
// MockOracle.sol
contract MockOracle {
    int256 public price = 150e8; // $150 with 8 decimals
    
    function decimals() external pure returns (uint8) {
        return 8;
    }
    
    function latestRoundData() external view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ) {
        return (1, price, block.timestamp, block.timestamp, 1);
    }
    
    function setPrice(int256 _price) external {
        price = _price;
    }
}
```

## Post-Deployment

### 1. Verify Contracts

```bash
# Verify on Etherscan
forge verify-contract \
    --chain-id 1 \
    --constructor-args $(cast abi-encode "constructor(address)" $DEPLOYER) \
    $WSXMR_ADDRESS \
    ethereum/contracts/wsXMR.sol:wsXMR
```

### 2. Test Basic Functions

```bash
# Check wsXMR token
cast call $WSXMR_ADDRESS "name()(string)"
cast call $WSXMR_ADDRESS "symbol()(string)"
cast call $WSXMR_ADDRESS "decimals()(uint8)"
cast call $WSXMR_ADDRESS "vaultManager()(address)"

# Check VaultManager
cast call $VAULT_MANAGER "wsxmrToken()(address)"
cast call $VAULT_MANAGER "COLLATERAL_RATIO()(uint256)"
cast call $VAULT_MANAGER "LIQUIDATION_RATIO()(uint256)"
```

### 3. Create First Vault (LP)

```bash
# LP creates a vault
cast send $VAULT_MANAGER "createVault(address)" 0x0000000000000000000000000000000000000000 \
    --private-key $LP_PRIVATE_KEY

# LP deposits ETH collateral (1 ETH = 1e18 wei)
cast send $VAULT_MANAGER "depositCollateral(uint256)" 1000000000000000000 \
    --value 1000000000000000000 \
    --private-key $LP_PRIVATE_KEY
```

## Contract Addresses

After deployment, save these addresses:

```
Network: [Mainnet/Sepolia/etc]
wsXMR Token: 0x...
VaultManager: 0x...
XMR/USD Oracle: 0x...
ETH/USD Oracle: 0x...
Deployment Block: ...
Deployer: 0x...
```

## Security Considerations

⚠️ **Before Production:**

1. **Audit** - Get professional security audit
2. **Timelock** - Add timelock to admin functions
3. **Multisig** - Transfer ownership to multisig
4. **Oracle Monitoring** - Set up alerts for stale/invalid prices
5. **Pause Mechanism** - Consider adding emergency pause
6. **Upgrade Path** - Plan for potential upgrades

## Troubleshooting

### Compilation Issues

If local `solc` hangs, use Docker as shown above.

### Deployment Fails

- Check deployer has enough ETH for gas
- Verify oracle addresses are correct
- Ensure constructor parameters are in correct order

### Transaction Reverts

- Check error messages in block explorer
- Verify you're calling functions in correct order
- Ensure proper approvals/allowances

## Next Steps

1. **Daemon Integration** - Update daemon to listen for mint/burn events
2. **Frontend** - Build UI for users and LPs
3. **Monitoring** - Set up liquidation bot
4. **Documentation** - Create user guides
5. **Testing** - Extensive testnet testing before mainnet

## Support

For issues or questions:
- Check existing documentation in `/docs`
- Review contract comments
- Test on testnet first
