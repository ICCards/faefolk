extends Control


func _on_button_pressed():
	get_parent().get_parent().current_item = name.to_int()
	get_parent().get_parent().radial_menu_off()

