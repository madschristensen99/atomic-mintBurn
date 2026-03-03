// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package contracts

import (
	"errors"
	"math/big"
	"strings"

	ethereum "github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/event"
)

// Reference imports to suppress errors if they are not otherwise used.
var (
	_ = errors.New
	_ = big.NewInt
	_ = strings.NewReader
	_ = ethereum.NotFound
	_ = bind.Bind
	_ = common.Big1
	_ = types.BloomLookup
	_ = event.NewSubscription
	_ = abi.ConvertType
)

// WsXMRMetaData contains all meta data concerning the WsXMR contract.
var WsXMRMetaData = &bind.MetaData{
	ABI: "[{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_initialOwner\",\"type\":\"address\"}],\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"inputs\":[],\"name\":\"OnlyVaultManager\",\"type\":\"error\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"}],\"name\":\"OwnableInvalidOwner\",\"type\":\"error\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"}],\"name\":\"OwnableUnauthorizedAccount\",\"type\":\"error\"},{\"inputs\":[],\"name\":\"ZeroAddress\",\"type\":\"error\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"spender\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"value\",\"type\":\"uint256\"}],\"name\":\"Approval\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"previousOwner\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"newOwner\",\"type\":\"address\"}],\"name\":\"OwnershipTransferred\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"from\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"value\",\"type\":\"uint256\"}],\"name\":\"Transfer\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"oldManager\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"newManager\",\"type\":\"address\"}],\"name\":\"VaultManagerUpdated\",\"type\":\"event\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"spender\",\"type\":\"address\"}],\"name\":\"allowance\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"spender\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"approve\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"}],\"name\":\"balanceOf\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_from\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"_amount\",\"type\":\"uint256\"}],\"name\":\"burn\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"decimals\",\"outputs\":[{\"internalType\":\"uint8\",\"name\":\"\",\"type\":\"uint8\"}],\"stateMutability\":\"pure\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"spender\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"subtractedValue\",\"type\":\"uint256\"}],\"name\":\"decreaseAllowance\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"spender\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"addedValue\",\"type\":\"uint256\"}],\"name\":\"increaseAllowance\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_to\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"_amount\",\"type\":\"uint256\"}],\"name\":\"mint\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"name\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"owner\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"renounceOwnership\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_vaultManager\",\"type\":\"address\"}],\"name\":\"setVaultManager\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"symbol\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"totalSupply\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"transfer\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"from\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"transferFrom\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"newOwner\",\"type\":\"address\"}],\"name\":\"transferOwnership\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"vaultManager\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"}]",
	Bin: "0x60806040523480156200001157600080fd5b50604051620010093803806200100983398101604081905262000034916200015b565b806040518060400160405280601081526020016f5772617073796e7468204d6f6e65726f60801b815250604051806040016040528060058152602001643bb9ac26a960d91b81525081600390816200008d919062000232565b5060046200009c828262000232565b5050506001600160a01b038116620000ce57604051631e4fbdf760e01b81526000600482015260240160405180910390fd5b620000d98162000109565b506001600160a01b038116620001025760405163d92e233d60e01b815260040160405180910390fd5b50620002fe565b600580546001600160a01b038381166001600160a01b0319831681179093556040519116919082907f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e090600090a35050565b6000602082840312156200016e57600080fd5b81516001600160a01b03811681146200018657600080fd5b9392505050565b634e487b7160e01b600052604160045260246000fd5b600181811c90821680620001b857607f821691505b602082108103620001d957634e487b7160e01b600052602260045260246000fd5b50919050565b601f8211156200022d57600081815260208120601f850160051c81016020861015620002085750805b601f850160051c820191505b81811015620002295782815560010162000214565b5050505b505050565b81516001600160401b038111156200024e576200024e6200018d565b62000266816200025f8454620001a3565b84620001df565b602080601f8311600181146200029e5760008415620002855750858301515b600019600386901b1c1916600185901b17855562000229565b600085815260208120601f198616915b82811015620002cf57888601518255948401946001909101908401620002ae565b5085821015620002ee5787850151600019600388901b60f8161c191681555b5050505050600190811b01905550565b610cfb806200030e6000396000f3fe608060405234801561001057600080fd5b50600436106101165760003560e01c80638a4adf24116100a2578063a457c2d711610071578063a457c2d714610240578063a9059cbb14610253578063b543503e14610266578063dd62ed3e14610279578063f2fde38b1461028c57600080fd5b80638a4adf24146101e95780638da5cb5b1461021457806395d89b41146102255780639dc29fac1461022d57600080fd5b8063313ce567116100e9578063313ce56714610181578063395093511461019057806340c10f19146101a357806370a08231146101b8578063715018a6146101e157600080fd5b806306fdde031461011b578063095ea7b31461013957806318160ddd1461015c57806323b872dd1461016e575b600080fd5b61012361029f565b6040516101309190610b45565b60405180910390f35b61014c610147366004610baf565b610331565b6040519015158152602001610130565b6002545b604051908152602001610130565b61014c61017c366004610bd9565b61034b565b60405160088152602001610130565b61014c61019e366004610baf565b61036f565b6101b66101b1366004610baf565b610391565b005b6101606101c6366004610c15565b6001600160a01b031660009081526020819052604090205490565b6101b66103ca565b6006546101fc906001600160a01b031681565b6040516001600160a01b039091168152602001610130565b6005546001600160a01b03166101fc565b6101236103de565b6101b661023b366004610baf565b6103ed565b61014c61024e366004610baf565b610422565b61014c610261366004610baf565b6104a2565b6101b6610274366004610c15565b6104b0565b610160610287366004610c37565b610531565b6101b661029a366004610c15565b61055c565b6060600380546102ae90610c6a565b80601f01602080910402602001604051908101604052809291908181526020018280546102da90610c6a565b80156103275780601f106102fc57610100808354040283529160200191610327565b820191906000526020600020905b81548152906001019060200180831161030a57829003601f168201915b5050505050905090565b60003361033f81858561059a565b60019150505b92915050565b6000336103598582856106bf565b610364858585610739565b506001949350505050565b60003361033f8185856103828383610531565b61038c9190610ca4565b61059a565b6006546001600160a01b031633146103bc5760405163612bde3d60e01b815260040160405180910390fd5b6103c682826108dd565b5050565b6103d261099c565b6103dc60006109c9565b565b6060600480546102ae90610c6a565b6006546001600160a01b031633146104185760405163612bde3d60e01b815260040160405180910390fd5b6103c68282610a1b565b600033816104308286610531565b9050838110156104955760405162461bcd60e51b815260206004820152602560248201527f45524332303a2064656372656173656420616c6c6f77616e63652062656c6f77604482015264207a65726f60d81b60648201526084015b60405180910390fd5b610364828686840361059a565b60003361033f818585610739565b6104b861099c565b6001600160a01b0381166104df5760405163d92e233d60e01b815260040160405180910390fd5b600680546001600160a01b038381166001600160a01b0319831681179093556040519116919082907f8cfaacab0869ad5307d9175b1a62164d7c9630958cbbc7bc9918133cd6fbb02d90600090a35050565b6001600160a01b03918216600090815260016020908152604080832093909416825291909152205490565b61056461099c565b6001600160a01b03811661058e57604051631e4fbdf760e01b81526000600482015260240161048c565b610597816109c9565b50565b6001600160a01b0383166105fc5760405162461bcd60e51b8152602060048201526024808201527f45524332303a20617070726f76652066726f6d20746865207a65726f206164646044820152637265737360e01b606482015260840161048c565b6001600160a01b03821661065d5760405162461bcd60e51b815260206004820152602260248201527f45524332303a20617070726f766520746f20746865207a65726f206164647265604482015261737360f01b606482015260840161048c565b6001600160a01b0383811660008181526001602090815260408083209487168084529482529182902085905590518481527f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b92591015b60405180910390a3505050565b60006106cb8484610531565b9050600019811461073357818110156107265760405162461bcd60e51b815260206004820152601d60248201527f45524332303a20696e73756666696369656e7420616c6c6f77616e6365000000604482015260640161048c565b610733848484840361059a565b50505050565b6001600160a01b03831661079d5760405162461bcd60e51b815260206004820152602560248201527f45524332303a207472616e736665722066726f6d20746865207a65726f206164604482015264647265737360d81b606482015260840161048c565b6001600160a01b0382166107ff5760405162461bcd60e51b815260206004820152602360248201527f45524332303a207472616e7366657220746f20746865207a65726f206164647260448201526265737360e81b606482015260840161048c565b6001600160a01b038316600090815260208190526040902054818110156108775760405162461bcd60e51b815260206004820152602660248201527f45524332303a207472616e7366657220616d6f756e7420657863656564732062604482015265616c616e636560d01b606482015260840161048c565b6001600160a01b03848116600081815260208181526040808320878703905593871680835291849020805487019055925185815290927fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef910160405180910390a3610733565b6001600160a01b0382166109335760405162461bcd60e51b815260206004820152601f60248201527f45524332303a206d696e7420746f20746865207a65726f206164647265737300604482015260640161048c565b80600260008282546109459190610ca4565b90915550506001600160a01b038216600081815260208181526040808320805486019055518481527fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef910160405180910390a35050565b6005546001600160a01b031633146103dc5760405163118cdaa760e01b815233600482015260240161048c565b600580546001600160a01b038381166001600160a01b0319831681179093556040519116919082907f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e090600090a35050565b6001600160a01b038216610a7b5760405162461bcd60e51b815260206004820152602160248201527f45524332303a206275726e2066726f6d20746865207a65726f206164647265736044820152607360f81b606482015260840161048c565b6001600160a01b03821660009081526020819052604090205481811015610aef5760405162461bcd60e51b815260206004820152602260248201527f45524332303a206275726e20616d6f756e7420657863656564732062616c616e604482015261636560f01b606482015260840161048c565b6001600160a01b0383166000818152602081815260408083208686039055600280548790039055518581529192917fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef91016106b2565b600060208083528351808285015260005b81811015610b7257858101830151858201604001528201610b56565b506000604082860101526040601f19601f8301168501019250505092915050565b80356001600160a01b0381168114610baa57600080fd5b919050565b60008060408385031215610bc257600080fd5b610bcb83610b93565b946020939093013593505050565b600080600060608486031215610bee57600080fd5b610bf784610b93565b9250610c0560208501610b93565b9150604084013590509250925092565b600060208284031215610c2757600080fd5b610c3082610b93565b9392505050565b60008060408385031215610c4a57600080fd5b610c5383610b93565b9150610c6160208401610b93565b90509250929050565b600181811c90821680610c7e57607f821691505b602082108103610c9e57634e487b7160e01b600052602260045260246000fd5b50919050565b8082018082111561034557634e487b7160e01b600052601160045260246000fdfea264697066735822122059b4d7bc94b70ddf5c7ce5ab16ae6840733f6dc05dff51262a428d8e450af05764736f6c63430008130033",
}

