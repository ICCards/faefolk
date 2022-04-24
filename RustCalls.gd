extends Node


onready var api = Api
var thread = Thread.new()


func _whoAmI(_value):
	print("THREAD FUNC!")
	var result = api.mint(api_call_name.to_lower(), "jkfup-u5fms-2eumr-7z7ub-5ssv2-dpuxn-pmnrx-vwr4h-cqghb-xhki5-aae")
	call_deferred("loadDone")
	return result

func loadDone():
	var value = thread.wait_to_finish()
	print(value)	
	queue_free()
