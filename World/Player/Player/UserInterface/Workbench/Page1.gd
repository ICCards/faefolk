extends GridContainer

var hovered_item

func initialize():
	for item in self.get_children():
		if get_parent().level == "workbench #1":
			if get_parent().level_1_items.find(item.name) != -1:
				get_node(item.name).material.set_shader_param("flash_modifier", 0)
				if PlayerData.isSufficientMaterialToCraft(item.name):
					get_node(item.name).modulate = Color(1, 1, 1, 1)
				else:
					get_node(item.name).modulate = Color(1, 1, 1, 0.4)
			else:
				set_locked(item.name)
		elif get_parent().level == "workbench #2":
			if get_parent().level_1_items.find(item.name) != -1 or get_parent().level_2_items.find(item.name) != -1:
				get_node(item.name).material.set_shader_param("flash_modifier", 0)
				if PlayerData.isSufficientMaterialToCraft(item.name):
					get_node(item.name).modulate = Color(1, 1, 1, 1)
				else:
					get_node(item.name).modulate = Color(1, 1, 1, 0.4)
			else:
				set_locked(item.name)
		else: # level 3
			get_node(item.name).material.set_shader_param("flash_modifier", 0)
			if PlayerData.isSufficientMaterialToCraft(item.name):
				get_node(item.name).modulate = Color(1, 1, 1, 1)
			else:
				get_node(item.name).modulate = Color(1, 1, 1, 0.4)

func set_locked(item_name):
	get_node(item_name).disabled = true
	get_node(item_name).modulate = Color("50ffffff")
	get_node(item_name).material.set_shader_param("flash_modifier", 1)

func _on_wood_axe_pressed():
	get_parent().craft("wood axe")
func _on_stone_axe_pressed():
	get_parent().craft("stone axe")
func _on_bronze_axe_pressed():
	get_parent().craft("bronze axe")
func _on_iron_axe_pressed():
	get_parent().craft("iron axe")
func _on_gold_axe_pressed():
	get_parent().craft("gold axe")

func _on_wood_pickaxe_pressed():
	get_parent().craft("wood pickaxe")
func _on_stone_pickaxe_pressed():
	get_parent().craft("stone pickaxe")
func _on_bronze_pickaxe_pressed():
	get_parent().craft("bronze pickaxe")
func _on_iron_pickaxe_pressed():
	get_parent().craft("iron pickaxe")
func _on_gold_pickaxe_pressed():
	get_parent().craft("gold pickaxe")

func _on_wood_hoe_pressed():
	get_parent().craft("wood hoe")
func _on_stone_hoe_pressed():
	get_parent().craft("stone hoe")
func _on_bronze_hoe_pressed():
	get_parent().craft("bronze hoe")
func _on_iron_hoe_pressed():
	get_parent().craft("iron hoe")
func _on_gold_hoe_pressed():
	get_parent().craft("gold hoe")


func _on_wood_axe_mouse_entered():
	get_parent().entered_item_area("wood axe")
func _on_wood_axe_mouse_exited():
	get_parent().exited_item_area("wood axe")

func _on_stone_axe_mouse_entered():
	get_parent().entered_item_area("stone axe")
func _on_stone_axe_mouse_exited():
	get_parent().exited_item_area("stone axe")

func _on_bronze_axe_mouse_entered():
	get_parent().entered_item_area("bronze axe")
func _on_bronze_axe_mouse_exited():
	get_parent().exited_item_area("bronze axe")

func _on_iron_axe_mouse_entered():
	get_parent().entered_item_area("iron axe")
func _on_iron_axe_mouse_exited():
	get_parent().exited_item_area("iron axe")

func _on_gold_axe_mouse_entered():
	get_parent().entered_item_area("gold axe")
func _on_gold_axe_mouse_exited():
	get_parent().exited_item_area("gold axe")

func _on_wood_pickaxe_mouse_entered():
	get_parent().entered_item_area("wood pickaxe")
func _on_wood_pickaxe_mouse_exited():
	get_parent().exited_item_area("wood pickaxe")
	
func _on_stone_pickaxe_mouse_entered():
	get_parent().entered_item_area("stone pickaxe")
func _on_stone_pickaxe_mouse_exited():
	get_parent().exited_item_area("stone pickaxe")

func _on_bronze_pickaxe_mouse_entered():
	get_parent().entered_item_area("bronze pickaxe")
func _on_bronze_pickaxe_mouse_exited():
	get_parent().exited_item_area("bronze pickaxe")

func _on_iron_pickaxe_mouse_entered():
	get_parent().entered_item_area("iron pickaxe")
func _on_iron_pickaxe_mouse_exited():
	get_parent().exited_item_area("iron pickaxe")

func _on_gold_pickaxe_mouse_entered():
	get_parent().entered_item_area("gold pickaxe")
func _on_gold_pickaxe_mouse_exited():
	get_parent().exited_item_area("gold pickaxe")

func _on_wood_hoe_mouse_entered():
	get_parent().entered_item_area("wood hoe")
func _on_wood_hoe_mouse_exited():
	get_parent().exited_item_area("wood hoe")
	
func _on_stone_hoe_mouse_entered():
	get_parent().entered_item_area("stone hoe")
func _on_stone_hoe_mouse_exited():
	get_parent().exited_item_area("stone hoe")

func _on_bronze_hoe_mouse_entered():
	get_parent().entered_item_area("bronze hoe")
func _on_bronze_hoe_mouse_exited():
	get_parent().exited_item_area("bronze hoe")

func _on_iron_hoe_mouse_entered():
	get_parent().entered_item_area("iron hoe")
func _on_iron_hoe_mouse_exited():
	get_parent().exited_item_area("iron hoe")
	
func _on_gold_hoe_mouse_entered():
	get_parent().entered_item_area("gold hoe")
func _on_gold_hoe_mouse_exited():
	get_parent().exited_item_area("gold hoe")


