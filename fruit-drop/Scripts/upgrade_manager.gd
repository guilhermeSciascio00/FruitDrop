extends Node

enum Upgrades{
	SPEED,
	BOWLSIZE
}

const MAX_LEVEL_CAP : int = 4

var upgrades_info : Dictionary = { 
	# name - price
	Upgrades.SPEED : {"Price" : 300, "HasBoughtIt" : false, "Level":1}, 
	Upgrades.BOWLSIZE : {"Price" : 500, "HasBoughtIt" : false, "Level":1},
	}

func has_enough_credits(currentMoney : float, upgrade : Upgrades) -> bool:
	return currentMoney >= upgrades_info[upgrade]["Price"]

func buy_upgrade(upgrade : Upgrades) -> String:
	if has_enough_credits(CurrencyManager.money_amount, upgrade) and upgrades_info[upgrade]["Level"] < MAX_LEVEL_CAP:
		upgrades_info[upgrade]["HasBoughtIt"] = true
		CurrencyManager.money_amount -= upgrades_info[upgrade]["Price"]
		update_upgrade_values(upgrade)
		return "Upgrade Bought"
	elif !has_enough_credits(CurrencyManager.money_amount, upgrade):
		return "Not Enough Credits"
	elif upgrades_info[upgrade]["Level"] >= MAX_LEVEL_CAP:
		return "Max Level Reached"
		
	return "Shouldn't return this line"

func update_upgrade_values(upgrade : Upgrades) -> void:
		match(upgrade):
			Upgrades.SPEED:
				upgrades_info[upgrade]["Level"] += 1
				upgrades_info[upgrade]["Price"] *= upgrades_info[upgrade]["Level"] 
				upgrades_info[upgrade]["HasBoughtIt"] = false
			Upgrades.BOWLSIZE:
				upgrades_info[upgrade]["Level"] += 1
				upgrades_info[upgrade]["Price"] *= upgrades_info[upgrade]["Level"] 
				upgrades_info[upgrade]["HasBoughtIt"] = false
			_:
				print("shouldn't print it")
				print(upgrades_info[upgrade])

func has_bought_upgrade(upgrade: Upgrades) -> bool:
	return upgrades_info[upgrade]["HasBoughtIt"]

func get_upgrade_level(upgrade : Upgrades) -> int:
	return upgrades_info[upgrade]["Level"]

func get_upgrade_price(upgrade : Upgrades) -> int:
	return upgrades_info[upgrade]["Price"]

func is_upgrade_maxed(upgrade : Upgrades) -> bool:
	return upgrades_info[upgrade]["Level"] >= MAX_LEVEL_CAP
