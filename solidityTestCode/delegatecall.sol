//
pragma solidity ^0.8.3;

contract test{

    uint256 public n;
    address public sender;
    uint256 public value;

    function set(uint256 _n) external payable{
        n += _n;
        sender = msg.sender;
        value += msg.value;
    }

    function getBalance() view public returns(uint256){
        return address(this).balance;
    }
    
}

//委托调用跟被调用合约的状态变量完全无关
contract delegateCall{

    uint256 public n;
    address public sender;
    uint256 public value;

    function set2(address _addr, uint256 _n) external payable{
        
        //(bool success2, bytes memory _data2) = _addr.delegatecall(abi.encodeWithSignature("set(uint256)", _n));
        
        //(bool success, bytes memory _data) = _addr.delegatecall(abi.encodeWithSelector(test.set.selector, _n));

        (bool success3, bytes memory _data3) = _addr.delegatecall(abi.encodeWithSelector(bytes4(keccak256("set(uint256)")), _n));
        //delegatecall后面不能带{value:amount}，直接传递msg.sender和value
    }

    function getBalance() view public returns(uint256){
        return address(this).balance;
    }
    
}