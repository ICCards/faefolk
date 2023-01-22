extends Node2D

var rng = RandomNumberGenerator.new()

var type
var variety
var location

var harvested = false

var object_name = "forage"

func _ready():
	call_deferred("hide")
	if type == "clam":
		Tiles.remove_valid_tiles(location)
		$MovementCollision/CollisionShape2D.set_deferred("disabled", false)
	elif type == "raw egg":
		pass
	else:
		Tiles.add_navigation_tiles(location)
	set_forage_texture()

func set_forage_texture():
	if type == "flower":
		$Sprite.call_deferred("hide")
		$AnimatedFlower.call_deferred("show")
		$AnimatedFlower.call_deferred("play", variety)
		$AnimatedFlower.set_deferred("frame", rng.randi_range(0,4))
	else:
		$Sprite.call_deferred("show")
		$AnimatedFlower.call_deferred("hide")
		$Sprite.set_deferred("texture", load("res://Assets/Images/inventory_icons/Forage/"+ variety +".png"))


func _on_VisibilityNotifier2D_screen_entered():
	call_deferred("show")
	$AnimatedFlower.set_deferred("playing", true)

func _on_VisibilityNotifier2D_screen_exited():
	call_deferred("hide")
	$AnimatedFlower.set_deferred("playing", false)
