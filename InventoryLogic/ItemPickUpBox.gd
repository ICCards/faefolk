extends Control


var item_name = "strawberry seeds"
var item_quantity
var delay = 0

var width

func _ready():
	initialize()

func initialize():
	show()
	set_deferred("modulate", Color("ffffff"))
	$Icon.set_deferred("texture", load("res://Assets/Images/inventory_icons/" + JsonData.item_data[item_name]["ItemCategory"] + "/" + item_name + ".png"))
	$ItemName.set_deferred("text", item_name[0].to_upper() + item_name.substr(1,-1))
	yield(get_tree(), "idle_frame")
	set_size_of_description($ItemName.rect_size.x)
	$GridContainer.rect_size.x = width
	if item_quantity == 1:
		$Quantity.set_deferred("visible", false)
	else:
		$Quantity.set_deferred("visible", true)
		$Quantity.set_deferred("text", str(item_quantity))
	$AnimationPlayer.stop()
	$DestroyTimer.start(3+delay)

func set_size_of_description(x):
	if x <= 120:
		width = 55
	else:
		width = 55 + ((x - 120) / 4.75)

func _on_DestroyTimer_timeout():
	$AnimationPlayer.play("fade out")
	yield($AnimationPlayer, "animation_finished")
	call_deferred("queue_free")
