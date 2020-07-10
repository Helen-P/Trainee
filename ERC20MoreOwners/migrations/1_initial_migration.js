const Migrations = artifacts.require("Migrations");
const Owned = artifacts.require("Owned");
module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(Owned);
};
