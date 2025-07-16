import { DeployFunction } from "hardhat-deploy/types";
import { typedDeployments } from "@utils";

const migrate: DeployFunction = async ({ deployments, getNamedAccounts }) => {
  // const { deploy, execute } = typedDeployments(deployments);
  // const { deployer } = await getNamedAccounts();
  //
  // console.log(deployer);
  //
  // const owner = deployer;
  // const schemaId = "0x8fd97ea8d093598a317f51f593c647b44ebaf0f07b831be36b5c1afa0e3bdbe3";
  // const fee = 1000;
  //
  // await deploy("RubyscoreFeeModule", {
  //   from: deployer,
  //   args: [owner],
  //   log: true,
  // });
  //
  // await execute("RubyscoreFeeModule", { from: deployer, log: true }, "setFees", [schemaId], [fee]);
};

migrate.tags = ["fee"];

export default migrate;
