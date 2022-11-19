extends Control



func _on_button_mouse_entered():
	get_node("../../").current_index = name.to_int()
	$hovered.show()


func _on_button_mouse_exited():
	get_node("../../").current_index = -1
	$hovered.hide()


func set_disabled():
	modulate = Color("8c8c8c")
	$button.disabled = true
	$hovered.hide()

func set_enabled():
	modulate = Color("ffffff")
	$button.disabled = false
	$hovered.hide()
