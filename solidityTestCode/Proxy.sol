pragma solidity^0.8.7;

//定义数据合约
contract storageStructure {
    //记录球员和分数
    address public implementation;//合约实现地址（逻辑地址）
    mapping(address=>uint256) public points;
    uint256 public totalPlayers;
    address public owner;
}

//定义逻辑合约
contract implementationV1 is storageStructure {
    modifier onlyowner()  {
        require(msg.sender == owner, "only owner can do");
        _;
    }
    //增加球员分数
    function addPlayer(address player, uint256 point) public onlyowner virtual {
        require(points[player] == 0, "player already exists");
        points[player] = point;
    }
    //修改球员分数
    function setPlayer(address player, uint256 point) public onlyowner {
        require(points[player] != 0, "player must already exists");
        points[player] = point;
    }
}

//0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
//0x6fd075fc000000000000000000000000Ab8483F64d9C6d1EcF9b849Ae677dD3315835cb20000000000000000000000000000000000000000000000000000000000000061
//0x6fd075fc0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc40000000000000000000000000000000000000000000000000000000000000064

//代理合约 代理合约调用逻辑合约的逻辑去修改代理合约内的数据
contract proxy is storageStructure {
    modifier onlyowner()  {
        require(msg.sender == owner, "only owner can do");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    //更新逻辑合约的地址
    function setImpl(address impl) public {
        implementation = impl;
    }
    
    //fallback函数 完成合约间调用
    fallback() external {
        address impl = implementation; //逻辑合约的地址
        require(impl != address(0), "implementation must already exists");
        
        //底层调用
        assembly {
            //调用delegateccall
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            //delegatecall(g, a, in, insize, out, outsize)
            let result := delegatecall(gas(), impl, ptr, calldatasize(), 0, 0)
            let size := returndatasize()
            
            //returndatacopy(t, f, s)
            returndatacopy(ptr, 0, size)
            
            switch result 
                case 0 { revert(ptr, size) }
                default { return(ptr, size) }
            
            
        }
    }
    
}
//0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
//0x6fd075fc0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc40000000000000000000000000000000000000000000000000000000000000064
//0x6fd075fc000000000000000000000000Ab8483F64d9C6d1EcF9b849Ae677dD3315835cb20000000000000000000000000000000000000000000000000000000000000066

//第二版本逻辑合约
contract implementationV2 is implementationV1 {
    
    function addPlayer(address player, uint256 point) override public onlyowner virtual {
        require(points[player] == 0, "player already exists");
        points[player] = point;
        totalPlayers ++;
    }
}