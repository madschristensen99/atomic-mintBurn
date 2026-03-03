// SPDX-License-Identifier: LGPLv3
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {wsXMR} from "../ethereum/contracts/wsXMR.sol";
import {VaultManager} from "../ethereum/contracts/VaultManager.sol";

/**
 * @title DeployMainnet
 * @notice Deploy wsXMR protocol to Monad Mainnet with Pyth oracles
 */
contract DeployMainnet is Script {
    // Pyth contract on Monad Mainnet
    address constant PYTH_CONTRACT = 0x2880aB155794e7179c9eE2e38200202908C17B43;
    
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        console.log("===========================================");
        console.log("Deploying wsXMR Protocol to Monad Mainnet");
        console.log("===========================================");
        console.log("Deployer:", deployer);
        console.log("Balance:", deployer.balance / 1e18, "MON");
        console.log("Pyth Oracle:", PYTH_CONTRACT);
        console.log("");
        
        vm.startBroadcast(deployerPrivateKey);
        
        // Step 1: Deploy wsXMR Token
        console.log("Step 1: Deploying wsXMR Token...");
        wsXMR token = new wsXMR(deployer);
        console.log("wsXMR Token:", address(token));
        console.log("");
        
        // Step 2: Deploy VaultManager with Pyth
        console.log("Step 2: Deploying VaultManager with Pyth...");
        VaultManager vaultManager = new VaultManager(
            address(token),
            PYTH_CONTRACT,
            deployer
        );
        console.log("VaultManager:", address(vaultManager));
        console.log("");
        
        // Step 3: Authorize VaultManager on wsXMR token
        console.log("Step 3: Authorizing VaultManager...");
        token.setVaultManager(address(vaultManager));
        console.log("VaultManager authorized");
        
        vm.stopBroadcast();
        
        console.log("");
        console.log("===========================================");
        console.log("Deployment Complete!");
        console.log("===========================================");
        console.log("");
        console.log("Contract Addresses:");
        console.log("  wsXMR Token:   ", address(token));
        console.log("  VaultManager:  ", address(vaultManager));
        console.log("  Pyth Oracle:   ", PYTH_CONTRACT);
        console.log("");
        console.log("Pyth Price Feeds:");
        console.log("  XMR/USD: 0x46b8cc9347f04391764a0361e0b17c3ba394b001e7c304f7650f6376e37c321d");
        console.log("  MON/USD: 0x31491744e2dbf6df7fcf4ac0820d18a609b49076d45066d3568424e62f686cd1");
        console.log("");
        console.log("Protocol Parameters:");
        console.log("  Collateral Ratio:   150%");
        console.log("  Liquidation Ratio:  120%");
        console.log("  Liquidation Bonus:  110%");
        console.log("");
        console.log("Next Steps:");
        console.log("1. Verify contracts on MonadScan");
        console.log("2. Test vault creation and minting");
        console.log("3. Monitor Pyth price feeds");
        console.log("===========================================");
    }
}
