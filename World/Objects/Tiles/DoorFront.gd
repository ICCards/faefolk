extends Node2D


var door_open = false

var id
var location
var tier
var health
var max_health
var temp_health
var entered = false

func _ready():
	set_type()


func _input(event):
	if event.is_action_pressed("action") and entered:
		if door_open:
		#$AnimationPlayer.play("close")
			$AnimatedSprite.play("close")
			$MovementCollision/CollisionShape2D.disabled = false
		else:
			#$AnimationPlayer.play("open")
			$AnimatedSprite.play("open")
			$MovementCollision/CollisionShape2D.disabled = true
		door_open = !door_open
	
func set_type():
	match tier:
		"wood":
			$AnimatedSprite.frames = preload("res://Assets/Tilesets/doors/wood.tres")
			health = Stats.MAX_WOOD_WALL
			max_health = Stats.MAX_WOOD_WALL
		"metal":
			$AnimatedSprite.frames = preload("res://Assets/Tilesets/doors/metal.tres")
			health = Stats.MAX_METAL_WALL
			max_health = Stats.MAX_METAL_WALL
		"armored":
			$AnimatedSprite.frames = preload("res://Assets/Tilesets/doors/armored.tres")
			health = Stats.MAX_ARMORED_WALL
			max_health = Stats.MAX_ARMORED_WALL
		"demolish":
			Tiles.set_valid_tiles(location, Vector2(2,1))
			queue_free()
	
func remove_icon():
	$SelectedBorder.hide()


func _on_Area2D_input_event(viewport, event, shape_idx):
	pass
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot) and not PlayerInventory.viewInventoryMode:
			var tool_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
			if tool_name == "hammer":
				$SelectedBorder.show()
				Server.player_node.get_node("Camera2D/UserInterface/RadialDoorMenu").initialize(location, self)



func _on_HurtBox_area_entered(area):
	Stats.decrease_tool_health()
	show_health()
	if tier == "twig" or tier == "wood":
		health -= 1
	else:
		temp_health += 1
		if temp_health == 3:
			temp_health = 0
			health -= 1
	update_health_bar()

func update_health_bar():
	if health != 0:
		$HealthBar/Progress.value = health
		$HealthBar/Progress.max_value = max_health
	else:
		remove_tile()

func remove_tile():
	Tiles.set_valid_tiles(location, Vector2(2,1))
	queue_free()


func show_health():
	$AnimationPlayer2.stop()
	$AnimationPlayer2.play("show health bar")


func _on_EnterDoorway_area_entered(area):
	entered = true

func _on_EnterDoorway_area_exited(area):
	entered = false
