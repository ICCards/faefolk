extends Control


func _ready():
	$SoundMenu/Slider1/MusicSlider.value = Sounds.music_volume
	$SoundMenu/Slider2/SoundSlider.value = Sounds.sound_volume
	$SoundMenu/Slider3/AmbientSlider.value = Sounds.ambient_volume
	$SoundMenu/Slider4/FootstepsSlider.value = Sounds.footstep_volume


func _on_MusicSlider_value_changed(value):
	Sounds.set_music_volume(value)

func _on_SoundSlider_value_changed(value):
	Sounds.set_sound_volume(value)

func _on_AmbientSlider_value_changed(value):
	Sounds.set_ambient_volume(value)

func _on_FootstepsSlider_value_changed(value):
	Sounds.set_footstep_volume(value)


func _on_DownButton_pressed():
	$SoundEffects.stream = Sounds.button_select
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
	$SoundEffects.play()
	$SoundMenu.visible = false
	$ControlsMenu.visible = true
	
func _on_UpButton_pressed():
	$SoundEffects.stream = Sounds.button_select
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
	$SoundEffects.play()
	$SoundMenu.visible = true
	$ControlsMenu.visible = false
