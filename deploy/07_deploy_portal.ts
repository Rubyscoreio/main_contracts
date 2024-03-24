import { DeployFunction } from "hardhat-deploy/types";
import { typedDeployments } from "@utils";

const migrate: DeployFunction = async ({ deployments, getNamedAccounts }) => {
  const { deploy } = typedDeployments(deployments);
  const { deployer, admin, veraxRouter, signCheckModule } = await getNamedAccounts();

  await deploy("RubyScoreVeraxPortal", {
    from: deployer,
    args: [[signCheckModule], veraxRouter],
    log: true,
  });
};

migrate.tags = ["port"];

export default migrate;
