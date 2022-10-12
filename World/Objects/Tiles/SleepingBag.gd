extends Node2D

onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")

var direction 

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
			Server.player_node.sleep(direction, adjusted_pos())

func adjusted_pos():
	match direction:
		"down":
			return position + Vector2(16,30)
		"up":
			return position + Vector2(16,30)
		"right":
			return position + Vector2(16,30)
		"left":
			return position + Vector2(16,30)

func _on_HurtBox_area_entered(area):
	var itemDrop = ItemDrop.instance()
	itemDrop.initItemDropType("sleeping bag")
	get_parent().call_deferred("add_child", itemDrop)
	itemDrop.global_position = global_position 
	queue_free()
