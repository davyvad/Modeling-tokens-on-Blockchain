pragma solidity >=0.4.25 <0.7.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/OwnershipToken.sol";

contract TestOwnershipToken {

  function testInitialBalanceUsingDeployedContract() public {
    OwnershipToken car = OwnershipToken(DeployedAddresses.OwnershipToken());

    uint expected = 1;

    Assert.equal(car.balanceOf(tx.origin), expected, "Owner should have 1 car initially");
  }

  function testInitialBalanceWithNewOwnershipToken() public {
    OwnershipToken car = new OwnershipToken("Naomie's Car", "Car", 1);

    uint expected = 1;

    Assert.equal(car.balanceOf(tx.origin), expected, "Owner should have 1 car initially");
  }

  function testSellAction() public {
    OwnershipToken car = OwnershipToken(DeployedAddresses.OwnershipToken());
    uint expected = 1;
    Assert.equal(car.balanceOf(car.address), expected,  "Owner should have 1 car initially");
    Assert.equal(car.sell(0xF801ad96A1E082eEc0F4677A6041DA1E88686E4d, 1), true, "Transaction should return true");
    expected = 0;
    Assert.equal(car.balanceOf(car.address), expected,  "The car was sent, expected balance of 0");
    expected = 1;
    Assert.equal(car.balanceOf(0xF801ad96A1E082eEc0F4677A6041DA1E88686E4d), expected,  "The car was sent, expected balance of 0");

  }

}
