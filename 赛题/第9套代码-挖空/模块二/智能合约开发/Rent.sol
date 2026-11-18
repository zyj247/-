pragma solidity 0.8.3;

contract Rent {
    uint256 constant deposit = 3000;
    uint256 constant rent = 3000;
    uint256 constant timeLimit = 1 days;
    struct Tenant { bool deposited; bool rentPaid; uint256 depositTime; }
    struct Landlord { bool deposited; uint256 depositTime; }
    mapping(address => Tenant) public tenants;
    mapping(address => Landlord) public landlords;

    /*********** 租客缴纳押金与租金接口 **********/
    // TODO
    /***
    /*********** 房东收取押金接口 **********/
    // TODO
    /***
    /*********** 租客缴纳押金情况查询接口 **********/
    // TODO
    /***
    /*********** 房东收取押金情况查询接口 **********/
    // TODO
    /***
    function checkTenantDepositTime(address tenant) public view returns (uint256) { return tenants[tenant].depositTime; }
    function checkLandlordDepositTime(address landlord) public view returns (uint256) { return landlords[landlord].depositTime; }
    function checkTimeLimit() public view returns (bool) { return block.timestamp <= tenants[msg.sender].depositTime + timeLimit; }
    function refund() public {
        // TODO: 超时且房东未确认时退还租金与押金
        ***
    }
}
