import { DeployFunction } from "hardhat-deploy/types";
import { typedDeployments } from "@utils";
import { ethers } from "hardhat";

const migrate: DeployFunction = async ({ deployments, getNamedAccounts }) => {
  // const { execute } = typedDeployments(deployments);
  // const { deployer, veraxPortalRegistry, veraxSchemaRegistry, portalAddress } = await getNamedAccounts();
  //
  // const fee = "500000000000000"; // 0.0005 ETH
  //
  // const schemaString = "bool onchainLineaLvl3";
  // const registryPortalInfo = {
  //   name: "RubyScore",
  //   description: "RubyScore portal for Linea level certificates",
  //   isRevocable: true,
  //   ownerName: "RubyScore",
  // };
  // const registrySchemaInfo = {
  //   name: "RubyScoreLineaLvl3",
  //   description: "RubyScore - Linea Level 3",
  //   context: "https://rubyscore.io/",
  //   schemaString,
  // };
  //
  // const schemaRegistry = await ethers.getContractAt("ISchemaRegistry", veraxSchemaRegistry);
  // const portalRegistry = await ethers.getContractAt("IPortalRegistry", veraxPortalRegistry);
  // // const certificate = await ethers.getContractAt("Rubyscore_Certificates", certificateNFTAddress);
  // const portal = await ethers.getContractAt("RubyScoreVeraxPortal", portalAddress);
  //
  // const schemaId = await schemaRegistry.getIdFromSchemaString(schemaString);
  // const isSchemaRegistered = await schemaRegistry.isRegistered(schemaId);
  // if (!isSchemaRegistered) {
  //   if (await portalRegistry.isIssuer(deployer)) {
  //     console.log("Register Schema");
  //     await schemaRegistry.createSchema(
  //       registrySchemaInfo.name,
  //       registrySchemaInfo.description,
  //       registrySchemaInfo.description,
  //       registrySchemaInfo.schemaString,
  //     );
  //   } else {
  //     console.log("!!! Deployer not issuer at portalRegistry !!!");
  //     return;
  //   }
  // }
  //
  // await execute(
  //   "RubyScoreVeraxPortal",
  //   {
  //     from: deployer,
  //     log: true,
  //   },
  //   "setUpCertificates",
  //   [schemaId],
  //   [true],
  // );
  //
  // // const DEFAULT_ADMIN_ROLE = await certificate.DEFAULT_ADMIN_ROLE();
  // // const MINTER_ROLE = await certificate.MINTER_ROLE();
  // // if (await certificate.hasRole(DEFAULT_ADMIN_ROLE, deployer)) {
  // //   console.log("Grand minter role for Portal");
  // //   await certificate.grantRole(MINTER_ROLE, portal.address);
  // // } else {
  // //   console.log("!!! Can't set Portal as MINTER at certificate !!!");
  // // }
  //
  // const isPortalRegistered = await portalRegistry.isRegistered(portal.target);
  // if (!isPortalRegistered) {
  //   if (await portalRegistry.isIssuer(deployer)) {
  //     console.log("Register Portal");
  //     await portalRegistry.register(
  //       portal.target,
  //       registryPortalInfo.name,
  //       registryPortalInfo.description,
  //       registryPortalInfo.isRevocable,
  //       registryPortalInfo.ownerName,
  //     );
  //   } else {
  //     console.log("!!! Deployer not issuer at portalRegistry !!!");
  //     return;
  //   }
  // } else {
  //   console.log("!!! Register Portal ALREADY registered !!!");
  // }
  // console.log("Set fees");
  // await portal.setFees([schemaId], [fee]);
};

migrate.tags = ["setup"];

export default migrate;
