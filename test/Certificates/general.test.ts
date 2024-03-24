import { ethers, getChainId } from "hardhat";
import { RubyScoreVeraxPortal, IAttestationRegistry } from "@contracts";
import { HardhatEthersSigner, sign } from "@test-utils";
import "@openzeppelin/hardhat-upgrades";
import * as SchemaRegistry from "./linea-abi/SchemaRegistry";
import * as ModuleRegistry from "./linea-abi/ModuleRegistry";
import * as PortalRegistry from "./linea-abi/PortalRegistry";
import * as AttestationRegistry from "./linea-abi/AttestationRegistry";
import * as Router from "./linea-abi/Router";
import { BytesLike, ContractTransactionResponse } from "ethers";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";

const abiCoder = new ethers.AbiCoder();
// const BASE_URI = "https://xproject.api/achivments/";

async function prepare() {
  const [deployer, admin, operator, minter, user] = await ethers.getSigners();
  const schemaRegistry = await ethers.getContractAt(
    "ISchemaRegistry",
    SchemaRegistry.address as string,
    deployer,
  );
  const attestationRegistry = await ethers.getContractAt(
    "IAttestationRegistry",
    AttestationRegistry.address as string,
    deployer,
  );
  const portalRegistry = await ethers.getContractAt(
    "IPortalRegistry",
    PortalRegistry.address as string,
    deployer,
  );
  const moduleRegistry = await ethers.getContractAt(
    "IModuleRegistry",
    ModuleRegistry.address as string,
    deployer,
  );

  const VeraxOwnerAddress = "0x39241a22ea7162c206409aaa2e4a56f9a79c15ab";
  const veraxOwner = await ethers.getImpersonatedSigner(VeraxOwnerAddress);

  await portalRegistry.connect(veraxOwner).setIssuer(deployer.address);

  // Already at main net
  // let number = await schemaRegistry.connect(deployer).getSchemasNumber();
  // console.log("schemas number before: ", number);

  const schemaString = "bool onchainLineaLvl3";

  // const tx = await schemaRegistry.createSchema("name", "discription", "context", schemaString);
  // await tx.wait();

  // number = await schemaRegistry.connect(deployer).getSchemasNumber();
  // console.log("schemas number after: ", number);

  const schemaId = await schemaRegistry.connect(deployer).getIdFromSchemaString(schemaString);
  console.log("schemaId: ", schemaId);

  const isRegistered = await schemaRegistry.connect(deployer).isRegistered(schemaId);
  console.log("isRegistered: ", isRegistered);

  // console.log("Deploy Certificate");
  // const CertificateInstance = await ethers.getContractFactory("Rubyscore_Certificates", deployer);
  // const certificate = await CertificateInstance.deploy(
  //   deployer.address,
  //   deployer.address,
  //   deployer.address,
  //   BASE_URI,
  //   "RUBY_SCORE_CERTIFICATE",
  //   "RSC"
  // );

  console.log("Deploy RubyscoreSignCheckModule");
  const RubyscoreSignCheckModuleInstance = await ethers.getContractFactory(
    "RubyscoreSignCheckModule",
    deployer,
  );
  const signCheckModule = await RubyscoreSignCheckModuleInstance.deploy(deployer.address, minter.address);

  console.log("Register RubyscoreSignCheckModule");
  await moduleRegistry.register(
    "RubyscoreSignCheckModuleV1",
    "RubyscoreSignCheck",
    await signCheckModule.getAddress(),
  );

  console.log("Deploy Portal");
  const PortalInstance = await ethers.getContractFactory("RubyScoreVeraxPortal", deployer);
  const portal = await PortalInstance.deploy([await signCheckModule.getAddress()], Router.address as string);

  console.log("Set schema to Portal");
  await portal.connect(deployer).setUpCertificates([schemaId], [true]);

  console.log("Register Portal");
  await portalRegistry.register(await portal.getAddress(), "name", "description", true, "ownerName");

  // console.log("Grant MINTER role for Portal");
  // const MINTER_ROLE = await certificate.MINTER_ROLE();
  // await certificate.grantRole(MINTER_ROLE, portal.address);

  console.log("set check statuses");
  await portal.connect(deployer).setCheckStatuses(true, false);

  console.log("attestScore");

  const signer = await signCheckModule.getSigner();
  console.log("signer: ", signer);
  console.log("deployer: ", deployer.address);

  const domain = {
    name: "Rubyscore_SignCheckModule",
    version: "0.0.1",
    chainId: await getChainId(),
    verifyingContract: await signCheckModule.getAddress(),
  };

  const types = {
    AttestationPayload: [
      { name: "schemaId", type: "bytes32" },
      { name: "expirationDate", type: "uint64" },
      { name: "subject", type: "bytes" },
      { name: "attestationData", type: "bytes" },
    ],
  };

  return {
    deployer,
    admin,
    operator,
    minter,
    user,
    types,
    domain,
    portal,
    portalRegistry,
    schemaRegistry,
    attestationRegistry,
    schemaId,
  };
}

