// SPDX-License-Identifier: LGPLv3
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

interface IVaultManager {
    function createVault(address _collateralAsset) external;
    function depositCollateral(uint256 _amount) external payable;
    function getVault(address _lpAddress) external view returns (
        address collateralAsset,
        uint256 collateralAmount,
        uint256 debtAmount,
        bool exists
    );
    function getVaultCollateralRatio(address _lpAddress) external view returns (uint256);
    function initiateMint(
        address _lpVault,
        uint256 _wsxmrAmount,
        bytes32 _claimCommitment,
        uint256 _timeout
    ) external returns (bytes32);
}

interface IWsXMR {
    function balanceOf(address account) external view returns (uint256);
    function totalSupply() external view returns (uint256);
}

/**
 * @title TestFlow
 * @notice Test the full wsXMR mint flow on Monad Testnet
 */
contract TestFlow is Script {
    // Deployed contract addresses
    address constant VAULT_MANAGER = 0xd821A7D919e007b6b39925f672f1219dB4865Fba;
    address constant WSXMR_TOKEN = 0x75b85bbC8779B9cDe77cc9DD0335C27410455A53;
    
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        console.log("===========================================");
        console.log("Testing wsXMR Protocol Flow");
        console.log("===========================================");
        console.log("Tester Address:", deployer);
        console.log("Balance:", deployer.balance / 1e18, "MON");
        console.log("");
        
        IVaultManager vaultMgr = IVaultManager(VAULT_MANAGER);
        IWsXMR wsxmr = IWsXMR(WSXMR_TOKEN);
        
        vm.startBroadcast(deployerPrivateKey);
        
        // Step 1: Create LP Vault
        console.log("Step 1: Creating LP Vault...");
        vaultMgr.createVault(address(0)); // ETH collateral
        console.log("Vault created for LP:", deployer);
        
        // Step 2: Deposit Collateral (1 ETH)
        console.log("\nStep 2: Depositing 1 MON collateral...");
        vaultMgr.depositCollateral{value: 1 ether}(1 ether);
        
        // Check vault state
        (
            address collateralAsset,
            uint256 collateralAmount,
            uint256 debtAmount,
            bool exists
        ) = vaultMgr.getVault(deployer);
        
        console.log("Vault State:");
        console.log("  Collateral Asset:", collateralAsset);
        console.log("  Collateral Amount:", collateralAmount / 1e18, "MON");
        console.log("  Debt Amount:", debtAmount / 1e8, "wsXMR");
        console.log("  Exists:", exists);
        
        // Step 3: User initiates mint
        console.log("\nStep 3: User initiating mint request...");
        
        // Generate a test claim commitment (in production, this comes from Monero PTLC)
        bytes32 claimCommitment = keccak256(abi.encodePacked("test_secret_commitment"));
        uint256 wsxmrAmount = 100 * 1e8; // 100 wsXMR (8 decimals)
        uint256 timeout = block.timestamp + 24 hours;
        
        bytes32 requestId = vaultMgr.initiateMint(
            deployer, // LP vault
            wsxmrAmount,
            claimCommitment,
            timeout
        );
        
        console.log("Mint Request Created:");
        console.log("  Request ID:", vm.toString(requestId));
        console.log("  wsXMR Amount:", wsxmrAmount / 1e8);
        console.log("  Claim Commitment:", vm.toString(claimCommitment));
        console.log("  Timeout:", timeout);
        
        // Check updated vault state
        (, collateralAmount, debtAmount, ) = vaultMgr.getVault(deployer);
        uint256 ratio = vaultMgr.getVaultCollateralRatio(deployer);
        
        console.log("\nVault State After Mint Request:");
        console.log("  Collateral:", collateralAmount / 1e18, "MON");
        console.log("  Debt:", debtAmount / 1e8, "wsXMR");
        console.log("  Collateral Ratio:", ratio, "%");
        
        // Check wsXMR supply
        uint256 totalSupply = wsxmr.totalSupply();
        console.log("\nwsXMR Total Supply:", totalSupply / 1e8);
        
        vm.stopBroadcast();
        
        console.log("\n===========================================");
        console.log("Test Flow Complete!");
        console.log("===========================================");
        console.log("\nNext Steps:");
        console.log("1. LP monitors Monero chain for XMR lock");
        console.log("2. LP calls setMintReady() after verifying XMR");
        console.log("3. LP claims XMR on Monero (reveals secret)");
        console.log("4. LP calls finalizeMint(secret) to mint wsXMR");
        console.log("===========================================");
    }
}
