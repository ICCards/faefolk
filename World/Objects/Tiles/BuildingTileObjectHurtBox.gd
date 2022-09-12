extends Node2D


var tier
var health
var max_health
var item_name
var location

var temp_health = 0
var wall_tiles
var id


func _ready():
	name = str(id)
	set_type()
	
func remove_icon():
	$SelectedBorder.hide()
	
func set_type():
	match tier:
		"twig":
			health = Stats.MAX_TWIG_WALL
			max_health = Stats.MAX_TWIG_WALL
		"wood":
			health = Stats.MAX_WOOD_WALL
			max_health = Stats.MAX_WOOD_WALL
		"stone":
			health = Stats.MAX_STONE_WALL
			max_health = Stats.MAX_STONE_WALL
		"metal":
			health = Stats.MAX_METAL_WALL
			max_health = Stats.MAX_METAL_WALL
		"armored":
			health = Stats.MAX_ARMORED_WALL
			max_health = Stats.MAX_ARMORED_WALL
		"demolish":
			remove_tile()
	update_health_bar()


func update_health_bar():
	if health != 0:
		$HealthBar/Progress.value = health
		$HealthBar/Progress.max_value = max_health
	else:
		remove_tile()



func remove_tile():
	Tiles.reset_valid_tiles(location)
	Tiles.wall_tiles.set_cellv(location, -1)
	Tiles.wall_tiles.update_bitmask_area(location)
	queue_free()


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


func show_health():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("show health bar")

func _on_HurtBox_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot) and not PlayerInventory.viewInventoryMode:
			var tool_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
			if tool_name == "hammer":
				$SelectedBorder.show()
				Server.player_node.get_node("Camera2D/UserInterface/RadialHammerMenu").initialize(location, self)


func _on_HammerRepairBox_area_entered(area):
	set_type()
	Server.world.play_upgrade_building_effect(location)
	show_health()
