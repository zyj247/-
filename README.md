# GZ036 模块二 · 合约离线编译与本地 EVM 验证工具

GZ036 模块二（第 4–10 套）Solidity 合约题的**离线编译 / 本地部署 / 冒烟验证**工具链。
不依赖任何在线 IDE 或测试网，全部在本机用 Ganache 内存链跑通。

## 目录结构

```
.
├── 赛题/            第4–10套「挖空版」题目合约（待填空）
├── 答案/            第4–10套「完整版」参考实现
├── tools/           编译、部署、验证脚本
├── package.json     依赖与命令
└── README.md
```

`第N套代码-挖空` 是对外练习用的题目骨架，`第N套代码-完整` 是对应的参考答案。

## 快速开始

需要 Node.js 18+。

```bash
# 1. 安装依赖（首次约 300 MB，含三套 solc 与 Ganache）
npm install

# 2. 编译全部合约
npm run compile

# 3. 在本地 EVM 上部署并跑冒烟测试
npm test
```

`npm install` 会拉取三个版本的编译器（`solc@0.4.25` / `0.6.10` / `0.8.3`，分别以别名
`solc-0425`、`solc-0610`、`solc-083` 安装），因为 GZ036 各套题目锁定的 solidity 版本不同。

## 脚本说明

| 脚本 | 作用 |
| --- | --- |
| `npm run compile` | 按题目中的 pragma 自动选择对应 solc 版本编译 |
| `npm test` | 启动 Ganache 内存链，部署合约并执行断言 |

`tools/` 下的辅助脚本（按需单独运行）：

- `compile-all.cjs` —— 批量编译所有套题
- `compile-old.cjs` / `compile4.cjs` —— 针对 0.4.x / 老版本语法的编译入口
- `complete6.cjs` —— 第 6 套的补全/校验脚本
- `deploy-smoke-all.cjs` —— 全量部署冒烟
- `inspect-solc0425.cjs` —— 检查 0.4.25 编译器可用性
- `test4.cjs` —— 第 4 套的单元验证

## 不想装 Node 环境？

到仓库的 **Releases** 页面下载 `gz036-module2-full.zip`（已内置 `node_modules`），
解压后直接 `npm test` 即可运行，无需联网安装依赖。

## 说明

题库内容仅用于课程练习与自测。答案目录请先自行完成再看。
