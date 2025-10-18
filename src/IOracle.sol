// SPDX-License-Identifier: MIT
pragma solidity >0.8.22;

// https://docs.chain.link/data-feeds/price-feeds/addresses?page=1&testnetPage=1
// ETH/USD 0x694AA1769357215DE4FAC081bf1f309aDC325306
interface IOracle {
    function latestAnswer() external view returns(int256);
}
