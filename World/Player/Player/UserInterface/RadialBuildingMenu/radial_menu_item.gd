extends Control


func _on_button_mouse_entered():
	get_node("../../").current_item = name.to_int()




