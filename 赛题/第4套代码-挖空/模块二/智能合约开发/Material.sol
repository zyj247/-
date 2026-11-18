pragma solidity 0.6.10;

// 原材料合约
contract Material {
    struct Material{
        address  owner;
        string  name;
        string  id;
        string  memo;
        uint  createdAt;
        bool exist;
    }

    mapping(string => Material) public materials;

    // 可自行添加形参和返回值
    // 编写原材料接口 newMaterial，初始化原材料信息，返回合约地址，并实现原材料信息上链功能
    function newMaterial (string memory _name, string memory _id,...) public {
        // TODO
        ***
    }

    // 可自行添加形参和返回值
    // 编写获取存证信息接口 getMaterial，根据合约地址获取原材料信息
    function getMaterial(string memory id) public view returns  (...) {
        // TODO
        ***
    }
}
