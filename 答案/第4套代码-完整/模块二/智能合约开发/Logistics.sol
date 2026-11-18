// SPDX-License-Identifier: MIT
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

    // 记录产品物流流转信息。
    function addLogistics(address cargo, address orgin, address destination, string memory memo) public {
        require(cargo != address(0), "Cargo address is required");
        _logisticsData.push(LogisticsData(cargo, orgin, destination, memo, block.timestamp, 0));
        recordCount++;
    }

    // 按产品地址查询物流记录，并统计全局及单条记录查询次数。
    function getLogisticsInfo(address _cargo) public returns (LogisticsData[] memory _cargoLogisticsData) {
        uint count = 0;
        for (uint i = 0; i < _logisticsData.length; i++) {
            if (_logisticsData[i].cargo == _cargo) count++;
        }

        queryCount++;
        LogisticsData[] memory result = new LogisticsData[](count);
        uint idx = 0;
        for (uint i = 0; i < _logisticsData.length; i++) {
            if (_logisticsData[i].cargo == _cargo) {
                _logisticsData[i].queryCount++;
                result[idx] = _logisticsData[i];
                idx++;
            }
        }
        return result;
    }

    function getLogisticsRecordCount() external view returns (uint) {
        return _logisticsData.length;
    }
}
