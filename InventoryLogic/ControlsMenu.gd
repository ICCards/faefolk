extends Control


var file_name = "res://keybinding.json"

var key_dict = {"move_right":68,
				"move_left":65,
				"move_up": 87,
				"move_down": 83,
				"open_menu": 69,
				"action": 88,
				"rotate": 82
				}
				
var setting_key = false

func _ready():
	load_keys()
#	get_child(0).visible = false
#	pause_mode = Node.PAUSE_MODE_PROCESS
	pass # Replace with function body.

#func _process(delta):
#	if(Input.is_action_just_pressed("pause")):
#		get_tree().paused = !get_tree().paused
#		get_child(0).visible = get_tree().paused
#	pass
	
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
		save_keys()
	pass
	
func delete_old_keys():
	#Remove the old keys
	for i in key_dict:
		var oldkey = InputEventKey.new()
		oldkey.scancode = int(ControlsMenu.key_dict[i])
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
	
func save_keys():
	var file = File.new()
	file.open(file_name,File.WRITE)
	file.store_string(to_json(key_dict))
	file.close()
	print("saved")
	pass
