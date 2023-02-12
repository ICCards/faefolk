extends Control


func initialize():
	$Energy.size.y = (PlayerData.player_data["energy"]/100.0)*51.0
	$Mana.size.y = (PlayerData.player_data["mana"]/100.0)*51.0
	$Health.size.y = (PlayerData.player_data["health"]/100.0)*51.0
