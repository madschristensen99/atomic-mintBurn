// SPDX-License-Identifier: LGPLv3
pragma solidity ^0.8.0 ^0.8.1 ^0.8.19;

// ethereum/contracts/@openzeppelin/contracts/utils/Address.sol

// OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     *
     * Furthermore, `isContract` will also return true if the target contract within
     * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
     * which only has an effect at the end of a transaction.
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

// ethereum/contracts/AggregatorV3Interface.sol

//
// Contract comes from here:
//   https://github.com/smartcontractkit/smart-contract-examples/blob/main/pricefeed-golang/aggregatorv3/AggregatorV3Interface.sol
//

interface AggregatorV3Interface {
    function decimals() external view returns (uint8);

    function description() external view returns (string memory);

    function version() external view returns (uint256);

    // getRoundData and latestRoundData should both raise "No data present"
    // if they do not have data to report, instead of returning unset values
    // which could be misinterpreted as actual reported values.
    function getRoundData(
        uint80 _roundId
    )
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );

    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}

// ethereum/contracts/@openzeppelin/contracts/utils/Context.sol

// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// ethereum/contracts/@openzeppelin/contracts/token/ERC20/IERC20.sol

// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

// ethereum/contracts/@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol

// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/extensions/IERC20Permit.sol)

/**
 * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
 * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
 *
 * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
 * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
 * need to send a transaction, and thus is not required to hold Ether at all.
 */
interface IERC20Permit {
    /**
     * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
     * given ``owner``'s signed approval.
     *
     * IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `deadline` must be a timestamp in the future.
     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
     * over the EIP712-formatted function arguments.
     * - the signature must use ``owner``'s current nonce (see {nonces}).
     *
     * For more information on the signature format, see the
     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
     * section].
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

// ethereum/contracts/@openzeppelin/contracts/utils/ReentrancyGuard.sol

// OpenZeppelin Contracts (last updated v5.0.0) (utils/ReentrancyGuard.sol)

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 */
abstract contract ReentrancyGuard {
    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = 2;

    uint256 private _status;

    error ReentrancyGuardReentrantCall();

    constructor() {
        _status = NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be NOT_ENTERED
        if (_status == ENTERED) {
            revert ReentrancyGuardReentrantCall();
        }

        // Any calls to nonReentrant after this point will fail
        _status = ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == ENTERED;
    }
}

// ethereum/contracts/Secp256k1.sol

// Implemention based on Vitalik's idea:
// https://ethresear.ch/t/you-can-kinda-abuse-ecrecover-to-do-ecmul-in-secp256k1-today

contract Secp256k1 {
    // solhint-disable-next-line
    uint256 private constant gx =
        0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798;
    // solhint-disable-next-line
    uint256 private constant m = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;

    // mulVerify returns true if `Q = s * G` on the secp256k1 curve
    // qKeccak is defined as uint256(keccak256(abi.encodePacked(qx, qy))
    function mulVerify(uint256 scalar, uint256 qKeccak) public pure returns (bool) {
        address qRes = ecrecover(0, 27, bytes32(gx), bytes32(mulmod(scalar, gx, m)));
        return uint160(qKeccak) == uint160(qRes);
    }
}

// ethereum/contracts/@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol

// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata_0 is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// ethereum/contracts/IERC20Metadata.sol

/**
 * @title IERC20Metadata
 * @notice Interface for ERC20 tokens with metadata (decimals, name, symbol)
 */
interface IERC20Metadata_1 is IERC20 {
    function decimals() external view returns (uint8);
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
}

// ethereum/contracts/@openzeppelin/contracts/access/Ownable.sol

// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 */
abstract contract Ownable is Context {
    address private _owner;

    error OwnableUnauthorizedAccount(address account);
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// ethereum/contracts/@openzeppelin/contracts/token/ERC20/ERC20.sol

// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * The default value of {decimals} is 18. To change this, you should override
 * this function so it returns a different value.
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20, IERC20Metadata_0 {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the default value returned by this function, unless
     * it's overridden.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `from` to `to`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     */
    function _transfer(address from, address to, uint256 amount) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
            // decrementing then incrementing.
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        unchecked {
            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
            // Overflow not possible: amount <= accountBalance <= totalSupply.
            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
     *
     * Does not update the allowance amount in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Might emit an {Approval} event.
     */
    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
}

// ethereum/contracts/@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol

// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/utils/SafeERC20.sol)

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using Address for address;

    /**
     * @dev Transfer `value` amount of `token` from the calling contract to `to`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    /**
     * @dev Transfer `value` amount of `token` from `from` to `to`, spending the approval given by `from` to the
     * calling contract. If `token` returns no value, non-reverting calls are assumed to be successful.
     */
    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    /**
     * @dev Increase the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 oldAllowance = token.allowance(address(this), spender);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance + value));
    }

    /**
     * @dev Decrease the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance - value));
        }
    }

    /**
     * @dev Set the calling contract's allowance toward `spender` to `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful. Compatible with tokens that require the approval to be set to
     * 0 before setting it to a non-zero value.
     */
    function forceApprove(IERC20 token, address spender, uint256 value) internal {
        bytes memory approvalCall = abi.encodeWithSelector(token.approve.selector, spender, value);

        if (!_callOptionalReturnBool(token, approvalCall)) {
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));
            _callOptionalReturn(token, approvalCall);
        }
    }

