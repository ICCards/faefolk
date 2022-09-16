extends Node



var file_name = "res://keybinding.json"

var key_dict = {
	"move_right":68,
	"move_left":65,
	"move_up": 87,
	"move_down": 83,
	"open_menu": 73,
	"action": 69,
	"rotate": 82,
	"open_map": 71
}

func save_keys():
	var file = File.new()
	file.open(file_name,File.WRITE)
	file.store_string(to_json(Settings.key_dict))
	file.close()
	print("saved")
	pass
	
#We'll use this when the game loads
func load_keys():
	var file = File.new()
	if(file.file_exists(file_name)):
		delete_old_keys()
		file.open(file_name,File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if(typeof(data) == TYPE_DICTIONARY):
			print("LOADED SET KEYS")
			key_dict = data
			setup_keys()
		else:
			printerr("corrupted data!")
	else:
		#NoFile, so lets save the default keys now
		setup_keys()
		save_keys()
	pass
	
func delete_old_keys():
	#Remove the old keys
	for i in key_dict:
		var oldkey = InputEventKey.new()
		oldkey.scancode = int(key_dict[i])
		InputMap.action_erase_event(i,oldkey)
		
func setup_keys():
	print("SETTING UP KEYS")
	for i in key_dict:
		for j in get_tree().get_nodes_in_group("button_keys"):
			if(j.action_name == i):
				j.text = OS.get_scancode_string(key_dict[i])
		var newkey = InputEventKey.new()
		newkey.scancode = int(key_dict[i])
		InputMap.action_add_event(i,newkey)
