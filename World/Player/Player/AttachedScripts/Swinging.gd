extends Node2D


onready var sound_effects = $SoundEffects
onready var axe_pickaxe_swing = $AxePickaxeSwing
onready var watering_can_particles1 = $WateringCanParticles1
onready var watering_can_particles2 = $WateringCanParticles2

onready var player_animation_player = get_node("../CompositeSprites/AnimationPlayer")
onready var composite_sprites = get_node("../CompositeSprites")
onready var dirt_tiles = get_node("/root/World/GeneratedTiles/DirtTiles")
onready var hoed_tiles = get_node("/root/World/FarmingTiles/HoedAutoTiles")
onready var watered_tiles = get_node("/root/World/FarmingTiles/WateredAutoTiles")
onready var ocean_tiles = get_node("/root/World/GeneratedTiles/AnimatedOceanTiles")


var animation
var direction

enum {
	MOVEMENT, 
	SWINGING,
	EAT,
	FISHING,
	CHANGE_TILE
}

func swing(item_name, direction):
	if get_parent().state != SWINGING:
		get_parent().state = SWINGING
		if item_name == "stone watering can":
			set_watered_tile()
			animation = "watering_" + direction.to_lower()
			player_animation_player.play("watering")
		elif item_name == "wood sword":
			animation = "sword_swing_" + direction.to_lower()
			player_animation_player.play(animation)
		else:
			set_swing_collision_layer_and_position(item_name, direction)
			animation = "swing_" + direction.to_lower()
			player_animation_player.play("axe pickaxe swing")
		PlayerStats.decrease_energy()
		#sendAction(SWING, {"tool": item_name, "direction": direction})
		composite_sprites.set_player_animation(get_parent().character, animation, item_name)
		yield(player_animation_player, "animation_finished" )
		get_parent().state = MOVEMENT

func set_swing_collision_layer_and_position(tool_name, direction):
	axe_pickaxe_swing.position = Util.set_swing_position(Vector2(0,0), direction)
	match tool_name:
		"wood axe": 
			axe_pickaxe_swing.set_collision_mask(8)
		"wood pickaxe":
			axe_pickaxe_swing.set_collision_mask(16)
			remove_hoed_tile(direction)
		"wood hoe":
			axe_pickaxe_swing.set_collision_mask(0)
			set_hoed_tile(direction)

func set_hoed_tile(direction):
	var pos = Util.set_swing_position(global_position, direction)
	var location = Tiles.valid_tiles.world_to_map(pos)
	if Tiles.valid_tiles.get_cellv(location) == 0 and \
	hoed_tiles.get_cellv(location) == -1 and \
	Tiles.isCenterBitmaskTile(location, dirt_tiles):
		yield(get_tree().create_timer(0.6), "timeout")
#		var id = get_node("/root/World").tile_ids["" + str(location.x) + "" + str(location.y)]
#		var data = {"id": id, "l": location}
#		Server.action("HOE", data)
		Stats.decrease_tool_health()
		sound_effects.stream = preload("res://Assets/Sound/Sound effects/Farming/hoe.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
		sound_effects.play()
		hoed_tiles.set_cellv(location, 0)
		hoed_tiles.update_bitmask_region()	


func remove_hoed_tile(direction):
	var pos = Util.set_swing_position(global_position, direction)
	var location = hoed_tiles.world_to_map(pos)
	if hoed_tiles.get_cellv(location) != -1:
		yield(get_tree().create_timer(0.6), "timeout")
		Stats.decrease_tool_health()
#		var id = get_node("/root/World").tile_ids["" + str(location.x) + "" + str(location.y)]
#		var data = {"id": id, "l": location}
#		Server.action("PICKAXE", data)
		sound_effects.stream = preload("res://Assets/Sound/Sound effects/Farming/hoe.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
		sound_effects.play()
		watered_tiles.set_cellv(location, -1)
		hoed_tiles.set_cellv(location, -1)
		hoed_tiles.update_bitmask_region()
		watered_tiles.update_bitmask_region()
		
		
func set_watered_tile():
	direction = get_parent().direction
	var pos = Util.set_swing_position(global_position, direction)
	var location = hoed_tiles.world_to_map(pos)
	if ocean_tiles.get_cellv(location) != -1:
		sound_effects.stream = preload("res://Assets/Sound/Sound effects/Farming/water fill.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
		sound_effects.play()
		Stats.refill_watering_can(PlayerInventory.hotbar[PlayerInventory.active_item_slot][0])
	elif PlayerInventory.hotbar[PlayerInventory.active_item_slot][2] >= 1:
		Stats.decrease_tool_health()
		sound_effects.stream = preload("res://Assets/Sound/Sound effects/Farming/water.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
		sound_effects.play()
		yield(get_tree().create_timer(0.2), "timeout")
		Server.world.play_watering_can_effect(location)
		if direction != "UP":
			watering_can_particles1.position = Util.returnAdjustedWateringCanPariclePos(direction)
			watering_can_particles1.emitting = true
			watering_can_particles2.position = Util.returnAdjustedWateringCanPariclePos(direction)
			watering_can_particles2.emitting = true
		yield(get_tree().create_timer(0.4), "timeout")
		watering_can_particles1.emitting = false
		watering_can_particles2.emitting = false
		if hoed_tiles.get_cellv(location) != -1:
	#		var id = get_node("/root/World").tile_ids["" + str(location.x) + "" + str(location.y)]
	#		var data = {"id": id, "l": location}
	#		Server.action("WATER", data)
			watered_tiles.set_cellv(location, 0)
			watered_tiles.update_bitmask_region()
	else: 
		sound_effects.stream = preload("res://Assets/Sound/Sound effects/Farming/ES_Error Tone Chime 6 - SFX Producer.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
		sound_effects.play()

