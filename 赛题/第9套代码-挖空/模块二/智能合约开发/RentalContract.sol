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
    constructor(address payable _landlord, address payable _tenant, uint _rentAmount, uint _securityDeposit, uint _contractStartDate, uint _contractEndDate, uint _gracePeriod, uint _terminationFee) {
        landlord = _landlord; tenant = _tenant; rentAmount = _rentAmount; securityDeposit = _securityDeposit;
        contractStartDate = _contractStartDate; contractEndDate = _contractEndDate; gracePeriod = _gracePeriod; terminationFee = _terminationFee; contractActive = true;
    }
    function terminateContract() public {
        require(contractActive, "合同无效。");
        if (msg.sender == landlord) {
            require(!landlordTerminated, "房东已终止合同。");
            /*********** 编写房东终止合同接口开发 **********/
            /***
        } else if (msg.sender == tenant) {
            require(!tenantTerminated, "租客已终止合同。");
            /*********** 编写租客终止合同接口开发 **********/
            /***
        }
    }
    function getSecurityDeposit() public {
        require(!contractActive, "合同仍然有效。");
        require(!securityDepositReturned, "押金已经退还。");
        require(!tenantDefaulted, "租客已违约。");
        /*********** 押金退还接口 **********/
        /***
    }
}
