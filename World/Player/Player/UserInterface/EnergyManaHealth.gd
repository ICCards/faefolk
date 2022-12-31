extends Control


func initialize():
	$Energy.rect_size.y = (PlayerData.player_data["energy"]/100)*51
	$Mana.rect_size.y = (PlayerData.player_data["mana"]/100)*51
	$Health.rect_size.y = (PlayerData.player_data["health"]/100)*51
