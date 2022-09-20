extends YSort

onready var WallHitEffect = preload("res://World/Objects/Tiles/WallHitEffect.tscn")

var tier
var health
var max_health
var item_name
var location

var temp_health = 0
var wall_tiles
var id

enum Tiers {
	TWIG,
	WOOD,
	STONE,
	METAL,
	ARMORED
}

func _ready():
	name = str(id)
	set_type()
	
func remove_icon():
	$SelectedBorder.hide()
	Tiles.selected_wall_tiles.set_cellv(location,-1)
	Tiles.selected_foundation_tiles.set_cellv(location,-1)
	
func set_type():
	match item_name:
		"wall":
			match tier:
				"twig":
					$SelectedWallVisual.texture = preload("res://Assets/Tilesets/walls/walls/twig.png")
					Tiles.wall_tiles.set_cellv(location, Tiers.TWIG)
					health = Stats.MAX_TWIG_WALL
					max_health = Stats.MAX_TWIG_WALL
				"wood":
					$SelectedWallVisual.texture = preload("res://Assets/Tilesets/walls/walls/wood.png")
					Tiles.wall_tiles.set_cellv(location, Tiers.WOOD)
					health = Stats.MAX_WOOD_WALL
					max_health = Stats.MAX_WOOD_WALL
				"stone":
					$SelectedWallVisual.texture = preload("res://Assets/Tilesets/walls/walls/stone.png")
					Tiles.wall_tiles.set_cellv(location, Tiers.STONE)
					health = Stats.MAX_STONE_WALL
					max_health = Stats.MAX_STONE_WALL
				"metal":
					$SelectedWallVisual.texture = preload("res://Assets/Tilesets/walls/walls/metal.png")
					Tiles.wall_tiles.set_cellv(location, Tiers.METAL)
					health = Stats.MAX_METAL_WALL
					max_health = Stats.MAX_METAL_WALL
				"armored":
					$SelectedWallVisual.texture = preload("res://Assets/Tilesets/walls/walls/armored.png")
					Tiles.wall_tiles.set_cellv(location, Tiers.ARMORED)
					health = Stats.MAX_ARMORED_WALL
					max_health = Stats.MAX_ARMORED_WALL
				"demolish":
					remove_wall()
			Tiles.wall_tiles.update_bitmask_area(location)
		"foundation":
			match tier:
				"twig":
					$TypeOfFoundationArea.set_collision_mask(512)
					Tiles.foundation_tiles.set_cellv(location, Tiers.TWIG)
					health = Stats.MAX_TWIG_WALL
					max_health = Stats.MAX_TWIG_WALL
				"wood":
					$TypeOfFoundationArea.set_collision_mask(512)
					Tiles.foundation_tiles.set_cellv(location, Tiers.WOOD)
					health = Stats.MAX_WOOD_WALL
					max_health = Stats.MAX_WOOD_WALL
				"stone":
					$TypeOfFoundationArea.set_collision_mask(1024)
					Tiles.foundation_tiles.set_cellv(location, Tiers.STONE)
					health = Stats.MAX_STONE_WALL
					max_health = Stats.MAX_STONE_WALL
				"metal":
					Tiles.foundation_tiles.set_cellv(location, Tiers.METAL)
					health = Stats.MAX_METAL_WALL
					max_health = Stats.MAX_METAL_WALL
				"armored":
					Tiles.foundation_tiles.set_cellv(location, Tiers.ARMORED)
					health = Stats.MAX_ARMORED_WALL
					max_health = Stats.MAX_ARMORED_WALL
				"demolish":
					remove_foundation()
			Tiles.foundation_tiles.update_bitmask_area(location)
	update_health_bar()


func update_health_bar():
	if health != 0:
		$HealthBar/Progress.value = health
		$HealthBar/Progress.max_value = max_health
	else:
		if item_name == "foundation":
			remove_foundation()
		elif item_name == "wall":
			remove_wall()


func remove_wall():
	Tiles.reset_valid_tiles(location)
	Tiles.wall_tiles.set_cellv(location, -1)
	Tiles.wall_tiles.update_bitmask_area(location)
	queue_free()

