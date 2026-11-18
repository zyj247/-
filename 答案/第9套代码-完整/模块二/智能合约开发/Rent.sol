// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.3;

contract Rent {
    uint256 constant deposit = 3000;
    uint256 constant rent = 3000;
    uint256 constant timeLimit = 1 days;
    struct Tenant { bool deposited; bool rentPaid; uint256 depositTime; }
    struct Landlord { bool deposited; uint256 depositTime; }
    mapping(address => Tenant) public tenants;
    mapping(address => Landlord) public landlords;
    mapping(address => uint256) public refundable;

    function tenantDeposit() public payable {
        require(!tenants[msg.sender].deposited && !tenants[msg.sender].rentPaid, "Tenant has already deposited or paid rent");
        require(msg.value == deposit + rent, "Tenant must deposit both deposit and rent");
        tenants[msg.sender] = Tenant(true, true, block.timestamp);
        refundable[msg.sender] = msg.value;
    }

    // 原题没有房东与租客绑定关系，此函数保留原题“同一演示账户”统计约定。
    // 它仅标记确认，不实际转移资金；确认后不允许走超时退款。
    function landlordDeposit() public {
        require(tenants[msg.sender].deposited && tenants[msg.sender].rentPaid, "Tenant has not deposited or paid rent");
        require(!landlords[msg.sender].deposited, "Landlord has already deposited");
        require(block.timestamp <= tenants[msg.sender].depositTime + timeLimit, "confirmation expired");
        landlords[msg.sender] = Landlord(true, block.timestamp);
    }

    function checkTenantDeposit(address tenant) public view returns (bool) {
        return tenants[tenant].deposited;
    }

    function checkLandlordDeposit(address landlord) public view returns (bool) {
        return landlords[landlord].deposited;
    }

    function checkTenantDepositTime(address tenant) public view returns (uint256) {
        return tenants[tenant].depositTime;
    }

    function checkLandlordDepositTime(address landlord) public view returns (uint256) {
        return landlords[landlord].depositTime;
    }

    function checkTimeLimit() public view returns (bool) {
        return tenants[msg.sender].deposited && block.timestamp <= tenants[msg.sender].depositTime + timeLimit;
    }

    function refund() public {
        require(tenants[msg.sender].deposited && !landlords[msg.sender].deposited, "refund unavailable");
        require(block.timestamp > tenants[msg.sender].depositTime + timeLimit, "time limit not reached");
        uint amount = refundable[msg.sender];
        require(amount > 0, "nothing to refund");
        refundable[msg.sender] = 0;
        delete tenants[msg.sender];
        (bool ok, ) = payable(msg.sender).call{value: amount}("");
        require(ok, "refund failed");
    }
}
