extends Button


export(String) var action_name = ""

var do_set = false

func _pressed():
	$SoundEffects.stream = Sounds.button_select
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
	$SoundEffects.play()
	do_set = true
	Server.player_node.user_interface.show_set_button_dialogue()

func _input(event):
	if(do_set):
		if(event is InputEventKey):
			#Remove the old keys
			var newkey = InputEventKey.new()
			newkey.scancode = int(Settings.key_dict[action_name])
			InputMap.action_erase_event(action_name,newkey)
			#Add the new key for this action
			InputMap.action_add_event(action_name,event)
			#Update the keydictionary with the scanscode to save
			Settings.key_dict[action_name] = event.scancode
			#Save the dictionary to json
			Settings.save_keys()
			#stop setting the key
			do_set = false
			get_node("../../../").set_label_texts()
			Server.player_node.user_interface.hide_set_button_dialogue()
