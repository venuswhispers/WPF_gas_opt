# 10 使用更好的递增

## 运行

根据[Foundry 官方文档](https://getfoundry.sh/)配置好运行环境后，于本项目下执行下列命令，即可看到实际 gas 差异对比。

```bash
forge test --contracts 10_Increment/Increment.T.sol --gas-report
```

## 功能简述

递增是我们在合约中经常用到的功能，常见的递增方式有如下几种

- num += 1
- num = num +1
- num++
- ++num

## DemoCode

下面分别用几种形式进行递增，来观察其 gas 差异。

```solidity
contract Increment1 {
    function increment1() external pure {
        uint num;
        num += 1;
    }
}

contract Increment2 {
    function increment2() external pure {
        uint num;
        num = num + 1;
    }
}

contract Increment3 {
    function increment3() external pure {
        uint num;
        num++;
    }
}

contract Increment4 {
    function increment4() external pure {
        uint num;
        ++num;
    }
}
```

以下是测试后的情况，建议递增使用 `++i`;

| 数据类型 | gas 消耗 | 节省     | 结果    |
| -------- | -------- | -------- | ------- |
| i += 1   | 204      |          |         |
| i = i +1 | 204      |          |         |
| i++      | 198      |          |         |
| ++i      | 193      | 5 (≈3%) | ✅ 建议 |
