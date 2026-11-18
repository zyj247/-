pragma solidity 0.6.10;
pragma experimental ABIEncoderV2;

// 食品物流合约
contract Logistics {
    struct LogisticsData {
        address cargo;
        address orgin;
        address destination;
        string memo;
        uint createdAt;
        uint queryCount;
    }

    LogisticsData[] private _logisticsData;

    uint public recordCount;
    uint public queryCount;

    // 可自行添加形参和返回值
    // 编写食品物流上链接口 addLogistic，实现食品物流信息上链功能
    function addLogistics(address cargo, address orgin，...) public {
        // TODO
        ***
    }

    // 可自行添加形参和返回值
    // 编写获取食品物流信息的接口 getLogistics，根据食品产品编号获取物流信息
    function getLogisticsInfo(address _cargo) public returns(LogisticsData[] memory _cargoLogisticsData) {
        // TODO
        ***
    }
}
