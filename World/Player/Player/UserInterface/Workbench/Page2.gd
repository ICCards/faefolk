extends GridContainer

func initialize():
	for item in self.get_children():
		if get_parent().level == "workbench #1":
			if get_parent().level_1_items.find(item.name) != -1:
				get_node(item.name).disabled = false
				get_node(item.name).material.set_shader_param("flash_modifier", 0)
				if PlayerData.isSufficientMaterialToCraft(item.name):
					get_node(item.name).modulate = Color(1, 1, 1, 1)
				else:
					get_node(item.name).modulate = Color(1, 1, 1, 0.4)
			else:
				set_locked(item.name)
		elif get_parent().level == "workbench #2":
			if get_parent().level_1_items.find(item.name) != -1 or get_parent().level_2_items.find(item.name) != -1:
				get_node(item.name).disabled = false
				get_node(item.name).material.set_shader_param("flash_modifier", 0)
				if PlayerData.isSufficientMaterialToCraft(item.name):
					get_node(item.name).modulate = Color(1, 1, 1, 1)
				else:
					get_node(item.name).modulate = Color(1, 1, 1, 0.4)
			else:
				set_locked(item.name)
		else: # level 3
			get_node(item.name).disabled = false
			get_node(item.name).material.set_shader_param("flash_modifier", 0)
			if PlayerData.isSufficientMaterialToCraft(item.name):
				get_node(item.name).modulate = Color(1, 1, 1, 1)
			else:
				get_node(item.name).modulate = Color(1, 1, 1, 0.4)

func set_locked(item_name):
	get_node(item_name).disabled = true
	get_node(item_name).modulate = Color("50ffffff")
	get_node(item_name).material.set_shader_param("flash_modifier", 1)

func _on_wood_sword_pressed():
	get_parent().craft("wood sword")
func _on_stone_sword_pressed():
	get_parent().craft("stone sword")
func _on_bronze_sword_pressed():
	get_parent().craft("bronze sword")
func _on_iron_sword_pressed():
	get_parent().craft("iron sword")
func _on_gold_sword_pressed():
	get_parent().craft("gold sword")
	
func _on_stone_watering_can_pressed():
	get_parent().craft("stone watering can")
func _on_bronze_watering_can_pressed():
	get_parent().craft("bronze watering can")
func _on_gold_watering_can_pressed():
	get_parent().craft("gold watering can")
	
func _on_fishing_rod_pressed():
	get_parent().craft("fishing rod")
func _on_scythe_pressed():
	get_parent().craft("scythe")
func _on_bow_pressed():
	get_parent().craft("bow")
func _on_arrow_pressed():
	get_parent().craft("arrow")


func _on_wood_sword_mouse_entered():
	get_parent().entered_item_area("wood sword")
func _on_wood_sword_mouse_exited():
	get_parent().exited_item_area("wood sword")

func _on_stone_sword_mouse_entered():
	get_parent().entered_item_area("stone sword")
func _on_stone_sword_mouse_exited():
	get_parent().exited_item_area("stone sword")

func _on_bronze_sword_mouse_entered():
	get_parent().entered_item_area("bronze sword")
func _on_bronze_sword_mouse_exited():
	get_parent().exited_item_area("bronze sword")

func _on_iron_sword_mouse_entered():
	get_parent().entered_item_area("iron sword")
func _on_iron_sword_mouse_exited():
	get_parent().exited_item_area("iron sword")

func _on_gold_sword_mouse_entered():
	get_parent().entered_item_area("gold sword")
func _on_gold_sword_mouse_exited():
	get_parent().exited_item_area("gold sword")

func _on_stone_watering_can_mouse_entered():
	get_parent().entered_item_area("stone watering can")
func _on_stone_watering_can_mouse_exited():
	get_parent().exited_item_area("stone watering can")

func _on_bronze_watering_can_mouse_entered():
	get_parent().entered_item_area("bronze watering can")
func _on_bronze_watering_can_mouse_exited():
	get_parent().exited_item_area("bronze watering can")
	
func _on_gold_watering_can_mouse_entered():
	get_parent().entered_item_area("gold watering can")
func _on_gold_watering_can_mouse_exited():
	get_parent().exited_item_area("gold watering can")

func _on_fishing_rod_mouse_entered():
	get_parent().entered_item_area("fishing rod")
func _on_fishing_rod_mouse_exited():
	get_parent().exited_item_area("fishing rod")

func _on_scythe_mouse_entered():
	get_parent().entered_item_area("scythe")
func _on_scythe_mouse_exited():
	get_parent().exited_item_area("scythe")


func _on_bow_mouse_entered():
	get_parent().entered_item_area("bow")
func _on_bow_mouse_exited():
	get_parent().exited_item_area("bow")

func _on_arrow_mouse_entered():
	get_parent().entered_item_area("arrow")
func _on_arrow_mouse_exited():
	get_parent().exited_item_area("arrow")
