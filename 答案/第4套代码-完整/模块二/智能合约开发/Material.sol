// SPDX-License-Identifier: MIT
pragma solidity 0.6.10;

// 原材料合约
contract Material {
    struct MaterialInfo {
        address owner;
        string name;
        string id;
        string memo;
        uint createdAt;
        bool exist;
    }

    mapping(string => MaterialInfo) public materials;

    // 初始化原材料信息并上链，返回本存证管理合约地址。
    function newMaterial(string memory _name, string memory _id, string memory _memo)
        public
        returns (address)
    {
        require(!materials[_id].exist, "Material id already exists");
        materials[_id] = MaterialInfo(msg.sender, _name, _id, _memo, block.timestamp, true);
        return address(this);
    }

    // 按原材料编号获取存证信息。
    function getMaterial(string memory id)
        public
        view
        returns (address, string memory, string memory, string memory, uint, bool)
    {
        MaterialInfo storage m = materials[id];
        return (m.owner, m.name, m.id, m.memo, m.createdAt, m.exist);
    }
}
