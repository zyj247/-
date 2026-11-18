// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract MedicalRecordManagement {
    struct MedicalRecord {
        string patientID;
        string hospitalName;
        string department;
        string doctorName;
        string registrationInfo;
        string pastMedicalHistory;
        string currentMedicalHistory;
        bool isFilled;
    }

    mapping(string => MedicalRecord) private medicalRecords;
    mapping(string => bool) public recordExists;
    mapping(string => address) public assignedDoctor;

    event ConsultationStarted(string indexed patientID, address indexed doctor, bool hasPastHistory);
    event MedicalRecordFilled(string indexed patientID, address indexed doctor);
    event ConsultationEnded(string indexed patientID, address indexed doctor);

    function startConsultation(string memory patientID) public {
        require(bytes(patientID).length > 0, "patient id is required");
        bool hasPastHistory = bytes(medicalRecords[patientID].pastMedicalHistory).length > 0;
        if (!recordExists[patientID]) {
            medicalRecords[patientID] = MedicalRecord(patientID, "", "", "", "", "", "", false);
            recordExists[patientID] = true;
        }
        assignedDoctor[patientID] = msg.sender;
        medicalRecords[patientID].isFilled = false;
        emit ConsultationStarted(patientID, msg.sender, hasPastHistory);
    }

    function updateMedicalRecord(
        string memory patientID,
        string memory hospitalName,
        string memory department,
        string memory doctorName,
        string memory registrationInfo
    ) public {
        require(assignedDoctor[patientID] == msg.sender, "Only assigned doctor can update record");
        medicalRecords[patientID].hospitalName = hospitalName;
        medicalRecords[patientID].department = department;
        medicalRecords[patientID].doctorName = doctorName;
        medicalRecords[patientID].registrationInfo = registrationInfo;
    }

    function fillInMedicalHistory(
        string memory patientID,
        string memory pastMedicalHistory,
        string memory currentMedicalHistory
    ) public {
        require(assignedDoctor[patientID] == msg.sender, "Only assigned doctor can fill record");
        require(bytes(pastMedicalHistory).length > 0 && bytes(currentMedicalHistory).length > 0, "medical history is required");
        medicalRecords[patientID].pastMedicalHistory = pastMedicalHistory;
        medicalRecords[patientID].currentMedicalHistory = currentMedicalHistory;
        medicalRecords[patientID].isFilled = true;
        emit MedicalRecordFilled(patientID, msg.sender);
    }

    function endConsultation(string memory patientID) public {
        require(assignedDoctor[patientID] == msg.sender, "Only assigned doctor can end consultation");
        require(medicalRecords[patientID].isFilled, "medical record is incomplete");
        medicalRecords[patientID].isFilled = false;
        delete assignedDoctor[patientID];
        emit ConsultationEnded(patientID, msg.sender);
    }

    function getMedicalRecord(string memory patientID) public view returns (MedicalRecord memory) {
        return medicalRecords[patientID];
    }
}
