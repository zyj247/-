// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;

contract PensionInsurance {
    struct Account { uint256 personalBalance; uint256 overallBalance; bool isSponsor; uint256 paymentTimestamp; bool exists; bool active; }
    uint256 public constant MAX_INSURANCE_BASE = 24000;
    uint256 public constant MIN_INSURANCE_BASE = 3200;
    uint256 public constant PERSONAL_RATE = 8;
    uint256 public constant OVERALL_RATE = 19;
    uint256 public constant PAYMENT_DEADLINE = 30 days;
    address public sponsor;
    mapping(address => Account) public accounts;
    mapping(address => uint256) public salaryOf;

    constructor() { sponsor = msg.sender; accounts[msg.sender] = Account(0, 0, true, block.timestamp, true, true); }
    modifier onlySponsor() { require(msg.sender == sponsor, "only sponsor"); _; }

    /*********** ② 添加新职工账户接口 **********/
    function addEmployee(address employee) external onlySponsor {
        // TODO: 仅管理员可调用；账户不存在；建立余额为0、未赞助的职工账户。
        ***
    }
    /*********** ② 添加新雇主账户接口 **********/
    function addEmployer(address employer) external onlySponsor {
        // TODO: 仅管理员可调用；账户不存在；建立余额为0、已赞助的雇主账户。
        ***
    }

    function setSalary(address employee, uint256 salary) external onlySponsor { salaryOf[employee] = salary; }
    function creditEmployer(address employer, uint256 amount) external onlySponsor { accounts[employer].overallBalance += amount; }
    function makePayment(address employee) external onlySponsor {
        // TODO: 根据工资截取3200~24000缴费基数，按8%/19%入账并检查30天截止。
        ***
    }
    function removeEmployee(address employee) external onlySponsor {
        // TODO: 仅删除无余额、非雇主账户；将active置为false。
        ***
    }
    function _insuranceBase(address employee) internal view returns (uint256) {
        uint256 salary = salaryOf[employee];
        if (salary == 0) salary = 5000;
        if (salary > MAX_INSURANCE_BASE) return MAX_INSURANCE_BASE;
        if (salary < MIN_INSURANCE_BASE) return MIN_INSURANCE_BASE;
        return salary;
    }
}
