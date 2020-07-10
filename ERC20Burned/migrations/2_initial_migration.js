const Burn = artifacts.require("ERC20Burned.sol");

module.exports = function(deployer) {
  deployer.deploy(Burn);
};
