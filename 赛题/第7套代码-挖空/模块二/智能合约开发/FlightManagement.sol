// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;

contract FlightManagement {
    struct Flight { string flightNumber; uint256 scheduledDepartureTime; uint256 actualDepartureTime; uint256 arrivalTime; bool delayed; }
    mapping(string => Flight) private flights;
    address public owner;
    uint256 public constant DELAY_THRESHOLD = 4 hours;

    constructor() { owner = msg.sender; }
    modifier onlyOwner() { require(msg.sender == owner, "only owner"); _; }

    function addFlight(string calldata _flightNumber, uint256 _scheduledDepartureTime, uint256 _arrivalTime) external onlyOwner {
        flights[_flightNumber] = Flight(_flightNumber, _scheduledDepartureTime, 0, _arrivalTime, false);
    }
    function updateActualDepartureTime(string calldata _flightNumber, uint256 _actualDepartureTime) external onlyOwner {
        flights[_flightNumber].actualDepartureTime = _actualDepartureTime;
    }

    /*********** ② 获取航班信息接口开发 **********/
    function getFlight(string calldata _flightNumber) external view returns (string memory, uint256, uint256, uint256, bool) {
        // TODO: 读取映射并按题目顺序返回航班号、计划起飞、实际起飞、到达、延误状态。
        ***
    }

    /*********** ② 编写判断航班是否延误接口开发 **********/
    function isDelayedOverFourHours(string calldata _flightNumber) external view returns (bool) {
        // TODO: 以 actualDepartureTime - scheduledDepartureTime >= 4 hours 判断。
        ***
    }
}
