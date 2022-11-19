extends Node2D

var entered = false
var door_open = false
var id
var location
var item_name = "wood gate"


func _on_HurtBox_area_entered(area):
	if area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	InstancedScenes.intitiateItemDrop(item_name, position, 1)
	Tiles.add_valid_tiles(location, Vector2(2,1))
	queue_free()

func _input(event):
	if event.is_action_pressed("action") and $DetectObjectOverPathBox.get_overlapping_areas().size() <= 0:
		if door_open:
			$AnimatedSprite.play("close")
			$MovementCollision/CollisionShape2D.disabled = false
		else:
			$AnimatedSprite.play("open")
			$MovementCollision/CollisionShape2D.disabled = true
		door_open = !door_open
