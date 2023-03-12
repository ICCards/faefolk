extends Node2D

@onready var interactives: Node = $Interactives
@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
@onready var hurt_box: CollisionShape2D = $Marker2D/HurtBox/CollisionShape2D
@onready var movement_collision: CollisionShape2D = $Marker2D/MovementCollision/CollisionShape2D
@onready var hammer_repair_box: CollisionShape2D = $Marker2D/HammerRepairBox/CollisionShape2D

@onready var WallHitEffect = load("res://World/Building/Tiles/WallHitEffect.tscn")
@onready var DoorInteractiveAreaNode = load("res://World/Building/Tiles/Attached nodes/door_interactive_area.tscn")

var tier
var health
var max_health
var item_name
var location
var direction
var wall_tiles
var door_opened: bool 
var destroyed: bool = false

enum Tiers {
	TWIG,
	WOOD,
	STONE,
	METAL,
	ARMORED
}

func _ready():
	set_type()
	if item_name == "wall":
		$Marker2D/HurtBox.set_collision_mask(8+16+262144)
		movement_collision.set_deferred("disabled", false)
		Tiles.remove_valid_tiles(location, Vector2(1,1))
	elif item_name == "foundation":
		movement_collision.set_deferred("disabled", true)
		$Marker2D/HurtBox.set_collision_mask(8+16)
	else:
		set_door_state()
		
func set_door_state():
	add_door_interactive_area_node("door")
	$Marker2D/HurtBox.set_collision_mask(8+16+262144)
	movement_collision.set_deferred("disabled", false)
	$Marker2D.scale = Constants.dimensions_dict[item_name]
	if direction == "left" or direction == "right":
		$Marker2D.rotation = 90
		$Marker2D.position.y = (Constants.dimensions_dict[item_name].x - 1) * -8
	else:
		$HealthBar.position.x = 12
		$Marker2D.position.x = (Constants.dimensions_dict[item_name].x - 1) * 8
	if direction == "down" or direction == "up":
		Tiles.remove_valid_tiles(location, Vector2(2,1))
	else:
		Tiles.remove_valid_tiles(location, Vector2(1,2))


func add_door_interactive_area_node(type):
	var doorInteractiveAreaNode = DoorInteractiveAreaNode.instantiate()
	doorInteractiveAreaNode.object_name = type
	doorInteractiveAreaNode.name = name
	$Marker2D.call_deferred("add_child", doorInteractiveAreaNode)


func remove_icon():
	$SelectedBorder.hide()
	#Tiles.selected_wall_tiles.set_cellv(location,-1)
	#Tiles.selected_foundation_tiles.set_cellv(location,-1)
	

func tile_upgraded():
	if tier != "demolish":
		match tier:
			"twig":
				health = Stats.MAX_TWIG_BUILDING
			"wood":
				health = Stats.MAX_WOOD_BUILDING
			"stone":
				health = Stats.MAX_STONE_BUILDING
			"metal":
				health = Stats.MAX_METAL_BUILDING
			"armored":
				health = Stats.MAX_ARMORED_BUILDING
	set_type()
	
