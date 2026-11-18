pragma solidity ^0.8.3;

contract MedicalDataSharingPlatform {
    struct Patient {
        string name;
        string gender;
        uint age;
        address accountAddress;
    }
    mapping (string => Patient) patients;

    function register(string memory _id, string memory _name, string memory _gender, uint _age) public {
        patients[_id] = Patient(_name, _gender, _age, msg.sender);
    }

    /***********检索个人信息接口开发 **********/
    // TODO
    /*** 

    /*********** 信息管理接口开发 **********/
    // TODO
    /***
}
