// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import '../interfaces/IERC20.sol';

contract DLNC is IERC20 {
    string constant _name = "DLN_Coin";
    string constant _symbol = "DLNC";
    uint8 constant _decimals = 18; 

    uint256 _totalSupply = 2000000000 * 10**18;

    mapping(address => uint) _balances;
    mapping(address => mapping(address => uint)) _allowance;

    bytes32 public DOMAIN_SEPARATOR;
    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    mapping(address => uint) public nonces;

    constructor() {
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);

        uint chainId;
        assembly {
            chainId := chainid()
        }
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
                keccak256(bytes(_name)),
                keccak256(bytes('1')),
                chainId,
                address(this)
            )
        );
    }

    function name() override external pure returns (string memory){
        return _name;
    }

    function symbol() override external pure returns (string memory){
        return _symbol;
    }

    function decimals() override external pure returns (uint8){
        return _decimals;
    }
    
    function totalSupply() override external view returns (uint256){
        return _totalSupply;
    }

    function balanceOf(address tokenOwner) override external view returns (uint256){
        return _balances[tokenOwner];
    }

    function _approve(address owner, address spender, uint value) private {
        _allowance[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _transfer(address from, address to, uint value) private {
        _balances[from] = _balances[from] - value;
        _balances[to] = _balances[to] + value;
        emit Transfer(from, to, value);
    }

    function allowance(address tokenOwner, address spender) override external view returns (uint) {
        return _allowance[tokenOwner][spender];
    }

    function approve(address spender, uint value) override external returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transfer(address to, uint value) override external returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint value) override external returns (bool) {
        require(from == msg.sender || _allowance[from][msg.sender] >= value, "no right to transfer");
        _allowance[from][msg.sender] = _allowance[from][msg.sender] - value;
        _transfer(from, to, value);
        return true;
    }

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
        require(deadline >= block.timestamp, "EXPIRED");
        bytes32 digest = keccak256(
            abi.encodePacked(
                '\x19\x01',
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
            )
        );
        address recoveredAddress = ecrecover(digest, v, r, s);
        require(recoveredAddress != address(0) && recoveredAddress == owner, 'INVALID_SIGNATURE');
        _approve(owner, spender, value);
    }
}