func set_type():
#	if tier != "demolish":
#		MapData.world["placeable"][str(name)]["v"] = tier
	match item_name:
		"wood door":
			max_health = Stats.MAX_WOOD_DOOR
		"metal door":
			max_health = Stats.MAX_METAL_DOOR
		"armored door":
			max_health = Stats.MAX_ARMORED_DOOR
		"wall":
			match tier:
				"twig":
					Tiles.wall_tiles.set_cells_terrain_connect(0,[location],0,Tiers.TWIG)
					max_health = Stats.MAX_TWIG_BUILDING
				"wood":
					Tiles.wall_tiles.set_cells_terrain_connect(0,[location],0,Tiers.WOOD)
					max_health = Stats.MAX_WOOD_BUILDING
				"stone":
					Tiles.wall_tiles.set_cells_terrain_connect(0,[location],0,Tiers.STONE)
					max_health = Stats.MAX_STONE_BUILDING
				"metal":
					Tiles.wall_tiles.set_cells_terrain_connect(0,[location],0,Tiers.METAL)
					max_health = Stats.MAX_METAL_BUILDING
				"armored":
					Tiles.wall_tiles.set_cells_terrain_connect(0,[location],0,Tiers.ARMORED)
					max_health = Stats.MAX_ARMORED_BUILDING
				"demolish":
					remove_wall()
		"foundation":
			match tier:
				"twig":
					Tiles.foundation_tiles.set_cells_terrain_connect(0,[location],0,Tiers.TWIG)
					max_health = Stats.MAX_TWIG_BUILDING
				"wood":
					Tiles.foundation_tiles.set_cells_terrain_connect(0,[location],0,Tiers.WOOD)
					max_health = Stats.MAX_WOOD_BUILDING
				"stone":
					Tiles.foundation_tiles.set_cells_terrain_connect(0,[location],0,Tiers.STONE)
					max_health = Stats.MAX_STONE_BUILDING
				"metal":
					Tiles.foundation_tiles.set_cells_terrain_connect(0,[location],0,Tiers.METAL)
					max_health = Stats.MAX_METAL_BUILDING
				"armored":
					Tiles.foundation_tiles.set_cells_terrain_connect(0,[location],0,Tiers.ARMORED)
					max_health = Stats.MAX_ARMORED_BUILDING
				"demolish":
					remove_foundation()
	update_health_bar()


func update_health_bar():
	$HealthBar/Progress.value = health
	$HealthBar/Progress.max_value = max_health


func remove_wall():
	if not destroyed:
		destroyed = true
		Tiles.wall_tiles.set_cells_terrain_connect(0,[location],0,-1)
		$HealthBar.call_deferred("hide")
		$WallHit.call_deferred("hide")
		hurt_box.set_deferred("disabled", true)
		movement_collision.set_deferred("disabled", true)
		hammer_repair_box.set_deferred("disabled", true)
		MapData.remove_object("placeable",name)
		Tiles.add_valid_tiles(location)
		Tiles.wall_tiles.set_cells_terrain_connect(0,[location],0,-1)
		play_break_sound_effect()
		await get_tree().create_timer(1.5).timeout
		queue_free()

func remove_foundation():
	if not destroyed:
		destroyed = true
		Tiles.foundation_tiles.set_cells_terrain_connect(0,[location],0,-1)
		$HealthBar.call_deferred("hide")
		hurt_box.set_deferred("disabled", true)
		hammer_repair_box.set_deferred("disabled", true)
		MapData.remove_object("placeable",name)
		play_break_sound_effect()
		await get_tree().create_timer(1.0).timeout
		queue_free()

func _on_HurtBox_area_entered(area):
	if not destroyed:
		if item_name == "foundation" and not Tiles.valid_tiles.get_cell_atlas_coords(0,location) == Constants.VALID_TILE_ATLAS_CORD:
			return
		if area.name == "AxePickaxeSwing":
			Stats.decrease_tool_health()
		health -= Stats.return_tool_damage(area.tool_name)
		if health > 0:
			if item_name == "wall":
				$WallHit.initialize()
			play_hit_sound_effect()
			show_health()
			update_health_bar()
		else:
			if item_name == "foundation":
				remove_foundation()
			elif item_name == "wall":
				remove_wall()

#func play_wall_hit_effect():
#	pass
#	if Server.world.has_node("WallHitEffect" + str(location)):
#		Server.world.get_node("WallHitEffect" + str(location)).restart()
#	else:
#		var wallHitEffect = WallHitEffect.instantiate()
#		wallHitEffect.name = "WallHitEffect" + str(location)
#		wallHitEffect.tier = tier
#		wallHitEffect.autotile_cord = Tiles.wall_tiles.get_cell_autotile_coord(location.x, location.y)
#		wallHitEffect.location = location
#		wallHitEffect.position = (location*32)+Vector2(20,-20)
#		Server.world.call_deferred("add_child", wallHitEffect)

