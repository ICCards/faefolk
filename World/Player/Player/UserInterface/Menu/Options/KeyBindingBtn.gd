extends Button

onready var EnterNewKey = load("res://World/Player/Player/UserInterface/Menu/Options/EnterNewKey.tscn")

export(String) var action_name = ""

var do_set = false

func _pressed():
	$SoundEffects.stream = Sounds.button_select
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
	$SoundEffects.play()
	do_set = true
	var enterNewKey = EnterNewKey.instance()
	enterNewKey.name = "EnterNewKey"
	if Server.isLoaded:
		Server.player_node.user_interface.add_child(enterNewKey)
	else:
		get_node("../../../../").add_child(enterNewKey)

func _input(event):
	if(do_set):
		if(event is InputEventKey):
			#Remove the old keys
			var newkey = InputEventKey.new()
			newkey.scancode = int(PlayerData.player_data["settings"]["key_dict"][action_name])
			InputMap.action_erase_event(action_name,newkey)
			#Add the new key for this action
			InputMap.action_add_event(action_name,event)
			#Update the keydictionary with the scanscode to save
			PlayerData.player_data["settings"]["key_dict"][action_name] = event.scancode
			#Save the dictionary to json
			#Settings.save_keys()
			#stop setting the key
			do_set = false
			get_node("../../../../").set_label_texts()
			if Server.isLoaded:
				Server.player_node.user_interface.get_node("EnterNewKey").queue_free()
			else:
				get_node("../../../../EnterNewKey").queue_free()
#	if(do_set):
#		if(event is InputEventKey):
#			#Remove the old keys
#			var newkey = InputEventKey.new()
#			newkey.scancode = int(Settings.key_dict[action_name])
#			InputMap.action_erase_event(action_name,newkey)
#			#Add the new key for this action
#			InputMap.action_add_event(action_name,event)
#			#Update the keydictionary with the scanscode to save
#			Settings.key_dict[action_name] = event.scancode
#			#Save the dictionary to json
#			Settings.save_keys()
#			#stop setting the key
#			do_set = false
#			get_node("../../../../").set_label_texts()
#			if Server.player_node:
#				Server.player_node.user_interface.get_node("EnterNewKey").queue_free()
#			else:
#				get_node("../../../../").queue_free()

