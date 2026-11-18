pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./Seal.sol";
import "./MultiSeal.sol";

contract ElectronicSeal {
    address owner;
    uint8 counter;
    mapping(address => Seal) sealMap;
    mapping(address => bool) signerMap;
    mapping(address => MultiSeal) multiSealMap;
    mapping(string => MultiSeal) multiSealHistory;
    string[] codes;
    mapping(address => bool) promoterMap;

    event AddSealAccountEvent(address, string, string, string);
    event CancelSealAccountEvent(address);
    event SealSignature(address, string, string, string);

    constructor() public { owner = msg.sender; counter = 0; }

    modifier onlyOwner() { require(owner == msg.sender, "Only owner can call"); _; }
    modifier onlyPromoter() { require(promoterMap[msg.sender], "Only Promoter can call"); _; }
    modifier onlySigner() { require(signerMap[msg.sender], "Only Signer can call"); _; }
    modifier onlyPromoterOrSinger() { require(promoterMap[msg.sender] || signerMap[msg.sender], "Only Signer or Promoter can call"); _; }

    function addSealAccount(address _account, string _name, string _cardId, string _data, string _datetime) public onlyOwner {
        require(_account != address(0));
        require(!signerMap[_account], "Already registered");
        sealMap[_account] = new Seal(_name, _cardId, _data, _datetime);
        signerMap[_account] = true;
        require(counter < uint8(-1), "counter overflow");
        counter++;
        emit AddSealAccountEvent(_account, _name, _cardId, _datetime);
    }

    function sealSignature(address _account, string _hash, string _code, string _datetime) public onlyOwner {
        require(_account != address(0));
        Seal seal = sealMap[_account];
        require(signerMap[_account] && seal.getIsUsed(), "Seal account is inactive");
        seal.signature(_hash, _code, _datetime);
        emit SealSignature(_account, _hash, _code, _datetime);
    }

    function getSealAccount(address _account) view public returns (string, string, string) {
        require(_account != address(0));
        return sealMap[_account].getSealInfo();
    }

    function querySignature(address _account, string _hash) view public returns (string, string) {
        require(_account != address(0));
        return sealMap[_account].getRecord(_hash);
    }

    function queryAllHash(address _account) view public returns (string[] memory) {
        require(_account != address(0));
        return sealMap[_account].getAllHash();
    }

    function cancelSealAccount(address _account) public onlyOwner {
        require(_account != address(0) && signerMap[_account], "Account is inactive");
        signerMap[_account] = false;
        sealMap[_account].setIsUsed(false);
        counter--;
        emit CancelSealAccountEvent(_account);
    }

    function getSealData(address _account) view public onlyOwner returns (string) {
        require(_account != address(0));
        return sealMap[_account].getSealData();
    }

    function getSealAccountCounter() view public onlyOwner returns (uint) { return counter; }

    function addPromoter(address _address) public onlyOwner {
        require(_address != address(0));
        promoterMap[_address] = true;
    }

    function isPromoter(address _address) public view onlyOwner returns (bool) {
        require(_address != address(0));
        return promoterMap[_address];
    }

    function startMultiSign(string _code, uint _number, address[] memory _accounts) public onlyPromoter {
        require(address(multiSealMap[msg.sender]) == address(0));
        require(!isExistMultiCode(_code), "code is exist.");
        require(_accounts.length > 0 && _number == _accounts.length, "invalid signer count");
        MultiSeal multiSeal = new MultiSeal(msg.sender, _code, _number, _accounts);
        multiSeal.initSigner();
        multiSealMap[msg.sender] = multiSeal;
    }

    function doMultiSign(address _address, string _hash, string _datetime) public onlyPromoter {
        require(_address != address(0));
        MultiSeal multiSeal = multiSealMap[msg.sender];
        address signer = multiSeal.getSigner();
        require(signer == _address, "signer is incorrect");
        multiSeal.sign(_address, _hash, _datetime);
    }

    function finishMultiSign() public onlyPromoter {
        MultiSeal multiSeal = multiSealMap[msg.sender];
        require(address(multiSeal) != address(0));
        require(multiSeal.signStatus() == MultiSeal.SignStatus.FINISH, "status is signing.");
        string memory code = multiSeal.getCode();
        multiSealHistory[code] = multiSeal;
        codes.push(code);
        multiSealMap[msg.sender] = MultiSeal(address(0));
    }

    function getMultiSingInfo(string _code) public view onlyPromoterOrSinger returns (string, address, string, uint, address[] memory) {
        MultiSeal multiSeal = multiSealHistory[_code];
        require(address(multiSeal) != address(0), "code not found");
        return multiSeal.multiSingInfo();
    }

    function getCodes() view public onlyOwner returns (string[] memory) { return codes; }

    function getSingInfoFromSigner() view public onlySigner returns (string[] memory) {
        string[] memory matches = new string[](codes.length);
        uint count = 0;
        for (uint i = 0; i < codes.length; i++) {
            MultiSeal multiSeal = multiSealHistory[codes[i]];
            if (keccak256(bytes(codes[i])) == keccak256(bytes(multiSeal.multiSingInfoFromSigner(msg.sender)))) {
                matches[count++] = codes[i];
            }
        }
        string[] memory result = new string[](count);
        for (uint j = 0; j < count; j++) result[j] = matches[j];
        return result;
    }

    function isExistMultiCode(string _code) view internal returns (bool) {
        for (uint index = 0; index < codes.length; ++index) {
            if (keccak256(bytes(_code)) == keccak256(bytes(codes[index]))) return true;
        }
        return false;
    }
}
