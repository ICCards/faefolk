extends ScrollContainer

onready var music_slider = $VBoxContainer/Grid/Slider1/HBoxContainer/MusicSlider
onready var sound_slider = $VBoxContainer/Grid/Slider2/HBoxContainer/SoundSlider
onready var ambient_slider = $VBoxContainer/Grid/Slider3/HBoxContainer/AmbientSlider
onready var footsteps_slider = $VBoxContainer/Grid/Slider4/HBoxContainer/FootstepsSlider

func set_label_texts():
	$VBoxContainer/Grid2/MoveLeftLabel.text = "Move left: " + OS.get_scancode_string(Settings.key_dict["move_left"])
	$VBoxContainer/Grid2/MoveRightLabel.text = "Move right: " + OS.get_scancode_string(Settings.key_dict["move_right"])
	$VBoxContainer/Grid2/MoveUpLabel.text = "Move up: " + OS.get_scancode_string(Settings.key_dict["move_up"])
	$VBoxContainer/Grid2/MoveDownLabel.text = "Move down: " + OS.get_scancode_string(Settings.key_dict["move_down"])
	$VBoxContainer/Grid2/OpenMenuLabel.text = "Open menu: " + OS.get_scancode_string(Settings.key_dict["open_menu"])
	$VBoxContainer/Grid2/ActionLabel.text = "Action/Interact: " + OS.get_scancode_string(Settings.key_dict["action"])
	$VBoxContainer/Grid2/RotateObjectLabel.text = "Rotate object: " + OS.get_scancode_string(Settings.key_dict["rotate"])
	$VBoxContainer/Grid2/OpenMapLabel.text = "Open map: " + OS.get_scancode_string(Settings.key_dict["open_map"])
	$VBoxContainer/Grid2/SprintLabel.text = "Sprint: " + OS.get_scancode_string(Settings.key_dict["sprint"])
	$VBoxContainer/Grid2/ChangeVarietyLabel.text = "Change variety: " + OS.get_scancode_string(Settings.key_dict["change_variety"])

func _ready():
	set_label_texts()
	music_slider.value = Sounds.music_volume
	sound_slider.value = Sounds.sound_volume
	ambient_slider.value = Sounds.ambient_volume
	footsteps_slider.value = Sounds.footstep_volume

func _on_MusicSlider_value_changed(value):
	Sounds.set_music_volume(value)

func _on_SoundSlider_value_changed(value):
	Sounds.set_sound_volume(value)

func _on_AmbientSlider_value_changed(value):
	Sounds.set_ambient_volume(value)

func _on_FootstepsSlider_value_changed(value):
	Sounds.set_footstep_volume(value)

