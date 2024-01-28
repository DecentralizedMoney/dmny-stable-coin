pragma solidity ^0.8.0;

import "./DividendDistributor.sol";

contract Token is ERC20 {
    DividendDistributor public dividendDistributor;

    constructor(address _dividendDistributor) ERC20("MyToken", "MTK") {
        dividendDistributor = DividendDistributor(_dividendDistributor);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        super.transfer(recipient, amount);
        dividendDistributor.setBalance(msg.sender, balanceOf(msg.sender));
        dividendDistributor.setBalance(recipient, balanceOf(recipient));
        return true;
    }

    // ... другие функции ...
}