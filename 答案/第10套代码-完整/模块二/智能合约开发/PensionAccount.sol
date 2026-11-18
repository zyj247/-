// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;

/// @notice Deterministic local stubs stand in for公安、劳动和社保部门.
contract PensionAccount {
    struct Person {
        string name;
        uint256 age;
        string idNumber;
        string employer;
        uint256 startDate;
        uint256 salary;
        uint256 paymentBase;
    }

    mapping(string => Person) public people;
    mapping(string => bool) public accountExists;
    address public owner;

    event PensionAccountGenerated(string indexed idNumber, string name, string employer);

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // 本地stub：实际系统应由授权的部门适配器返回并验签。
    function generatePensionAccount(string calldata idNumber) external onlyOwner {
        require(bytes(idNumber).length > 0, "id required");
        require(!accountExists[idNumber], "account already exists");
        people[idNumber] = Person(
            retrieveName(idNumber),
            retrieveAge(idNumber),
            idNumber,
            retrieveEmployer(idNumber),
            retrieveStartDate(idNumber),
            retrieveSalary(idNumber),
            retrievePaymentBase()
        );
        accountExists[idNumber] = true;
        emit PensionAccountGenerated(idNumber, people[idNumber].name, people[idNumber].employer);
    }

    function retrieveName(string calldata) private pure returns (string memory) { return "John Doe"; }
    function retrieveAge(string calldata) private pure returns (uint256) { return 35; }
    function retrieveEmployer(string calldata) private pure returns (string memory) { return "ABC Company"; }
    function retrieveStartDate(string calldata) private pure returns (uint256) { return 1625097600; }
    function retrieveSalary(string calldata) private pure returns (uint256) { return 5000; }
    function retrievePaymentBase() private pure returns (uint256) { return 5000; }
}
