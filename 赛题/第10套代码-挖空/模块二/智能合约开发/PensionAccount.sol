// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;

contract PensionAccount {
    struct Person { string name; uint256 age; string idNumber; string employer; uint256 startDate; uint256 salary; uint256 paymentBase; }
    mapping(string => Person) public people;
    mapping(string => bool) public accountExists;
    address public owner;
    constructor() { owner = msg.sender; }
    modifier onlyOwner() { require(msg.sender == owner, "only owner"); _; }

    /*********** ① 生成账户接口开发 **********/
    function generatePensionAccount(string calldata idNumber) external onlyOwner {
        // TODO: 按题目顺序调用本地stub，组合姓名、年龄、身份证、雇主、开始日期、工资、缴费基数并存储。
        ***
    }

    // 确定性的本地stub：真实系统应接入并验签公安、劳动、社保接口。
    function retrieveName(string calldata) private pure returns (string memory) { return "John Doe"; }
    function retrieveAge(string calldata) private pure returns (uint256) { return 35; }
    function retrieveEmployer(string calldata) private pure returns (string memory) { return "ABC Company"; }
    function retrieveStartDate(string calldata) private pure returns (uint256) { return 1625097600; }
    function retrieveSalary(string calldata) private pure returns (uint256) { return 5000; }
    function retrievePaymentBase() private pure returns (uint256) { return 5000; }
}
