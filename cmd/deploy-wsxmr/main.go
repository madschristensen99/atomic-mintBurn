// Copyright 2023 The AthanorLabs/atomic-swap Authors
// SPDX-License-Identifier: LGPL-3.0-only

package main

import (
	"context"
	"crypto/ecdsa"
	"flag"
	"fmt"
	"os"
	"time"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/ethclient"
	logging "github.com/ipfs/go-log/v2"

	contracts "github.com/athanorlabs/atomic-swap/ethereum"
)

var log = logging.Logger("deploy-wsxmr")

func main() {
	var (
		rpcURL       = flag.String("rpc", "http://localhost:8545", "Ethereum RPC endpoint")
		privKeyHex   = flag.String("key", "", "Private key hex (without 0x prefix)")
		xmrOracleStr = flag.String("xmr-oracle", "", "XMR/USD Chainlink oracle address")
		ethOracleStr = flag.String("eth-oracle", "", "ETH/USD Chainlink oracle address")
		verbose      = flag.Bool("v", false, "Verbose logging")
	)

	flag.Parse()

	if *verbose {
		_ = logging.SetLogLevel("deploy-wsxmr", "debug")
		_ = logging.SetLogLevel("contracts", "debug")
	} else {
		_ = logging.SetLogLevel("deploy-wsxmr", "info")
		_ = logging.SetLogLevel("contracts", "info")
	}

	if *privKeyHex == "" {
		log.Fatal("--key is required")
	}

	if *xmrOracleStr == "" {
		log.Fatal("--xmr-oracle is required (Chainlink XMR/USD price feed address)")
	}

	if *ethOracleStr == "" {
		log.Fatal("--eth-oracle is required (Chainlink ETH/USD price feed address)")
	}

	// Parse private key
	privKey, err := crypto.HexToECDSA(*privKeyHex)
	if err != nil {
		log.Fatalf("invalid private key: %v", err)
	}

	// Parse oracle addresses
	xmrOracle := common.HexToAddress(*xmrOracleStr)
	ethOracle := common.HexToAddress(*ethOracleStr)

	// Connect to Ethereum node
	log.Infof("connecting to Ethereum node at %s", *rpcURL)
	ec, err := ethclient.Dial(*rpcURL)
	if err != nil {
		log.Fatalf("failed to connect to Ethereum node: %v", err)
	}
	defer ec.Close()

	// Get deployer address
	deployerAddr := crypto.PubkeyToAddress(privKey.PublicKey)
	log.Infof("deployer address: %s", deployerAddr.Hex())

	// Check balance
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	balance, err := ec.BalanceAt(ctx, deployerAddr, nil)
	if err != nil {
		log.Fatalf("failed to get balance: %v", err)
	}
	log.Infof("deployer balance: %s wei", balance.String())

	// Deploy protocol
	log.Infof("deploying wsXMR protocol...")
	log.Infof("  XMR/USD Oracle: %s", xmrOracle.Hex())
	log.Infof("  ETH/USD Oracle: %s", ethOracle.Hex())

	wsxmrAddr, vaultMgrAddr, err := deployProtocol(ctx, ec, privKey, xmrOracle, ethOracle)
	if err != nil {
		log.Fatalf("deployment failed: %v", err)
	}

	log.Infof("✅ wsXMR Protocol deployed successfully!")
	log.Infof("📝 Contract Addresses:")
	log.Infof("   wsXMR Token:    %s", wsxmrAddr.Hex())
	log.Infof("   VaultManager:   %s", vaultMgrAddr.Hex())
	log.Infof("")
	log.Infof("🔗 Next steps:")
	log.Infof("   1. Verify contracts on block explorer")
	log.Infof("   2. Update daemon configuration with VaultManager address")
	log.Infof("   3. LPs can now create vaults and deposit collateral")
}

func deployProtocol(
	ctx context.Context,
	ec *ethclient.Client,
	privKey *ecdsa.PrivateKey,
	xmrOracle, ethOracle common.Address,
) (common.Address, common.Address, error) {
	deployerAddr := crypto.PubkeyToAddress(privKey.PublicKey)

	wsxmrAddr, vaultMgrAddr, err := contracts.DeployWsXMRProtocol(
		ctx,
		ec,
		privKey,
		xmrOracle,
		ethOracle,
		deployerAddr,
	)
	if err != nil {
		return common.Address{}, common.Address{}, fmt.Errorf("failed to deploy: %w", err)
	}

	return wsxmrAddr, vaultMgrAddr, nil
}
