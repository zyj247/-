pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

// 多人印章合约。
contract MultiSeal {
    string hash;
    address promoter;
    string code;
    uint number;
    address[] accounts;
    mapping(address => RecordInfo) recordMap;
    SignStatus status;

    enum SignStatus { START, SIGNING, FINISH }

    struct RecordInfo {
        bool isSigned;
        string hash;
        string datetime;
    }

    constructor(address _address, string _code, uint _number, address[] memory _accounts) public {
        code = _code;
        number = _number;
        accounts = _accounts;
        promoter = _address;
        status = SignStatus.START;
    }

    function initSigner() public {
        for (uint index = 0; index < accounts.length; ++index) {
            address signer = accounts[index];
            recordMap[signer] = RecordInfo(false, "0", "0");
        }
    }

    function getSigner() view public returns (address) {
        for (uint index = 0; index < accounts.length; ++index) {
            address signer = accounts[index];
            RecordInfo storage recordInfo = recordMap[signer];
            if (!recordInfo.isSigned) return signer;
        }
        return address(0);
    }

    function getCode() view public returns (string) {
        return code;
    }

    function sign(address _address, string _hash, string _datetime) public {
        require(status == SignStatus.START || status == SignStatus.SIGNING, "status is error");
        require(recordMap[_address].isSigned == false, "signer already signed");
        bool listed = false;
        for (uint index = 0; index < accounts.length; ++index) {
            if (accounts[index] == _address) listed = true;
        }
        require(listed, "unknown signer");

        RecordInfo storage recordInfo = recordMap[_address];
        recordInfo.isSigned = true;
        recordInfo.hash = _hash;
        recordInfo.datetime = _datetime;
        status = SignStatus.SIGNING;

        if (isFinish()) {
            hash = _hash;
            status = SignStatus.FINISH;
        }
    }

    function signStatus() view public returns (SignStatus) {
        return status;
    }

    function isFinish() view internal returns (bool) {
        for (uint index = 0; index < accounts.length; ++index) {
            if (!recordMap[accounts[index]].isSigned) return false;
        }
        return accounts.length > 0;
    }

    function multiSingInfo() view public returns (string, address, string, uint, address[] memory) {
        return (hash, promoter, code, number, accounts);
    }

    function multiSingInfoFromSigner(address _address) view public returns (string memory) {
        require(_address != address(0));
        for (uint index = 0; index < accounts.length; ++index) {
            if (_address == accounts[index]) return code;
        }
        return "";
    }
}
