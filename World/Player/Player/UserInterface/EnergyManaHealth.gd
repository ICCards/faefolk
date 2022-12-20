extends Control


func initialize():
	$Energy.text = str(PlayerData.player_data["energy"]) + "/100"
	$Mana.text = str(PlayerData.player_data["mana"]) + "/100"
	$Health.text = str(PlayerData.player_data["health"]) + "/100"
