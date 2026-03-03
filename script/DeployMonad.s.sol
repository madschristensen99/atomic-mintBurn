// SPDX-License-Identifier: LGPLv3
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

/**
 * @title DeployMonad
 * @notice Deploy wsXMR protocol to Monad Testnet with mock oracles
 */
contract DeployMonad is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Deploying to Monad Testnet");
        console.log("Deployer:", deployer);
        console.log("Balance:", deployer.balance);

        vm.startBroadcast(deployerPrivateKey);

        // Step 1: Deploy Mock Oracles
        console.log("\n1. Deploying Mock Price Oracles...");
        MockOracle xmrOracle = new MockOracle(150e8, 8); // $150 XMR
        MockOracle ethOracle = new MockOracle(2500e8, 8); // $2500 ETH
        console.log("XMR/USD Oracle:", address(xmrOracle));
        console.log("ETH/USD Oracle:", address(ethOracle));

        // Step 2: Deploy wsXMR Token
        console.log("\n2. Deploying wsXMR Token...");
        bytes memory wsxmrBytecode = abi.encodePacked(
            vm.getCode("wsXMR.sol:wsXMR"),
            abi.encode(deployer)
        );
        address wsxmrAddr;
        assembly {
            wsxmrAddr := create(0, add(wsxmrBytecode, 0x20), mload(wsxmrBytecode))
        }
        require(wsxmrAddr != address(0), "wsXMR deployment failed");
        console.log("wsXMR Token:", wsxmrAddr);

        // Step 3: Deploy VaultManager
        console.log("\n3. Deploying VaultManager...");
        bytes memory vaultMgrBytecode = abi.encodePacked(
            vm.getCode("VaultManager.sol:VaultManager"),
            abi.encode(wsxmrAddr, address(xmrOracle), address(ethOracle), deployer)
        );
        address vaultMgrAddr;
        assembly {
            vaultMgrAddr := create(0, add(vaultMgrBytecode, 0x20), mload(vaultMgrBytecode))
        }
        require(vaultMgrAddr != address(0), "VaultManager deployment failed");
        console.log("VaultManager:", vaultMgrAddr);

        // Step 4: Authorize VaultManager on wsXMR
        console.log("\n4. Authorizing VaultManager...");
        (bool success, ) = wsxmrAddr.call(
            abi.encodeWithSignature("setVaultManager(address)", vaultMgrAddr)
        );
        require(success, "setVaultManager failed");
        console.log("VaultManager authorized");

        vm.stopBroadcast();

        console.log("\n========================================");
        console.log("Deployment Complete!");
        console.log("========================================");
        console.log("wsXMR Token:    ", wsxmrAddr);
        console.log("VaultManager:   ", vaultMgrAddr);
        console.log("XMR/USD Oracle: ", address(xmrOracle));
        console.log("ETH/USD Oracle: ", address(ethOracle));
        console.log("========================================");
        console.log("Explorer: https://testnet.monadvision.com");
        console.log("========================================");
    }
}

/**
 * @title MockOracle
 * @notice Mock Chainlink oracle for testnet
 */
contract MockOracle {
    int256 public price;
    uint8 public decimals;
    
    constructor(int256 _price, uint8 _decimals) {
        price = _price;
        decimals = _decimals;
    }
    
    function latestRoundData() external view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ) {
        return (1, price, block.timestamp, block.timestamp, 1);
    }
    
    function setPrice(int256 _price) external {
        price = _price;
    }
}
