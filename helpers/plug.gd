extends Node

var _callback_ref = JavaScript.create_callback(self, "_my_callback")

func _input(ev):
	var window = JavaScript.get_interface("window")
	if Input.is_key_pressed(KEY_C):
		window.connect()
	if Input.is_key_pressed(KEY_S):
		window.sanityCheck().then(_callback_ref)
	if Input.is_key_pressed(KEY_P):
		window.createPlayer("humanMale").then(_callback_ref)
	if Input.is_key_pressed(KEY_A):
		window.submitActions("watering-15|harvesting-12|hoeing-5").then(_callback_ref)
	if Input.is_key_pressed(KEY_G):
		window.getPlayer().then(_callback_ref)
	if Input.is_key_pressed(KEY_W):
		window.wieldItem("axe").then(_callback_ref)
		

func _my_callback(args):
	print(args[0])
