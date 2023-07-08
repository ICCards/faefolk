extends Node2D

var rng = RandomNumberGenerator.new()

var item_name = "sunflower"
var location 
var harvested = false
var first_placement
var object_name = "forage"

func _ready():
	rng.randomize()
	if item_name == "red clam" or item_name == "blue clam" or item_name == "pink clam":
		Tiles.remove_valid_tiles(location)
		$MovementCollision/CollisionShape2D.set_deferred("disabled", false)
		$HurtBox/CollisionShape2D.set_deferred("disabled", false)
	elif item_name == "raw egg":
		pass
	else:
		Tiles.add_navigation_tiles(location)
	set_forage_texture()


func remove_from_world():
	$MovementCollision.call_deferred("queue_free")
	$CollisionShape2D.call_deferred("queue_free")
	call_deferred("queue_free")


func set_forage_texture():
	if item_name == "sunflower" or item_name == "dandelion" or item_name == "lily of the nile" or item_name == "poppy flower" or item_name == "tulip":
		$Sprite2D.call_deferred("hide")
		$AnimatedFlower.call_deferred("show")
		$AnimatedFlower.call_deferred("play", item_name)
		$AnimatedFlower.set_deferred("frame", rng.randi_range(0,4))
	else:
		$Sprite2D.call_deferred("show")
		$AnimatedFlower.call_deferred("hide")
		$Sprite2D.set_deferred("texture", load("res://Assets/Images/inventory_icons/Forage/"+ item_name +".png"))



func _on_hurt_box_area_entered(area):
	if area.tool_name == "arrow" or area.tool_name == "fire projectile":
		area.destroy()
