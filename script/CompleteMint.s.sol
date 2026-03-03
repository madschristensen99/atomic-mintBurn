// SPDX-License-Identifier: LGPLv3
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

interface IVaultManager {
    function setMintReady(bytes32 _requestId) external;
    function finalizeMint(bytes32 _requestId, bytes32 _secret) external;
    function getVault(address _lpAddress) external view returns (
        address collateralAsset,
        uint256 collateralAmount,
        uint256 debtAmount,
        bool exists
    );
}

interface IWsXMR {
    function balanceOf(address account) external view returns (uint256);
    function totalSupply() external view returns (uint256);
}

/**
 * @title CompleteMint
 * @notice Complete the mint flow: setMintReady -> finalizeMint
 */
contract CompleteMint is Script {
    // Deployed contract addresses
    address constant VAULT_MANAGER = 0xd821A7D919e007b6b39925f672f1219dB4865Fba;
    address constant WSXMR_TOKEN = 0x75b85bbC8779B9cDe77cc9DD0335C27410455A53;
    
    // Request ID from previous test (you'll need to update this)
    bytes32 constant REQUEST_ID = 0x9ae94e6c1636a7658ca56d41717a59cfb56ab8871310da226f069b3789b01246;
    
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        console.log("===========================================");
        console.log("Completing wsXMR Mint Flow");
        console.log("===========================================");
        console.log("LP Address:", deployer);
        console.log("Request ID:", vm.toString(REQUEST_ID));
        console.log("");
        
        IVaultManager vaultMgr = IVaultManager(VAULT_MANAGER);
        IWsXMR wsxmr = IWsXMR(WSXMR_TOKEN);
        
        vm.startBroadcast(deployerPrivateKey);
        
        // Step 1: LP sets mint ready (after verifying XMR lock on Monero)
        console.log("Step 1: LP setting mint to READY state...");
        console.log("(In production: LP has verified XMR lock on Monero chain)");
        vaultMgr.setMintReady(REQUEST_ID);
        console.log("Mint status set to READY");
        
        // Step 2: LP finalizes mint with secret (after claiming XMR on Monero)
        console.log("\nStep 2: LP finalizing mint with secret...");
        console.log("(In production: LP claimed XMR on Monero, revealing secret)");
        
        // The secret that matches our commitment from TestFlow
        bytes32 secret = keccak256(abi.encodePacked("test_secret"));
        console.log("Secret:", vm.toString(secret));
        
        vaultMgr.finalizeMint(REQUEST_ID, secret);
        console.log("Mint finalized! wsXMR minted to user");
        
        // Check final state
        console.log("\n===========================================");
        console.log("Final State:");
        console.log("===========================================");
        
        uint256 userBalance = wsxmr.balanceOf(deployer);
        uint256 totalSupply = wsxmr.totalSupply();
        
        console.log("User wsXMR Balance:", userBalance / 1e8);
        console.log("Total wsXMR Supply:", totalSupply / 1e8);
        
        (
            ,
            uint256 collateralAmount,
            uint256 debtAmount,
        ) = vaultMgr.getVault(deployer);
        
        console.log("\nLP Vault:");
        console.log("  Collateral:", collateralAmount / 1e18, "MON");
        console.log("  Debt:", debtAmount / 1e8, "wsXMR");
        
        vm.stopBroadcast();
        
        console.log("\n===========================================");
        console.log("Mint Flow Complete!");
        console.log("===========================================");
    }
}
