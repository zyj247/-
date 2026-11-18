// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;

import "./FlightDelayInsurance.sol";

contract Claims is FlightDelayInsurance {
    struct Flight { uint256 departureTime; uint256 delayTime; bool isDelayed; bool isInsured; bool settled; }
    mapping(bytes32 => Flight) public flights;
    uint256 public compensationNew;

    constructor(address _platformS, address _airlineV, address _insuranceCompanyC, uint256 _premium, uint256 _compensation)
        FlightDelayInsurance(_platformS, _airlineV, _insuranceCompanyC, _premium, _compensation) { compensationNew = _compensation; }

    function updateFlight(bytes32 flightKey, uint256 departureTime, uint256 delayTime, bool isDelayed) external {
        require(msg.sender == insuranceCompanyC || msg.sender == airlineV, "only trusted updater");
        flights[flightKey] = Flight(departureTime, delayTime, isDelayed, purchased, false);
    }

    /*********** ③ 客户理赔接口 **********/
    function claim(bytes32 flightKey) external {
        // TODO: 延误且 delayTime >= 4 hours 时仅投保人可领取 compensationNew，并只结算一次。
        ***
    }

    /*********** ③ 保险公司收取保费接口开发 **********/
    function collectPremium(bytes32 flightKey) external {
        // TODO: 未达到4小时理赔条件时，仅保险公司可收取 premium 与赔偿金余额，并只结算一次。
        ***
    }

    receive() external payable {}
}
