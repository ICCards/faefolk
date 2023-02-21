extends Control


func _ready():
	$KeyBindingBtn.action_name = name
	set_label()
	PlayerData.connect("key_binding_button_changed", Callable(self, "set_label"))

func set_label():
	var key_ascii = PlayerData.player_data["settings"]["key_dict"][name]
	$Label.text = Util.capitalizeFirstLetter(name) + ": " + OS.get_keycode_string(key_ascii) 
