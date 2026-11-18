# 第8套模块二完整答案

编译器：Solidity 0.8.3。合约按题目给出的信息管理、病历管理和病历查看三个合约拆分。

- `MedicalDataSharingPlatform.sol`：患者注册、个人信息查询、预约信息记录。
- `MedicalRecordManagement.sol`：开始就诊、更新病例、填写病史、结束就诊。
- `MedicalRecords.sol`：个人信息、既往病史和病情描述查询。

题目原示例用低级 call 向患者地址发送字符串，这会让普通账户回退；完整版把预约文本先写入 `appointments`，并保留无值 call 作为兼容性检查。平台链和前端接口仍需在题目环境中配置。
