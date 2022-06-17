extends Control


func _ready():
	$Slider1/MusicSlider.value = Sounds.music_volume
	$Slider2/SoundSlider.value = Sounds.sound_volume
	$Slider3/AmbientSlider.value = Sounds.ambient_volume
	$Slider4/FootstepsSlider.value = Sounds.footstep_volume


func _on_MusicSlider_value_changed(value):
	Sounds.set_music_volume(value)

func _on_SoundSlider_value_changed(value):
	Sounds.set_sound_volume(value)

func _on_AmbientSlider_value_changed(value):
	Sounds.set_ambient_volume(value)

func _on_FootstepsSlider_value_changed(value):
	Sounds.set_footstep_volume(value)
