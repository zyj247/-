# GZ036 第10套模块二挖空版：职工养老保险

本目录保留题目要求的 `TODO`、`***` 和 `①/②/③` 编号；挖空位置没有把官方答案整段复制进来。对应答案在工作区的 `答案\第10套代码-完整\模块二\智能合约开发` 目录。

## 文件和补全目标

- `PensionAccount.sol`：补全按题目顺序调用本地公安/劳动/社保 stub 并存储人员信息。
- `PensionInsurance.sol`：补全添加职工/雇主账户、按3200至24000缴费基数计算8%/19%缴费、减员。
- `PensionTransfer.sol`：补全申请转移、停缴核验、接收三类养老保险资金/账户数据。

## 编译

目标编译器为 Solidity `0.8.3`：

```powershell
solc --version
solc --base-path . --bin --abi PensionAccount.sol PensionInsurance.sol PensionTransfer.sol
```

挖空版按题意不能直接编译，原因是 `TODO` 和 `***` 是待补代码占位符；请参考对应答案版完成后再编译。外部部门接口以确定性的本地 stub 代替，详见答案目录 README。
