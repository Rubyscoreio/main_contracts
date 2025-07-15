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
	forge script scripts/DeployRubyscoreSoneiumBadge.s.sol:DeployRubyscoreSoneiumBadgeScript \
	$(chain) \
	--sig "run(string)" \
	--via-ir \
	-vvvv \
	--etherscan-api-key ${ETHERSCAN_API_KEY} \
# 	--broadcast \
# 	--verify \
