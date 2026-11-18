pragma solidity ^0.4.25;
library Roles {
    struct Role { mapping(address => bool) bearer; }
    function add(①, address account) ② {
        require(!③, "Roles: account already has role");
        role.④ = true;
    }
    function remove(①, address account) ② {
        require(③, "Roles: account does not have role");
        role.④ = false;
    }
    function has(①, address account) ② returns (bool) {
        require(③, "Roles: account is the zero address");
        return role.④;
    }
}
