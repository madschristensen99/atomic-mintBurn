// Copyright 2023 The AthanorLabs/atomic-swap Authors
// SPDX-License-Identifier: LGPL-3.0-only

package main

import (
	"context"
	"flag"
	"fmt"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/ethclient"
	logging "github.com/ipfs/go-log/v2"

	contracts "github.com/athanorlabs/atomic-swap/ethereum"
)

var log = logging.Logger("wsxmr-daemon")

func main() {
	var (
		rpcURL          = flag.String("rpc", "https://testnet-rpc.monad.xyz", "Ethereum RPC endpoint")
		vaultMgrAddr    = flag.String("vault-manager", "0x6ABAEB70c9BA9EA497Ff5e20D08bd20Ca1E02139", "VaultManager contract address")
		wsxmrAddr       = flag.String("wsxmr", "0xb694120Ecdc69fbbEe3Ae21831d7B76ab8a9169B", "wsXMR token address")
		pollInterval    = flag.Duration("poll", 12*time.Second, "Block polling interval")
		verbose         = flag.Bool("v", false, "Verbose logging")
	)

	flag.Parse()

	if *verbose {
		_ = logging.SetLogLevel("wsxmr-daemon", "debug")
	} else {
		_ = logging.SetLogLevel("wsxmr-daemon", "info")
	}

	log.Infof("Starting wsXMR Daemon")
	log.Infof("RPC: %s", *rpcURL)
	log.Infof("VaultManager: %s", *vaultMgrAddr)
	log.Infof("wsXMR Token: %s", *wsxmrAddr)

	// Connect to Ethereum
	ec, err := ethclient.Dial(*rpcURL)
	if err != nil {
		log.Fatalf("Failed to connect to Ethereum: %v", err)
	}
	defer ec.Close()

	// Create contract instances
	vaultMgr, err := contracts.NewVaultManager(common.HexToAddress(*vaultMgrAddr), ec)
	if err != nil {
		log.Fatalf("Failed to instantiate VaultManager: %v", err)
	}

	wsxmr, err := contracts.NewWsXMR(common.HexToAddress(*wsxmrAddr), ec)
	if err != nil {
		log.Fatalf("Failed to instantiate wsXMR: %v", err)
	}

	// Get initial state
	ctx := context.Background()
	name, _ := wsxmr.Name(&bind.CallOpts{Context: ctx})
	symbol, _ := wsxmr.Symbol(&bind.CallOpts{Context: ctx})
	decimals, _ := wsxmr.Decimals(&bind.CallOpts{Context: ctx})
	totalSupply, _ := wsxmr.TotalSupply(&bind.CallOpts{Context: ctx})

	log.Infof("Token: %s (%s) - %d decimals", name, symbol, decimals)
	log.Infof("Total Supply: %s", totalSupply.String())

	// Get VaultManager constants
	collateralRatio, _ := vaultMgr.COLLATERALRATIO(&bind.CallOpts{Context: ctx})
	liquidationRatio, _ := vaultMgr.LIQUIDATIONRATIO(&bind.CallOpts{Context: ctx})
	liquidationBonus, _ := vaultMgr.LIQUIDATIONBONUS(&bind.CallOpts{Context: ctx})

	log.Infof("Collateral Ratio: %d%%", collateralRatio.Uint64())
	log.Infof("Liquidation Ratio: %d%%", liquidationRatio.Uint64())
	log.Infof("Liquidation Bonus: %d%%", liquidationBonus.Uint64())

	// Start event monitoring
	log.Infof("Starting event monitor (polling every %v)", *pollInterval)
	
	ticker := time.NewTicker(*pollInterval)
	defer ticker.Stop()

	// Setup signal handler
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)

	var lastBlock uint64
	currentBlock, err := ec.BlockNumber(ctx)
	if err != nil {
		log.Fatalf("Failed to get current block: %v", err)
	}
	lastBlock = currentBlock
	log.Infof("Starting from block %d", lastBlock)

	for {
		select {
		case <-ticker.C:
			if err := monitorEvents(ctx, ec, vaultMgr, lastBlock); err != nil {
				log.Errorf("Error monitoring events: %v", err)
			}
			
			// Update last block
			currentBlock, err := ec.BlockNumber(ctx)
			if err != nil {
				log.Errorf("Failed to get current block: %v", err)
				continue
			}
			if currentBlock > lastBlock {
				log.Debugf("Scanned blocks %d to %d", lastBlock, currentBlock)
				lastBlock = currentBlock
			}

		case sig := <-sigChan:
			log.Infof("Received signal %v, shutting down...", sig)
			return
		}
	}
}

