pragma solidity >=0.4.25 <0.7.0;

// import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract OwnershipToken is ERC20 {
    constructor(string memory name, string memory symbol, uint256 amount)
        ERC20(name, symbol)
        public
    {
        _mint(tx.origin, amount);
        _setupDecimals(1);
    }

    function getBalance(address account) public view returns (uint256){
        return balanceOf(account);
    }
    
    function sell(address buyer, uint256 amount) public returns (bool) {
        transfer(buyer, amount);
    }

}
