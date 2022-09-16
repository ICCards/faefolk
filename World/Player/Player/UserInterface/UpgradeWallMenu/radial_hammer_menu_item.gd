extends Control

func _on_button_mouse_entered():
	get_node("../../").current_index = name.to_int()


func _on_button_mouse_exited():
	get_node("../../").current_index = -1


func _on_button_button_up():
	print("RELEASED ON BTN")
