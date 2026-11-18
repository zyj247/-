pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

// 印章合约：保存个人印章信息和签章记录。
contract Seal {
    bool isUsed;

    struct SealInfo {
        string name;
        string cardId;
        string data;
        string datetime;
    }

    struct RecordInfo {
        string code;
        string datetime;
    }

    SealInfo public sealInfo;
    mapping(string => RecordInfo) recordMap;
    string[] keys;

    // 保留附件源码的四参数 API；官方答案片段遗漏了 _data 参数，见运行说明。
    constructor(string _name, string _cardId, string _data, string _datetime) public {
        sealInfo.name = _name;
        sealInfo.cardId = _cardId;
        sealInfo.data = _data;
        sealInfo.datetime = _datetime;
        isUsed = true;
    }

    function setIsUsed(bool _status) public {
        isUsed = _status;
    }

    function getIsUsed() view public returns (bool) {
        return isUsed;
    }

    function getSealData() view public returns (string) {
        return sealInfo.data;
    }

    function getSealInfo() view public returns (string, string, string) {
        return (sealInfo.name, sealInfo.cardId, sealInfo.datetime);
    }

    function signature(string _hash, string _code, string _datetime) public {
        recordMap[_hash] = RecordInfo(_code, _datetime);
        keys.push(_hash);
    }

    function getRecord(string _hash) view public returns (string, string) {
        RecordInfo memory recordInfo = recordMap[_hash];
        return (recordInfo.code, recordInfo.datetime);
    }

    function getAllHash() view public returns (string[] memory) {
        return keys;
    }
}
