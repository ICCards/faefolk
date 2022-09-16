extends GridContainer

func initialize():
	for item in self.get_children():
		if item.name != "empty" and item.name != "empty2":
			if PlayerInventory.isSufficientMaterialToCraft(item.name):
				get_node(item.name).modulate = Color(1, 1, 1, 1)
			else:
				get_node(item.name).modulate = Color(1, 1, 1, 0.4)

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
#func _on_hammer_pressed():
#	get_parent().craft("hammer")
#func _on_blueprint_pressed():
#	get_parent().craft("blueprint")
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

#func _on_hammer_mouse_entered():
#	get_parent().entered_item_area("hammer")
#func _on_hammer_mouse_exited():
#	get_parent().exited_item_area("hammer")
#
#func _on_blueprint_mouse_entered():
#	get_parent().entered_item_area("blueprint")
#func _on_blueprint_mouse_exited():
#	get_parent().exited_item_area("blueprint")

func _on_bow_mouse_entered():
	get_parent().entered_item_area("bow")
func _on_bow_mouse_exited():
	get_parent().exited_item_area("bow")

func _on_arrow_mouse_entered():
	get_parent().entered_item_area("arrow")
func _on_arrow_mouse_exited():
	get_parent().exited_item_area("arrow")
