pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./Seal.sol";
import "./MultiSeal.sol";

contract ElectronicSeal {
    address owner;
    uint8 counter;
    mapping(address=>Seal) sealMap;
    mapping(address=>bool) signerMap;
    mapping(address=>MultiSeal) multiSealMap;
    mapping(string=>MultiSeal) multiSealHistory;
    string[] codes;
    mapping(address=>bool) promoterMap;

    event AddSealAccountEvent(address,string,string,string);
    event CancelSealAccountEvent(address);
    event SealSignature(address,string,string,string);
    constructor() public { owner=msg.sender; counter=0; }
    modifier onlyOwner(){require(owner==msg.sender,"Only owner can call");_;}
    modifier onlyPromoter(){require(promoterMap[msg.sender],"Only Promoter can call");_;}
    modifier onlySigner(){require(signerMap[msg.sender],"Only Signer can call");_;}
    modifier onlyPromoterOrSinger(){require(promoterMap[msg.sender]||signerMap[msg.sender],"Only Signer or Promoter can call");_;}

    function addSealAccount(address _account,string _name,string _cardId,string _data,string _datetime) public onlyOwner { Seal seal=new Seal(_name,_cardId,_data,_datetime); sealMap[_account]=seal; signerMap[_account]=true; counter++; emit AddSealAccountEvent(_account,_name,_cardId,_datetime); }
    function sealSignature(address _account,string _hash,string _code,string _datetime) public onlyOwner { require(_account!=address(0)); Seal seal=sealMap[_account]; if(seal.getIsUsed()){seal.signature(_hash,_code,_datetime);} emit SealSignature(_account,_hash,_code,_datetime); }
    function getSealAccount(address _account) view public returns(string,string,string){require(_account!=address(0)); return sealMap[_account].getSealInfo();}
    function querySignature(address _account,string _hash) view public returns(string,string){require(_account!=address(0));return sealMap[_account].getRecord(_hash);}
    function queryAllHash(address _account) view public returns(string[] memory){require(_account!=address(0));return sealMap[_account].getAllHash();}
    function cancelSealAccount(address _account) public onlyOwner {require(_account!=address(0));signerMap[_account]=false;sealMap[_account].setIsUsed(false);counter--;emit CancelSealAccountEvent(_account);}
    function getSealData(address _account) view public onlyOwner returns(string){require(_account!=address(0));return sealMap[_account].getSealData();}
    function getSealAccountCounter() view public onlyOwner returns(uint){return counter;}
    function addPromoter(address _address) public onlyOwner {require(_address!=address(0));promoterMap[_address]=true;}
    function isPromoter(address _address) public view onlyOwner returns(bool){require(_address!=address(0));return promoterMap[_address];}
    function startMultiSign(string _code,uint _number,address[] memory _accounts) public onlyPromoter {require(address(multiSealMap[msg.sender])==address(0));require(!isExistMultiCode(_code),"code is exist.");MultiSeal m=new MultiSeal(msg.sender,_code,_number,_accounts);m.initSigner();multiSealMap[msg.sender]=m;}
    function doMultiSign(address _address,string _hash,string _datetime) public onlyPromoter {
        //①判断传入的签章人账户地址不能为空
        //②获取多人签章合约对象实例
        //③获取当前等待签章账户地址
        //④判断合约调用者是否为等待签章人账户地址
        //⑤进行签章
    }
    function finishMultiSign() public onlyPromoter {MultiSeal m=multiSealMap[msg.sender];require(m.signStatus()==MultiSeal.SignStatus.FINISH,"status is signing.");string memory code=m.getCode();multiSealHistory[code]=m;codes.push(code);multiSealMap[msg.sender]=MultiSeal(address(0));}

    //@@GET:题目只挖以下函数体，编号从①重新开始。
    function getMultiSingInfo(string _code) public view onlyPromoterOrSinger returns(string,address,string,uint,address[] memory) {
        //①获取多人签章合约对象实例
        //②返回多人签章信息
    }

    function isExistMultiCode(string _code) view internal returns(bool) {
        //①遍历所有多人签章文件编号并与传入签章文件编号参数进行比较
        //②返回不存在
    }
}
