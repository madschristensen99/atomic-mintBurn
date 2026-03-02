// SPDX-License-Identifier: LGPLv3
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

// Import our contracts (adjust paths as needed for Foundry)
interface IWsXMR {
    function setVaultManager(address _vaultManager) external;
}

/**
 * @title DeployWsXMR
 * @notice Foundry script to deploy the wsXMR protocol
 * @dev Usage:
 *   forge script script/DeployWsXMR.s.sol:DeployWsXMR \
 *     --rpc-url $RPC_URL \
 *     --private-key $PRIVATE_KEY \
 *     --broadcast \
 *     --verify
 */
contract DeployWsXMR is Script {
    function run() external {
        // Read environment variables
        address xmrUsdOracle = vm.envAddress("XMR_USD_ORACLE");
        address ethUsdOracle = vm.envAddress("ETH_USD_ORACLE");
        address deployer = vm.envAddress("DEPLOYER_ADDRESS");

        console.log("Deploying wsXMR Protocol...");
        console.log("Deployer:", deployer);
        console.log("XMR/USD Oracle:", xmrUsdOracle);
        console.log("ETH/USD Oracle:", ethUsdOracle);

        vm.startBroadcast();

        // Deploy wsXMR token
        console.log("\n1. Deploying wsXMR token...");
        bytes memory wsxmrBytecode = vm.getCode("wsXMR.sol:wsXMR");
        bytes memory wsxmrConstructor = abi.encode(deployer);
        address wsxmrAddress;
        assembly {
            wsxmrAddress := create(0, add(wsxmrBytecode, 0x20), mload(wsxmrBytecode))
        }
        require(wsxmrAddress != address(0), "wsXMR deployment failed");
        console.log("wsXMR deployed at:", wsxmrAddress);

        // Deploy VaultManager
        console.log("\n2. Deploying VaultManager...");
        bytes memory vaultMgrBytecode = vm.getCode("VaultManager.sol:VaultManager");
        bytes memory vaultMgrConstructor = abi.encode(
            wsxmrAddress,
            xmrUsdOracle,
            ethUsdOracle,
            deployer
        );
        address vaultMgrAddress;
        assembly {
            vaultMgrAddress := create(0, add(vaultMgrBytecode, 0x20), mload(vaultMgrBytecode))
        }
        require(vaultMgrAddress != address(0), "VaultManager deployment failed");
        console.log("VaultManager deployed at:", vaultMgrAddress);

        // Set VaultManager as authorized minter on wsXMR
        console.log("\n3. Authorizing VaultManager on wsXMR token...");
        IWsXMR(wsxmrAddress).setVaultManager(vaultMgrAddress);
        console.log("VaultManager authorized");

        vm.stopBroadcast();

        console.log("\n========================================");
        console.log("Deployment Complete!");
        console.log("========================================");
        console.log("wsXMR Token:    ", wsxmrAddress);
        console.log("VaultManager:   ", vaultMgrAddress);
        console.log("========================================");
    }
}