func monitorEvents(ctx context.Context, ec *ethclient.Client, vaultMgr *contracts.VaultManager, fromBlock uint64) error {
	currentBlock, err := ec.BlockNumber(ctx)
	if err != nil {
		return fmt.Errorf("failed to get current block: %w", err)
	}

	if currentBlock <= fromBlock {
		return nil
	}

	opts := &bind.FilterOpts{
		Start:   fromBlock + 1,
		End:     &currentBlock,
		Context: ctx,
	}

	// Monitor MintInitiated events
	mintIter, err := vaultMgr.FilterMintInitiated(opts, nil, nil, nil)
	if err != nil {
		return fmt.Errorf("failed to filter MintInitiated: %w", err)
	}
	defer mintIter.Close()

	for mintIter.Next() {
		event := mintIter.Event
		log.Infof("🔵 MintInitiated: RequestID=%s User=%s LP=%s wsXMR=%s",
			common.Bytes2Hex(event.RequestId[:]),
			event.User.Hex(),
			event.LpVault.Hex(),
			event.WsxmrAmount.String(),
		)
	}

	// Monitor MintReady events
	readyIter, err := vaultMgr.FilterMintReady(opts, nil)
	if err != nil {
		return fmt.Errorf("failed to filter MintReady: %w", err)
	}
	defer readyIter.Close()

	for readyIter.Next() {
		event := readyIter.Event
		log.Infof("🟢 MintReady: RequestID=%s", common.Bytes2Hex(event.RequestId[:]))
	}

	// Monitor MintFinalized events
	finalizedIter, err := vaultMgr.FilterMintFinalized(opts, nil)
	if err != nil {
		return fmt.Errorf("failed to filter MintFinalized: %w", err)
	}
	defer finalizedIter.Close()

	for finalizedIter.Next() {
		event := finalizedIter.Event
		log.Infof("✅ MintFinalized: RequestID=%s Secret=%s",
			common.Bytes2Hex(event.RequestId[:]),
			common.Bytes2Hex(event.Secret[:]),
		)
	}

	// Monitor BurnInitiated events
	burnIter, err := vaultMgr.FilterBurnInitiated(opts, nil, nil, nil)
	if err != nil {
		return fmt.Errorf("failed to filter BurnInitiated: %w", err)
	}
	defer burnIter.Close()

	for burnIter.Next() {
		event := burnIter.Event
		log.Infof("🔴 BurnInitiated: RequestID=%s User=%s LP=%s wsXMR=%s",
			common.Bytes2Hex(event.RequestId[:]),
			event.User.Hex(),
			event.LpVault.Hex(),
			event.WsxmrAmount.String(),
		)
	}

	// Monitor BurnFinalized events
	burnFinalizedIter, err := vaultMgr.FilterBurnFinalized(opts, nil)
	if err != nil {
		return fmt.Errorf("failed to filter BurnFinalized: %w", err)
	}
	defer burnFinalizedIter.Close()

	for burnFinalizedIter.Next() {
		event := burnFinalizedIter.Event
		log.Infof("✅ BurnFinalized: RequestID=%s Secret=%s",
			common.Bytes2Hex(event.RequestId[:]),
			common.Bytes2Hex(event.Secret[:]),
		)
	}

	// Monitor VaultLiquidated events
	liqIter, err := vaultMgr.FilterVaultLiquidated(opts, nil, nil)
	if err != nil {
		return fmt.Errorf("failed to filter VaultLiquidated: %w", err)
	}
	defer liqIter.Close()

	for liqIter.Next() {
		event := liqIter.Event
		log.Infof("⚠️  VaultLiquidated: LP=%s Liquidator=%s Debt=%s Collateral=%s",
			event.LpVault.Hex(),
			event.Liquidator.Hex(),
			event.DebtCleared.String(),
			event.CollateralSeized.String(),
		)
	}

	return nil
}
