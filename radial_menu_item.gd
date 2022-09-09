extends Control


#func _on_button_pressed():
#	pass
#	get_parent().get_parent().current_item = name.to_int()
#	get_parent().get_parent().radial_menu_off()



func _on_button_button_up():
	pass
#	get_parent().get_parent().current_item = name.to_int()
#	get_parent().get_parent().radial_menu_off()


func _on_button_mouse_entered():
	get_node("../../").current_item = name.to_int()


func _on_button_mouse_exited():
	pass # Replace with function body.
