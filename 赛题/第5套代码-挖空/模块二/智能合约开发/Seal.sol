pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

//印章合约
contract Seal {
    bool isUsed;

    //印章信息
    struct SealInfo {
        //①姓名
        //②身份证
        //③印章数据
        //④创建印章时间戳
    }

    //签章记录
    struct RecordInfo {
        string code;
        string datetime;
    }

    SealInfo public sealInfo;
    mapping(string=>RecordInfo) recordMap;
    string[] keys;

    //题目提取文本遗漏了_data形参；此处保留附件的四参数API。
    constructor(string _name,string _cardId,string _data,string _datetime) public {
        //①用户姓名
        //②用户身份ID
        //③用户数据
        //④时间戳
        isUsed = true;
    }

    function setIsUsed(bool _status) public {
        isUsed = _status;
    }

    function getIsUsed() view public returns(bool) {
        return isUsed;
    }

    function getSealData() view public returns(string) {
        return sealInfo.data;
    }

    function getSealInfo() view public returns(string,string,string) {
        return (sealInfo.name,sealInfo.cardId,sealInfo.datetime);
    }

    function signature(string _hash,string _code,string _datetime) public {
        recordMap[_hash] = RecordInfo(_code,_datetime);
        keys.push(_hash);
    }

    function getRecord(string _hash) view public returns(string,string) {
        RecordInfo memory recordInfo = recordMap[_hash];
        return (recordInfo.code,recordInfo.datetime);
    }

    function getAllHash() view public returns(string[] memory) {
        return keys;
    }
}
