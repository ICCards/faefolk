extends Node

var _callback_ref = JavaScript.create_callback(self, "_my_callback")

func _input(ev):
	var window = JavaScript.get_interface("window")
	if Input.is_key_pressed(KEY_C):
		window.connect()
	if Input.is_key_pressed(KEY_SPACE):
		window.call("sanityCheck").then(_callback_ref)
		

func _my_callback(args):
	print(args[0])
