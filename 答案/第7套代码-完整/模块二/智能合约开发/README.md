# GZ036 第7套模块二：航班延误保险

## 文件

- `FlightDelayInsurance.sol`：购票、30分钟内购险、保险公司2小时内预存赔偿金、退保、生成保单。
- `FlightManagement.sol`：本地航班信息存证、实际起飞时间更新、航班查询和4小时延误判定。
- `Claims.sol`：继承 `FlightDelayInsurance`，由可信航司/保险公司更新航班，按延误条件执行理赔或保险公司收取保费。

## 编译

目标编译器为 Solidity `0.8.3`。在本目录执行：

```powershell
solc --version
solc --base-path . --include-path . --bin --abi FlightDelayInsurance.sol FlightManagement.sol Claims.sol
```

`Claims.sol` 依赖同目录的 `FlightDelayInsurance.sol`，不要单独复制到没有该文件的目录。若使用 Hardhat/Foundry，请将这三个文件放入同一 sources 目录并固定 compiler 为 `0.8.3`。

## 本地部署/调用顺序

1. 部署 `FlightDelayInsurance`：构造参数依次为平台地址、航空公司地址、保险公司地址、保费、赔偿金。
2. 乘客调用 `purchaseTicket()`，再在购票后30分钟内以 `premium` wei 调用 `purchaseInsurance()`。
3. 保险公司以 `compensation` wei 调用 `depositCompensation()`，平台随后调用 `generatePolicy()`。
4. 部署 `FlightManagement`，由部署者添加航班并更新实际起飞时间。`getFlight()` 和 `isDelayedOverFourHours()` 为查询接口。
5. 部署 `Claims`（同样的5个构造参数）。向 Claims 合约补充至少 `premium + compensation` wei；可信航司或保险公司调用 `updateFlight()`。延误达到4小时，投保人调用 `claim()`；否则保险公司调用 `collectPremium()`。

金额单位是 wei，时间单位是 Solidity 的秒单位。这里的“外部部门/航班数据库”以确定性的链上 stub 和可信地址校验替代，生产环境应接入经签名的预言机/业务网关。

## 与官方答案的实现差异

- 将原答案中以全局 `purchaseTime` 判断所有用户的做法修正为每个乘客记录 `ticketPurchaseTime`。
- 将“2小时预存”基于投保时间 `purchaseTime`，避免 `depositTime` 尚未赋值导致永不过期。
- 补齐 Claims 的正确继承构造器、余额检查、单次结算和可信航班更新。
- 理赔/收款显式使用合约余额，并用 `settled` 防止重复支付。

## 测试声明

本目录附带的检查脚本只做源码结构、接口和挖空标记检查；本次没有宣称已连接 Geth、私链或已运行链上交易测试。若本机安装 solc，可另行按上面的命令编译验证。