describe("Method: constructor", () => {
  let minter: HardhatEthersSigner, user: HardhatEthersSigner;
  let portal: RubyScoreVeraxPortal;
  let schemaId: BytesLike;

  before(async () => {
    console.log(SchemaRegistry.address);
    [, , , minter, user] = await ethers.getSigners();
  });

  describe("When all parameters correct", () => {
    let tx: ContractTransactionResponse, attestationRegistry: IAttestationRegistry, attestationId: BytesLike;

    it("attestRubyscore without problem", async () => {
      const deployments = await loadFixture(prepare);
      minter = deployments.minter;
      user = deployments.user;
      const types = deployments.types;
      const domain = deployments.domain;
      portal = deployments.portal;
      attestationRegistry = deployments.attestationRegistry;
      schemaId = deployments.schemaId;

      // console.log("Set signer address to portal");
      // await portal.setAuthorizedSigners(minter.address);

      const attestationParams = {
        schemaId,
        expirationDate: "1967786495",
        subject: abiCoder.encode(["address"], [user.address]),
        attestationData: abiCoder.encode(["bool"], [true]),
      };
      console.log("minter: ", minter.address);
      console.log("attestationParams: ", attestationParams);
      // ["0xce6351ef35f71cd649b75be11a4d08a8420811e21db89085b27f56c9eeac1578",1967786495,"0x00000000000000000000000015d34aaf54267db7d7c367839aaf71a00a2c6a65","0x0000000000000000000000000000000000000000000000000000000000000001"]

      const operatorSignature = await sign(domain, types, attestationParams, minter);
      console.log("operatorSignature: ", operatorSignature);

      tx = await portal.connect(user).attestRubyscore(attestationParams, [operatorSignature], {
        value: 1000,
      });

      const processedTx = await tx.wait();
      console.log(processedTx?.logs);

      attestationId = processedTx?.logs?.filter((event) => {
        return event.index === 0;
      })[0].topics[1] as BytesLike;
      console.log("attestationId: ", attestationId);
    });

    it("should user have attestation", async () => {
      const balance = await attestationRegistry.balanceOf(user.address, attestationId);
      console.log("balance: ", balance);
      expect(balance).to.be.eq(1);
    });

    it("should get attestation", async () => {
      const getAttestation = await attestationRegistry.getAttestation(attestationId);
      console.log("getAttestation: ", getAttestation);
    });

    // it("should user have attestation NFT", async () => {
    //   const balance = await certificate.balanceOf(user.address, 1);
    //   expect(balance).to.be.eq(1);
    // });

    it("should emit Minted event", async () => {
      await expect(tx).to.emit(attestationRegistry, "AttestationRegistered").withArgs(attestationId);
    });
  });
});
