// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./TokenExchange.sol";

contract dUSDToken is ERC20, Ownable, TokenExchange {
    string private _tokenURI;

    constructor(
        address initialOwner,
        uint256 initialEthToTokenRate,
        uint256 initialTokenToEthRate
    )
        ERC20("USD Decentralized", "USDD")
        Ownable(initialOwner)
        TokenExchange(initialEthToTokenRate, initialTokenToEthRate)
    {
        _mint(msg.sender, 1080 * (10 ** decimals()));
        _setTokenURI("https://assets.dmny.org/dusd.json");
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
}