pragma solidity 0.8.3;

contract RentalAgreement {
    address public landlord;
    address public tenant;
    uint public rentAmount = 3000;
    uint public depositAmount = 3000;
    uint public rentDueDate = 16;
    uint public leaseStartDate;
    uint public leaseEndDate;
    uint public leaseDuration;
    bytes32 public contractHash;
    bytes32 public propertyHash;
    event AgreementSigned(address indexed _signer, bytes32 _contractHash);
    event RentPaid(address indexed _payer, uint _amount);
    event DepositPaid(address indexed _payer, uint _amount);
    event LeaseTerminated(address indexed _terminator);
    constructor(address _landlord, address _tenant, uint _leaseDuration, bytes32 _propertyHash) {
        landlord = _landlord; tenant = _tenant; leaseDuration = _leaseDuration; propertyHash = _propertyHash;
    }
    /*********** 房东签署合同接口开发 **********/
    // TODO
    /***
    /*********** 租金支付接口开发 **********/
    // TODO
    /***
    function payDeposit() public payable {
        require(msg.sender == tenant, "Only the tenant can pay the deposit.");
        require(msg.value == depositAmount, "Incorrect deposit amount.");
        emit DepositPaid(msg.sender, msg.value);
    }
    function terminateLease() public {
        require(msg.sender == landlord, "Only the landlord can terminate the lease.");
        require(block.timestamp < leaseEndDate, "Lease has already ended.");
        leaseEndDate = block.timestamp;
        emit LeaseTerminated(msg.sender);
    }
}
