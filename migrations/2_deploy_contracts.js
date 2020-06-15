const ConvertLib = artifacts.require("ConvertLib");
const MetaCoin = artifacts.require("MetaCoin");
// const RentalToken = artifacts.require("RentalToken");
// const ExtensionToken = artifacts.require("ExtensionToken");
// const OwnershipToken = artifacts.require("OwnershipToken");
// const SmartRentalToken = artifacts.require("SmartRentalToken");
//const SmartOwnershipToken = artifacts.require("SmartOwnershipToken");
//const A = artifacts.require("A");
//const B = artifacts.require("B");
const ExtensionInfo = artifacts.require("ExtensionInfo");

module.exports = function(deployer) {
  // deployer.deploy(ConvertLib);
  // deployer.link(ConvertLib, MetaCoin);
  // deployer.deploy(MetaCoin);

  const name = "My car";
  const symbol = "car";
  const amount = 1;
  //SmartOwnership = new SmartOwnershipToken;

  //deployer.deploy(OwnershipToken, name, symbol, amount);
  //deployer.deploy(RentalToken, name, symbol);
  
  // deployer.deploy(ExtensionToken);
  // deployer.deploy(SmartOwnershipToken, name , symbol);
  // deployer.deploy(SmartRentalToken, name, symbol);
  //deployer.deploy(A);
  //deployer.deploy(B);
  deployer.deploy(ExtensionInfo);
  //deployer.deploy(RentalToken, "rental1", "symb");

};
