import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-deploy";
import "solidity-docgen";

import "tsconfig-paths/register";

import "./tasks/index";

import envConfig from "./config";

const {
  DEPLOYER_KEY,
  INFURA_KEY,
  ETHERSCAN_API_KEY,
  POLYGONSCAN_API_KEY,
  POLYGONZKSCAN_API_KEY,
  BSCSCAN_API_KEY,
  BASESCAN_API_KEY,
  LINEASCAN_API_KEY,
  ZORASCAN_API_KEY,
  OPTIMIZM_API_KEY,
  SCROLLSCAN_API_KEY,
  MANTASCAN_API_KEY,
  MANTLESCAN_API_KEY,
} = envConfig;

function typedNamedAccounts<T>(namedAccounts: { [key in string]: T }) {
  return namedAccounts;
}

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.21",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  typechain: {
    outDir: "types/typechain-types",
  },
  networks: {
    hardhat: {
      gasPrice: "auto",
      loggingEnabled: false,
      forking: {
        url: `https://linea-mainnet.infura.io/v3/${INFURA_KEY}`,
        enabled: true,
      },
    },
    localhost: {
      url: "http://127.0.0.1:8545",
    },
    zkEVMMainnet: {
      url: `https://zkevm-rpc.com`,
      accounts: [DEPLOYER_KEY],
    },
    zkEVMTestnet: {
      url: `https://rpc.public.zkevm-test.net`,
      accounts: [DEPLOYER_KEY],
    },
    scrollSepolia: {
      url: "https://sepolia-rpc.scroll.io",
      accounts: [DEPLOYER_KEY],
    },
    scrollMainnet: {
      url: "https://rpc.scroll.io/",
      accounts: [DEPLOYER_KEY],
      gasPrice: 424483200,
    },
    optimismMainnet: {
      url: "https://mainnet.optimism.io",
      accounts: [DEPLOYER_KEY],
    },
    optimismGoerli: {
      url: "https://optimism-goerli.publicnode.com",
      accounts: [DEPLOYER_KEY],
    },
    mainnet: {
      url: `https://mainnet.infura.io/v3/${INFURA_KEY}`,
      chainId: 1,
      accounts: [DEPLOYER_KEY],
    },
    baseMainnet: {
      url: "https://mainnet.base.org",
      accounts: [DEPLOYER_KEY],
    },
    baseGoerli: {
      url: "https://goerli.base.org",
      accounts: [DEPLOYER_KEY],
      gasPrice: 1000000000,
    },
    baseLocal: {
      url: "http://localhost:8545",
      accounts: [DEPLOYER_KEY],
      gasPrice: 1000000000,
    },
    lineaTestnet: {
      url: `https://rpc.goerli.linea.build/`,
      accounts: [DEPLOYER_KEY],
      chainId: 59140,
      gasPrice: 1000000007,
    },
    lineaMainnet: {
      url: `https://linea-mainnet.infura.io/v3/${INFURA_KEY}`,
      accounts: [DEPLOYER_KEY],
    },
    zoraGoerli: {
      url: "https://testnet.rpc.zora.energy/",
      accounts: [DEPLOYER_KEY],
      gasPrice: 2000000008,
    },
    zoraMainnet: {
      url: "https://rpc.zora.energy/",
      accounts: [DEPLOYER_KEY],
    },
    goerli: {
      url: `https://goerli.infura.io/v3/${INFURA_KEY}`,
      chainId: 5,
      accounts: [DEPLOYER_KEY],
    },
    polygon: {
      url: `https://polygon-mainnet.infura.io/v3/${INFURA_KEY}`,
      chainId: 137,
      accounts: [DEPLOYER_KEY],
    },
    polygonMumbai: {
      url: `https://rpc-mumbai.maticvigil.com/`,
      chainId: 80001,
      accounts: [DEPLOYER_KEY],
    },
    bsc: {
      url: "https://bsc-dataseed.binance.org/",
      chainId: 56,
      accounts: [DEPLOYER_KEY],
    },
    bscTestnet: {
      url: "https://bsc-testnet.public.blastapi.io",
      chainId: 97,
      accounts: [DEPLOYER_KEY],
    },
    mantaMainnet: {
      url: "https://pacific-rpc.manta.network/http",
      chainId: 169,
      accounts: [DEPLOYER_KEY],
    },
    mantaTestnet: {
      url: "https://manta-testnet.calderachain.xyz/http",
      chainId: 3441005,
      accounts: [DEPLOYER_KEY],
    },
    mantleMainnet: {
      url: "https://rpc.mantle.xyz",
      chainId: 5000,
      accounts: [DEPLOYER_KEY],
    },
    mantleTestnet: {
      url: "https://rpc.sepolia.mantle.xyz",
      chainId: 5003,
      accounts: [DEPLOYER_KEY],
    },
  },
  etherscan: {
    apiKey: {
      mainnet: ETHERSCAN_API_KEY,
      goerli: ETHERSCAN_API_KEY,
      polygon: POLYGONSCAN_API_KEY,
      polygonMumbai: POLYGONSCAN_API_KEY,
      zkEVMMainnet: POLYGONZKSCAN_API_KEY,
      zkEVMTestnet: POLYGONZKSCAN_API_KEY,
      scrollSepolia: SCROLLSCAN_API_KEY,
      scrollMainnet: SCROLLSCAN_API_KEY,
      bsc: BSCSCAN_API_KEY,
      bscTestnet: BSCSCAN_API_KEY,
      baseGoerli: BASESCAN_API_KEY,
      baseMainnet: BASESCAN_API_KEY,
      lineaTestnet: LINEASCAN_API_KEY,
      lineaMainnet: LINEASCAN_API_KEY,
      optimismGoerli: OPTIMIZM_API_KEY,
      optimismMainnet: OPTIMIZM_API_KEY,
      zoraGoerli: ZORASCAN_API_KEY,
      zoraMainnet: ZORASCAN_API_KEY,
      mantaMainnet: MANTASCAN_API_KEY,
      mantaTestnet: MANTASCAN_API_KEY,
      mantleMainnet: MANTLESCAN_API_KEY,
      mantleTestnet: MANTLESCAN_API_KEY,
    },
    customChains: [
      {
        network: "zkEVMMainnet",
        chainId: 1101,
        urls: {
          apiURL: "https://explorer.mainnet.zkevm-test.net/api",
          browserURL: "https://explorer.mainnet.zkevm-test.net/",
        },
      },
      {
        network: "zkEVMTestnet",
        chainId: 1442,
        urls: {
          apiURL: "https://testnet-zkevm.polygonscan.com/api",
          browserURL: "https://testnet-zkevm.polygonscan.com",
        },
      },
      {
        network: "scrollSepolia",
        chainId: 534351,
        urls: {
          apiURL: "https://api-sepolia.scrollscan.com/api",
          browserURL: "https://sepolia.scrollscan.com",
        },
      },
      {
        network: "scrollMainnet",
        chainId: 534352,
        urls: {
          apiURL: "https://api.scrollscan.com/api",
          browserURL: "https://scrollscan.com/",
        },
      },
      {
        network: "optimismMainnet",
        chainId: 10,
        urls: {
          apiURL: "https://api-optimistic.etherscan.io/api",
          browserURL: "https://explorer.optimism.io",
        },
      },
      {
        network: "optimismGoerli",
        chainId: 420,
        urls: {
          apiURL: "https://api-goerli-optimistic.etherscan.io/",
          browserURL: "https://goerli-explorer.optimism.io",
        },
      },

      {
        network: "baseGoerli",
        chainId: 84531,
        urls: {
          apiURL: "https://api-goerli.basescan.org/api",
          browserURL: "https://goerli.basescan.org",
        },
      },
      {
        network: "baseMainnet",
        chainId: 8453,
        urls: {
          apiURL: "https://api.basescan.org/api",
          browserURL: "https://basescan.org",
        },
      },
      {
        network: "lineaMainnet",
        chainId: 59144,
        urls: {
          apiURL: "https://api.lineascan.build/api",
          browserURL: "https://lineascan.build/",
        },
      },
      {
        network: "lineaTestnet",
        chainId: 59140,
        urls: {
          apiURL: "https://api-testnet.lineascan.build/api",
          browserURL: "https://goerli.lineascan.build/address",
        },
      },
      {
        network: "zoraGoerli",
        chainId: 999,
        urls: {
          apiURL: "https://testnet.explorer.zora.energy/api",
          browserURL: "https://testnet.explorer.zora.energy",
        },
      },
      {
        network: "zoraMainnet",
        chainId: 7777777,
        urls: {
          apiURL: "https://explorer.zora.energy/api",
          browserURL: "https://explorer.zora.energy",
        },
      },
      {
        network: "mantaMainnet",
        urls: {
          apiURL: "https://pacific-explorer.manta.network/api",
          browserURL: "https://pacific-explorer.manta.network",
        },
        chainId: 169,
      },
      {
        network: "mantaTestnet",
        urls: {
          apiURL: "https://pacific-explorer.testnet.manta.network/api",
          browserURL: "https://pacific-explorer.testnet.manta.network",
        },
        chainId: 3441005,
      },
      {
        network: "mantleMainnet",
        urls: {
          apiURL: "https://api.mantlescan.xyz/api",
          browserURL: "https://api.mantlescan.xyz",
        },
        chainId: 5000,
      },
      {
        network: "mantleTestnet",
        urls: {
          apiURL: "https://explorer.sepolia.mantle.xyz/api",
          browserURL: "https://explorer.sepolia.mantle.xyz/",
        },
        chainId: 5003,
      },
    ],
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
