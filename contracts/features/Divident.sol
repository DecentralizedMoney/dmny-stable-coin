pragma solidity ^0.8.0;

contract DividendDistributor {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public dividendBalance;
    uint256 public totalDividends;
    uint256 public totalDistributed;
    uint256 public dividendsPerToken;
    uint256 public constant decimals = 18;

    // Функция для обновления баланса пользователя
    function setBalance(address user, uint256 balance) external {
        updateDividendBalance(user);
        balances[user] = balance;
    }

    function distributeDividends(uint256 amount) public {
        totalDividends += amount;
        dividendsPerToken += amount / totalSupply();  // Предполагается, что есть функция totalSupply()
    }

    function withdrawDividends() public {
        updateDividendBalance(msg.sender);
        uint256 owed = dividendBalance[msg.sender];
        require(owed > 0, "Нет дивидендов для снятия");
        dividendBalance[msg.sender] = 0;
        payable(msg.sender).transfer(owed);
    }

    function updateDividendBalance(address user) internal {
        uint256 owed = dividendsPerToken * balances[user] - dividendBalance[user];
        dividendBalance[user] += owed;
    }

    // ... другие функции ...
}