    /**
     * @dev Use a ERC-2612 signature to set the `owner` approval toward `spender` on `token`.
     * Revert on invalid signature.
     */
    function safePermit(
        IERC20Permit token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        uint256 nonceBefore = token.nonces(owner);
        token.permit(owner, spender, value, deadline, v, r, s);
        uint256 nonceAfter = token.nonces(owner);
        require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        require(returndata.length == 0 || abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     *
     * This is a variant of {_callOptionalReturn} that silents catches all reverts and returns a bool instead.
     */
    function _callOptionalReturnBool(IERC20 token, bytes memory data) private returns (bool) {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We cannot use {Address-functionCall} here since this should return false
        // and not revert is the subcall reverts.

        (bool success, bytes memory returndata) = address(token).call(data);
        return
            success && (returndata.length == 0 || abi.decode(returndata, (bool))) && Address.isContract(address(token));
    }
}

// ethereum/contracts/wsXMR.sol

/**
 * @title wsXMR - Wrapped and Staked Monero
 * @notice ERC-20 token representing wrapped XMR backed by overcollateralized LP vaults
 * @dev Only the VaultManager contract can mint and burn tokens
 */
contract wsXMR is ERC20, Ownable {
    // Address of the VaultManager contract that can mint/burn
    address public vaultManager;

    // Events
    event VaultManagerUpdated(address indexed oldManager, address indexed newManager);

    // Errors
    error OnlyVaultManager();
    error ZeroAddress();

    /**
     * @notice Constructor initializes the token with name and symbol
     * @param _initialOwner Address that will own the contract initially
     */
    constructor(address _initialOwner) ERC20("Wrapsynth Monero", "wsXMR") Ownable(_initialOwner) {
        if (_initialOwner == address(0)) revert ZeroAddress();
    }

    /**
     * @notice Set the VaultManager contract address
     * @param _vaultManager Address of the VaultManager contract
     */
    function setVaultManager(address _vaultManager) external onlyOwner {
        if (_vaultManager == address(0)) revert ZeroAddress();
        address oldManager = vaultManager;
        vaultManager = _vaultManager;
        emit VaultManagerUpdated(oldManager, _vaultManager);
    }

    /**
     * @notice Mint new wsXMR tokens
     * @param _to Address to receive the minted tokens
     * @param _amount Amount of tokens to mint
     */
    function mint(address _to, uint256 _amount) external {
        if (msg.sender != vaultManager) revert OnlyVaultManager();
        _mint(_to, _amount);
    }

    /**
     * @notice Burn wsXMR tokens
     * @param _from Address to burn tokens from
     * @param _amount Amount of tokens to burn
     */
    function burn(address _from, uint256 _amount) external {
        if (msg.sender != vaultManager) revert OnlyVaultManager();
        _burn(_from, _amount);
    }

    /**
     * @notice Returns the number of decimals (8 to match XMR)
     */
    function decimals() public pure override returns (uint8) {
        return 8;
    }
}

// ethereum/contracts/VaultManager.sol

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
            (bool success, ) = payable(msg.sender).call{value: _amount}("");
            require(success, "ETH transfer failed");
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
        // Allow cancellation from PENDING (timeout) or READY (extended timeout)
        if (request.status != MintStatus.PENDING && request.status != MintStatus.READY) {
            revert InvalidStatus();
        }
        if (msg.sender != request.user) revert Unauthorized();
        
        // For READY state, require extended timeout (48h from initiation)
        uint256 requiredTimeout = request.status == MintStatus.READY 
            ? request.timeout + 24 hours 
            : request.timeout;
        
        if (block.timestamp < requiredTimeout) revert TimeoutNotReached();
        
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
        
        // Calculate the 120% collateral to escrow (matching liquidation ratio)
        // If LP fails, user gets 120% penalty. Excess stays with LP.
        uint256 collateralValue = getCollateralValueForDebt(_wsxmrAmount);
        uint256 collateralToEscrow = usdToCollateral(
            vault.collateralAsset,
            (collateralValue * LIQUIDATION_RATIO) / RATIO_PRECISION
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
            (bool success, ) = payable(request.user).call{value: request.escrowedCollateral}("");
            require(success, "ETH transfer failed");
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
            (bool success, ) = payable(msg.sender).call{value: collateralAmount}("");
            require(success, "ETH transfer failed");
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
        if (decimals > 18) {
            return uint256(price) / (10 ** (decimals - 18));
        }
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
        if (decimals > 18) {
            return uint256(price) / (10 ** (decimals - 18));
        }
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
        uint8 collateralDecimals = _collateralAsset == address(0) ? 18 : IERC20Metadata_1(_collateralAsset).decimals();
        
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
        uint8 decimals = _asset == address(0) ? 18 : IERC20Metadata_1(_asset).decimals();
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

