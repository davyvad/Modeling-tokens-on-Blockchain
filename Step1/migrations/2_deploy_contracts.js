const OwnershipToken = artifacts.require("OwnershipToken");
const RentalToken = artifacts.require("RentalToken");

module.exports = function(deployer) {

  const name = "My car";
  const symbol = "car";
  const array = ['0xBC57c3B9724E412669d6379B5f84Fbba2e6Fb30B'];
  const time = 3;
  deployer.deploy(OwnershipToken, name, symbol);
  deployer.deploy(RentalToken, name, symbol, array, time );

};
