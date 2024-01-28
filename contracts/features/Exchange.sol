// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenExchange is ERC20, Ownable {
    uint256 public ethToTokenRate; // Курс для эмиссии токенов за Ethereum
    uint256 public tokenToEthRate; // Курс для высвобождения Ethereum за токены

    constructor(uint256 initialEthToTokenRate, uint256 initialTokenToEthRate) {
        ethToTokenRate = initialEthToTokenRate;
        tokenToEthRate = initialTokenToEthRate;
    }

    // Функция для покупки токенов за Ethereum
    function buyTokens() public payable {
        uint256 tokensToMint = (msg.value * ethToTokenRate) * 10**decimals();
        _mint(msg.sender, tokensToMint);
    }

    function sellTokens(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Not enough tokens");
        uint256 ethToReturn = (amount * 10**decimals()) / tokenToEthRate;
        _burn(msg.sender, amount);
        payable(msg.sender).transfer(ethToReturn);
    }

    // Функции для установки курсов
    function setEthToTokenRate(uint256 newRate) public onlyOwner {
        ethToTokenRate = newRate;
    }

    function setTokenToEthRate(uint256 newRate) public onlyOwner {
        tokenToEthRate = newRate;
    }

    // Функция для получения текущего курса Ethereum к токену
    function getCurrentEthToTokenRate() public view returns (uint256) {
        return ethToTokenRate;
    }

    // Функция для получения текущего курса токена к Ethereum
    function getCurrentTokenToEthRate() public view returns (uint256) {
        return tokenToEthRate;
    }
}