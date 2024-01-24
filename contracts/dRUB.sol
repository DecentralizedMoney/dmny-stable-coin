// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";



contract dRUBToken is ERC20, Ownable {
    string private _tokenURI;
    uint256 public ethToTokenRate; // Курс для эмиссии токенов за Ethereum
    uint256 public tokenToEthRate; // Курс для высвобождения Ethereum за токены

    constructor(string memory name, string memory symbol, address initialOwner)
        ERC20("Decentralized RUB", "dRUB")
        Ownable(initialOwner)
    {
        name="Decentralized RUB";
        symbol="dRUB";

        //_setupDecimals(2);

        _mint(msg.sender, 108000 * (10 ** decimals()));
        _setTokenURI("https://assets.dmny.org/drub.json");
        ethToTokenRate = 162000;
        tokenToEthRate = 162000;
    }

    function tokenURI(uint256) public view returns (string memory) {
        return _tokenURI;
    }

    function _setTokenURI(string memory myTokenURI) internal {
        _tokenURI = myTokenURI;
    }

    // Функция для дополнительной эмиссии токенов
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Функция для демиссии (сжигания) токенов
    function burn(address from, uint256 amount) public onlyOwner {
        _burn(from, amount);
    }

    // Функция, вызываемая при отправке Ethereum на контракт
    receive() external payable {
        buyTokens();
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