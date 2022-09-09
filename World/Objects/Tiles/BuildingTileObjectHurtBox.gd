extends Node2D


var tier
var health
var max_health
var item_name
var location

var temp_health = 0
var wall_tiles


func _ready():
	set_type()
	
func set_type():
	wall_tiles = get_node("/root/World/PlacableTiles/BuildingTiles")
	match tier:
		"twig":
			health = Stats.MAX_TWIG_WALL
			max_health = Stats.MAX_TWIG_WALL
		"wood":
			health = Stats.MAX_WOOD_WALL
			max_health = Stats.MAX_WOOD_WALL
			wall_tiles.set_cellv(location, 2)
		"stone":
			health = Stats.MAX_STONE_WALL
			max_health = Stats.MAX_STONE_WALL
			wall_tiles.set_cellv(location, 0)
		"metal":
			health = Stats.MAX_METAL_WALL
			max_health = Stats.MAX_METAL_WALL
		"armored":
			health = Stats.MAX_ARMORED_WALL
			max_health = Stats.MAX_ARMORED_WALL
	update_health_bar()


func update_health_bar():
	if health != 0:
		$HealthBar/WateringCanProgress.value = health
		$HealthBar/WateringCanProgress.max_value = max_health
	else:
		remove_tile()



func remove_tile():
	Tiles.reset_valid_tiles(location)
	Tiles.building_tiles.set_cellv(location, -1)
	Tiles.building_tiles.update_bitmask_region()
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
	if event.is_action_pressed("mouse_click"):
		if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
			var tool_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
			if tool_name == "hammer":
				$UpgradeWallLabel.initialize()
				$UpgradeWallLabel.visible = not $UpgradeWallLabel.visible
