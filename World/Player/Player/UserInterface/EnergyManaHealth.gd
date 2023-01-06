extends Control


func initialize():
	$Energy.rect_size.y = (PlayerData.player_data["energy"]/100.0)*51.0
	$Mana.rect_size.y = (PlayerData.player_data["mana"]/100.0)*51.0
	$Health.rect_size.y = (PlayerData.player_data["health"]/100.0)*51.0