// WsXMRABI is the input ABI used to generate the binding from.
// Deprecated: Use WsXMRMetaData.ABI instead.
var WsXMRABI = WsXMRMetaData.ABI

// WsXMRBin is the compiled bytecode used for deploying new contracts.
// Deprecated: Use WsXMRMetaData.Bin instead.
var WsXMRBin = WsXMRMetaData.Bin

// DeployWsXMR deploys a new Ethereum contract, binding an instance of WsXMR to it.
func DeployWsXMR(auth *bind.TransactOpts, backend bind.ContractBackend, _initialOwner common.Address) (common.Address, *types.Transaction, *WsXMR, error) {
	parsed, err := WsXMRMetaData.GetAbi()
	if err != nil {
		return common.Address{}, nil, nil, err
	}
	if parsed == nil {
		return common.Address{}, nil, nil, errors.New("GetABI returned nil")
	}

	address, tx, contract, err := bind.DeployContract(auth, *parsed, common.FromHex(WsXMRBin), backend, _initialOwner)
	if err != nil {
		return common.Address{}, nil, nil, err
	}
	return address, tx, &WsXMR{WsXMRCaller: WsXMRCaller{contract: contract}, WsXMRTransactor: WsXMRTransactor{contract: contract}, WsXMRFilterer: WsXMRFilterer{contract: contract}}, nil
}

