import { DeployFunction } from "hardhat-deploy/types";
import { typedDeployments } from "@utils";
import { ZERO_BYTES } from "@test-utils";

const migrate: DeployFunction = async ({ deployments, getNamedAccounts }) => {
  const { deploy, execute } = typedDeployments(deployments);
  const { deployer } = await getNamedAccounts();

  console.log(deployer);

  const owner = deployer;
  const certificateNFT = "0x79257C480058094d790A2E31944e41E08ed17cD5";
  const portal = deployer;
  const schemaId = "0x8fd97ea8d093598a317f51f593c647b44ebaf0f07b831be36b5c1afa0e3bdbe3";
  const certId = 1;

  await deploy("RubyscoreIssuanceModule", {
    from: deployer,
    args: [owner, portal, certificateNFT],
    log: true,
  });

  await execute(
    "RubyscoreIssuanceModule",
    { from: deployer, log: true },
    "setUpCertificates",
    [schemaId],
    [certId]
  );
};

// struct AttestationPayload {
//   bytes32 schemaId; // The identifier of the schema this attestation adheres to.
//   uint64 expirationDate; // The expiration date of the attestation.
//   bytes subject; // The ID of the attestee, EVM address, DID, URL etc.
//   bytes attestationData; // The attestation data.
// }
ZERO_BYTES;

// ["0x8fd97ea8d093598a317f51f593c647b44ebaf0f07b831be36b5c1afa0e3bdbe3", 1767786495, "0x52696d616e","0x000000000000000000000000000000000000000000000000000000000000000301"]

migrate.tags = ["minter"];

export default migrate;
