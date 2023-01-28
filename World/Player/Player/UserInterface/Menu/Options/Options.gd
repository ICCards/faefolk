extends Control

const MAX_SCROLL_SIZE = 1115

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
	$ScrollContainer/VBoxContainer/Grid2/SwitchHotbar.text = "Switch hotbar: " + OS.get_scancode_string(PlayerData.player_data["settings"]["key_dict"]["toggle_hotbar"])
	$ScrollContainer/VBoxContainer/Grid2/Slot1.text = "Slot 1: " + OS.get_scancode_string(PlayerData.player_data["settings"]["key_dict"]["slot1"])
	$ScrollContainer/VBoxContainer/Grid2/Slot2.text = "Slot 2: " + OS.get_scancode_string(PlayerData.player_data["settings"]["key_dict"]["slot2"])
	$ScrollContainer/VBoxContainer/Grid2/Slot3.text = "Slot 3: " + OS.get_scancode_string(PlayerData.player_data["settings"]["key_dict"]["slot3"])
	$ScrollContainer/VBoxContainer/Grid2/Slot4.text = "Slot 4: " + OS.get_scancode_string(PlayerData.player_data["settings"]["key_dict"]["slot4"])
	$ScrollContainer/VBoxContainer/Grid2/Slot5.text = "Slot 5: " + OS.get_scancode_string(PlayerData.player_data["settings"]["key_dict"]["slot5"])
	$ScrollContainer/VBoxContainer/Grid2/Slot6.text = "Slot 6: " + OS.get_scancode_string(PlayerData.player_data["settings"]["key_dict"]["slot6"])
	$ScrollContainer/VBoxContainer/Grid2/Slot7.text = "Slot 7: " + OS.get_scancode_string(PlayerData.player_data["settings"]["key_dict"]["slot7"])
	$ScrollContainer/VBoxContainer/Grid2/Slot8.text = "Slot 8: " + OS.get_scancode_string(PlayerData.player_data["settings"]["key_dict"]["slot8"])
	$ScrollContainer/VBoxContainer/Grid2/Slot9.text = "Slot 9: " + OS.get_scancode_string(PlayerData.player_data["settings"]["key_dict"]["slot9"])
	$ScrollContainer/VBoxContainer/Grid2/Slot10.text = "Slot 10: " + OS.get_scancode_string(PlayerData.player_data["settings"]["key_dict"]["slot10"])


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
