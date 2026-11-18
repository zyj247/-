// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.3;

contract RentalContract {
    address payable public landlord;
    address payable public tenant;
    uint public rentAmount;
    uint public securityDeposit;
    uint public contractStartDate;
    uint public contractEndDate;
    uint public gracePeriod;
    uint public terminationFee;
    bool public contractActive;
    bool public landlordTerminated;
    bool public tenantTerminated;
    bool public tenantDefaulted;
    bool public securityDepositReturned;
    bool public depositFunded;

    constructor(address payable _landlord, address payable _tenant, uint _rentAmount,
        uint _securityDeposit, uint _contractStartDate, uint _contractEndDate,
        uint _gracePeriod, uint _terminationFee) payable {
        require(_landlord != address(0) && _tenant != address(0) && _landlord != _tenant, "invalid parties");
        require(_contractEndDate > _contractStartDate, "invalid dates");
        require(msg.value == 0 || msg.value == _securityDeposit, "incorrect funding");
        landlord = _landlord;
        tenant = _tenant;
        rentAmount = _rentAmount;
        securityDeposit = _securityDeposit;
        contractStartDate = _contractStartDate;
        contractEndDate = _contractEndDate;
        gracePeriod = _gracePeriod;
        terminationFee = _terminationFee;
        contractActive = true;
        depositFunded = msg.value == _securityDeposit;
    }

    // 原模板没有收押金入口，补上以免终止合同时因余额不足回滚。
    function fundSecurityDeposit() external payable {
        require(msg.sender == tenant && contractActive, "only active tenant");
        require(!depositFunded && msg.value == securityDeposit, "incorrect or duplicate funding");
        depositFunded = true;
    }

    function payRent() public payable {
        require(msg.sender == tenant, "only tenant");
        require(msg.value == rentAmount, "incorrect rent");
        require(contractActive && block.timestamp <= contractEndDate, "contract inactive");
        require(depositFunded, "deposit not funded");
        if (block.timestamp > contractStartDate + gracePeriod) {
            tenantDefaulted = true;
            uint penalty = securityDeposit >= rentAmount ? rentAmount : securityDeposit;
            securityDeposit -= penalty;
            _pay(landlord, msg.value + penalty);
        } else {
            _pay(landlord, msg.value);
        }
    }

    function terminateContract() public {
        require(contractActive, "contract inactive");
        require(depositFunded, "deposit not funded");
        address payable recipient;
        if (msg.sender == landlord) {
            require(!landlordTerminated, "landlord already terminated");
            landlordTerminated = true;
            recipient = tenant;
        } else if (msg.sender == tenant) {
            require(!tenantTerminated, "tenant already terminated");
            tenantTerminated = true;
            recipient = landlord;
        } else {
            revert("only contract parties");
        }
        // 单方终止即失效；先清账、后转账，防止重复退还和重入。
        contractActive = false;
        securityDepositReturned = true;
        uint amount = securityDeposit;
        securityDeposit = 0;
        _pay(recipient, amount);
    }

    function getSecurityDeposit() public {
        require(msg.sender == tenant, "only tenant");
        require(block.timestamp > contractEndDate, "contract not expired");
        require(depositFunded && !securityDepositReturned, "deposit unavailable");
        contractActive = false;
        securityDepositReturned = true;
        uint amount = securityDeposit;
        securityDeposit = 0;
        _pay(tenant, amount);
    }

    function _pay(address payable recipient, uint amount) private {
        if (amount > 0) {
            (bool ok, ) = recipient.call{value: amount}("");
            require(ok, "transfer failed");
        }
    }
}
