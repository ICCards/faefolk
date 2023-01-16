extends GridContainer


func initialize():
	show()
	for mob in PlayerData.player_data["collections"]["mobs"].keys():
		if PlayerData.player_data["collections"]["mobs"][mob] > 0:
			get_node(mob).modulate = Color("ffffff") # unlocked
			get_node(mob).material.set_shader_param("flash_modifier", 0)
		else:
			get_node(mob).modulate = Color("50ffffff") # locked
			get_node(mob).material.set_shader_param("flash_modifier", 1)

func entered_item_area(item_name):
	get_parent().item = item_name
	get_node("../Tween").interpolate_property(get_node(item_name), "rect_scale",
		get_node(item_name).rect_scale, Vector2(1.1, 1.1), 0.075,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_node("../Tween").start()

func exited_item_area(item_name):
	get_parent().item = null
	if has_node(item_name):
		get_node("../Tween").interpolate_property(get_node(item_name), "rect_scale",
		get_node(item_name).rect_scale, Vector2(1.0, 1.0), 0.075,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_node("../Tween").start()
