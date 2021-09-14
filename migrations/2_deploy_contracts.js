var PetFactory = artifacts.require("./PetFactory.sol");

module.exports = function(deployer) {
  deployer.deploy(PetFactory);
};
      