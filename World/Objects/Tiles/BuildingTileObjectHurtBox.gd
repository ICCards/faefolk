extends YSort

onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

onready var WallHitEffect = load("res://World/Objects/Tiles/WallHitEffect.tscn")

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
	if tier != "demolish":
		MapData.world["placables"][str(name)]["v"] = tier
	match item_name:
		"wall":
			match tier:
				"twig":
					Tiles.wall_tiles.set_cellv(location, Tiers.TWIG)
					max_health = Stats.MAX_TWIG_WALL
				"wood":
					Tiles.wall_tiles.set_cellv(location, Tiers.WOOD)
					max_health = Stats.MAX_WOOD_WALL
				"stone":
					Tiles.wall_tiles.set_cellv(location, Tiers.STONE)
					max_health = Stats.MAX_STONE_WALL
				"metal":
					Tiles.wall_tiles.set_cellv(location, Tiers.METAL)
					max_health = Stats.MAX_METAL_WALL
				"armored":
					Tiles.wall_tiles.set_cellv(location, Tiers.ARMORED)
					max_health = Stats.MAX_ARMORED_WALL
				"demolish":
					remove_wall()
			Tiles.wall_tiles.update_bitmask_area(location)
		"foundation":
			match tier:
				"twig":
					Tiles.foundation_tiles.set_cellv(location, Tiers.TWIG)
					max_health = Stats.MAX_TWIG_WALL
				"wood":
					Tiles.foundation_tiles.set_cellv(location, Tiers.WOOD)
					max_health = Stats.MAX_WOOD_WALL
				"stone":
					Tiles.foundation_tiles.set_cellv(location, Tiers.STONE)
					max_health = Stats.MAX_STONE_WALL
				"metal":
					Tiles.foundation_tiles.set_cellv(location, Tiers.METAL)
					max_health = Stats.MAX_METAL_WALL
				"armored":
					Tiles.foundation_tiles.set_cellv(location, Tiers.ARMORED)
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
	if Server.world.has_node("WallHitEffect" + str(location)):
		Server.world.get_node("WallHitEffect" + str(location)).queue_free()
	$HealthBar.hide()
	$HurtBox/CollisionShape2D.set_deferred("disabled", true)
	$HammerRepairBox/CollisionShape2D.set_deferred("disabled", true)
	MapData.remove_object("placables",id)
	Tiles.add_valid_tiles(location)
	Tiles.wall_tiles.set_cellv(location, -1)
	Tiles.wall_tiles.update_bitmask_area(location)
	play_break_sound_effect()
	yield(get_tree().create_timer(1.5), "timeout")
	queue_free()

func remove_foundation():
	$HealthBar.hide()
	$HurtBox/CollisionShape2D.set_deferred("disabled", true)
	$HammerRepairBox/CollisionShape2D.set_deferred("disabled", true)
	MapData.remove_object("placables",id)
	Tiles.foundation_tiles.set_cellv(location, -1)
	Tiles.foundation_tiles.update_bitmask_area(location)
	play_break_sound_effect()
	yield(get_tree().create_timer(1.5), "timeout")
	queue_free()

func _on_HurtBox_area_entered(area):
	if health != 0:
		if area.name == "AxePickaxeSwing":
			Stats.decrease_tool_health()
		if tier == "twig" or tier == "wood":
			health -= 1
		else:
			temp_health += 1
			if temp_health == 3:
				temp_health = 0
				health -= 1
		if item_name == "wall" and health != 0:
			play_wall_hit_effect()
		if health != 0:
			play_hit_sound_effect()
		show_health()
		update_health_bar()

func play_wall_hit_effect():
	if Server.world.has_node("WallHitEffect" + str(location)):
		Server.world.get_node("WallHitEffect" + str(location)).restart()
	else:
		var wallHitEffect = WallHitEffect.instance()
		wallHitEffect.name = "WallHitEffect" + str(location)
		wallHitEffect.tier = tier
		wallHitEffect.autotile_cord = Tiles.wall_tiles.get_cell_autotile_coord(location.x, location.y)
		wallHitEffect.location = location
		wallHitEffect.position = (location*32)+Vector2(20,-20)
		Server.world.call_deferred("add_child", wallHitEffect)

func show_health():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("show health bar")

func _on_HurtBox_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		if PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot)) and not PlayerData.viewInventoryMode:
			var tool_name = PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][0]
			if tool_name == "hammer":
				$SelectedBorder.show()
				show_selected_tile()
				Server.player_node.user_interface.get_node("RadialUpgradeMenu").initialize(location, self)

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
	play_hammer_hit_sound()
	set_type()
	InstancedScenes.play_upgrade_building_effect(location)
	show_health()


func _on_DetectObjectOverPathBox_area_entered(area):
	if item_name == "foundation":
		$HurtBox/CollisionShape2D.set_deferred("disabled", true)
		$HammerRepairBox/CollisionShape2D.set_deferred("disabled", true)

func _on_DetectObjectOverPathBox_area_exited(area):
	if not Server.world.is_changing_scene:
		if item_name == "foundation":
			yield(get_tree().create_timer(0.25), "timeout")
			$HurtBox/CollisionShape2D.set_deferred("disabled", false)
			$HammerRepairBox/CollisionShape2D.set_deferred("disabled", false)

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

