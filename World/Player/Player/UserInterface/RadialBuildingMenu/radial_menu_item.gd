extends Control


func _on_button_mouse_entered():
	get_node("../../").current_item = name.to_int()
	$hovered.show()


func _on_button_mouse_exited():
	get_node("../../").current_item = -1
	$hovered.hide()

func initialize():
	$hovered.hide()
