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
    mapping(string => MedicalRecord) medicalRecords;

    /*********** 新建病历接口 **********/
    // TODO
    /***

    function updateMedicalRecord(string memory patientID, string memory hospitalName, string memory department, string memory doctorName, string memory registrationInfo) public {
        medicalRecords[patientID].hospitalName = hospitalName;
        medicalRecords[patientID].department = department;
        medicalRecords[patientID].doctorName = doctorName;
        medicalRecords[patientID].registrationInfo = registrationInfo;
    }

    function fillInMedicalHistory(string memory patientID, string memory pastMedicalHistory, string memory currentMedicalHistory) public {
        require(bytes(pastMedicalHistory).length > 0 && bytes(currentMedicalHistory).length > 0, "a");
        medicalRecords[patientID].pastMedicalHistory = pastMedicalHistory;
        medicalRecords[patientID].currentMedicalHistory = currentMedicalHistory;
        medicalRecords[patientID].isFilled = true;
    }

    /*********** 结束就诊接口 **********/
    // TODO
    /***
}
