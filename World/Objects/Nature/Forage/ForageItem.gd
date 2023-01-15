extends Node2D

var rng = RandomNumberGenerator.new()

var type
var variety
var location

var harvested = false

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
	$Sprite.texture = load("res://Assets/Images/inventory_icons/Forage/"+ variety +".png")
	
func _input(event):
	if event.is_action_pressed("action") and $DetectPlayer.get_overlapping_areas().size() >= 1:
		if not harvested:
			harvested = true
			PlayerData.player_data["collections"]["forage"][variety] += 1
			$Sprite.hide()
			if type != "raw egg":
				Tiles.add_valid_tiles(location)
				MapData.remove_forage(name)
			Server.player_node.actions.harvest_forage(variety)
			yield(get_tree().create_timer(0.6), "timeout")
			PlayerData.add_item_to_hotbar(variety, 1, null)
			queue_free()
