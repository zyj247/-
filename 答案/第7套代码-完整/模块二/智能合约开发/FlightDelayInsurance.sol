// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;

/// @notice Flight-delay insurance purchase, deposit and policy lifecycle.
/// External airline/insurance systems are represented by constructor addresses.
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
    mapping(address => bool) public insured; // refunded users
    mapping(address => bool) public policy;
    mapping(address => bool) public purchasedTicket;
    mapping(address => uint256) public ticketPurchaseTime;
    address public purchasedBy;

    event TicketPurchased(address indexed passenger, uint256 at);
    event InsurancePurchased(address indexed passenger, uint256 amount);
    event CompensationDeposited(address indexed insurer, uint256 amount);
    event PremiumRefunded(address indexed passenger, uint256 amount);
    event PolicyGenerated(address indexed passenger);

    constructor(
        address _platformS,
        address _airlineV,
        address _insuranceCompanyC,
        uint256 _premium,
        uint256 _compensation
    ) {
        require(_platformS != address(0) && _airlineV != address(0) && _insuranceCompanyC != address(0), "zero address");
        require(_premium > 0 && _compensation > 0, "amount must be positive");
        platformS = _platformS;
        airlineV = _airlineV;
        insuranceCompanyC = _insuranceCompanyC;
        premium = _premium;
        compensation = _compensation;
    }

    function purchaseTicket() external {
        require(!purchasedTicket[msg.sender], "ticket already purchased");
        purchasedTicket[msg.sender] = true;
        ticketPurchaseTime[msg.sender] = block.timestamp;
        emit TicketPurchased(msg.sender, block.timestamp);
    }

    /// ① 航班保险购买上链接口：只有购票用户可在30分钟内支付准确保费。
    function purchaseInsurance() external payable {
        require(purchasedTicket[msg.sender], "ticket required");
        require(msg.value == premium, "incorrect premium");
        require(block.timestamp <= ticketPurchaseTime[msg.sender] + INSURANCE_WINDOW, "purchase expired");
        require(!purchased && purchasedBy == address(0), "policy already purchased");
        purchased = true;
        purchasedBy = msg.sender;
        purchaseTime = block.timestamp;
        emit InsurancePurchased(msg.sender, msg.value);
    }

    function depositCompensation() external payable {
        require(msg.sender == insuranceCompanyC, "only insurer");
        require(purchased && !deposited, "insurance is not pending");
        require(msg.value == compensation, "incorrect compensation");
        require(block.timestamp <= purchaseTime + COMPENSATION_WINDOW, "deposit expired");
        deposited = true;
        depositTime = block.timestamp;
        emit CompensationDeposited(msg.sender, msg.value);
    }

    /// ① 退保接口：赔偿金未按时预存时，退回乘客保费。
    function refundPremium() external {
        require(purchased && msg.sender == purchasedBy, "not insured passenger");
        require(!deposited, "compensation already deposited");
        require(!insured[msg.sender], "premium already refunded");
        insured[msg.sender] = true;
        payable(msg.sender).transfer(premium);
        emit PremiumRefunded(msg.sender, premium);
    }

    function generatePolicy() external {
        require(msg.sender == platformS, "only platform");
        require(deposited, "compensation not deposited");
        require(purchasedBy != address(0) && !policy[purchasedBy], "policy already generated");
        policy[purchasedBy] = true;
        emit PolicyGenerated(purchasedBy);
    }

    receive() external payable {}
}
