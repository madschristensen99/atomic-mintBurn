#!/usr/bin/env bash

set -e

# Use the project root as the current working directory:
PROJECT_ROOT="$(dirname "$(dirname "$(realpath "$0")")")"
cd "${PROJECT_ROOT}"

echo "Compiling wsXMR protocol contracts using Docker..."

# Create output directories
mkdir -p ethereum/abi
mkdir -p ethereum/bin

# Compile wsXMR.sol
echo "Compiling wsXMR.sol..."
docker run --rm \
    -v "${PROJECT_ROOT}:/workspace" \
    -w /workspace \
    ethereum/solc:0.8.19 \
    --optimize --optimize-runs=200 \
    --metadata --metadata-literal \
    --base-path ethereum/contracts \
    --abi ethereum/contracts/wsXMR.sol \
    -o /workspace/ethereum/abi/ --overwrite

docker run --rm \
    -v "${PROJECT_ROOT}:/workspace" \
    -w /workspace \
    ethereum/solc:0.8.19 \
    --optimize --optimize-runs=200 \
    --base-path ethereum/contracts \
    --bin ethereum/contracts/wsXMR.sol \
    -o /workspace/ethereum/bin/ --overwrite

# Compile VaultManager.sol
echo "Compiling VaultManager.sol..."
docker run --rm \
    -v "${PROJECT_ROOT}:/workspace" \
    -w /workspace \
    ethereum/solc:0.8.19 \
    --optimize --optimize-runs=200 \
    --metadata --metadata-literal \
    --base-path ethereum/contracts \
    --abi ethereum/contracts/VaultManager.sol \
    -o /workspace/ethereum/abi/ --overwrite

docker run --rm \
    -v "${PROJECT_ROOT}:/workspace" \
    -w /workspace \
    ethereum/solc:0.8.19 \
    --optimize --optimize-runs=200 \
    --base-path ethereum/contracts \
    --bin ethereum/contracts/VaultManager.sol \
    -o /workspace/ethereum/bin/ --overwrite

echo "✅ Compilation successful!"
echo "ABI files: ethereum/abi/"
echo "Bytecode files: ethereum/bin/"
ls -lh ethereum/abi/ | grep -E "(wsXMR|VaultManager)"
ls -lh ethereum/bin/ | grep -E "(wsXMR|VaultManager)"
