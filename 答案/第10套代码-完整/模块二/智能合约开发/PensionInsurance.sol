// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;

/// @notice Pension contribution management with local employer/employee account state.
contract PensionInsurance {
    struct Account {
        uint256 personalBalance;
        uint256 overallBalance;
        bool isSponsor;
        uint256 paymentTimestamp;
        bool exists;
        bool active;
    }

    uint256 public constant MAX_INSURANCE_BASE = 24000;
    uint256 public constant MIN_INSURANCE_BASE = 3200;
    uint256 public constant PERSONAL_RATE = 8;
    uint256 public constant OVERALL_RATE = 19;
    uint256 public constant SPONSOR_RATE = 11;
    uint256 public constant PAYMENT_DEADLINE = 30 days;

    address public sponsor;
    mapping(address => Account) public accounts;
    mapping(address => uint256) public salaryOf;

    event EmployeeAdded(address indexed employee);
    event EmployerAdded(address indexed employer);
    event PaymentMade(address indexed employee, address indexed employer, uint256 personalAmount, uint256 overallAmount);
    event EmployeeRemoved(address indexed employee);

    constructor() {
        sponsor = msg.sender;
        accounts[msg.sender] = Account(0, 0, true, block.timestamp, true, true);
    }

    modifier onlySponsor() {
        require(msg.sender == sponsor, "only sponsor");
        _;
    }

    function addEmployee(address employee) external onlySponsor {
        require(employee != address(0) && !accounts[employee].exists, "employee exists");
        accounts[employee] = Account(0, 0, false, block.timestamp, true, true);
        emit EmployeeAdded(employee);
    }

    function addEmployer(address employer) external onlySponsor {
        require(employer != address(0) && !accounts[employer].exists, "employer exists");
        accounts[employer] = Account(0, 0, true, block.timestamp, true, true);
        emit EmployerAdded(employer);
    }

    function setSalary(address employee, uint256 salary) external onlySponsor {
        require(accounts[employee].exists && !accounts[employee].isSponsor, "employee required");
        salaryOf[employee] = salary;
    }

    function setSponsor(address newSponsor) external onlySponsor {
        require(accounts[newSponsor].exists && accounts[newSponsor].isSponsor, "employer required");
        require(newSponsor != sponsor, "same sponsor");
        accounts[sponsor].isSponsor = false;
        sponsor = newSponsor;
        accounts[newSponsor].isSponsor = true;
    }

    /// Employer funds are represented by its ledger balance in this local exercise.
    function creditEmployer(address employer, uint256 amount) external onlySponsor {
        require(accounts[employer].exists && accounts[employer].isSponsor, "employer required");
        accounts[employer].overallBalance += amount;
    }

    function makePayment(address employee) external onlySponsor {
        Account storage worker = accounts[employee];
        Account storage employer = accounts[sponsor];
        require(worker.exists && !worker.isSponsor && worker.active, "employee required");
        require(employer.exists && employer.isSponsor, "sponsor required");
        require(employer.overallBalance >= _overallAmount(employee), "insufficient employer funds");
        require(block.timestamp <= employer.paymentTimestamp + PAYMENT_DEADLINE, "payment expired");

        uint256 base = _insuranceBase(employee);
        uint256 personalAmount = base * PERSONAL_RATE / 100;
        uint256 overallAmount = base * OVERALL_RATE / 100;
        worker.personalBalance += personalAmount;
        worker.overallBalance += overallAmount;
        employer.overallBalance -= overallAmount;
        worker.paymentTimestamp = block.timestamp;
        employer.paymentTimestamp = block.timestamp;
        emit PaymentMade(employee, sponsor, personalAmount, overallAmount);
    }

    function removeEmployee(address employee) external onlySponsor {
        Account storage worker = accounts[employee];
        require(worker.exists && !worker.isSponsor, "employee required");
        require(worker.personalBalance == 0 && worker.overallBalance == 0, "funds must be transferred");
        worker.active = false;
        emit EmployeeRemoved(employee);
    }

    function _insuranceBase(address employee) internal view returns (uint256) {
        uint256 salary = salaryOf[employee];
        if (salary == 0) salary = 5000;
        if (salary > MAX_INSURANCE_BASE) return MAX_INSURANCE_BASE;
        if (salary < MIN_INSURANCE_BASE) return MIN_INSURANCE_BASE;
        return salary;
    }

    function _overallAmount(address employee) internal view returns (uint256) {
        return _insuranceBase(employee) * OVERALL_RATE / 100;
    }
}
