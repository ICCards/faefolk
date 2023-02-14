extends Node2D

var item_name
var item_quantity
var item_health


func set_item(nm, qt, health):
	item_name = nm
	item_quantity = qt
	item_health = health
	
	if item_name == "wood path1" or item_name == "wood path2":
		item_name = "wood path"
	elif item_name == "stone path1" or item_name == "stone path2" or  item_name == "stone path3" or item_name == "stone path4": 
		item_name = "stone path"
	$Image.texture = load("res://Assets/Images/inventory_icons/" + JsonData.item_data[item_name]["ItemCategory"] + "/" + item_name + ".png")
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size == 1 or item_quantity == null:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = String(item_quantity)
	if item_health != null:
		$HealthBar.visible = true
		set_health_bar(item_health)
	if item_quantity == null:
		$Image.size = Vector2(64,64)


func hover_crafting_item():
	var tween = get_tree().create_tween()
	tween.tween_property($Image, "scale", Vector2(1.05, 1.05), 0.075)
	
func exit_crafting_item():
	var tween = get_tree().create_tween()
	tween.tween_property($Image, "scale", Vector2(1.0, 1.0), 0.075,)


func set_health_bar(health):
	$HealthBar.value = health
	match item_name:
		"bow":
			$HealthBar.max_value = Stats.BOW_HEALTH
		"wood axe":
			$HealthBar.max_value = Stats.WOOD_TOOL_HEALTH
		"wood pickaxe":
			$HealthBar.max_value = Stats.WOOD_TOOL_HEALTH
		"wood sword":
			$HealthBar.max_value = Stats.WOOD_TOOL_HEALTH
		"wood hoe":
			$HealthBar.max_value = Stats.WOOD_TOOL_HEALTH
		"stone axe":
			$HealthBar.max_value = Stats.STONE_TOOL_HEALTH
		"stone pickaxe":
			$HealthBar.max_value = Stats.STONE_TOOL_HEALTH
		"stone sword":
			$HealthBar.max_value = Stats.STONE_TOOL_HEALTH
		"stone hoe":
			$HealthBar.max_value = Stats.STONE_TOOL_HEALTH
		"bronze axe":
			$HealthBar.max_value = Stats.BRONZE_TOOL_HEALTH
		"bronze pickaxe":
			$HealthBar.max_value = Stats.BRONZE_TOOL_HEALTH
		"bronze sword":
			$HealthBar.max_value = Stats.BRONZE_TOOL_HEALTH
		"bronze hoe":
			$HealthBar.max_value = Stats.BRONZE_TOOL_HEALTH
		"iron axe":
			$HealthBar.max_value = Stats.IRON_TOOL_HEALTH
		"iron pickaxe":
			$HealthBar.max_value = Stats.IRON_TOOL_HEALTH
		"iron sword":
			$HealthBar.max_value = Stats.IRON_TOOL_HEALTH
		"iron hoe":
			$HealthBar.max_value = Stats.IRON_TOOL_HEALTH
		"gold axe":
			$HealthBar.max_value = Stats.GOLD_TOOL_HEALTH
		"gold pickaxe":
			$HealthBar.max_value = Stats.GOLD_TOOL_HEALTH
		"gold sword":
			$HealthBar.max_value = Stats.GOLD_TOOL_HEALTH
		"gold hoe":
			$HealthBar.max_value = Stats.GOLD_TOOL_HEALTH
		"stone watering can":
			$HealthBar.max_value = Stats.MAX_STONE_WATERING_CAN
		"bronze watering can":
			$HealthBar.max_value = Stats.MAX_BRONZE_WATERING_CAN
		"gold watering can":
			$HealthBar.max_value = Stats.MAX_GOLD_WATERING_CAN
			
func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = String(item_quantity)
	
func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$Label.text = String(item_quantity)
