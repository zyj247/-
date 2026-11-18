// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract MedicalRecords {
    struct Patient {
        string name;
        uint age;
        string personalInfo;
        string medicalHistory;
        string medicalContent;
    }

    mapping(address => Patient) public patients;

    function addPatient(
        string memory _name,
        uint _age,
        string memory _personalInfo,
        string memory _medicalHistory,
        string memory _medicalContent
    ) public {
        patients[msg.sender] = Patient(_name, _age, _personalInfo, _medicalHistory, _medicalContent);
    }

    function getPersonalInfo() public view returns (string memory) {
        return patients[msg.sender].personalInfo;
    }

    function getMedicalHistory() public view returns (string memory) {
        return patients[msg.sender].medicalHistory;
    }

    function getMedicalContent() public view returns (string memory) {
        return patients[msg.sender].medicalContent;
    }

    function getPatient(address account) public view returns (Patient memory) {
        return patients[account];
    }
}
