extends Node2D

var rng = RandomNumberGenerator.new()

var type
var variety
var location

var harvested = false

var object_name = "forage"

func _ready():
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
		$Sprite.hide()
		$AnimatedFlower.show()
		$AnimatedFlower.play(variety)
		$AnimatedFlower.frame = rng.randi_range(0,4)
	else:
		$Sprite.show()
		$AnimatedFlower.hide()
		$Sprite.texture = load("res://Assets/Images/inventory_icons/Forage/"+ variety +".png")


func _on_VisibilityNotifier2D_screen_entered():
	show()
	$AnimatedFlower.playing = true


func _on_VisibilityNotifier2D_screen_exited():
	hide()
	$AnimatedFlower.playing = false
