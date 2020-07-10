var MyContract = artifacts.require("ItisMyToken");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(MyContract);
};