var GlobalToken = artifacts.require("./GlobalToken.sol");

module.exports = function(deployer){
    deployer.deploy(GlobalToken, "Global", "GLB");
}