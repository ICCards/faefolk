extends Node2D

var item_name
var item_quantity


func _ready():
	PlayerStats.connect("watering_can_changed", self, "update_watering_can_amount")
	
func update_watering_can_amount():
	$WateringCanProgressIndicator/WateringCanProgress.value = PlayerStats.watering_can
	$WateringCanProgressIndicator/WateringCanProgress.max_value = PlayerStats.watering_can_maximum

func set_item(nm, qt):
	item_name = nm
	item_quantity = qt
	
	if item_name == "wood path1" or item_name == "wood path2":
		item_name = "wood path"
	elif item_name == "stone path1" or item_name == "stone path2" or  item_name == "stone path3" or item_name == "stone path4": 
		item_name = "stone path"
	$TextureRect.texture = load("res://Assets/Images/inventory_icons/" + JsonData.item_data[item_name]["ItemCategory"] + "/" + item_name + ".png")
	
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = String(item_quantity)
	if item_name == "stone watering can" or item_name == "bronze watering can" or item_name == "gold watering can":
		$WateringCanProgressIndicator.visible = true
		update_watering_can_amount()
	
func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = String(item_quantity)
	
func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$Label.text = String(item_quantity)
