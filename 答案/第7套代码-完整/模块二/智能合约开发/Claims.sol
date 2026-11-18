// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;

import "./FlightDelayInsurance.sol";

/// @notice Local claims stub. The insurer deposits the compensation pool and the platform settles one flight once.
contract Claims is FlightDelayInsurance {
    struct Flight {
        uint256 departureTime;
        uint256 delayTime;
        bool isDelayed;
        bool isInsured;
        bool settled;
    }

    mapping(bytes32 => Flight) public flights;
    uint256 public compensationNew;

    event FlightUpdated(bytes32 indexed flightKey, uint256 delayTime, bool isDelayed);
    event Claim(bytes32 indexed flightKey, address indexed passenger, uint256 amount);
    event PremiumCollected(bytes32 indexed flightKey, address indexed insurer, uint256 amount);

    constructor(
        address _platformS,
        address _airlineV,
        address _insuranceCompanyC,
        uint256 _premium,
        uint256 _compensation
    ) FlightDelayInsurance(_platformS, _airlineV, _insuranceCompanyC, _premium, _compensation) {
        compensationNew = _compensation;
    }

    function updateFlight(
        bytes32 flightKey,
        uint256 departureTime,
        uint256 delayTime,
        bool isDelayed
    ) external {
        require(msg.sender == insuranceCompanyC || msg.sender == airlineV, "only trusted updater");
        require(flights[flightKey].departureTime == 0, "flight already updated");
        flights[flightKey] = Flight(departureTime, delayTime, isDelayed, purchased, false);
        emit FlightUpdated(flightKey, delayTime, isDelayed);
    }

    // ③ 客户理赔接口：延误达到4小时，由赔偿池向投保人支付赔偿金。
    function claim(bytes32 flightKey) external {
        Flight storage flight = flights[flightKey];
        require(!flight.settled && flight.isInsured, "claim unavailable");
        require(flight.isDelayed && flight.delayTime >= 4 hours, "delay is below threshold");
        require(msg.sender == purchasedBy, "only insured passenger");
        require(address(this).balance >= compensationNew, "insufficient compensation pool");
        flight.settled = true;
        uint256 amount = compensationNew;
        compensationNew = 0;
        payable(msg.sender).transfer(amount);
        emit Claim(flightKey, msg.sender, amount);
    }

    // ③ 保险公司收取保费接口：无延误或延误少于4小时，保费归保险公司且退赔偿金。
    function collectPremium(bytes32 flightKey) external {
        Flight storage flight = flights[flightKey];
        require(!flight.settled && flight.isInsured, "settlement unavailable");
        require(msg.sender == insuranceCompanyC, "only insurer");
        require(!flight.isDelayed || flight.delayTime < 4 hours, "claim is due");
        require(address(this).balance >= premium + compensationNew, "insufficient settlement balance");
        flight.settled = true;
        uint256 refund = compensationNew;
        compensationNew = 0;
        payable(insuranceCompanyC).transfer(premium + refund);
        emit PremiumCollected(flightKey, insuranceCompanyC, premium);
    }

}
