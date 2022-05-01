extends Node


var footsteps_sound = preload("res://Assets/Sound effects/dirt footsteps.mp3")

func set_wood_footsteps(isOnWood):
	if isOnWood:
		footsteps_sound = preload("res://Assets/Sound effects/wood footsteps.mp3")
	else:
		footsteps_sound = preload("res://Assets/Sound effects/dirt footsteps.mp3")
