// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;

/// @notice Local flight-information stub. Replace the writer authorization with the airline gateway in production.
contract FlightManagement {
    struct Flight {
        string flightNumber;
        uint256 scheduledDepartureTime;
        uint256 actualDepartureTime;
        uint256 arrivalTime;
        bool delayed;
    }

    mapping(string => Flight) private flights;
    address public owner;
    uint256 public constant DELAY_THRESHOLD = 4 hours;

    event FlightAdded(string indexed flightNumber, uint256 scheduledDepartureTime, uint256 arrivalTime);
    event ActualDepartureUpdated(string indexed flightNumber, uint256 actualDepartureTime);

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addFlight(
        string calldata _flightNumber,
        uint256 _scheduledDepartureTime,
        uint256 _arrivalTime
    ) external onlyOwner {
        require(bytes(_flightNumber).length > 0, "flight number required");
        require(_arrivalTime >= _scheduledDepartureTime, "arrival before departure");
        flights[_flightNumber] = Flight(_flightNumber, _scheduledDepartureTime, 0, _arrivalTime, false);
        emit FlightAdded(_flightNumber, _scheduledDepartureTime, _arrivalTime);
    }

    function updateActualDepartureTime(string calldata _flightNumber, uint256 _actualDepartureTime) external onlyOwner {
        Flight storage flight = flights[_flightNumber];
        require(bytes(flight.flightNumber).length > 0, "flight not found");
        require(_actualDepartureTime >= flight.scheduledDepartureTime, "actual before scheduled");
        flight.actualDepartureTime = _actualDepartureTime;
        flight.delayed = _actualDepartureTime - flight.scheduledDepartureTime >= DELAY_THRESHOLD;
        emit ActualDepartureUpdated(_flightNumber, _actualDepartureTime);
    }

    // ② 获取航班信息接口。
    function getFlight(string calldata _flightNumber)
        external
        view
        returns (string memory, uint256, uint256, uint256, bool)
    {
        Flight memory flight = flights[_flightNumber];
        return (flight.flightNumber, flight.scheduledDepartureTime, flight.actualDepartureTime, flight.arrivalTime, flight.delayed);
    }

    // ② 判断航班是否延误超过4小时接口。
    function isDelayedOverFourHours(string calldata _flightNumber) external view returns (bool) {
        Flight memory flight = flights[_flightNumber];
        require(bytes(flight.flightNumber).length > 0, "flight not found");
        require(flight.actualDepartureTime > 0, "actual departure not set");
        return flight.actualDepartureTime - flight.scheduledDepartureTime >= DELAY_THRESHOLD;
    }
}
