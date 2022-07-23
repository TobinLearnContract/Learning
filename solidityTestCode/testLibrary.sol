pragma solidity^0.8.7;

library Math{

    function get(uint256 num) external pure returns(uint256){//external可以
        return num;
    }

    function add(uint256 num) internal pure returns(uint256){
        num++;
        return num;
    }

    function sub(uint256 num, address addr) internal returns(uint256){//不一定pure或view，可以改变状态变量
        num--;
        A(addr).jian();
        return num;
    }
}

contract A {
    uint256 public num = 66;
    uint256 public www = 123456;
    function diao() public view returns(uint256){
        return Math.get(num);
    }

    function jian() external {
        www--;
    }

    function diao2(address addr) public returns(uint256){
        return Math.sub(num, addr);
    }

}
