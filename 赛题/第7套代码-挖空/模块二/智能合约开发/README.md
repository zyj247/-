# GZ036 第7套模块二挖空版：航班延误保险

本目录保留题目要求的 `TODO`、`***` 和 `①/②/③` 编号；挖空位置没有把官方答案整段复制进来。对应答案在工作区的 `答案\第7套代码-完整\模块二\智能合约开发` 目录。

## 文件和补全目标

- `FlightDelayInsurance.sol`：补全购票后30分钟内支付准确保费、投保状态上链、赔偿金未预存时退保退款。
- `FlightManagement.sol`：补全 `getFlight` 和 `isDelayedOverFourHours`。
- `Claims.sol`：补全延误达到4小时的客户理赔，以及未达到4小时的保险公司收取保费/退还赔偿金。

## 编译

目标编译器为 Solidity `0.8.3`：

```powershell
solc --version
solc --base-path . --include-path . --bin --abi FlightDelayInsurance.sol FlightManagement.sol Claims.sol
```

挖空版按题意不能直接编译，原因是 `TODO` 和 `***` 是待补代码占位符；请参考同目录结构的答案版完成后再编译。`Claims.sol` 依赖同目录 `FlightDelayInsurance.sol`。

## 本地 stub 和调用顺序

外部航班数据库、保险平台以合约中的可信地址和链上字段作确定性本地 stub。完整调用顺序、余额单位和官方答案差异见答案目录 README。金额单位是 wei，时间单位是秒。
