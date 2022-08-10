extends Node2D


var tier
var health
var max_health
var item_name
var location

var temp_health = 0
var wall_tiles


const MAX_TWIG_WALL = 10
const MAX_WOOD_WALL = 250
const MAX_STONE_WALL = 500
const MAX_METAL_WALL = 1000
const MAX_ARMORED_WALL = 2000


func _ready():
	set_type()
	
func set_type():
	match tier:
		"twig":
			health = MAX_TWIG_WALL
			max_health = MAX_TWIG_WALL
		"wood":
			health = MAX_WOOD_WALL
			max_health = MAX_WOOD_WALL
		"stone":
			health = MAX_STONE_WALL
			max_health = MAX_STONE_WALL
		"metal":
			health = MAX_METAL_WALL
			max_health = MAX_METAL_WALL
		"armored":
			health = MAX_ARMORED_WALL
			max_health = MAX_ARMORED_WALL
	update_health_bar()


func update_health_bar():
	if health != 0:
		$HealthBar/WateringCanProgress.value = health
		$HealthBar/WateringCanProgress.max_value = max_health
	else:
		remove_tile()
		
func remove_tile():
	wall_tiles = get_node("/root/World/PlacableTiles/WallTiles")
	wall_tiles.set_cellv(location, -1)
	queue_free()


func _on_HurtBox_area_entered(area):
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
		$UpgradeWallLabel.initialize()
		$UpgradeWallLabel.visible = not $UpgradeWallLabel.visible
