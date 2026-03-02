// SPDX-License-Identifier: LGPLv3
pragma solidity ^0.8.19;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20Metadata} from "./IERC20Metadata.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Secp256k1} from "./Secp256k1.sol";
import {AggregatorV3Interface} from "./AggregatorV3Interface.sol";
import {wsXMR} from "./wsXMR.sol";

/**
 * @title VaultManager
 * @notice Manages LP vaults, collateralization, and mint/burn operations for wsXMR
 * @dev Integrates cryptographic proofs from atomic swaps with CDP vault mechanics
 */
contract VaultManager is Secp256k1, ReentrancyGuard, Ownable {
    using SafeERC20 for IERC20;

    // ========== CONSTANTS ==========
    
    uint256 public constant COLLATERAL_RATIO = 150; // 150% overcollateralization
    uint256 public constant LIQUIDATION_RATIO = 120; // 120% liquidation threshold
    uint256 public constant LIQUIDATION_BONUS = 110; // 110% liquidator reward (must be < threshold)
    uint256 public constant RATIO_PRECISION = 100;
    uint256 public constant PRICE_PRECISION = 1e18;
    uint256 public constant BURN_TIMEOUT = 24 hours; // LP must fulfill burn within 24h
    // NOTE: Monero PTLC refund timelock MUST be < BURN_TIMEOUT (e.g., 12h) to prevent griefing
    
    // ========== STATE VARIABLES ==========
    
    wsXMR public immutable wsxmrToken;
    
    // Price oracles
    AggregatorV3Interface public xmrUsdOracle;
    AggregatorV3Interface public ethUsdOracle;
    
    // Supported collateral tokens (address(0) = native ETH)
    mapping(address => bool) public supportedCollateral;
    mapping(address => AggregatorV3Interface) public collateralOracles;
    
    // ========== ENUMS ==========
    
    enum MintStatus {
        INVALID,
        PENDING,
        READY,      // LP confirmed XMR lock on Monero chain
        COMPLETED,
        CANCELLED
    }
    
    enum BurnStatus {
        INVALID,
        PENDING,
        COMPLETED,
        SLASHED
    }
    
    // ========== STRUCTS ==========
    
    /**
     * @notice Vault represents an LP's collateral position
     */
    struct Vault {
        address lpAddress;
        address collateralAsset; // address(0) for ETH
        uint256 collateralAmount;
        uint256 debtAmount; // Amount of wsXMR backed by this vault
        bool active;
    }
    
    /**
     * @notice MintRequest tracks a pending mint operation
     */
    struct MintRequest {
        bytes32 requestId;
        address user;
        address lpVault;
        uint256 xmrAmount; // Amount of XMR (in atomic units, 1e12 per XMR)
        uint256 wsxmrAmount; // Amount of wsXMR to mint (1e8 per wsXMR)
        bytes32 claimCommitment; // Hash of secret that LP will reveal
        uint256 timeout;
        MintStatus status;
    }
    
    /**
     * @notice BurnRequest tracks a pending burn operation
     */
    struct BurnRequest {
        bytes32 requestId;
        address user;
        address lpVault;
        uint256 wsxmrAmount;
        uint256 xmrAmount;
        uint256 escrowedCollateral; // Collateral escrowed for this burn (prevents race with liquidation)
        bytes32 refundCommitment; // Hash of secret that user will reveal
        uint256 deadline; // LP must complete before this
        BurnStatus status;
    }
    
    // ========== MAPPINGS ==========
    
    mapping(address => Vault) public vaults;
    mapping(bytes32 => MintRequest) public mintRequests;
    mapping(bytes32 => BurnRequest) public burnRequests;
    
    // Track all vault addresses
    address[] public vaultList;
    
    // ========== EVENTS ==========
    
    event VaultCreated(address indexed lpAddress, address indexed collateralAsset);
    event CollateralDeposited(address indexed lpAddress, address indexed asset, uint256 amount);
    event CollateralWithdrawn(address indexed lpAddress, address indexed asset, uint256 amount);
    
    event MintInitiated(
        bytes32 indexed requestId,
        address indexed user,
        address indexed lpVault,
        uint256 xmrAmount,
        uint256 wsxmrAmount,
        bytes32 claimCommitment,
        uint256 timeout
    );
    event MintReady(bytes32 indexed requestId);
    event MintFinalized(bytes32 indexed requestId, bytes32 secret);
    event MintCancelled(bytes32 indexed requestId);
    
    event BurnInitiated(
        bytes32 indexed requestId,
        address indexed user,
        address indexed lpVault,
        uint256 wsxmrAmount,
        uint256 xmrAmount,
        bytes32 refundCommitment,
        uint256 deadline
    );
    event BurnFinalized(bytes32 indexed requestId, bytes32 secret);
    event BurnSlashed(bytes32 indexed requestId, address indexed user, uint256 collateralSeized);
    
    event VaultLiquidated(
        address indexed lpVault,
        address indexed liquidator,
        uint256 debtCleared,
        uint256 collateralSeized
    );
    
    event OracleUpdated(string indexed oracleType, address indexed newOracle);
    event CollateralSupported(address indexed asset, address indexed oracle);
    
    // ========== ERRORS ==========
    
    error ZeroAddress();
    error ZeroAmount();
    error VaultAlreadyExists();
    error VaultDoesNotExist();
    error VaultNotActive();
    error InsufficientCollateral();
    error InvalidCollateralAsset();
    error InvalidMintRequest();
    error InvalidBurnRequest();
    error MintAlreadyExists();
    error BurnAlreadyExists();
    error InvalidSecret();
    error InvalidStatus();
    error TimeoutNotReached();
    error DeadlineExpired();
    error DeadlineNotExpired();
    error VaultHealthy();
    error InsufficientDebt();
    error Unauthorized();
    error InvalidValue();
    error StalePrice();
    
    // ========== CONSTRUCTOR ==========
    
    constructor(
        address _wsxmrToken,
        address _xmrUsdOracle,
        address _ethUsdOracle,
        address _initialOwner
    ) Ownable(_initialOwner) {
        if (_wsxmrToken == address(0)) revert ZeroAddress();
        if (_xmrUsdOracle == address(0)) revert ZeroAddress();
        if (_ethUsdOracle == address(0)) revert ZeroAddress();
        if (_initialOwner == address(0)) revert ZeroAddress();
        
        wsxmrToken = wsXMR(_wsxmrToken);
        xmrUsdOracle = AggregatorV3Interface(_xmrUsdOracle);
        ethUsdOracle = AggregatorV3Interface(_ethUsdOracle);
        
        // Enable ETH as default collateral
        supportedCollateral[address(0)] = true;
        collateralOracles[address(0)] = ethUsdOracle;
        emit CollateralSupported(address(0), _ethUsdOracle);
    }
    
    // ========== VAULT MANAGEMENT ==========
    
    /**
     * @notice Create a new LP vault
     * @param _collateralAsset Address of collateral token (address(0) for ETH)
     */
    function createVault(address _collateralAsset) external {
        if (vaults[msg.sender].active) revert VaultAlreadyExists();
        if (!supportedCollateral[_collateralAsset]) revert InvalidCollateralAsset();
        
        vaults[msg.sender] = Vault({
            lpAddress: msg.sender,
            collateralAsset: _collateralAsset,
            collateralAmount: 0,
            debtAmount: 0,
            active: true
        });
        
        vaultList.push(msg.sender);
        emit VaultCreated(msg.sender, _collateralAsset);
    }
    
    /**
     * @notice Deposit collateral into vault
     * @param _amount Amount of collateral to deposit
     */
    function depositCollateral(uint256 _amount) external payable nonReentrant {
        if (!vaults[msg.sender].active) revert VaultDoesNotExist();
        if (_amount == 0) revert ZeroAmount();
        
        Vault storage vault = vaults[msg.sender];
        
        if (vault.collateralAsset == address(0)) {
            // ETH deposit
            if (msg.value != _amount) revert InvalidValue();
            vault.collateralAmount += _amount;
        } else {
            // ERC20 deposit
            if (msg.value != 0) revert InvalidValue();
            IERC20(vault.collateralAsset).safeTransferFrom(msg.sender, address(this), _amount);
            vault.collateralAmount += _amount;
        }
        
        emit CollateralDeposited(msg.sender, vault.collateralAsset, _amount);
    }
    
    /**
     * @notice Withdraw collateral from vault (only if health ratio allows)
     * @param _amount Amount of collateral to withdraw
     */
    function withdrawCollateral(uint256 _amount) external nonReentrant {
        if (!vaults[msg.sender].active) revert VaultDoesNotExist();
        if (_amount == 0) revert ZeroAmount();
        
        Vault storage vault = vaults[msg.sender];
        if (vault.collateralAmount < _amount) revert InsufficientCollateral();
        
        // Check if withdrawal would make vault unhealthy
        uint256 newCollateralAmount = vault.collateralAmount - _amount;
        if (vault.debtAmount > 0) {
            uint256 ratio = calculateCollateralRatio(
                vault.collateralAsset,
                newCollateralAmount,
                vault.debtAmount
            );
            if (ratio < COLLATERAL_RATIO) revert InsufficientCollateral();
        }
        
        vault.collateralAmount = newCollateralAmount;
        
        // Transfer collateral back to LP
        if (vault.collateralAsset == address(0)) {
            payable(msg.sender).transfer(_amount);
        } else {
            IERC20(vault.collateralAsset).safeTransfer(msg.sender, _amount);
        }
        
        emit CollateralWithdrawn(msg.sender, vault.collateralAsset, _amount);
    }
    
    // ========== MINTING FLOW ==========
    
    /**
     * @notice User initiates a mint request
     * @param _lpVault Address of the LP vault to use
     * @param _xmrAmount Amount of XMR to lock (atomic units)
     * @param _claimCommitment Hash of the secret LP will reveal
     * @param _timeoutDuration How long before request can be cancelled
     * @return requestId Unique identifier for this mint request
     */
    function initiateMint(
        address _lpVault,
        uint256 _xmrAmount,
        bytes32 _claimCommitment,
        uint256 _timeoutDuration
    ) external returns (bytes32 requestId) {
        if (_lpVault == address(0)) revert ZeroAddress();
        if (_xmrAmount == 0) revert ZeroAmount();
        if (_claimCommitment == bytes32(0)) revert InvalidSecret();
        if (!vaults[_lpVault].active) revert VaultDoesNotExist();
        
        // Convert XMR amount to wsXMR amount (XMR has 12 decimals, wsXMR has 8)
        uint256 wsxmrAmount = _xmrAmount / 1e4;
        
        // Check if LP has enough collateral capacity
        Vault storage vault = vaults[_lpVault];
        uint256 newDebt = vault.debtAmount + wsxmrAmount;
        uint256 ratio = calculateCollateralRatio(
            vault.collateralAsset,
            vault.collateralAmount,
            newDebt
        );
        if (ratio < COLLATERAL_RATIO) revert InsufficientCollateral();
        
        // Generate unique request ID
        requestId = keccak256(abi.encodePacked(
            msg.sender,
            _lpVault,
            _xmrAmount,
            _claimCommitment,
            block.timestamp,
            block.number
        ));
        
        if (mintRequests[requestId].status != MintStatus.INVALID) revert MintAlreadyExists();
        
        mintRequests[requestId] = MintRequest({
            requestId: requestId,
            user: msg.sender,
            lpVault: _lpVault,
            xmrAmount: _xmrAmount,
            wsxmrAmount: wsxmrAmount,
            claimCommitment: _claimCommitment,
            timeout: block.timestamp + _timeoutDuration,
            status: MintStatus.PENDING
        });
        
        emit MintInitiated(
            requestId,
            msg.sender,
            _lpVault,
            _xmrAmount,
            wsxmrAmount,
            _claimCommitment,
            block.timestamp + _timeoutDuration
        );
        
        return requestId;
    }
    
    /**
     * @notice LP confirms User has locked XMR on the Monero network
     * @param _requestId The mint request ID
     */
    function setMintReady(bytes32 _requestId) external {
        MintRequest storage request = mintRequests[_requestId];
        if (request.status != MintStatus.PENDING) revert InvalidStatus();
        if (msg.sender != request.lpVault) revert Unauthorized();
        
        request.status = MintStatus.READY;
        emit MintReady(_requestId);
    }
    
    /**
     * @notice Finalize mint after LP has claimed XMR on Monero chain
     * @param _requestId The mint request ID
     * @param _secret The secret revealed by LP when claiming XMR
     */
    function finalizeMint(bytes32 _requestId, bytes32 _secret) external nonReentrant {
        MintRequest storage request = mintRequests[_requestId];
        if (request.status != MintStatus.READY) revert InvalidStatus(); // MUST be READY, not PENDING
        
        // Verify the secret matches the commitment using secp256k1 verification
        if (!mulVerify(uint256(_secret), uint256(request.claimCommitment))) {
            revert InvalidSecret();
        }
        
        // Update vault debt
        Vault storage vault = vaults[request.lpVault];
        vault.debtAmount += request.wsxmrAmount;
        
        // Mint wsXMR to user
        wsxmrToken.mint(request.user, request.wsxmrAmount);
        
        // Mark as completed
        request.status = MintStatus.COMPLETED;
        
        emit MintFinalized(_requestId, _secret);
    }
    
    /**
     * @notice Cancel a mint request after timeout
     * @param _requestId The mint request ID
     */
    function cancelMint(bytes32 _requestId) external {
        MintRequest storage request = mintRequests[_requestId];
        if (request.status != MintStatus.PENDING) revert InvalidStatus();
        if (msg.sender != request.user) revert Unauthorized();
        if (block.timestamp < request.timeout) revert TimeoutNotReached();
        
        request.status = MintStatus.CANCELLED;
        emit MintCancelled(_requestId);
    }
    
    // ========== BURNING FLOW ==========
    
    /**
     * @notice User initiates burn to get XMR back
     * @param _wsxmrAmount Amount of wsXMR to burn
     * @param _lpVault LP vault to handle the burn
     * @param _refundCommitment Hash of secret user will reveal when claiming XMR
     * @return requestId Unique identifier for this burn request
     */
    function initiateBurn(
        uint256 _wsxmrAmount,
        address _lpVault,
        bytes32 _refundCommitment
    ) external returns (bytes32 requestId) {
        if (_wsxmrAmount == 0) revert ZeroAmount();
        if (_lpVault == address(0)) revert ZeroAddress();
        if (_refundCommitment == bytes32(0)) revert InvalidSecret();
        if (!vaults[_lpVault].active) revert VaultDoesNotExist();
        
        Vault storage vault = vaults[_lpVault];
        if (vault.debtAmount < _wsxmrAmount) revert InsufficientDebt();
        
        // Convert wsXMR to XMR amount
        uint256 xmrAmount = _wsxmrAmount * 1e4;
        
        // Calculate the 150% collateral required strictly for this burn
        uint256 collateralValue = getCollateralValueForDebt(_wsxmrAmount);
        uint256 collateralToEscrow = usdToCollateral(
            vault.collateralAsset,
            (collateralValue * COLLATERAL_RATIO) / RATIO_PRECISION
        );
        
        // Ensure the LP actually has enough free collateral to cover this burn
        if (vault.collateralAmount < collateralToEscrow) revert InsufficientCollateral();
        
        // Generate unique request ID
        requestId = keccak256(abi.encodePacked(
            msg.sender,
            _lpVault,
            _wsxmrAmount,
            _refundCommitment,
            block.timestamp,
            block.number
        ));
        
        if (burnRequests[requestId].status != BurnStatus.INVALID) revert BurnAlreadyExists();
        
        // CRITICAL: Immediately escrow the collateral and remove the debt from the Vault
        // This prevents race condition with liquidation causing underflow
        vault.collateralAmount -= collateralToEscrow;
        vault.debtAmount -= _wsxmrAmount;
        
        // Burn the wsXMR tokens from user
        wsxmrToken.burn(msg.sender, _wsxmrAmount);
        
        burnRequests[requestId] = BurnRequest({
            requestId: requestId,
            user: msg.sender,
            lpVault: _lpVault,
            wsxmrAmount: _wsxmrAmount,
            xmrAmount: xmrAmount,
            escrowedCollateral: collateralToEscrow,
            refundCommitment: _refundCommitment,
            deadline: block.timestamp + BURN_TIMEOUT,
            status: BurnStatus.PENDING
        });
        
        emit BurnInitiated(
            requestId,
            msg.sender,
            _lpVault,
            _wsxmrAmount,
            xmrAmount,
            _refundCommitment,
            block.timestamp + BURN_TIMEOUT
        );
        
        return requestId;
    }
    
    /**
     * @notice LP finalizes burn after user claims XMR on Monero chain
     * @param _requestId The burn request ID
     * @param _secret The secret revealed by user when claiming XMR
     */
    function finalizeBurn(bytes32 _requestId, bytes32 _secret) external nonReentrant {
        BurnRequest storage request = burnRequests[_requestId];
        if (request.status != BurnStatus.PENDING) revert InvalidStatus();
        if (block.timestamp >= request.deadline) revert DeadlineExpired();
        
        // Verify the secret matches the commitment
        if (!mulVerify(uint256(_secret), uint256(request.refundCommitment))) {
            revert InvalidSecret();
        }
        
        // Debt was already reduced in initiateBurn
        // Simply return the escrowed collateral to the LP's active balance
        Vault storage vault = vaults[request.lpVault];
        vault.collateralAmount += request.escrowedCollateral;
        
        // Mark as completed
        request.status = BurnStatus.COMPLETED;
        
        emit BurnFinalized(_requestId, _secret);
    }
    
    /**
     * @notice User claims slashed collateral if LP failed to fulfill burn
     * @param _requestId The burn request ID
     */
    function claimSlashedCollateral(bytes32 _requestId) external nonReentrant {
        BurnRequest storage request = burnRequests[_requestId];
        if (request.status != BurnStatus.PENDING) revert InvalidStatus();
        if (msg.sender != request.user) revert Unauthorized();
        if (block.timestamp < request.deadline) revert DeadlineNotExpired();
        
        Vault storage vault = vaults[request.lpVault];
        
        // Debt and Collateral were already separated from the vault in initiateBurn
        // Just send the escrow straight to the user (no underflow risk)
        if (vault.collateralAsset == address(0)) {
            payable(request.user).transfer(request.escrowedCollateral);
        } else {
            IERC20(vault.collateralAsset).safeTransfer(request.user, request.escrowedCollateral);
        }
        
        request.status = BurnStatus.SLASHED;
        emit BurnSlashed(_requestId, request.user, request.escrowedCollateral);
    }
    
    // ========== LIQUIDATION ==========
    
    /**
     * @notice Liquidate an undercollateralized vault
     * @param _lpVault Address of the vault to liquidate
     * @param _debtToClear Amount of debt to clear (in wsXMR)
     */
    function liquidate(address _lpVault, uint256 _debtToClear) external nonReentrant {
        if (!vaults[_lpVault].active) revert VaultDoesNotExist();
        if (_debtToClear == 0) revert ZeroAmount();
        
        Vault storage vault = vaults[_lpVault];
        if (vault.debtAmount == 0) revert InsufficientDebt();
        if (_debtToClear > vault.debtAmount) {
            _debtToClear = vault.debtAmount;
        }
        
        // Check if vault is underwater
        uint256 ratio = calculateCollateralRatio(
            vault.collateralAsset,
            vault.collateralAmount,
            vault.debtAmount
        );
        if (ratio >= LIQUIDATION_RATIO) revert VaultHealthy();
        
        // Calculate collateral to seize (at liquidation bonus, which is < threshold to prevent death spiral)
        uint256 collateralValue = getCollateralValueForDebt(_debtToClear);
        uint256 collateralToSeize = (collateralValue * LIQUIDATION_BONUS) / RATIO_PRECISION;
        uint256 collateralAmount = usdToCollateral(vault.collateralAsset, collateralToSeize);
        
        if (collateralAmount > vault.collateralAmount) {
            collateralAmount = vault.collateralAmount;
        }
        
        // CHECKS-EFFECTS-INTERACTIONS: Update state before external calls
        vault.collateralAmount -= collateralAmount;
        vault.debtAmount -= _debtToClear;
        
        // Burn wsXMR from liquidator (interaction after state changes)
        wsxmrToken.burn(msg.sender, _debtToClear);
        
        // Transfer collateral to liquidator
        if (vault.collateralAsset == address(0)) {
            payable(msg.sender).transfer(collateralAmount);
        } else {
            IERC20(vault.collateralAsset).safeTransfer(msg.sender, collateralAmount);
        }
        
        emit VaultLiquidated(_lpVault, msg.sender, _debtToClear, collateralAmount);
    }
    
    // ========== PRICE ORACLE FUNCTIONS ==========
    
    /**
     * @notice Get XMR price in USD (18 decimals)
     */
    function getXmrPrice() public view returns (uint256) {
        (, int256 price, , uint256 updatedAt, ) = xmrUsdOracle.latestRoundData();
        if (price <= 0) revert StalePrice();
        if (block.timestamp - updatedAt > 1 hours) revert StalePrice();
        
        // Chainlink prices are typically 8 decimals, scale to 18
        uint8 decimals = xmrUsdOracle.decimals();
        return uint256(price) * (10 ** (18 - decimals));
    }
    
    /**
     * @notice Get collateral asset price in USD (18 decimals)
     */
    function getCollateralPrice(address _asset) public view returns (uint256) {
        AggregatorV3Interface oracle = collateralOracles[_asset];
        (, int256 price, , uint256 updatedAt, ) = oracle.latestRoundData();
        if (price <= 0) revert StalePrice();
        if (block.timestamp - updatedAt > 1 hours) revert StalePrice();
        
        uint8 decimals = oracle.decimals();
        return uint256(price) * (10 ** (18 - decimals));
    }
    
    /**
     * @notice Calculate collateral ratio for a vault
     * @return ratio Collateral ratio (e.g., 150 for 150%)
     */
    function calculateCollateralRatio(
        address _collateralAsset,
        uint256 _collateralAmount,
        uint256 _debtAmount
    ) public view returns (uint256 ratio) {
        if (_debtAmount == 0) return type(uint256).max;
        
        uint256 collateralPrice = getCollateralPrice(_collateralAsset);
        uint256 xmrPrice = getXmrPrice();
        
        // Get collateral decimals
        uint8 collateralDecimals = _collateralAsset == address(0) ? 18 : IERC20Metadata(_collateralAsset).decimals();
        
        // Calculate collateral value in USD (18 decimals)
        uint256 collateralValue = (_collateralAmount * collateralPrice) / (10 ** collateralDecimals);
        
        // Calculate debt value in USD (wsXMR has 8 decimals)
        uint256 debtValue = (_debtAmount * xmrPrice) / 1e8;
        
        // Return ratio as percentage
        ratio = (collateralValue * RATIO_PRECISION) / debtValue;
    }
    
    /**
     * @notice Get USD value of collateral needed for debt amount
     */
    function getCollateralValueForDebt(uint256 _debtAmount) internal view returns (uint256) {
        uint256 xmrPrice = getXmrPrice();
        return (_debtAmount * xmrPrice) / 1e8;
    }
    
    /**
     * @notice Convert USD value to collateral token amount
     */
    function usdToCollateral(address _asset, uint256 _usdValue) internal view returns (uint256) {
        uint256 collateralPrice = getCollateralPrice(_asset);
        uint8 decimals = _asset == address(0) ? 18 : IERC20Metadata(_asset).decimals();
        return (_usdValue * (10 ** decimals)) / collateralPrice;
    }
    
    // ========== VIEW FUNCTIONS ==========
    
    /**
     * @notice Get vault information
     */
    function getVault(address _lpAddress) external view returns (Vault memory) {
        return vaults[_lpAddress];
    }
    
    /**
     * @notice Get current collateral ratio for a vault
     */
    function getVaultCollateralRatio(address _lpAddress) external view returns (uint256) {
        Vault memory vault = vaults[_lpAddress];
        if (!vault.active) revert VaultDoesNotExist();
        return calculateCollateralRatio(
            vault.collateralAsset,
            vault.collateralAmount,
            vault.debtAmount
        );
    }
    
    /**
     * @notice Check if vault is liquidatable
     */
    function isVaultLiquidatable(address _lpAddress) external view returns (bool) {
        Vault memory vault = vaults[_lpAddress];
        if (!vault.active || vault.debtAmount == 0) return false;
        
        uint256 ratio = calculateCollateralRatio(
            vault.collateralAsset,
            vault.collateralAmount,
            vault.debtAmount
        );
        return ratio < LIQUIDATION_RATIO;
    }
    
    /**
     * @notice Get total number of vaults
     */
    function getVaultCount() external view returns (uint256) {
        return vaultList.length;
    }
    
    // ========== ADMIN FUNCTIONS ==========
    
    /**
     * @notice Update XMR/USD oracle
     */
    function setXmrOracle(address _oracle) external onlyOwner {
        if (_oracle == address(0)) revert ZeroAddress();
        xmrUsdOracle = AggregatorV3Interface(_oracle);
        emit OracleUpdated("XMR_USD", _oracle);
    }
    
    /**
     * @notice Update ETH/USD oracle
     */
    function setEthOracle(address _oracle) external onlyOwner {
        if (_oracle == address(0)) revert ZeroAddress();
        ethUsdOracle = AggregatorV3Interface(_oracle);
        collateralOracles[address(0)] = ethUsdOracle;
        emit OracleUpdated("ETH_USD", _oracle);
    }
    
    /**
     * @notice Add support for new collateral type
     */
    function addCollateralSupport(address _asset, address _oracle) external onlyOwner {
        if (_oracle == address(0)) revert ZeroAddress();
        supportedCollateral[_asset] = true;
        collateralOracles[_asset] = AggregatorV3Interface(_oracle);
        emit CollateralSupported(_asset, _oracle);
    }
    
    /**
     * @notice Remove support for collateral type
     */
    function removeCollateralSupport(address _asset) external onlyOwner {
        supportedCollateral[_asset] = false;
        delete collateralOracles[_asset];
    }
}
