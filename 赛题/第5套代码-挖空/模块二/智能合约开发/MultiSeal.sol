pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

//多人印章合约（本文件为题目附件基线，题目挖空集中在 Seal/ElectronicSeal）。
contract MultiSeal {
    string hash;
    address promoter;
    string code;
    uint number;
    address[] accounts;
    mapping(address=>RecordInfo) recordMap;
    SignStatus status;
    enum SignStatus { START, SIGNING, FINISH }
    struct RecordInfo { bool isSigned; string hash; string datetime; }

    constructor(address _address,string _code,uint _number,address[] memory _accounts) public {
        code = _code; number = _number; accounts = _accounts; promoter = _address; status = SignStatus.START;
    }
    function initSigner() public { for(uint i=0;i<accounts.length;++i) recordMap[accounts[i]]=RecordInfo(false,"0","0"); }
    function getSigner() view public returns(address) { for(uint i=0;i<accounts.length;++i) if(!recordMap[accounts[i]].isSigned) return accounts[i]; return address(0); }
    function getCode() view public returns(string) { return code; }
    function sign(address _address,string _hash,string _datetime) public { require(status==SignStatus.START||status==SignStatus.SIGNING,"status is error"); RecordInfo storage r=recordMap[_address]; r.isSigned=true; r.hash=_hash; r.datetime=_datetime; status=SignStatus.SIGNING; if(isFinish()){hash=_hash;status=SignStatus.FINISH;} }
    function signStatus() view public returns(SignStatus) { return status; }
    function isFinish() view internal returns(bool) { for(uint i=0;i<accounts.length;++i) if(!recordMap[accounts[i]].isSigned) return false; return true; }
    function multiSingInfo() view public returns(string,address,string,uint,address[] memory) { return(hash,promoter,code,number,accounts); }
    function multiSingInfoFromSigner(address _address) view public returns(string memory) { require(_address!=address(0)); for(uint i=0;i<accounts.length;++i) if(_address==accounts[i]) return code; return ""; }
}
