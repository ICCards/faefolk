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
		$HealthIndicator.visible = true
		set_health_bar(item_health)
	if item_quantity == null:
		$Image.rect_size = Vector2(64,64)

func set_init_hovered():
	pass
#	$Image.rect_scale = Vector2(1.075, 1.075)
#	$Image.rect_position = Vector2(1.0, 1.0)

func hover_item():
	pass
#	$Tween.interpolate_property($Image, "rect_scale",
#		$Image.rect_scale, Vector2(1.075, 1.075), 0.075,
#		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	$Tween.interpolate_property($Image, "rect_position",
#		$Image.rect_position, Vector2(1, 1), 0.075,
#		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	$Tween.start()
	 
func exit_item():
	pass
#	if Server.isLoaded:
#		$Tween.interpolate_property($Image, "rect_scale",
#			$Image.rect_scale, Vector2(1.0, 1.0), 0.075,
#			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#		$Tween.interpolate_property($Image, "rect_position",
#			$Image.rect_position, Vector2(3.0, 3.0), 0.075,
#			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#		$Tween.start()


func set_health_bar(health):
	$HealthIndicator/ProgressBar.value = health
	match item_name:
		"bow":
			$HealthIndicator/ProgressBar.max_value = Stats.BOW_HEALTH
		"wood axe":
			$HealthIndicator/ProgressBar.max_value = Stats.WOOD_TOOL_HEALTH
		"wood pickaxe":
			$HealthIndicator/ProgressBar.max_value = Stats.WOOD_TOOL_HEALTH
		"wood sword":
			$HealthIndicator/ProgressBar.max_value = Stats.WOOD_TOOL_HEALTH
		"wood hoe":
			$HealthIndicator/ProgressBar.max_value = Stats.WOOD_TOOL_HEALTH
		"stone axe":
			$HealthIndicator/ProgressBar.max_value = Stats.STONE_TOOL_HEALTH
		"stone pickaxe":
			$HealthIndicator/ProgressBar.max_value = Stats.STONE_TOOL_HEALTH
		"stone sword":
			$HealthIndicator/ProgressBar.max_value = Stats.STONE_TOOL_HEALTH
		"stone hoe":
			$HealthIndicator/ProgressBar.max_value = Stats.STONE_TOOL_HEALTH
		"bronze axe":
			$HealthIndicator/ProgressBar.max_value = Stats.BRONZE_TOOL_HEALTH
		"bronze pickaxe":
			$HealthIndicator/ProgressBar.max_value = Stats.BRONZE_TOOL_HEALTH
		"bronze sword":
			$HealthIndicator/ProgressBar.max_value = Stats.BRONZE_TOOL_HEALTH
		"bronze hoe":
			$HealthIndicator/ProgressBar.max_value = Stats.BRONZE_TOOL_HEALTH
		"iron axe":
			$HealthIndicator/ProgressBar.max_value = Stats.IRON_TOOL_HEALTH
		"iron pickaxe":
			$HealthIndicator/ProgressBar.max_value = Stats.IRON_TOOL_HEALTH
		"iron sword":
			$HealthIndicator/ProgressBar.max_value = Stats.IRON_TOOL_HEALTH
		"iron hoe":
			$HealthIndicator/ProgressBar.max_value = Stats.IRON_TOOL_HEALTH
		"gold axe":
			$HealthIndicator/ProgressBar.max_value = Stats.GOLD_TOOL_HEALTH
		"gold pickaxe":
			$HealthIndicator/ProgressBar.max_value = Stats.GOLD_TOOL_HEALTH
		"gold sword":
			$HealthIndicator/ProgressBar.max_value = Stats.GOLD_TOOL_HEALTH
		"gold hoe":
			$HealthIndicator/ProgressBar.max_value = Stats.GOLD_TOOL_HEALTH
		"stone watering can":
			$HealthIndicator/ProgressBar.max_value = Stats.MAX_STONE_WATERING_CAN
		"bronze watering can":
			$HealthIndicator/ProgressBar.max_value = Stats.MAX_BRONZE_WATERING_CAN
		"gold watering can":
			$HealthIndicator/ProgressBar.max_value = Stats.MAX_GOLD_WATERING_CAN
			
func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = String(item_quantity)
	
func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$Label.text = String(item_quantity)
