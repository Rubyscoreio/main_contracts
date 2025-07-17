import { HardhatUserConfig } from "hardhat/config";
import { NetworksUserConfig } from "hardhat/types";
import { ApiKey, ChainConfig } from "@nomicfoundation/hardhat-verify/types";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-deploy";
import "solidity-docgen";
import "@nomicfoundation/hardhat-foundry";

import "tsconfig-paths/register";

import "./tasks/index";

import envConfig from "./config";
import networks from "./networks";

const externalNetworks: NetworksUserConfig = {};
networks
  .filter((network) => network.networkData)
  .forEach((network) => {
    externalNetworks[network.name] = {
      chainId: network.chainId,
      ...network.networkData,
    };
  });

const apiKeys: ApiKey = {};
networks.forEach((network) => {
  apiKeys[network.name] = network.apiKey;
});

function typedNamedAccounts<T>(namedAccounts: { [key in string]: T }) {
  return namedAccounts;
}

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.21",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.8.28",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  typechain: {
    outDir: "types/typechain-types",
  },
  networks: {
    hardhat: {
      gasPrice: "auto",
      loggingEnabled: false,
      forking: {
        url: `https://linea-mainnet.infura.io/v3/${envConfig.INFURA_KEY}`,
        enabled: true,
      },
    },
    localhost: {
      url: "http://127.0.0.1:8545",
    },
    ...externalNetworks,
  },
  etherscan: {
    apiKey: apiKeys,
    customChains: networks
      .filter((network) => network.urls)
      .map((network) => (
          {
            network: network.name,
            chainId: network.chainId,
            urls: network.urls,
          }) as ChainConfig,
      ),
  },
  namedAccounts: typedNamedAccounts({
    deployer: 0,
    admin: "0x0d0D5Ff3cFeF8B7B2b1cAC6B6C27Fd0846c09361",
    minter: "0x381c031baa5995d0cc52386508050ac947780815",
    operator: "0x381c031baa5995d0cc52386508050ac947780815",
    veraxRouter: {
      lineaMainnet: "0x4d3a380A03f3a18A5dC44b01119839D8674a552E",
      lineaTestnet: "0x736c78b2f2cBf4F921E8551b2acB6A5Edc9177D5",
      hardhat: "0x4d3a380A03f3a18A5dC44b01119839D8674a552E",
    },
    veraxPortalRegistry: {
      lineaMainnet: "0xd5d61e4ECDf6d46A63BfdC262af92544DFc19083",
      lineaTestnet: "0x506f88a5Ca8D5F001f2909b029738A40042e42a6",
      hardhat: "0xd5d61e4ECDf6d46A63BfdC262af92544DFc19083",
    },
    veraxSchemaRegistry: {
      lineaMainnet: "0x0f95dCec4c7a93F2637eb13b655F2223ea036B59",
      lineaTestnet: "0xB2c4Da1f8F08A0CA25862509E5431289BE2b598B",
      hardhat: "0x0f95dCec4c7a93F2637eb13b655F2223ea036B59",
    },
    veraxModuleRegistry: {
      lineaMainnet: "0xf851513A732996F22542226341748f3C9978438f",
      lineaTestnet: "0x1a20b2CFA134686306436D2c9f778D7eC6c43A43",
      hardhat: "0xf851513A732996F22542226341748f3C9978438f",
    },
    certificateNFTAddress: {
      lineaMainnet: "",
      lineaTestnet: "0xed02ae22631c9a58b24d8612331dc4b28abfd49a",
    },
    signCheckModule: {
      lineaMainnet: "0xEAcf8B19E104803cfCD2557D893D6a407E4994F0",
      lineaTestnet: "0xaCD70AdfeEe619ACa7354e9c89C6a86968d11078",
      hardhat: "0xEAcf8B19E104803cfCD2557D893D6a407E4994F0",
    },
    portalAddress: {
      lineaMainnet: "0xB9cC0Bb020cF55197C4C3d826AC87CAdba51f272",
      lineaTestnet: "0x5E1FE999737bce29Ca8C73B844eB1483005f6148",
      hardhat: 0,
    },
  }),
  docgen: {
    exclude: ["./mocks"],
    pages: "files",
  },
  watcher: {
    test: {
      tasks: [{ command: "test", params: { testFiles: ["{path}"] } }],
      files: ["./test/**/*"],
      verbose: true,
    },
  },
  gasReporter: {
    enabled: false,
    coinmarketcap: "",
    currency: "USD",
    token: "ETH",
    gasPrice: 28,
  },
};

export default config;
