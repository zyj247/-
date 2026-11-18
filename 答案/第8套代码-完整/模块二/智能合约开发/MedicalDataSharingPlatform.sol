// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract MedicalDataSharingPlatform {
    struct Patient {
        string name;
        string gender;
        uint age;
        address accountAddress;
    }

    mapping(string => Patient) private patients;
    mapping(string => string) public appointments;

    function register(string memory _id, string memory _name, string memory _gender, uint _age) public {
        require(bytes(_id).length > 0, "id is required");
        patients[_id] = Patient(_name, _gender, _age, msg.sender);
    }

    function getPatientInfo(string memory _id) public view returns (string memory, string memory, uint) {
        Patient memory patient = patients[_id];
        return (patient.name, patient.gender, patient.age);
    }

    function makeAppointment(string memory _id, string memory _hospital, string memory _department) public {
        Patient memory patient = patients[_id];
        require(patient.accountAddress != address(0), "patient is not registered");
        string memory appointmentInfo = string(abi.encodePacked(
            "You have made an appointment with ", _hospital, " ", _department
        ));
        appointments[_id] = appointmentInfo;
        (bool success, ) = patient.accountAddress.call("");
        require(success, "Failed to send appointment information");
    }
}
