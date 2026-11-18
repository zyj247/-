// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;

contract PensionTransfer {
    struct Application { address applicant; string fromCity; string toCity; bool isStopped; bool isApproved; bool exists; }
    struct Account { uint256 personalFund; uint256 overallFund; uint256 pensionInsurance; }
    struct SocialSecurityBureau { address bureauAddress; bool isAuthorized; bool hasReceived; }
    Application[] public applications;
    mapping(address => Account) public accounts;
    mapping(address => SocialSecurityBureau) public socialSecurityBureaus;
    mapping(address => uint256) public activeApplication;

    function registerBureau(address bureau) external { socialSecurityBureaus[bureau] = SocialSecurityBureau(bureau, false, false); }
    function seedAccount(address applicant, uint256 personalFund, uint256 overallFund, uint256 pensionInsurance) external { accounts[applicant] = Account(personalFund, overallFund, pensionInsurance); }

    /*********** ③ 申请转移关系接口 **********/
    function applyTransfer(string calldata fromCity, string calldata toCity) external returns (uint256 applicationId) {
        // TODO: 创建申请，按题目顺序记录申请人、原城市、目标城市、停缴状态、批准状态，并加入列表。
        ***
    }

    function authorizeTransfer(uint256 applicationId, bool isStopped) external {
        // TODO: 社保局核验停缴状态；符合则将申请标记为 approved 并授权该局。
        ***
    }

    /*********** ③ 接收账户转移接口 **********/
    function receiveAccount(uint256 applicationId, address applicantAddress, uint256 personalFund, uint256 overallFund, uint256 pensionInsurance) external {
        // TODO: 校验目标社保局和已批准申请，按题目顺序接收个人基金、统筹基金、养老保险账户。
        ***
    }

    function getApplication(uint256 applicationId) external view returns (Application memory) {
        return applications[applicationId - 1];
    }
}
