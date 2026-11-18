# 第6套模块二完整答案

编译器：Solidity 0.4.25。合约来自官方 FoodTraceability 附件，包含 `FoodInfoItem.sol`、`Trace.sol`、`Producer.sol`、`Distributor.sol`、`Retailer.sol` 和 `Roles.sol`。

业务顺序：部署角色地址 → 生产商 `newFood` → 分销商 `addTraceInfoByDistributor` → 零售商 `addTraceInfoByRetailer` → `getFood`/`getTraceInfo` 查询。
