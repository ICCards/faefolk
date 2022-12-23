extends Node2D

onready var ItemDrop = load("res://InventoryLogic/ItemDrop.tscn")

var direction
var location

func _ready():
	set_direction()

func set_direction():
	match direction:
		"right":
			$Position2D.rotation_degrees = 0
			$Position2D.position = Vector2(0,0) 
			$Position2D/Image.flip_v = false
		"left":
			$Position2D.rotation_degrees = 180
			$Position2D.position = Vector2(64,32) 
			$Position2D/Image.flip_v = true
		"down":
			$Position2D.rotation_degrees = 270
			$Position2D.position = Vector2(0,32) 
			$Position2D/Image.flip_v = false
		"up":
			$Position2D.rotation_degrees = 90
			$Position2D.position = Vector2(32,-32) 
			$Position2D/Image.flip_v = false

func _unhandled_input(event):
	if event.is_action_pressed("action"):
		if $Position2D/DetectPlayer.get_overlapping_areas().size() >= 1 and Server.player_node.state == 0:
			Server.player_node.actions.sleep(direction, adjusted_pos())

func adjusted_pos():
	match direction:
		"down":
			return position + Vector2(16,30)
		"up":
			return position + Vector2(16,-32)
		"right":
			return position + Vector2(0,16)
		"left":
			return position + Vector2(64,16)

func _on_HurtBox_area_entered(area):
	var itemDrop = ItemDrop.instance()
	itemDrop.initItemDropType("sleeping bag")
	get_parent().call_deferred("add_child", itemDrop)
	itemDrop.global_position = global_position 
	if direction == "up" or direction == "down":
		Tiles.add_valid_tiles(location, Vector2(1,2))
	else:
		Tiles.add_valid_tiles(location, Vector2(2,1))
	queue_free()
