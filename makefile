-include .env

build:
	forge build

test:
	forge test --via-ir

deployVoteAndV2Achievements:
	forge script scripts/DeployGeneralContracts.s.sol:DeployGeneralContractsScript \
	$(chain) \
	--sig "deployVoteAndV2Achievements(string)" \
	-vvvv \
	--etherscan-api-key ${ETHERSCAN_API_KEY} \
# 	--broadcast \
# 	--verify \
# 	--with-gas-price 0.01gwei \
# 	--priority-gas-price 0.01gwei \

deployV2Achievements:
	forge script scripts/DeployGeneralContracts.s.sol:DeployGeneralContractsScript \
	$(chain) \
	--sig "deployV2Achievements(string)" \
	-vvvv \
    --verifier blockscout \
	--etherscan-api-key ${BASESCAN_API_KEY} \
# 	--broadcast \
# 	--verify \
# 	--with-gas-price 0.01gwei \
# 	--priority-gas-price 0.01gwei \

deployBasicVote:
	forge script scripts/DeployGeneralContracts.s.sol:DeployGeneralContractsScript \
	$(chain) \
	--sig "deployVote(string)" \
	-vvvv \
    --verifier blockscout \
	--etherscan-api-key ${ETHERSCAN_API_KEY} \
# 	--broadcast \
# 	--verify \
# 	--with-gas-price 0.01gwei \
# 	--priority-gas-price 0.01gwei \

deploySoneiumBadge:
	forge script scripts/DeployRubyscoreSoneiumContracts.s.sol:DeployRubyscoreSoneiumContractsScript \
	$(chain) \
	--sig "deployBadge(string)" \
	--via-ir \
	-vvvv \
# 	--broadcast \
# 	--verify \

deploySoneiumId:
	forge script scripts/DeployRubyscoreSoneiumContracts.s.sol:DeployRubyscoreSoneiumContractsScript \
	$(chain) \
	--sig "deployId(string)" \
	-vvvv \
	--etherscan-api-key ${ETHERSCAN_API_KEY} \
# 	--broadcast \
# 	--verify \

deploySoneiumVote:
	forge script scripts/DeployRubyscoreSoneiumContracts.s.sol:DeployRubyscoreSoneiumContractsScript \
	$(chain) \
	--sig "deployVote(string)" \
	--via-ir \
	-vvvv \
# 	--broadcast \
# 	--verify \

verifyProxy:
	/home/episqol/.cargo/bin/forge verify-contract \
        --rpc-url https://rpc.xrplevm.org \
        --verifier blockscout \
        --verifier-url 'https://explorer.xrplevm.org/api/' \
        --constructor-args 0x00000000000000000000000081f06f4b143a6ead0e246da04420f9d6d1fbef5900000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000000 \
        --compiler-version 0.8.28 \
        0xB9cC0Bb020cF55197C4C3d826AC87CAdba51f272 \
        /openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol:ERC1967Proxy

verifyAchievement:
	forge verify-contract \
        --rpc-url https://mainnet.unichain.org \
        --verifier blockscout \
        --verifier-url 'https://unichain.blockscout.com/api/' \
        0xbDB018e21AD1e5756853fe008793a474d329991b \
        contracts-forge/Rubyscore_Achievement.v2.sol:Rubyscore_Achievement_v2

verifyVote:
	forge verify-contract \
  --rpc-url https://rpc-cs.vana.org \
  --verifier blockscout \
  --verifier-url 'https://vanascan.io/api/' \
  0xDC3D8318Fbaec2de49281843f5bba22e78338146 \
  contracts-forge/base/RubyscoreVote.sol:RubyscoreVote
