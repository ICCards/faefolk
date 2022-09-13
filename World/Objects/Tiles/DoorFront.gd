extends Node2D


var door_open = false

var id
var location
var tier

func _on_Area2D_area_entered(area):
	if door_open:
		#$AnimationPlayer.play("close")
		$AnimatedSprite.play("close")
	else:
		#$AnimationPlayer.play("open")
		$AnimatedSprite.play("open")
	door_open = !door_open
	
	
func set_type():
	if tier == "demolish":
		Tiles.set_valid_tiles(location, Vector2(2,1))
		queue_free()
	
func remove_icon():
	$SelectedBorder.hide()


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot) and not PlayerInventory.viewInventoryMode:
			var tool_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
			if tool_name == "hammer":
				$SelectedBorder.show()
				Server.player_node.get_node("Camera2D/UserInterface/RadialDoorMenu").initialize(location, self)
