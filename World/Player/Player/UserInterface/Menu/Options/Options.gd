extends Control

const MAX_SCROLL_SIZE = 543

onready var music_slider = $ScrollContainer/VBoxContainer/Grid/Slider1/Music/MusicSlider
onready var sound_slider = $ScrollContainer/VBoxContainer/Grid/Slider2/Sound/SoundSlider
onready var ambient_slider = $ScrollContainer/VBoxContainer/Grid/Slider3/Ambient/AmbientSlider
onready var footsteps_slider = $ScrollContainer/VBoxContainer/Grid/Slider4/Footstep/FootstepSlider

func _ready():
	yield(get_tree().create_timer(0.25), "timeout")
	setup_keys()
	set_label_texts()
	music_slider.value = PlayerData.player_data["settings"]["volume"]["music"]
	sound_slider.value = PlayerData.player_data["settings"]["volume"]["sound"]
	ambient_slider.value = PlayerData.player_data["settings"]["volume"]["ambient"]
	footsteps_slider.value = PlayerData.player_data["settings"]["volume"]["footstep"]
	$ScrollContainer.scroll_vertical = 0
	$Slider.value = 100

func initialize():
	show()
	get_node("../../Background").set_deferred("texture", load("res://Assets/Images/User interface/inventory/options/options-tab.png"))

func set_label_texts():
	$ScrollContainer/VBoxContainer/Grid2/MoveLeftLabel.text = "Move left: " + OS.get_scancode_string(PlayerData.player_data["settings"]["key_dict"]["move_left"])
	$ScrollContainer/VBoxContainer/Grid2/MoveRightLabel.text = "Move right: " + OS.get_scancode_string(PlayerData.player_data["settings"]["key_dict"]["move_right"])
	$ScrollContainer/VBoxContainer/Grid2/MoveUpLabel.text = "Move up: " + OS.get_scancode_string(PlayerData.player_data["settings"]["key_dict"]["move_up"])
	$ScrollContainer/VBoxContainer/Grid2/MoveDownLabel.text = "Move down: " + OS.get_scancode_string(PlayerData.player_data["settings"]["key_dict"]["move_down"])
	$ScrollContainer/VBoxContainer/Grid2/OpenMenuLabel.text = "Open menu: " + OS.get_scancode_string(PlayerData.player_data["settings"]["key_dict"]["open_menu"])
	$ScrollContainer/VBoxContainer/Grid2/ActionLabel.text = "Action/Interact: " + OS.get_scancode_string(PlayerData.player_data["settings"]["key_dict"]["action"])
	$ScrollContainer/VBoxContainer/Grid2/RotateObjectLabel.text = "Rotate object: " + OS.get_scancode_string(PlayerData.player_data["settings"]["key_dict"]["rotate"])
	$ScrollContainer/VBoxContainer/Grid2/OpenMapLabel.text = "Open map: " + OS.get_scancode_string(PlayerData.player_data["settings"]["key_dict"]["open_map"])
	$ScrollContainer/VBoxContainer/Grid2/SprintLabel.text = "Sprint: " + OS.get_scancode_string(PlayerData.player_data["settings"]["key_dict"]["sprint"])
	$ScrollContainer/VBoxContainer/Grid2/ChangeVarietyLabel.text = "Change variety: " + OS.get_scancode_string(PlayerData.player_data["settings"]["key_dict"]["change_variety"])
	$ScrollContainer/VBoxContainer/Grid2/UseToolLabel.text = "Use tool: Left-click," + OS.get_scancode_string(PlayerData.player_data["settings"]["key_dict"]["use_tool"])

func _on_MusicSlider_value_changed(value):
	Sounds.set_music_volume(value)

func _on_SoundSlider_value_changed(value):
	Sounds.set_sound_volume(value)

func _on_AmbientSlider_value_changed(value):
	Sounds.set_ambient_volume(value)

func _on_FootstepSlider_value_changed(value):
	Sounds.set_footstep_volume(value)

func _on_Slider_value_changed(value):
	$ScrollContainer.scroll_vertical = ((100-value))/100*MAX_SCROLL_SIZE


func setup_keys():
	print("SETTING UP KEYS")
	for i in PlayerData.player_data["settings"]["key_dict"]:
#		for j in get_tree().get_nodes_in_group("button_keys"):
#			if(j.action_name == i):
#				j.text = OS.get_scancode_string(key_dict[i])
		var newkey = InputEventKey.new()
		newkey.scancode = int(PlayerData.player_data["settings"]["key_dict"][i])
		InputMap.action_add_event(i,newkey)
