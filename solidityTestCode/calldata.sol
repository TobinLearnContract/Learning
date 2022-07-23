pragma solidity ^0.8.3;

contract callData {

    uint256 public num;
    uint256[] public y;

    function example(uint256[] memory _y) public returns(string memory){
        _y[3] = 200;//memory不是read only，calldata是read only。
        num = 111;
        string memory str;
        str = "aa";
        str = "aaa";
        string calldata str2;
        return str2;
        //str2 = str;
        //str2 = "bbb";
    }

    function example2(uint256 _x) pure public{
        _x = 666;
    }

    function callExample() public{
        //example(y);
        example2(num);
    }

}