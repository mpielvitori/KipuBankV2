// SPDX-License-Identifier: MIT
pragma solidity >0.8.22;

import {IOracle} from "./IOracle.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//Stub del oraculo
contract Oracle is IOracle, ERC20 {
    constructor() ERC20("Oracle", "ORC") {}

    function latestAnswer() external pure returns(int256) {
        return 411788170000;
    }

    function latestRoundData() external view returns (uint80, int256, uint256, uint256, uint80) {
        return (0, 411788170000, 0, block.timestamp, 0);
    }

    function decimals() public pure override returns (uint8) {
        return 8;
    }
}