// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AutoMint {
    uint256 public lastMintTime;
    uint256 public totalMinted;
    uint256 public maxSupply;

    constructor(uint256 _maxSupply) {
        maxSupply = _maxSupply;
    }

    function autoMint() internal {
        uint256 timeElapsed = block.timestamp - lastMintTime;
        if (timeElapsed > 0) {
            uint256 remainingSupply = maxSupply - totalMinted;
            uint256 firstTerm = remainingSupply / PROGRESSION_DENOMINATOR;
            // Переделать формулу с учетом целых чисел и деления
            uint256 r = 1 / PROGRESSION_DENOMINATOR;

            // Вычисление суммы членов геометрической прогрессии
            uint256 mintAmount = firstTerm * (1 - (r ** timeElapsed)) / (1 - r);

            if (mintAmount > 0) {
                _mint(owner(), mintAmount);
                totalMinted += mintAmount;
                lastMintTime = block.timestamp;
            }
        }
    }
}
