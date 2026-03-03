# Contract Verification Guide

## Deployed Contracts (Monad Testnet)

### wsXMR Token
- **Address:** `0x75b85bbC8779B9cDe77cc9DD0335C27410455A53`
- **Explorer:** https://testnet.monadscan.com/address/0x75b85bbC8779B9cDe77cc9DD0335C27410455A53
- **Compiler:** v0.8.19
- **Optimization:** Enabled (200 runs)
- **Constructor Args:** `0x000000000000000000000000492c0b9f298cc49fe2644a2ebc6ea8df848c72fb`
- **Flattened Source:** `ethereum/wsXMR_flattened.sol`

### VaultManager
- **Address:** `0xd821A7D919e007b6b39925f672f1219dB4865Fba`
- **Explorer:** https://testnet.monadscan.com/address/0xd821A7D919e007b6b39925f672f1219dB4865Fba
- **Compiler:** v0.8.19
- **Optimization:** Enabled (200 runs)
- **Constructor Args (ABI Encoded):**
```
0x00000000000000000000000075b85bbc8779b9cde77cc9dd0335c27410455a530000000000000000000000008e3ef1e28262e351eb066374df1bed36cc704dda0000000000000000000000004a7c22878c8c25354dd926bd89722a3aadafcb66000000000000000000000000492c0b9f298cc49fe2644a2ebc6ea8df848c72fb
```
- **Flattened Source:** `ethereum/VaultManager_flattened.sol`

## Manual Verification Steps

1. Go to the contract address on MonadScan
2. Click "Contract" tab
3. Click "Verify & Publish"
4. Fill in the details:
   - Compiler Type: Solidity (Single file)
   - Compiler Version: v0.8.19
   - Open Source License Type: GNU LGPLv3
   - Optimization: Yes (200 runs)
5. Paste the flattened source code
6. Add constructor arguments (ABI-encoded hex)
7. Submit for verification

## Automated Verification (if supported)

```bash
# wsXMR Token
forge verify-contract \
  0x75b85bbC8779B9cDe77cc9DD0335C27410455A53 \
  ethereum/contracts/wsXMR.sol:wsXMR \
  --chain-id 10143 \
  --num-of-optimizations 200 \
  --constructor-args 0x000000000000000000000000492c0b9f298cc49fe2644a2ebc6ea8df848c72fb \
  --etherscan-api-key $ETHERSCAN_API_KEY \
  --verifier-url "https://testnet.monadscan.com/api"

# VaultManager
forge verify-contract \
  0xd821A7D919e007b6b39925f672f1219dB4865Fba \
  ethereum/contracts/VaultManager.sol:VaultManager \
  --chain-id 10143 \
  --num-of-optimizations 200 \
  --constructor-args 0x00000000000000000000000075b85bbc8779b9cde77cc9dd0335c27410455a530000000000000000000000008e3ef1e28262e351eb066374df1bed36cc704dda0000000000000000000000004a7c22878c8c25354dd926bd89722a3aadafcb66000000000000000000000000492c0b9f298cc49fe2644a2ebc6ea8df848c72fb \
  --etherscan-api-key $ETHERSCAN_API_KEY \
  --verifier-url "https://testnet.monadscan.com/api"
```
