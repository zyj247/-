# GZ036 第10套模块二：职工养老保险

## 文件

- `PensionAccount.sol`：按题目顺序调用确定性的公安、劳动、社保本地 stub，生成养老保险账户资料。
- `PensionInsurance.sol`：管理员添加职工/雇主、设置工资、给雇主记账、按缴费基数和8%/19%缴费、减员。
- `PensionTransfer.sol`：参保人申请转移，社保局核验停缴状态，转出并接收个人基金、统筹基金和养老保险账户。

## 编译

目标编译器为 Solidity `0.8.3`：

```powershell
solc --version
solc --base-path . --bin --abi PensionAccount.sol PensionInsurance.sol PensionTransfer.sol
```

## 本地调用顺序

1. 部署 `PensionAccount`，部署者是平台管理员，调用 `generatePensionAccount(idNumber)`。
2. 部署 `PensionInsurance`，部署者是初始管理员/雇主。调用 `addEmployee()`、`addEmployer()`、`setSalary()`、`creditEmployer()`，再调用 `makePayment()`。默认工资为5000；工资低于3200按3200计，高于24000按24000计；个人缴费8%，统筹缴费19%。
3. 部署 `PensionTransfer`。源/目标社保局分别调用 `registerBureau()`；平台/测试夹具可用 `seedAccount()` 初始化账户。参保人调用 `applyTransfer()`，源局调用 `authorizeTransfer(applicationId, true)`，转出时调用 `transferAccount()` 获取三类基金，目标局调用 `receiveAccount()` 写入接收账户。

## 外部接口 stub

题目要求的公安部门、劳动部门和社保局查询在官方答案中没有可部署接口。本实现用 `PensionAccount` 内部纯函数返回固定、确定性测试数据，以保证单文件可编译、可离线复现。真实部署应改成授权的部门适配器和签名验证。`PensionInsurance` 的余额是链上账本字段，不代表真实银行余额。

## 与官方答案的实现差异

- 修复官方答案费用合约中“新账户余额必须大于0”的存在性判断，改为显式 `exists`。
- 采用独立 `active` 字段实现减员，避免官方 `personalBalance > 0` 与随后 `personalBalance == 0` 的互斥条件。
- 转移申请使用 storage 写回，按申请 ID 操作；避免官方答案将 storage 内容复制到 memory 后修改但不落链。
- 将“停缴”为 `true` 定义为可转移条件，并显式登记源/目标社保局；基金转出和目标接收分为两个可审计步骤。

## 测试声明

本目录附带的检查脚本只做源码结构、接口和挖空标记检查；本次没有宣称已连接 Geth、私链或已运行链上交易测试。若本机安装 solc，可按上面的命令编译。