// WsXMR is an auto generated Go binding around an Ethereum contract.
type WsXMR struct {
	WsXMRCaller     // Read-only binding to the contract
	WsXMRTransactor // Write-only binding to the contract
	WsXMRFilterer   // Log filterer for contract events
}

// WsXMRCaller is an auto generated read-only Go binding around an Ethereum contract.
type WsXMRCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// WsXMRTransactor is an auto generated write-only Go binding around an Ethereum contract.
type WsXMRTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// WsXMRFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type WsXMRFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// WsXMRSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type WsXMRSession struct {
	Contract     *WsXMR            // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// WsXMRCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type WsXMRCallerSession struct {
	Contract *WsXMRCaller  // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts // Call options to use throughout this session
}

// WsXMRTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type WsXMRTransactorSession struct {
	Contract     *WsXMRTransactor  // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// WsXMRRaw is an auto generated low-level Go binding around an Ethereum contract.
type WsXMRRaw struct {
	Contract *WsXMR // Generic contract binding to access the raw methods on
}

// WsXMRCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type WsXMRCallerRaw struct {
	Contract *WsXMRCaller // Generic read-only contract binding to access the raw methods on
}

// WsXMRTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type WsXMRTransactorRaw struct {
	Contract *WsXMRTransactor // Generic write-only contract binding to access the raw methods on
}

