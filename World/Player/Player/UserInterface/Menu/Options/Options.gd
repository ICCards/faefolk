extends Control

const MAX_SCROLL_SIZE = 1419


func _ready():
	await get_tree().create_timer(0.25).timeout
	setup_keys()
	$ScrollContainer.scroll_vertical = 0
	$Slider.value = 100

func initialize():
	show()
	get_node("../../Background").set_deferred("texture", load("res://Assets/Images/User interface/inventory/options/options-tab.png"))

func _on_Slider_value_changed(value):
	$ScrollContainer.scroll_vertical = ((100-value))/100*MAX_SCROLL_SIZE

func setup_keys():
	for i in PlayerData.player_data["settings"]["key_dict"]:
		var newkey = InputEventKey.new()
		newkey.keycode = int(PlayerData.player_data["settings"]["key_dict"][i])
		InputMap.action_add_event(i,newkey)
