const fs = require('fs');
const path = require('path');
const root = path.resolve(__dirname, '..');
const src = 'C:/Users/ZYJ/AppData/Local/Temp/opencode/ext56/set6/GZ036 区块链技术应用赛项赛题第6套附件/代码/FoodTraceability/contract';
const answer = path.join(root,'答案/第6套代码-完整/模块二/智能合约开发');
const exam = path.join(root,'赛题/第6套代码-挖空/模块二/智能合约开发');
fs.mkdirSync(answer,{recursive:true});fs.mkdirSync(exam,{recursive:true});
for (const file of ['FoodInfoItem.sol','Trace.sol']) fs.copyFileSync(path.join(src,file),path.join(answer,file));
for (const file of ['Producer.sol','Distributor.sol','Retailer.sol']) fs.copyFileSync(path.join(answer,file),path.join(exam,file));
let f = fs.readFileSync(path.join(answer,'FoodInfoItem.sol'),'utf8');
const start=f.indexOf('    uint[] _timestamp;');
const end=f.indexOf('  constructor ');
f=f.slice(0,start)+`    //①保存食品流转过程中各个阶段的时间戳
    //②保存食品流转过程各个阶段的用户名
    //③保存食品流转过程各个阶段的用户地址信息（和用户一一对应）
    //④保存食品流转过程中各个阶段的质量
    //⑤食品名称
    //⑥当前用户名称
    //⑦质量（0=优质 1=合格 2=不合格）
    //⑧状态（0:生产 1:分销 2:出售）
    //⑨初始化owner

`+f.slice(end);
f=f.replace('string traceName, address distributor, uint8 quality','①, uint8 quality')
 .replace('string traceName, address retailer, uint8 quality','①, uint8 quality')
 .replaceAll('require(_owner == msg.sender, "only trace contract can invoke");','②')
 .replace('_traceAddress.push(distributor);','③')
 .replace('_traceAddress.push(retailer);','③')
 .replaceAll('_quality = quality;\n        _traceQuality.push(_quality);','④\n        _traceQuality.push(_quality);');
fs.writeFileSync(path.join(exam,'FoodInfoItem.sol'),f);
let t=fs.readFileSync(path.join(answer,'Trace.sol'),'utf8');
t=t.replace('function newFood(string name, uint256 traceNumber, string traceName, uint8 quality)','function newFood(①, string traceName, uint8 quality)')
 .replace('public onlyProducer returns(address)','public ② returns(③)')
 .replace(/            require\(foods\[traceNumber\] == address\(0\), "traceNumber already exist"\);\s*FoodInfoItem food = new FoodInfoItem\(name, traceName, quality, msg.sender\);\s*foods\[traceNumber\] = food;\s*foodList.push\(traceNumber\);\s*return food;/,'            ④\n            ⑤\n            ⑥\n            ⑦\n            ⑧')
 .replace('function addTraceInfoByDistributor(uint256 traceNumber, string traceName, uint8 quality)','function addTraceInfoByDistributor(①, uint8 quality)')
 .replace('public onlyDistributor returns(bool)','public ② returns(bool)')
 .replace('require(foods[traceNumber] != address(0), "traceNumber does not exist");\n            return FoodInfoItem(foods[traceNumber]).addTraceInfoByDistributor( traceName, msg.sender, quality);','③\n            return FoodInfoItem(foods[traceNumber]).④, quality);')
 .replace('function addTraceInfoByRetailer(uint256 traceNumber, string traceName, uint8 quality)','function addTraceInfoByRetailer(①, uint8 quality)')
 .replace('public onlyRetailer returns(bool)','public ② returns(bool)')
 .replace('return FoodInfoItem(foods[traceNumber]).addTraceInfoByRetailer(traceName, msg.sender, quality);','return FoodInfoItem(foods[traceNumber]).④, quality);');
const retail=t.indexOf('function addTraceInfoByRetailer(');const retEnd=t.indexOf('//获取食品溯源信息接口',retail);
t=t.slice(0,retail)+t.slice(retail,retEnd).replace('require(foods[traceNumber] != address(0), "traceNumber does not exist");','require(③, "traceNumber does not exist");')+t.slice(retEnd);
fs.writeFileSync(path.join(exam,'Trace.sol'),t);
fs.writeFileSync(path.join(exam,'Roles.sol'),`pragma solidity ^0.4.25;
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
`);
console.log('Set6: six answer sources and six matching exam sources written.');
