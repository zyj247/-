// SPDX-License-Identifier: UNLICENSED
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
    bool public depositPaid;
    event AgreementSigned(address indexed _signer, bytes32 _contractHash);
    event RentPaid(address indexed _payer, uint _amount);
    event DepositPaid(address indexed _payer, uint _amount);
    event LeaseTerminated(address indexed _terminator);

    constructor(address _landlord, address _tenant, uint _leaseDuration, bytes32 _propertyHash) {
        require(_landlord != address(0) && _tenant != address(0), "zero party");
        require(_landlord != _tenant && _leaseDuration > 0, "invalid lease");
        landlord = _landlord;
        tenant = _tenant;
        leaseDuration = _leaseDuration;
        propertyHash = _propertyHash;
    }

    function signAgreement() public {
        require(msg.sender == landlord, "Only the landlord can sign the agreement.");
        require(contractHash == bytes32(0), "agreement already signed");
        leaseStartDate = block.timestamp;
        leaseEndDate = leaseStartDate + leaseDuration;
        contractHash = keccak256(abi.encodePacked(landlord, tenant, leaseStartDate,
            leaseEndDate, rentAmount, depositAmount, rentDueDate));
        emit AgreementSigned(msg.sender, contractHash);
    }

    function payRent() public payable {
        require(msg.sender == tenant, "Only the tenant can pay rent.");
        require(msg.value == rentAmount, "Incorrect rent amount.");
        require(contractHash != bytes32(0) && block.timestamp < leaseEndDate, "lease inactive");
        (bool ok, ) = payable(landlord).call{value: msg.value}("");
        require(ok, "rent transfer failed");
        emit RentPaid(msg.sender, msg.value);
    }

    function payDeposit() public payable {
        require(msg.sender == tenant, "Only the tenant can pay the deposit.");
        require(msg.value == depositAmount && !depositPaid, "Incorrect or duplicate deposit.");
        require(contractHash != bytes32(0) && block.timestamp < leaseEndDate, "lease inactive");
        depositPaid = true;
        emit DepositPaid(msg.sender, msg.value);
    }

    function terminateLease() public {
        require(msg.sender == landlord, "Only the landlord can terminate the lease.");
        require(contractHash != bytes32(0) && block.timestamp < leaseEndDate, "Lease has already ended.");
        leaseEndDate = block.timestamp;
        _returnDeposit();
        emit LeaseTerminated(msg.sender);
    }

    function withdrawDeposit() external {
        require(msg.sender == tenant && contractHash != bytes32(0) && block.timestamp >= leaseEndDate, "lease not ended");
        require(depositPaid, "no deposit");
        _returnDeposit();
    }

    function _returnDeposit() private {
        if (depositPaid) {
            depositPaid = false;
            (bool ok, ) = payable(tenant).call{value: depositAmount}("");
            require(ok, "deposit refund failed");
        }
    }
}
