extends Control

func _on_button_mouse_entered():
	get_node("../../").current_index = name.to_int()


func _on_button_mouse_exited():
	get_node("../../").current_index = -1


func set_disabled():
	modulate = Color("000000")
	$button.disabled = true

func set_enabled():
	modulate = Color("ffffff")
	$button.disabled = false
