extends Control


func initialize():
	$Farming/Pg.value = PlayerData.player_data["skill_experience"]["farming"]
	$Mining/Pg.value = PlayerData.player_data["skill_experience"]["mining"]
	$Foraging/Pg.value = PlayerData.player_data["skill_experience"]["foraging"]
	$Fishing/Pg.value = PlayerData.player_data["skill_experience"]["fishing"]
