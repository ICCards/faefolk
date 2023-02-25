extends Control


var item_name = "strawberry seeds"
var item_quantity
var delay = 0

var width

func _ready():
	initialize()

func initialize():
	$AnimationPlayer.call_deferred("stop")
	set_deferred("modulate", Color("ffffff"))
	if item_name != "Inventory full!":
		$Icon.set_deferred("texture", load("res://Assets/Images/inventory_icons/" + JsonData.item_data[item_name]["ItemCategory"] + "/" + item_name + ".png"))
		$ItemName.set_deferred("text", item_name[0].to_upper() + item_name.substr(1,-1))
		await get_tree().process_frame
		set_size_of_description($ItemName.size.x)
		$GridContainer.size.x = width
		if item_quantity == 1:
			$Quantity.set_deferred("visible", false)
		else:
			$Quantity.set_deferred("visible", true)
			$Quantity.set_deferred("text", str(item_quantity))
		$DestroyTimer.start(3+delay)
	else:
		$Icon.set_deferred("texture", load("res://Assets/Images/User interface/ItemPickUpBox/x.png"))
		$ItemName.set_deferred("text", item_name)
		await get_tree().process_frame
		set_size_of_description($ItemName.size.x)
		$GridContainer.size.x = width
		$Quantity.set_deferred("visible", false)
		$DestroyTimer.start(3+delay)

func set_size_of_description(x):
	if x <= 417:
		width = 55
	else:
		width = 55 + ((x - 417) / 12)

func _on_DestroyTimer_timeout():
	$AnimationPlayer.call_deferred("play", "fade out")
	await $AnimationPlayer.animation_finished
	call_deferred("queue_free")
