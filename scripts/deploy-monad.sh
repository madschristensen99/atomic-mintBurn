#!/usr/bin/env bash
set -e

# Monad Testnet Configuration
RPC_URL="https://testnet-rpc.monad.xyz"
CHAIN_ID=10143

# Check for required environment variables
if [ -z "$PRIVATE_KEY" ]; then
    echo "Error: PRIVATE_KEY environment variable not set"
    exit 1
fi

# Mock oracles for testnet (we'll deploy our own)
# For production, use real Chainlink oracles
echo "Deploying wsXMR protocol to Monad Testnet..."
echo "RPC: $RPC_URL"
echo "Chain ID: $CHAIN_ID"

# Deploy using Foundry
forge script script/DeployMonad.s.sol:DeployMonad \
    --rpc-url $RPC_URL \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --verify \
    --etherscan-api-key monad \
    -vvvv

echo "✅ Deployment complete!"
echo "Check MonadVision Explorer: https://testnet.monadvision.com"
