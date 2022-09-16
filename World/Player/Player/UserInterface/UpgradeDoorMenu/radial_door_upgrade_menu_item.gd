extends Control



func _ready():
	if name == "0" or name == "2":
		modulate = Color("000000")
		$button.disabled = true


func _on_button_mouse_entered():
	get_node("../../").current_index = name.to_int()

func _on_button_mouse_exited():
	get_node("../../").current_index = -1
