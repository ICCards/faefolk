extends GridContainer


func initialize():
	show()
	for item in self.get_children():
		if PlayerData.player_data["collections"]["food"][item.name] > 0:
			item.modulate = Color("ffffff") # unlocked
			item.material.set_shader_parameter("flash_modifier", 0)
		else:
			item.modulate = Color("50ffffff") # locked
			item.material.set_shader_parameter("flash_modifier", 1)

func entered_item_area(item_name):
	get_parent().item = item_name
	var tween = get_tree().create_tween()
	tween.tween_property(get_node(item_name), "scale", Vector2(1.1, 1.1), 0.075)

func exited_item_area(item_name):
	get_parent().item = null
	if has_node(item_name):
		var tween = get_tree().create_tween()
		tween.tween_property(get_node(item_name), "scale", Vector2(1.0, 1.0), 0.075)

