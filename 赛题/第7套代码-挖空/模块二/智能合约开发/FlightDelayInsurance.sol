// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;

contract FlightDelayInsurance {
    uint256 public constant INSURANCE_WINDOW = 30 minutes;
    uint256 public constant COMPENSATION_WINDOW = 2 hours;
    address public platformS;
    address public airlineV;
    address public insuranceCompanyC;
    uint256 public premium;
    uint256 public compensation;
    uint256 public purchaseTime;
    uint256 public depositTime;
    bool public purchased;
    bool public deposited;
    mapping(address => bool) public insured;
    mapping(address => bool) public policy;
    mapping(address => bool) public purchasedTicket;
    mapping(address => uint256) public ticketPurchaseTime;
    address public purchasedBy;

    constructor(address _platformS, address _airlineV, address _insuranceCompanyC, uint256 _premium, uint256 _compensation) {
        platformS = _platformS; airlineV = _airlineV; insuranceCompanyC = _insuranceCompanyC;
        premium = _premium; compensation = _compensation;
    }

    function purchaseTicket() external {
        purchasedTicket[msg.sender] = true;
        ticketPurchaseTime[msg.sender] = block.timestamp;
    }

    /*********** ① 航班保险购买上链接口开发 **********/
    function purchaseInsurance() external payable {
        // TODO: 仅购票用户、正确保费、30分钟内且只能购买一次；写入 purchased/purchasedBy/purchaseTime。
        ***
    }

    function depositCompensation() external payable {
        require(msg.sender == insuranceCompanyC, "only insurer");
        require(purchased && !deposited, "insurance is not pending");
        require(msg.value == compensation, "incorrect compensation");
        require(block.timestamp <= purchaseTime + COMPENSATION_WINDOW, "deposit expired");
        deposited = true; depositTime = block.timestamp;
    }

    /*********** ① 退保接口开发 **********/
    function refundPremium() external {
        // TODO: 仅投保人可退保；赔偿金未预存且未退保时，标记并退回 premium。
        ***
    }

    function generatePolicy() external {
        require(msg.sender == platformS && deposited, "policy unavailable");
        policy[purchasedBy] = true;
    }

    receive() external payable {}
}
