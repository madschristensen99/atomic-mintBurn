// Copyright 2023 The AthanorLabs/atomic-swap Authors
// SPDX-License-Identifier: LGPL-3.0-only

package contracts

import (
	"context"
	"crypto/ecdsa"
	"fmt"

	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	ethcommon "github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/ethclient"

	"github.com/athanorlabs/atomic-swap/ethereum/block"
)

// DeployWsXMRProtocol deploys the complete wsXMR protocol (token + vault manager)
// using the passed privKey to pay for the deployment.
// Returns: wsXMR token address, VaultManager address, and any error
func DeployWsXMRProtocol(
	ctx context.Context,
	ec *ethclient.Client,
	privKey *ecdsa.PrivateKey,
	xmrUsdOracle ethcommon.Address,
	ethUsdOracle ethcommon.Address,
	deployer ethcommon.Address,
) (ethcommon.Address, ethcommon.Address, error) {
	txOpts, err := newTXOpts(ctx, ec, privKey)
	if err != nil {
		return ethcommon.Address{}, ethcommon.Address{}, err
	}

	// Step 1: Deploy wsXMR token
	log.Infof("deploying wsXMR.sol")
	wsxmrAddress, wsxmrTx, _, err := DeployWsXMR(txOpts, ec, deployer)
	if err != nil {
		return ethcommon.Address{}, ethcommon.Address{}, fmt.Errorf("failed to deploy wsXMR token: %w", err)
	}

	_, err = block.WaitForReceipt(ctx, ec, wsxmrTx.Hash())
	if err != nil {
		return ethcommon.Address{}, ethcommon.Address{}, err
	}
	log.Infof("deployed wsXMR.sol: address=%s tx hash=%s", wsxmrAddress, wsxmrTx.Hash())

	// Step 2: Deploy VaultManager
	log.Infof("deploying VaultManager.sol")
	vaultMgrAddress, vaultMgrTx, _, err := DeployVaultManager(
		txOpts,
		ec,
		wsxmrAddress,
		xmrUsdOracle,
		ethUsdOracle,
		deployer,
	)
	if err != nil {
		return ethcommon.Address{}, ethcommon.Address{}, fmt.Errorf("failed to deploy VaultManager: %w", err)
	}

	_, err = block.WaitForReceipt(ctx, ec, vaultMgrTx.Hash())
	if err != nil {
		return ethcommon.Address{}, ethcommon.Address{}, err
	}
	log.Infof("deployed VaultManager.sol: address=%s tx hash=%s", vaultMgrAddress, vaultMgrTx.Hash())

	// Step 3: Set VaultManager as the authorized minter/burner on wsXMR token
	log.Infof("setting VaultManager as authorized minter on wsXMR token")
	wsxmrToken, err := NewWsXMR(wsxmrAddress, ec)
	if err != nil {
		return ethcommon.Address{}, ethcommon.Address{}, fmt.Errorf("failed to instantiate wsXMR token: %w", err)
	}

	setVaultMgrTx, err := wsxmrToken.SetVaultManager(txOpts, vaultMgrAddress)
	if err != nil {
		return ethcommon.Address{}, ethcommon.Address{}, fmt.Errorf("failed to set vault manager: %w", err)
	}

	_, err = block.WaitForReceipt(ctx, ec, setVaultMgrTx.Hash())
	if err != nil {
		return ethcommon.Address{}, ethcommon.Address{}, err
	}
	log.Infof("VaultManager authorized on wsXMR token: tx hash=%s", setVaultMgrTx.Hash())

	log.Infof("wsXMR protocol deployment complete!")
	log.Infof("  wsXMR Token: %s", wsxmrAddress)
	log.Infof("  VaultManager: %s", vaultMgrAddress)

	return wsxmrAddress, vaultMgrAddress, nil
}

// DeployWsXMRWithKey is a convenience wrapper that deploys the wsXMR protocol
// and returns the VaultManager instance for immediate use
func DeployWsXMRWithKey(
	ctx context.Context,
	ec *ethclient.Client,
	privKey *ecdsa.PrivateKey,
	xmrUsdOracle ethcommon.Address,
	ethUsdOracle ethcommon.Address,
) (ethcommon.Address, *VaultManager, error) {
	deployerAddr := bind.NewKeyedTransactor(privKey).From

	wsxmrAddr, vaultMgrAddr, err := DeployWsXMRProtocol(
		ctx,
		ec,
		privKey,
		xmrUsdOracle,
		ethUsdOracle,
		deployerAddr,
	)
	if err != nil {
		return ethcommon.Address{}, nil, err
	}

	vaultMgr, err := NewVaultManager(vaultMgrAddr, ec)
	if err != nil {
		return ethcommon.Address{}, nil, fmt.Errorf("failed to instantiate VaultManager: %w", err)
	}

	return wsxmrAddr, vaultMgr, nil
}
