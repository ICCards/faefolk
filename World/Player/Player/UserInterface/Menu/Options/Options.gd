extends Control

const MAX_SCROLL_SIZE = 1167

@onready var music_slider = $ScrollContainer/VBoxContainer/Grid/Slider1/Music/MusicSlider
@onready var sound_slider = $ScrollContainer/VBoxContainer/Grid/Slider2/Sound/SoundSlider
@onready var ambient_slider = $ScrollContainer/VBoxContainer/Grid/Slider3/Ambient/AmbientSlider
@onready var footsteps_slider = $ScrollContainer/VBoxContainer/Grid/Slider4/Footstep/FootstepSlider

func _ready():
	await get_tree().create_timer(0.25).timeout
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
	$ScrollContainer/VBoxContainer/Grid2/MoveLeftLabel.text = "Move left: " + return_key_binding_string("move_left")
	$ScrollContainer/VBoxContainer/Grid2/MoveRightLabel.text = "Move right: " + return_key_binding_string("move_right")
	$ScrollContainer/VBoxContainer/Grid2/MoveUpLabel.text = "Move up: " + return_key_binding_string("move_up")
	$ScrollContainer/VBoxContainer/Grid2/MoveDownLabel.text = "Move down: " + return_key_binding_string("move_down")
	$ScrollContainer/VBoxContainer/Grid2/OpenMenuLabel.text = "Open menu: " + return_key_binding_string("open_menu")
	$ScrollContainer/VBoxContainer/Grid2/ActionLabel.text = "Action/Interact: " + return_key_binding_string("action")
	$ScrollContainer/VBoxContainer/Grid2/RotateObjectLabel.text = "Rotate object: " + return_key_binding_string("rotate")
	$ScrollContainer/VBoxContainer/Grid2/OpenMapLabel.text = "Open map: " + return_key_binding_string("open_map")
	$ScrollContainer/VBoxContainer/Grid2/SprintLabel.text = "Sprint: " + return_key_binding_string("sprint")
	$ScrollContainer/VBoxContainer/Grid2/ChangeVarietyLabel.text = "Change variety: " + return_key_binding_string("change_variety")
	$ScrollContainer/VBoxContainer/Grid2/UseToolLabel.text = "Use tool: Left-click," + return_key_binding_string("use_tool")
	$ScrollContainer/VBoxContainer/Grid2/SwitchHotbar.text = "Switch hotbar: " + return_key_binding_string("toggle_hotbar")
	$ScrollContainer/VBoxContainer/Grid2/Slot1.text = "Slot 1: " + return_key_binding_string("slot1")
	$ScrollContainer/VBoxContainer/Grid2/Slot2.text = "Slot 2: " + return_key_binding_string("slot2")
	$ScrollContainer/VBoxContainer/Grid2/Slot3.text = "Slot 3: " + return_key_binding_string("slot3")
	$ScrollContainer/VBoxContainer/Grid2/Slot4.text = "Slot 4: " + return_key_binding_string("slot4")
	$ScrollContainer/VBoxContainer/Grid2/Slot5.text = "Slot 5: " + return_key_binding_string("slot5")
	$ScrollContainer/VBoxContainer/Grid2/Slot6.text = "Slot 6: " + return_key_binding_string("slot6")
	$ScrollContainer/VBoxContainer/Grid2/Slot7.text = "Slot 7: " + return_key_binding_string("slot7")
	$ScrollContainer/VBoxContainer/Grid2/Slot8.text = "Slot 8: " + return_key_binding_string("slot8")
	$ScrollContainer/VBoxContainer/Grid2/Slot9.text = "Slot 9: " + return_key_binding_string("slot9")
	$ScrollContainer/VBoxContainer/Grid2/Slot10.text = "Slot 10: " + return_key_binding_string("slot10")
	$ScrollContainer/VBoxContainer/Grid2/CancelAttack.text = "Cancel attack: " + return_key_binding_string("cancel_attack")


func return_key_binding_string(action_name):
	var key_ascii = PlayerData.player_data["settings"]["key_dict"][action_name]
#	if key_ascii == 96:
#		return "~"
	if key_ascii == 127:
		return "Delete"
	else:
		return OS.get_keycode_string(key_ascii)


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
	for i in PlayerData.player_data["settings"]["key_dict"]:
		var newkey = InputEventKey.new()
		newkey.scancode = int(PlayerData.player_data["settings"]["key_dict"][i])
		InputMap.action_add_event(i,newkey)
