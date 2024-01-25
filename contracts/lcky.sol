// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";



contract LCKYToken is ERC20, Ownable {
    string private _tokenURI;
    uint256 public ethToTokenRate; // Курс для эмиссии токенов за Ethereum
    uint256 public tokenToEthRate; // Курс для высвобождения Ethereum за токены

    uint256 public totalMinted; // Общее количество выпущенных токенов
    uint256 public lastMintTime; // Время последнего выпуска токенов
    uint256 constant MAX_SUPPLY = 108000000000 * (10 ** 18); //(10 ** decimals()); // Максимальный предел выпуска
    uint256 constant PROGRESSION_DENOMINATOR = 2; // Знаменатель прогрессии

    constructor(string memory name, string memory symbol, address initialOwner)
        ERC20("LUCKY Coin", "LCKY")
        Ownable(initialOwner)
    {
        name="LUCKY Coin";
        symbol="LCKY";

        //_setupDecimals(18);

        //lastMintTime = block.timestamp; // Установка начального времени выпуска
        lastMintTime = 1660780800; // Джанмаштами UNIX timestamp для 18 августа 2022 года, 00:00 UTC
        totalMinted = 0; // Начальное количество выпущенных токенов
        
        _mint(msg.sender, 1080 * (10 ** decimals()));
        _setTokenURI("https://assets.dmny.org/lcky.json");

        ethToTokenRate = 1800 * (10 ** decimals());
        tokenToEthRate = 2600 * (10 ** decimals());
        autoMint(); // Автоэмиссия

    }

    function tokenURI(uint256) public view returns (string memory) {
        return _tokenURI;
    }

    function _setTokenURI(string memory myTokenURI) internal {
        _tokenURI = myTokenURI;
    }

    function autoMint() internal {
        uint256 timeElapsed = block.timestamp - lastMintTime;
        if (timeElapsed > 0) {
            uint256 remainingSupply = MAX_SUPPLY - totalMinted;
            uint256 firstTerm = remainingSupply / PROGRESSION_DENOMINATOR;
            //Переделать формулу с учетом целых чисел и деления
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

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal override {
        autoMint(); // Автоматическая эмиссия перед переводом
        super._transfer(sender, recipient, amount); // Стандартный перевод ERC20
    }

    // Функция для дополнительной эмиссии токенов
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
        autoMint(); // Автоэмиссия
    }

    // Функция для демиссии (сжигания) токенов
    function burn(address from, uint256 amount) public onlyOwner {
        _burn(from, amount);
        autoMint(); // Автоэмиссия
    }

    // Функция, вызываемая при отправке Ethereum на контракт
    receive() external payable {
        buyTokens();
    }

    // Функция для покупки токенов за Ethereum
    function buyTokens() public payable {
        uint256 tokensToMint = (msg.value * ethToTokenRate) / (10 ** decimals());
        _mint(msg.sender, tokensToMint);
        autoMint(); // Автоэмиссия
    }

    function sellTokens(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Not enough tokens");
        uint256 ethToReturn = (amount * tokenToEthRate) / (10 ** decimals());
         _burn(msg.sender, amount);
        payable(msg.sender).transfer(ethToReturn);
        autoMint(); // Автоэмиссия
    }

    // Функции для установки курсов
    function setEthToTokenRate(uint256 newRate) public onlyOwner {
        ethToTokenRate = newRate;
        autoMint(); // Автоэмиссия
    }

    function setTokenToEthRate(uint256 newRate) public onlyOwner {
        tokenToEthRate = newRate;
        autoMint(); // Автоэмиссия
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

