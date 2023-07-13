# 09 Packing

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令，即可看到实际 gas 差异对比。

```bash
forge test --contracts 09_Packing/Packing.T.sol --gas-report
```

## 功能简述

以太坊虚拟机（EVM）是用连续32字节的插槽来储存变量的，当我们在一个插槽中放置多个变量，它被称为变量打包。

如果我们试图打包的变量超过当前槽的32字节限制，它将被存储在一个新的插槽（slot）中。我们必须找出哪些变量最适合放在一起，以最小化浪费的空间，尽管Solidity 自动尝试将小的基本类型打包到同一插槽中，但是糟糕的结构体成员排序可能会阻止编译器执行此操作。

在Uniswap v4的Pool合约中就用了这个技巧，将6个变量打包到一个插槽中。

```
struct Slot0 {
    // the current price
    uint160 sqrtPriceX96;
    // the current tick
    int24 tick;
    uint8 protocolSwapFee;
    uint8 protocolWithdrawFee;
    uint8 hookSwapFee;
    uint8 hookWithdrawFee;
}
```

## DemoCode

下面分别用变量打包顺序不一样的合约进行测试，观察gas差异。

```solidity
contract Normal{
    uint64 x = 5;
    uint256 y = 5;
    uint64 z = 5;
}

contract Packing {
    uint256 y = 5;
    uint64 x = 5;
    uint64 z = 5;
}
```

以下是 2 种情况下消耗的 gas 差异对比。gas 优化建议如下：

1. 在选择数据类型时，留心变量打包，如果刚好可以与其他变量打包放入一个储存插槽中，那么使用一个小数据类型是不错的。

| 变量打包   | gas 消耗  | 节省       | 结果    |
| ---------- | -------- | ---------- | ------- |
| uint64     |  133521  | 22170(≈16%)|         |
| uint256    |          |            |         |
| uint64     |          |            |         |
| ---------- | -------- | ---------- | ------- |
| uint256    |  111351  |            | ✅ 建议 |
| uint64     |          |            |         |
| uint64     |          |            |         |