func show_health():
	$HealthBar/AnimationPlayer.stop()
	$HealthBar/AnimationPlayer.play("show health bar")

func _on_HurtBox_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot)) and not PlayerData.viewInventoryMode:
			var tool_name = PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][0]
			if tool_name == "hammer":
				#$SelectedBorder.show()
				show_selected_tile()
				Server.player_node.user_interface.get_node("RadialUpgradeMenu").initialize(location, self)

func show_selected_tile():
	pass
#	match item_name:
#		"wall":
#			var autotile_cord = Tiles.wall_tiles.get_cell_autotile_coord(location.x, location.y)
#			match tier:
#				"twig":
#					Tiles.selected_wall_tiles.set_cell(location.x, location.y, Tiers.TWIG, false, false, false, autotile_cord)
#				"wood":
#					Tiles.selected_wall_tiles.set_cell(location.x, location.y, Tiers.WOOD, false, false, false, autotile_cord)
#				"stone":
#					Tiles.selected_wall_tiles.set_cell(location.x, location.y, Tiers.STONE, false, false, false, autotile_cord)
#				"metal":
#					Tiles.selected_wall_tiles.set_cell(location.x, location.y, Tiers.METAL, false, false, false, autotile_cord)
#				"armored":
#					Tiles.selected_wall_tiles.set_cell(location.x, location.y, Tiers.ARMORED, false, false, false, autotile_cord)
#		"foundation":
#			var autotile_cord = Tiles.foundation_tiles.get_cell_autotile_coord(location.x, location.y)
#			match tier:
#				"twig":
#					Tiles.selected_foundation_tiles.set_cell(location.x, location.y, Tiers.TWIG, false, false, false, autotile_cord)
#				"wood":
#					Tiles.selected_foundation_tiles.set_cell(location.x, location.y, Tiers.WOOD, false, false, false, autotile_cord)
#				"stone":
#					Tiles.selected_foundation_tiles.set_cell(location.x, location.y, Tiers.STONE, false, false, false, autotile_cord)
#				"metal":
#					Tiles.selected_foundation_tiles.set_cell(location.x, location.y, Tiers.METAL, false, false, false, autotile_cord)
#				"armored":
#					Tiles.selected_foundation_tiles.set_cell(location.x, location.y, Tiers.ARMORED, false, false, false, autotile_cord)

func _on_HammerRepairBox_area_entered(area):
	play_hammer_hit_sound()
	set_type()
	InstancedScenes.play_upgrade_building_effect(location)
	show_health()

func play_hammer_hit_sound():
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Building/crafting.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
	sound_effects.play()

func play_hit_sound_effect():
	match tier:
		"twig":
			sound_effects.stream = load("res://Assets/Sound/Sound effects/Building/twig/twig hit.mp3")
		"wood":
			sound_effects.stream = load("res://Assets/Sound/Sound effects/Building/wood/wood hit.mp3")
		"stone":
			sound_effects.stream = load("res://Assets/Sound/Sound effects/Building/stone/stone hit.mp3")
		"metal":
			sound_effects.stream = load("res://Assets/Sound/Sound effects/Building/metal/metal hit.mp3")
		"armored":
			sound_effects.stream = load("res://Assets/Sound/Sound effects/Building/metal/metal hit.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
	sound_effects.play()

func play_break_sound_effect():
	match tier:
		"twig":
			sound_effects.stream = load("res://Assets/Sound/Sound effects/Building/wood/wood break.mp3")
		"wood":
			sound_effects.stream = load("res://Assets/Sound/Sound effects/Building/wood/wood break.mp3")
		"stone":
			sound_effects.stream = load("res://Assets/Sound/Sound effects/Building/stone/stone break.mp3")
		"metal":
			sound_effects.stream = null
		"armored":
			sound_effects.stream = null
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
	sound_effects.play()

