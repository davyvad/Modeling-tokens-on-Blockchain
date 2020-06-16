const ConvertLib = artifacts.require("ConvertLib");
const MetaCoin = artifacts.require("MetaCoin");
// const RentalToken = artifacts.require("RentalToken");
// const ExtensionToken = artifacts.require("ExtensionToken");
// const OwnershipToken = artifacts.require("OwnershipToken");
// const SmartRentalToken = artifacts.require("SmartRentalToken");
//const SmartOwnershipToken = artifacts.require("SmartOwnershipToken");
const DynamicOwnership = artifacts.require("DynamicOwnership");
//const B = artifacts.require("B");
const ExtensionInfo = artifacts.require("ExtensionInfo");
const Extension = artifacts.require("Extension");

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
  deployer.deploy(DynamicOwnership);
  // deployer.deploy(B);
  deployer.deploy(ExtensionInfo);
  deployer.deploy(Extension);
  //deployer.deploy(RentalToken, "rental1", "symb");

};
