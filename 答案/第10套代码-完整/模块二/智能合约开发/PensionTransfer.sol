// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;

/// @notice Pension relationship transfer using explicit city-bureau authorizations.
contract PensionTransfer {
    struct Application {
        address applicant;
        string fromCity;
        string toCity;
        bool isStopped;
        bool isApproved;
        bool exists;
    }

    struct Account {
        uint256 personalFund;
        uint256 overallFund;
        uint256 pensionInsurance;
    }

    struct SocialSecurityBureau {
        address bureauAddress;
        bool isAuthorized;
        bool hasReceived;
    }

    Application[] public applications;
    mapping(address => Account) public accounts;
    mapping(address => SocialSecurityBureau) public socialSecurityBureaus;
    mapping(address => uint256) public activeApplication;

    event TransferApplied(uint256 indexed applicationId, address indexed applicant, string fromCity, string toCity);
    event TransferAuthorized(uint256 indexed applicationId, address indexed bureau, bool approved);
    event AccountTransferred(uint256 indexed applicationId, address indexed applicant, uint256 personalFund, uint256 overallFund, uint256 pensionInsurance);
    event AccountReceived(uint256 indexed applicationId, address indexed applicant, address indexed bureau);

    function registerBureau(address bureau) external {
        require(bureau != address(0), "zero bureau");
        socialSecurityBureaus[bureau] = SocialSecurityBureau(bureau, false, false);
    }

    function seedAccount(address applicant, uint256 personalFund, uint256 overallFund, uint256 pensionInsurance) external {
        require(applicant != address(0), "zero applicant");
        accounts[applicant] = Account(personalFund, overallFund, pensionInsurance);
    }

    // ③ 申请转移关系接口：记录申请人、原城市、目标城市、停缴和批准状态。
    function applyTransfer(string calldata fromCity, string calldata toCity) external returns (uint256 applicationId) {
        require(bytes(fromCity).length > 0 && bytes(toCity).length > 0, "city required");
        require(activeApplication[msg.sender] == 0, "application pending");
        applications.push(Application(msg.sender, fromCity, toCity, false, false, true));
        applicationId = applications.length;
        activeApplication[msg.sender] = applicationId;
        emit TransferApplied(applicationId, msg.sender, fromCity, toCity);
    }

    /// Source bureau confirms stopping status. In this exercise `isStopped` means eligible to transfer.
    function authorizeTransfer(uint256 applicationId, bool isStopped) external {
        require(applicationId > 0 && applicationId <= applications.length, "application not found");
        require(socialSecurityBureaus[msg.sender].bureauAddress == msg.sender, "unregistered bureau");
        Application storage application = applications[applicationId - 1];
        require(!application.isApproved, "already approved");
        application.isStopped = isStopped;
        application.isApproved = isStopped;
        socialSecurityBureaus[msg.sender].isAuthorized = isStopped;
        emit TransferAuthorized(applicationId, msg.sender, isStopped);
    }

    function transferAccount(uint256 applicationId) external returns (uint256 personalFund, uint256 overallFund, uint256 pensionInsurance) {
        require(applicationId > 0 && applicationId <= applications.length, "application not found");
        require(socialSecurityBureaus[msg.sender].isAuthorized, "bureau not authorized");
        Application storage application = applications[applicationId - 1];
        require(application.isApproved, "transfer not approved");
        Account storage account = accounts[application.applicant];
        personalFund = account.personalFund;
        overallFund = account.overallFund;
        pensionInsurance = account.pensionInsurance;
        account.personalFund = 0;
        account.overallFund = 0;
        account.pensionInsurance = 0;
        emit AccountTransferred(applicationId, application.applicant, personalFund, overallFund, pensionInsurance);
    }

    // ③ 接收账户转移接口：目标社保局必须先注册，再完成授权并接收账户。
    function receiveAccount(uint256 applicationId, address applicantAddress, uint256 personalFund, uint256 overallFund, uint256 pensionInsurance) external {
        require(applicationId > 0 && applicationId <= applications.length, "application not found");
        require(socialSecurityBureaus[msg.sender].bureauAddress == msg.sender, "unregistered bureau");
        Application storage application = applications[applicationId - 1];
        require(application.isApproved && application.applicant == applicantAddress, "transfer not approved");
        accounts[applicantAddress] = Account(personalFund, overallFund, pensionInsurance);
        socialSecurityBureaus[msg.sender].hasReceived = true;
        emit AccountReceived(applicationId, applicantAddress, msg.sender);
    }

    function getApplication(uint256 applicationId) external view returns (Application memory) {
        require(applicationId > 0 && applicationId <= applications.length, "application not found");
        return applications[applicationId - 1];
    }
}
