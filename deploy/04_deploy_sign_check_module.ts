import { DeployFunction } from "hardhat-deploy/types";
import { typedDeployments } from "@utils";
import { ethers } from "hardhat";

const migrate: DeployFunction = async ({ deployments, getNamedAccounts }) => {
  const { deploy } = typedDeployments(deployments);
  const {
    deployer,
    admin,
    minter,
    veraxPortalRegistry,
    veraxModuleRegistry,
    // signCheckModule,
  } = await getNamedAccounts();

  const portalRegistry = await ethers.getContractAt("IPortalRegistry", veraxPortalRegistry);
  const moduleRegistry = await ethers.getContractAt("IModuleRegistry", veraxModuleRegistry);

  const signCheckModule = await deploy("RubyscoreSignCheckModule", {
    from: deployer,
    args: [deployer, minter],
    log: true,
  });

  const isModuleRegistered = await moduleRegistry.isRegistered(signCheckModule.address);
  if (!isModuleRegistered) {
    if (await portalRegistry.isIssuer(deployer)) {
      console.log("Register RubyscoreSignCheckModule");
      await moduleRegistry.register(
        "RubyscoreSignCheckModuleV1",
        "RubyscoreSignCheck",
        signCheckModule.address,
      );
    } else {
      console.log("!!! Deployer not issuer at portalRegistry !!!");
      return;
    }
  }

  // const singCheck = await ethers.getContractAt("RubyscoreSignCheckModule", signCheckModule);
  // const tx = await singCheck.setAuthorizedSigners("0xe4B66dBdE4A01914c404c14d19870b5102C7D8F5");
  // console.log(tx.hash);
};

migrate.tags = ["sign"];

export default migrate;
