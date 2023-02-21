extends Control



func _ready():
	$Label.text = Util.capitalizeFirstLetter(name) + " vol."
	$Slider.value = PlayerData.player_data["settings"]["volume"][name]

func _on_slider_value_changed(value):
	match name:
		"music":
			Sounds.set_music_volume(value)
		"sound":
			Sounds.set_sound_volume(value)
		"ambient":
			Sounds.set_ambient_volume(value)
		"footstep":
			Sounds.set_footstep_volume(value)