// NewWsXMR creates a new instance of WsXMR, bound to a specific deployed contract.
func NewWsXMR(address common.Address, backend bind.ContractBackend) (*WsXMR, error) {
	contract, err := bindWsXMR(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &WsXMR{WsXMRCaller: WsXMRCaller{contract: contract}, WsXMRTransactor: WsXMRTransactor{contract: contract}, WsXMRFilterer: WsXMRFilterer{contract: contract}}, nil
}

// NewWsXMRCaller creates a new read-only instance of WsXMR, bound to a specific deployed contract.
func NewWsXMRCaller(address common.Address, caller bind.ContractCaller) (*WsXMRCaller, error) {
	contract, err := bindWsXMR(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &WsXMRCaller{contract: contract}, nil
}

// NewWsXMRTransactor creates a new write-only instance of WsXMR, bound to a specific deployed contract.
func NewWsXMRTransactor(address common.Address, transactor bind.ContractTransactor) (*WsXMRTransactor, error) {
	contract, err := bindWsXMR(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &WsXMRTransactor{contract: contract}, nil
}

// NewWsXMRFilterer creates a new log filterer instance of WsXMR, bound to a specific deployed contract.
func NewWsXMRFilterer(address common.Address, filterer bind.ContractFilterer) (*WsXMRFilterer, error) {
	contract, err := bindWsXMR(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &WsXMRFilterer{contract: contract}, nil
}

// bindWsXMR binds a generic wrapper to an already deployed contract.
func bindWsXMR(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := WsXMRMetaData.GetAbi()
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, *parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_WsXMR *WsXMRRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _WsXMR.Contract.WsXMRCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_WsXMR *WsXMRRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _WsXMR.Contract.WsXMRTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_WsXMR *WsXMRRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _WsXMR.Contract.WsXMRTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_WsXMR *WsXMRCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _WsXMR.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_WsXMR *WsXMRTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _WsXMR.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_WsXMR *WsXMRTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _WsXMR.Contract.contract.Transact(opts, method, params...)
}

// Allowance is a free data retrieval call binding the contract method 0xdd62ed3e.
//
// Solidity: function allowance(address owner, address spender) view returns(uint256)
func (_WsXMR *WsXMRCaller) Allowance(opts *bind.CallOpts, owner common.Address, spender common.Address) (*big.Int, error) {
	var out []interface{}
	err := _WsXMR.contract.Call(opts, &out, "allowance", owner, spender)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// Allowance is a free data retrieval call binding the contract method 0xdd62ed3e.
//
// Solidity: function allowance(address owner, address spender) view returns(uint256)
func (_WsXMR *WsXMRSession) Allowance(owner common.Address, spender common.Address) (*big.Int, error) {
	return _WsXMR.Contract.Allowance(&_WsXMR.CallOpts, owner, spender)
}

// Allowance is a free data retrieval call binding the contract method 0xdd62ed3e.
//
// Solidity: function allowance(address owner, address spender) view returns(uint256)
func (_WsXMR *WsXMRCallerSession) Allowance(owner common.Address, spender common.Address) (*big.Int, error) {
	return _WsXMR.Contract.Allowance(&_WsXMR.CallOpts, owner, spender)
}

// BalanceOf is a free data retrieval call binding the contract method 0x70a08231.
//
// Solidity: function balanceOf(address account) view returns(uint256)
func (_WsXMR *WsXMRCaller) BalanceOf(opts *bind.CallOpts, account common.Address) (*big.Int, error) {
	var out []interface{}
	err := _WsXMR.contract.Call(opts, &out, "balanceOf", account)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// BalanceOf is a free data retrieval call binding the contract method 0x70a08231.
//
// Solidity: function balanceOf(address account) view returns(uint256)
func (_WsXMR *WsXMRSession) BalanceOf(account common.Address) (*big.Int, error) {
	return _WsXMR.Contract.BalanceOf(&_WsXMR.CallOpts, account)
}

// BalanceOf is a free data retrieval call binding the contract method 0x70a08231.
//
// Solidity: function balanceOf(address account) view returns(uint256)
func (_WsXMR *WsXMRCallerSession) BalanceOf(account common.Address) (*big.Int, error) {
	return _WsXMR.Contract.BalanceOf(&_WsXMR.CallOpts, account)
}

// Decimals is a free data retrieval call binding the contract method 0x313ce567.
//
// Solidity: function decimals() pure returns(uint8)
func (_WsXMR *WsXMRCaller) Decimals(opts *bind.CallOpts) (uint8, error) {
	var out []interface{}
	err := _WsXMR.contract.Call(opts, &out, "decimals")

	if err != nil {
		return *new(uint8), err
	}

	out0 := *abi.ConvertType(out[0], new(uint8)).(*uint8)

	return out0, err

}

// Decimals is a free data retrieval call binding the contract method 0x313ce567.
//
// Solidity: function decimals() pure returns(uint8)
func (_WsXMR *WsXMRSession) Decimals() (uint8, error) {
	return _WsXMR.Contract.Decimals(&_WsXMR.CallOpts)
}

// Decimals is a free data retrieval call binding the contract method 0x313ce567.
//
// Solidity: function decimals() pure returns(uint8)
func (_WsXMR *WsXMRCallerSession) Decimals() (uint8, error) {
	return _WsXMR.Contract.Decimals(&_WsXMR.CallOpts)
}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() view returns(string)
func (_WsXMR *WsXMRCaller) Name(opts *bind.CallOpts) (string, error) {
	var out []interface{}
	err := _WsXMR.contract.Call(opts, &out, "name")

	if err != nil {
		return *new(string), err
	}

	out0 := *abi.ConvertType(out[0], new(string)).(*string)

	return out0, err

}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() view returns(string)
func (_WsXMR *WsXMRSession) Name() (string, error) {
	return _WsXMR.Contract.Name(&_WsXMR.CallOpts)
}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() view returns(string)
func (_WsXMR *WsXMRCallerSession) Name() (string, error) {
	return _WsXMR.Contract.Name(&_WsXMR.CallOpts)
}

// Owner is a free data retrieval call binding the contract method 0x8da5cb5b.
//
// Solidity: function owner() view returns(address)
func (_WsXMR *WsXMRCaller) Owner(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _WsXMR.contract.Call(opts, &out, "owner")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Owner is a free data retrieval call binding the contract method 0x8da5cb5b.
//
// Solidity: function owner() view returns(address)
func (_WsXMR *WsXMRSession) Owner() (common.Address, error) {
	return _WsXMR.Contract.Owner(&_WsXMR.CallOpts)
}

// Owner is a free data retrieval call binding the contract method 0x8da5cb5b.
//
// Solidity: function owner() view returns(address)
func (_WsXMR *WsXMRCallerSession) Owner() (common.Address, error) {
	return _WsXMR.Contract.Owner(&_WsXMR.CallOpts)
}

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() view returns(string)
func (_WsXMR *WsXMRCaller) Symbol(opts *bind.CallOpts) (string, error) {
	var out []interface{}
	err := _WsXMR.contract.Call(opts, &out, "symbol")

	if err != nil {
		return *new(string), err
	}

	out0 := *abi.ConvertType(out[0], new(string)).(*string)

	return out0, err

}

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() view returns(string)
func (_WsXMR *WsXMRSession) Symbol() (string, error) {
	return _WsXMR.Contract.Symbol(&_WsXMR.CallOpts)
}

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() view returns(string)
func (_WsXMR *WsXMRCallerSession) Symbol() (string, error) {
	return _WsXMR.Contract.Symbol(&_WsXMR.CallOpts)
}

// TotalSupply is a free data retrieval call binding the contract method 0x18160ddd.
//
// Solidity: function totalSupply() view returns(uint256)
func (_WsXMR *WsXMRCaller) TotalSupply(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _WsXMR.contract.Call(opts, &out, "totalSupply")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// TotalSupply is a free data retrieval call binding the contract method 0x18160ddd.
//
// Solidity: function totalSupply() view returns(uint256)
func (_WsXMR *WsXMRSession) TotalSupply() (*big.Int, error) {
	return _WsXMR.Contract.TotalSupply(&_WsXMR.CallOpts)
}

// TotalSupply is a free data retrieval call binding the contract method 0x18160ddd.
//
// Solidity: function totalSupply() view returns(uint256)
func (_WsXMR *WsXMRCallerSession) TotalSupply() (*big.Int, error) {
	return _WsXMR.Contract.TotalSupply(&_WsXMR.CallOpts)
}

// VaultManager is a free data retrieval call binding the contract method 0x8a4adf24.
//
// Solidity: function vaultManager() view returns(address)
func (_WsXMR *WsXMRCaller) VaultManager(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _WsXMR.contract.Call(opts, &out, "vaultManager")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// VaultManager is a free data retrieval call binding the contract method 0x8a4adf24.
//
// Solidity: function vaultManager() view returns(address)
func (_WsXMR *WsXMRSession) VaultManager() (common.Address, error) {
	return _WsXMR.Contract.VaultManager(&_WsXMR.CallOpts)
}

// VaultManager is a free data retrieval call binding the contract method 0x8a4adf24.
//
// Solidity: function vaultManager() view returns(address)
func (_WsXMR *WsXMRCallerSession) VaultManager() (common.Address, error) {
	return _WsXMR.Contract.VaultManager(&_WsXMR.CallOpts)
}

// Approve is a paid mutator transaction binding the contract method 0x095ea7b3.
//
// Solidity: function approve(address spender, uint256 amount) returns(bool)
func (_WsXMR *WsXMRTransactor) Approve(opts *bind.TransactOpts, spender common.Address, amount *big.Int) (*types.Transaction, error) {
	return _WsXMR.contract.Transact(opts, "approve", spender, amount)
}

// Approve is a paid mutator transaction binding the contract method 0x095ea7b3.
//
// Solidity: function approve(address spender, uint256 amount) returns(bool)
func (_WsXMR *WsXMRSession) Approve(spender common.Address, amount *big.Int) (*types.Transaction, error) {
	return _WsXMR.Contract.Approve(&_WsXMR.TransactOpts, spender, amount)
}

// Approve is a paid mutator transaction binding the contract method 0x095ea7b3.
//
// Solidity: function approve(address spender, uint256 amount) returns(bool)
func (_WsXMR *WsXMRTransactorSession) Approve(spender common.Address, amount *big.Int) (*types.Transaction, error) {
	return _WsXMR.Contract.Approve(&_WsXMR.TransactOpts, spender, amount)
}

// Burn is a paid mutator transaction binding the contract method 0x9dc29fac.
//
// Solidity: function burn(address _from, uint256 _amount) returns()
func (_WsXMR *WsXMRTransactor) Burn(opts *bind.TransactOpts, _from common.Address, _amount *big.Int) (*types.Transaction, error) {
	return _WsXMR.contract.Transact(opts, "burn", _from, _amount)
}

// Burn is a paid mutator transaction binding the contract method 0x9dc29fac.
//
// Solidity: function burn(address _from, uint256 _amount) returns()
func (_WsXMR *WsXMRSession) Burn(_from common.Address, _amount *big.Int) (*types.Transaction, error) {
	return _WsXMR.Contract.Burn(&_WsXMR.TransactOpts, _from, _amount)
}

// Burn is a paid mutator transaction binding the contract method 0x9dc29fac.
//
// Solidity: function burn(address _from, uint256 _amount) returns()
func (_WsXMR *WsXMRTransactorSession) Burn(_from common.Address, _amount *big.Int) (*types.Transaction, error) {
	return _WsXMR.Contract.Burn(&_WsXMR.TransactOpts, _from, _amount)
}

// DecreaseAllowance is a paid mutator transaction binding the contract method 0xa457c2d7.
//
// Solidity: function decreaseAllowance(address spender, uint256 subtractedValue) returns(bool)
func (_WsXMR *WsXMRTransactor) DecreaseAllowance(opts *bind.TransactOpts, spender common.Address, subtractedValue *big.Int) (*types.Transaction, error) {
	return _WsXMR.contract.Transact(opts, "decreaseAllowance", spender, subtractedValue)
}

// DecreaseAllowance is a paid mutator transaction binding the contract method 0xa457c2d7.
//
// Solidity: function decreaseAllowance(address spender, uint256 subtractedValue) returns(bool)
func (_WsXMR *WsXMRSession) DecreaseAllowance(spender common.Address, subtractedValue *big.Int) (*types.Transaction, error) {
	return _WsXMR.Contract.DecreaseAllowance(&_WsXMR.TransactOpts, spender, subtractedValue)
}

// DecreaseAllowance is a paid mutator transaction binding the contract method 0xa457c2d7.
//
// Solidity: function decreaseAllowance(address spender, uint256 subtractedValue) returns(bool)
func (_WsXMR *WsXMRTransactorSession) DecreaseAllowance(spender common.Address, subtractedValue *big.Int) (*types.Transaction, error) {
	return _WsXMR.Contract.DecreaseAllowance(&_WsXMR.TransactOpts, spender, subtractedValue)
}

// IncreaseAllowance is a paid mutator transaction binding the contract method 0x39509351.
//
// Solidity: function increaseAllowance(address spender, uint256 addedValue) returns(bool)
func (_WsXMR *WsXMRTransactor) IncreaseAllowance(opts *bind.TransactOpts, spender common.Address, addedValue *big.Int) (*types.Transaction, error) {
	return _WsXMR.contract.Transact(opts, "increaseAllowance", spender, addedValue)
}

// IncreaseAllowance is a paid mutator transaction binding the contract method 0x39509351.
//
// Solidity: function increaseAllowance(address spender, uint256 addedValue) returns(bool)
func (_WsXMR *WsXMRSession) IncreaseAllowance(spender common.Address, addedValue *big.Int) (*types.Transaction, error) {
	return _WsXMR.Contract.IncreaseAllowance(&_WsXMR.TransactOpts, spender, addedValue)
}

// IncreaseAllowance is a paid mutator transaction binding the contract method 0x39509351.
//
// Solidity: function increaseAllowance(address spender, uint256 addedValue) returns(bool)
func (_WsXMR *WsXMRTransactorSession) IncreaseAllowance(spender common.Address, addedValue *big.Int) (*types.Transaction, error) {
	return _WsXMR.Contract.IncreaseAllowance(&_WsXMR.TransactOpts, spender, addedValue)
}

// Mint is a paid mutator transaction binding the contract method 0x40c10f19.
//
// Solidity: function mint(address _to, uint256 _amount) returns()
func (_WsXMR *WsXMRTransactor) Mint(opts *bind.TransactOpts, _to common.Address, _amount *big.Int) (*types.Transaction, error) {
	return _WsXMR.contract.Transact(opts, "mint", _to, _amount)
}

// Mint is a paid mutator transaction binding the contract method 0x40c10f19.
//
// Solidity: function mint(address _to, uint256 _amount) returns()
func (_WsXMR *WsXMRSession) Mint(_to common.Address, _amount *big.Int) (*types.Transaction, error) {
	return _WsXMR.Contract.Mint(&_WsXMR.TransactOpts, _to, _amount)
}

// Mint is a paid mutator transaction binding the contract method 0x40c10f19.
//
// Solidity: function mint(address _to, uint256 _amount) returns()
func (_WsXMR *WsXMRTransactorSession) Mint(_to common.Address, _amount *big.Int) (*types.Transaction, error) {
	return _WsXMR.Contract.Mint(&_WsXMR.TransactOpts, _to, _amount)
}

// RenounceOwnership is a paid mutator transaction binding the contract method 0x715018a6.
//
// Solidity: function renounceOwnership() returns()
func (_WsXMR *WsXMRTransactor) RenounceOwnership(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _WsXMR.contract.Transact(opts, "renounceOwnership")
}

// RenounceOwnership is a paid mutator transaction binding the contract method 0x715018a6.
//
// Solidity: function renounceOwnership() returns()
func (_WsXMR *WsXMRSession) RenounceOwnership() (*types.Transaction, error) {
	return _WsXMR.Contract.RenounceOwnership(&_WsXMR.TransactOpts)
}

// RenounceOwnership is a paid mutator transaction binding the contract method 0x715018a6.
//
// Solidity: function renounceOwnership() returns()
func (_WsXMR *WsXMRTransactorSession) RenounceOwnership() (*types.Transaction, error) {
	return _WsXMR.Contract.RenounceOwnership(&_WsXMR.TransactOpts)
}

// SetVaultManager is a paid mutator transaction binding the contract method 0xb543503e.
//
// Solidity: function setVaultManager(address _vaultManager) returns()
func (_WsXMR *WsXMRTransactor) SetVaultManager(opts *bind.TransactOpts, _vaultManager common.Address) (*types.Transaction, error) {
	return _WsXMR.contract.Transact(opts, "setVaultManager", _vaultManager)
}

// SetVaultManager is a paid mutator transaction binding the contract method 0xb543503e.
//
// Solidity: function setVaultManager(address _vaultManager) returns()
func (_WsXMR *WsXMRSession) SetVaultManager(_vaultManager common.Address) (*types.Transaction, error) {
	return _WsXMR.Contract.SetVaultManager(&_WsXMR.TransactOpts, _vaultManager)
}

// SetVaultManager is a paid mutator transaction binding the contract method 0xb543503e.
//
// Solidity: function setVaultManager(address _vaultManager) returns()
func (_WsXMR *WsXMRTransactorSession) SetVaultManager(_vaultManager common.Address) (*types.Transaction, error) {
	return _WsXMR.Contract.SetVaultManager(&_WsXMR.TransactOpts, _vaultManager)
}

// Transfer is a paid mutator transaction binding the contract method 0xa9059cbb.
//
// Solidity: function transfer(address to, uint256 amount) returns(bool)
func (_WsXMR *WsXMRTransactor) Transfer(opts *bind.TransactOpts, to common.Address, amount *big.Int) (*types.Transaction, error) {
	return _WsXMR.contract.Transact(opts, "transfer", to, amount)
}

// Transfer is a paid mutator transaction binding the contract method 0xa9059cbb.
//
// Solidity: function transfer(address to, uint256 amount) returns(bool)
func (_WsXMR *WsXMRSession) Transfer(to common.Address, amount *big.Int) (*types.Transaction, error) {
	return _WsXMR.Contract.Transfer(&_WsXMR.TransactOpts, to, amount)
}

// Transfer is a paid mutator transaction binding the contract method 0xa9059cbb.
//
// Solidity: function transfer(address to, uint256 amount) returns(bool)
func (_WsXMR *WsXMRTransactorSession) Transfer(to common.Address, amount *big.Int) (*types.Transaction, error) {
	return _WsXMR.Contract.Transfer(&_WsXMR.TransactOpts, to, amount)
}

// TransferFrom is a paid mutator transaction binding the contract method 0x23b872dd.
//
// Solidity: function transferFrom(address from, address to, uint256 amount) returns(bool)
func (_WsXMR *WsXMRTransactor) TransferFrom(opts *bind.TransactOpts, from common.Address, to common.Address, amount *big.Int) (*types.Transaction, error) {
	return _WsXMR.contract.Transact(opts, "transferFrom", from, to, amount)
}

// TransferFrom is a paid mutator transaction binding the contract method 0x23b872dd.
//
// Solidity: function transferFrom(address from, address to, uint256 amount) returns(bool)
func (_WsXMR *WsXMRSession) TransferFrom(from common.Address, to common.Address, amount *big.Int) (*types.Transaction, error) {
	return _WsXMR.Contract.TransferFrom(&_WsXMR.TransactOpts, from, to, amount)
}

// TransferFrom is a paid mutator transaction binding the contract method 0x23b872dd.
//
// Solidity: function transferFrom(address from, address to, uint256 amount) returns(bool)
func (_WsXMR *WsXMRTransactorSession) TransferFrom(from common.Address, to common.Address, amount *big.Int) (*types.Transaction, error) {
	return _WsXMR.Contract.TransferFrom(&_WsXMR.TransactOpts, from, to, amount)
}

// TransferOwnership is a paid mutator transaction binding the contract method 0xf2fde38b.
//
// Solidity: function transferOwnership(address newOwner) returns()
func (_WsXMR *WsXMRTransactor) TransferOwnership(opts *bind.TransactOpts, newOwner common.Address) (*types.Transaction, error) {
	return _WsXMR.contract.Transact(opts, "transferOwnership", newOwner)
}

// TransferOwnership is a paid mutator transaction binding the contract method 0xf2fde38b.
//
// Solidity: function transferOwnership(address newOwner) returns()
func (_WsXMR *WsXMRSession) TransferOwnership(newOwner common.Address) (*types.Transaction, error) {
	return _WsXMR.Contract.TransferOwnership(&_WsXMR.TransactOpts, newOwner)
}

// TransferOwnership is a paid mutator transaction binding the contract method 0xf2fde38b.
//
// Solidity: function transferOwnership(address newOwner) returns()
func (_WsXMR *WsXMRTransactorSession) TransferOwnership(newOwner common.Address) (*types.Transaction, error) {
	return _WsXMR.Contract.TransferOwnership(&_WsXMR.TransactOpts, newOwner)
}

// WsXMRApprovalIterator is returned from FilterApproval and is used to iterate over the raw logs and unpacked data for Approval events raised by the WsXMR contract.
type WsXMRApprovalIterator struct {
	Event *WsXMRApproval // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *WsXMRApprovalIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(WsXMRApproval)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(WsXMRApproval)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *WsXMRApprovalIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *WsXMRApprovalIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// WsXMRApproval represents a Approval event raised by the WsXMR contract.
type WsXMRApproval struct {
	Owner   common.Address
	Spender common.Address
	Value   *big.Int
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterApproval is a free log retrieval operation binding the contract event 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925.
//
// Solidity: event Approval(address indexed owner, address indexed spender, uint256 value)
func (_WsXMR *WsXMRFilterer) FilterApproval(opts *bind.FilterOpts, owner []common.Address, spender []common.Address) (*WsXMRApprovalIterator, error) {

	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}
	var spenderRule []interface{}
	for _, spenderItem := range spender {
		spenderRule = append(spenderRule, spenderItem)
	}

	logs, sub, err := _WsXMR.contract.FilterLogs(opts, "Approval", ownerRule, spenderRule)
	if err != nil {
		return nil, err
	}
	return &WsXMRApprovalIterator{contract: _WsXMR.contract, event: "Approval", logs: logs, sub: sub}, nil
}

// WatchApproval is a free log subscription operation binding the contract event 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925.
//
// Solidity: event Approval(address indexed owner, address indexed spender, uint256 value)
func (_WsXMR *WsXMRFilterer) WatchApproval(opts *bind.WatchOpts, sink chan<- *WsXMRApproval, owner []common.Address, spender []common.Address) (event.Subscription, error) {

	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}
	var spenderRule []interface{}
	for _, spenderItem := range spender {
		spenderRule = append(spenderRule, spenderItem)
	}

	logs, sub, err := _WsXMR.contract.WatchLogs(opts, "Approval", ownerRule, spenderRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(WsXMRApproval)
				if err := _WsXMR.contract.UnpackLog(event, "Approval", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseApproval is a log parse operation binding the contract event 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925.
//
// Solidity: event Approval(address indexed owner, address indexed spender, uint256 value)
func (_WsXMR *WsXMRFilterer) ParseApproval(log types.Log) (*WsXMRApproval, error) {
	event := new(WsXMRApproval)
	if err := _WsXMR.contract.UnpackLog(event, "Approval", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// WsXMROwnershipTransferredIterator is returned from FilterOwnershipTransferred and is used to iterate over the raw logs and unpacked data for OwnershipTransferred events raised by the WsXMR contract.
type WsXMROwnershipTransferredIterator struct {
	Event *WsXMROwnershipTransferred // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *WsXMROwnershipTransferredIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(WsXMROwnershipTransferred)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(WsXMROwnershipTransferred)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *WsXMROwnershipTransferredIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *WsXMROwnershipTransferredIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// WsXMROwnershipTransferred represents a OwnershipTransferred event raised by the WsXMR contract.
type WsXMROwnershipTransferred struct {
	PreviousOwner common.Address
	NewOwner      common.Address
	Raw           types.Log // Blockchain specific contextual infos
}

// FilterOwnershipTransferred is a free log retrieval operation binding the contract event 0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0.
//
// Solidity: event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)
func (_WsXMR *WsXMRFilterer) FilterOwnershipTransferred(opts *bind.FilterOpts, previousOwner []common.Address, newOwner []common.Address) (*WsXMROwnershipTransferredIterator, error) {

	var previousOwnerRule []interface{}
	for _, previousOwnerItem := range previousOwner {
		previousOwnerRule = append(previousOwnerRule, previousOwnerItem)
	}
	var newOwnerRule []interface{}
	for _, newOwnerItem := range newOwner {
		newOwnerRule = append(newOwnerRule, newOwnerItem)
	}

	logs, sub, err := _WsXMR.contract.FilterLogs(opts, "OwnershipTransferred", previousOwnerRule, newOwnerRule)
	if err != nil {
		return nil, err
	}
	return &WsXMROwnershipTransferredIterator{contract: _WsXMR.contract, event: "OwnershipTransferred", logs: logs, sub: sub}, nil
}

// WatchOwnershipTransferred is a free log subscription operation binding the contract event 0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0.
//
// Solidity: event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)
func (_WsXMR *WsXMRFilterer) WatchOwnershipTransferred(opts *bind.WatchOpts, sink chan<- *WsXMROwnershipTransferred, previousOwner []common.Address, newOwner []common.Address) (event.Subscription, error) {

	var previousOwnerRule []interface{}
	for _, previousOwnerItem := range previousOwner {
		previousOwnerRule = append(previousOwnerRule, previousOwnerItem)
	}
	var newOwnerRule []interface{}
	for _, newOwnerItem := range newOwner {
		newOwnerRule = append(newOwnerRule, newOwnerItem)
	}

	logs, sub, err := _WsXMR.contract.WatchLogs(opts, "OwnershipTransferred", previousOwnerRule, newOwnerRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(WsXMROwnershipTransferred)
				if err := _WsXMR.contract.UnpackLog(event, "OwnershipTransferred", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseOwnershipTransferred is a log parse operation binding the contract event 0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0.
//
// Solidity: event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)
func (_WsXMR *WsXMRFilterer) ParseOwnershipTransferred(log types.Log) (*WsXMROwnershipTransferred, error) {
	event := new(WsXMROwnershipTransferred)
	if err := _WsXMR.contract.UnpackLog(event, "OwnershipTransferred", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// WsXMRTransferIterator is returned from FilterTransfer and is used to iterate over the raw logs and unpacked data for Transfer events raised by the WsXMR contract.
type WsXMRTransferIterator struct {
	Event *WsXMRTransfer // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *WsXMRTransferIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(WsXMRTransfer)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(WsXMRTransfer)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *WsXMRTransferIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *WsXMRTransferIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// WsXMRTransfer represents a Transfer event raised by the WsXMR contract.
type WsXMRTransfer struct {
	From  common.Address
	To    common.Address
	Value *big.Int
	Raw   types.Log // Blockchain specific contextual infos
}

// FilterTransfer is a free log retrieval operation binding the contract event 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef.
//
// Solidity: event Transfer(address indexed from, address indexed to, uint256 value)
func (_WsXMR *WsXMRFilterer) FilterTransfer(opts *bind.FilterOpts, from []common.Address, to []common.Address) (*WsXMRTransferIterator, error) {

	var fromRule []interface{}
	for _, fromItem := range from {
		fromRule = append(fromRule, fromItem)
	}
	var toRule []interface{}
	for _, toItem := range to {
		toRule = append(toRule, toItem)
	}

	logs, sub, err := _WsXMR.contract.FilterLogs(opts, "Transfer", fromRule, toRule)
	if err != nil {
		return nil, err
	}
	return &WsXMRTransferIterator{contract: _WsXMR.contract, event: "Transfer", logs: logs, sub: sub}, nil
}

// WatchTransfer is a free log subscription operation binding the contract event 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef.
//
// Solidity: event Transfer(address indexed from, address indexed to, uint256 value)
func (_WsXMR *WsXMRFilterer) WatchTransfer(opts *bind.WatchOpts, sink chan<- *WsXMRTransfer, from []common.Address, to []common.Address) (event.Subscription, error) {

	var fromRule []interface{}
	for _, fromItem := range from {
		fromRule = append(fromRule, fromItem)
	}
	var toRule []interface{}
	for _, toItem := range to {
		toRule = append(toRule, toItem)
	}

	logs, sub, err := _WsXMR.contract.WatchLogs(opts, "Transfer", fromRule, toRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(WsXMRTransfer)
				if err := _WsXMR.contract.UnpackLog(event, "Transfer", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseTransfer is a log parse operation binding the contract event 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef.
//
// Solidity: event Transfer(address indexed from, address indexed to, uint256 value)
func (_WsXMR *WsXMRFilterer) ParseTransfer(log types.Log) (*WsXMRTransfer, error) {
	event := new(WsXMRTransfer)
	if err := _WsXMR.contract.UnpackLog(event, "Transfer", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// WsXMRVaultManagerUpdatedIterator is returned from FilterVaultManagerUpdated and is used to iterate over the raw logs and unpacked data for VaultManagerUpdated events raised by the WsXMR contract.
type WsXMRVaultManagerUpdatedIterator struct {
	Event *WsXMRVaultManagerUpdated // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *WsXMRVaultManagerUpdatedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(WsXMRVaultManagerUpdated)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(WsXMRVaultManagerUpdated)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *WsXMRVaultManagerUpdatedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *WsXMRVaultManagerUpdatedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// WsXMRVaultManagerUpdated represents a VaultManagerUpdated event raised by the WsXMR contract.
type WsXMRVaultManagerUpdated struct {
	OldManager common.Address
	NewManager common.Address
	Raw        types.Log // Blockchain specific contextual infos
}

// FilterVaultManagerUpdated is a free log retrieval operation binding the contract event 0x8cfaacab0869ad5307d9175b1a62164d7c9630958cbbc7bc9918133cd6fbb02d.
//
// Solidity: event VaultManagerUpdated(address indexed oldManager, address indexed newManager)
func (_WsXMR *WsXMRFilterer) FilterVaultManagerUpdated(opts *bind.FilterOpts, oldManager []common.Address, newManager []common.Address) (*WsXMRVaultManagerUpdatedIterator, error) {

	var oldManagerRule []interface{}
	for _, oldManagerItem := range oldManager {
		oldManagerRule = append(oldManagerRule, oldManagerItem)
	}
	var newManagerRule []interface{}
	for _, newManagerItem := range newManager {
		newManagerRule = append(newManagerRule, newManagerItem)
	}

	logs, sub, err := _WsXMR.contract.FilterLogs(opts, "VaultManagerUpdated", oldManagerRule, newManagerRule)
	if err != nil {
		return nil, err
	}
	return &WsXMRVaultManagerUpdatedIterator{contract: _WsXMR.contract, event: "VaultManagerUpdated", logs: logs, sub: sub}, nil
}

// WatchVaultManagerUpdated is a free log subscription operation binding the contract event 0x8cfaacab0869ad5307d9175b1a62164d7c9630958cbbc7bc9918133cd6fbb02d.
//
// Solidity: event VaultManagerUpdated(address indexed oldManager, address indexed newManager)
func (_WsXMR *WsXMRFilterer) WatchVaultManagerUpdated(opts *bind.WatchOpts, sink chan<- *WsXMRVaultManagerUpdated, oldManager []common.Address, newManager []common.Address) (event.Subscription, error) {

	var oldManagerRule []interface{}
	for _, oldManagerItem := range oldManager {
		oldManagerRule = append(oldManagerRule, oldManagerItem)
	}
	var newManagerRule []interface{}
	for _, newManagerItem := range newManager {
		newManagerRule = append(newManagerRule, newManagerItem)
	}

	logs, sub, err := _WsXMR.contract.WatchLogs(opts, "VaultManagerUpdated", oldManagerRule, newManagerRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(WsXMRVaultManagerUpdated)
				if err := _WsXMR.contract.UnpackLog(event, "VaultManagerUpdated", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseVaultManagerUpdated is a log parse operation binding the contract event 0x8cfaacab0869ad5307d9175b1a62164d7c9630958cbbc7bc9918133cd6fbb02d.
//
// Solidity: event VaultManagerUpdated(address indexed oldManager, address indexed newManager)
func (_WsXMR *WsXMRFilterer) ParseVaultManagerUpdated(log types.Log) (*WsXMRVaultManagerUpdated, error) {
	event := new(WsXMRVaultManagerUpdated)
	if err := _WsXMR.contract.UnpackLog(event, "VaultManagerUpdated", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