func remove_foundation():
	Tiles.foundation_tiles.set_cellv(location, -1)
	Tiles.foundation_tiles.update_bitmask_area(location)
	queue_free()


func _on_HurtBox_area_entered(area):
	if item_name == "wall":
		play_wall_hit_effect()
	if area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	if tier == "twig" or tier == "wood":
		health -= 1
	else:
		temp_health += 1
		if temp_health == 3:
			temp_health = 0
			health -= 1
	show_health()
	update_health_bar()

func play_wall_hit_effect():
	if has_node("WallHitEffect"):
		get_node("WallHitEffect").restart()
	else:
		var wallHitEffect = WallHitEffect.instance()
		wallHitEffect.name = "WallHitEffect"
		wallHitEffect.tier = tier
		wallHitEffect.autotile_cord = Tiles.wall_tiles.get_cell_autotile_coord(location.x, location.y)
		wallHitEffect.location = location
		wallHitEffect.position += Vector2(-16, 16)
		call_deferred("add_child", wallHitEffect)

func show_health():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("show health bar")

func _on_HurtBox_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot) and not PlayerInventory.viewInventoryMode:
			var tool_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
			if tool_name == "hammer":
				$SelectedBorder.show()
				show_selected_tile()
#				Tiles.wall_tiles.set_cellv(location,-1)
#				var autotile_cord = Tiles.wall_tiles.get_cell_autotile_coord(location.x, location.y)
#				Tiles.selected_wall_tiles.set_cell(location.x, location.y, false, false, false)
#				$SelectedWallVisual.frame = autotile_cord.x 
#				$SelectedWallVisual.show()
				Server.player_node.get_node("Camera2D/UserInterface/RadialUpgradeMenu").initialize(location, self)

func show_selected_tile():
	match item_name:
		"wall":
			var autotile_cord = Tiles.wall_tiles.get_cell_autotile_coord(location.x, location.y)
			match tier:
				"twig":
					Tiles.selected_wall_tiles.set_cell(location.x, location.y, Tiers.TWIG, false, false, false, autotile_cord)
				"wood":
					Tiles.selected_wall_tiles.set_cell(location.x, location.y, Tiers.WOOD, false, false, false, autotile_cord)
				"stone":
					Tiles.selected_wall_tiles.set_cell(location.x, location.y, Tiers.STONE, false, false, false, autotile_cord)
				"metal":
					Tiles.selected_wall_tiles.set_cell(location.x, location.y, Tiers.METAL, false, false, false, autotile_cord)
				"armored":
					Tiles.selected_wall_tiles.set_cell(location.x, location.y, Tiers.ARMORED, false, false, false, autotile_cord)
		"foundation":
			var autotile_cord = Tiles.foundation_tiles.get_cell_autotile_coord(location.x, location.y)
			match tier:
				"twig":
					Tiles.selected_foundation_tiles.set_cell(location.x, location.y, Tiers.TWIG, false, false, false, autotile_cord)
				"wood":
					Tiles.selected_foundation_tiles.set_cell(location.x, location.y, Tiers.WOOD, false, false, false, autotile_cord)
				"stone":
					Tiles.selected_foundation_tiles.set_cell(location.x, location.y, Tiers.STONE, false, false, false, autotile_cord)
				"metal":
					Tiles.selected_foundation_tiles.set_cell(location.x, location.y, Tiers.METAL, false, false, false, autotile_cord)
				"armored":
					Tiles.selected_foundation_tiles.set_cell(location.x, location.y, Tiers.ARMORED, false, false, false, autotile_cord)

func _on_HammerRepairBox_area_entered(area):
	set_type()
	Server.world.play_upgrade_building_effect(location)
	show_health()




func _on_DetectObjectOverPathBox_area_entered(area):
	if item_name == "foundation":
		$HurtBox/CollisionShape2D.set_deferred("disabled", true)
		$HammerRepairBox/CollisionShape2D.set_deferred("disabled", true)


func _on_DetectObjectOverPathBox_area_exited(area):
	if item_name == "foundation":
		yield(get_tree().create_timer(0.25), "timeout")
		$HurtBox/CollisionShape2D.set_deferred("disabled", false)
		$HammerRepairBox/CollisionShape2D.set_deferred("disabled", false)
