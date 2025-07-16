-include .env

build:
	forge build

test:
	forge test --via-ir

deployAchievementContract:
	forge script scripts/DeployRubyscoreAchievementV2.s.sol:DeployRubyscoreAchievementV2Script \
	$(chain) \
	--sig "run(string)" \
	--via-ir \
	-vvvv \
	--etherscan-api-key ${ETHERSCAN_API_KEY} \
# 	--broadcast \
# 	--verify \

deploySoneiumBadge:
	forge script scripts/DeployRubyscoreSoneiumContracts.s.sol:DeployRubyscoreSoneiumContractsScript \
	$(chain) \
	--sig "deployBadge(string)" \
	--via-ir \
	-vvvv \
	--etherscan-api-key ${ETHERSCAN_API_KEY} \
# 	--broadcast \
# 	--verify \

deploySoneiumId:
	forge script scripts/DeployRubyscoreSoneiumContracts.s.sol:DeployRubyscoreSoneiumContractsScript \
	$(chain) \
	--sig "deployId(string)" \
	--via-ir \
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
	--etherscan-api-key ${ETHERSCAN_API_KEY} \
# 	--broadcast \
# 	--verify \
