import { DeployFunction } from "hardhat-deploy/types";
import { typedDeployments } from "@utils";
import { utils } from "ethers";

const migrate: DeployFunction = async ({ deployments, getNamedAccounts }) => {
  // const { deploy } = typedDeployments(deployments);
  // const { deployer, admin /*, operator, minter*/ } = await getNamedAccounts();
  //
  // // const admin = DEPLOY.ADMIN;
  // const owner = deployer;
  // const operator = deployer;
  // const minter = deployer;
  // const baseURI = "ipfs://";
  // const name = "Rubyscore_Cetificate";
  // const symbol = "Rubyscore_Cetificate";
  //
  // console.log(deployer);
  //
  // await deploy("Rubyscore_Certificates", {
  //   from: deployer,
  //   args: [owner, operator, minter, baseURI, name, symbol],
  //   log: true,
  // });
};

migrate.tags = ["cert"];

export default migrate;
