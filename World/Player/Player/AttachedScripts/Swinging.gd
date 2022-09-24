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
onready var ocean_tiles = get_node("/root/World/GeneratedTiles/ShallowOcean")

onready var ArrowProjectile = preload("res://World/Objects/Misc/ArrowProjectile.tscn")

var rng = RandomNumberGenerator.new()

var animation
var direction

enum {
	MOVEMENT, 
	SWINGING,
	EAT,
	FISHING,
	CHANGE_TILE
}

var is_drawing = false
var is_releasing = false

func _process(delta):
	if is_drawing or is_releasing:
		var degrees = int($ArrowDirection.rotation_degrees) % 360
		$ArrowDirection.look_at(get_global_mouse_position())
		if $ArrowDirection.rotation_degrees >= 0:
			if degrees <= 45 or degrees >= 315:
				direction = "RIGHT"
			elif degrees <= 135:
				direction = "DOWN"
			elif degrees <= 225:
				direction = "LEFT"
			else:
				direction = "UP"
		else:
			if degrees >= -45 or degrees <= -315:
				direction = "RIGHT"
			elif degrees >= -135:
				direction = "UP"
			elif degrees >= -225:
				direction = "LEFT"
			else:
				direction = "DOWN"
		if is_drawing:
			composite_sprites.set_player_animation(get_parent().character, "draw_" + direction.to_lower(), "bow")
		elif is_releasing:
			composite_sprites.set_player_animation(get_parent().character, "release_" + direction.to_lower(), "bow release")

func swing(item_name, _direction):
	if get_parent().state != SWINGING:
		get_parent().state = SWINGING
		if item_name == "stone watering can" or item_name == "bronze watering can" or item_name == "gold watering can":
			set_watered_tile()
			animation = "watering_" + _direction.to_lower()
			player_animation_player.play("watering")
		elif item_name == "scythe" or item_name == "wood sword" or item_name == "stone sword" or item_name == "bronze sword" or item_name == "iron sword" or item_name == "gold sword":
			if item_name == "scythe":
				player_animation_player.play("scythe_swing_" + _direction.to_lower())
			else:
				player_animation_player.play("sword_swing_" + _direction.to_lower())
			animation = "sword_swing_" + _direction.to_lower()
			rng.randomize()
			sound_effects.stream = Sounds.sword_whoosh[rng.randi_range(0, Sounds.sword_whoosh.size()-1)]
			sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -4)
			sound_effects.play()
		elif item_name == "bow":
			if PlayerInventory.returnSufficentCraftingMaterial("arrow", 1):
				draw_bow(_direction)
				return
			else:
				get_parent().state = MOVEMENT
				return
		elif item_name == null:
			set_swing_collision_layer_and_position(item_name, _direction)
			animation = "punch_" + _direction.to_lower()
			player_animation_player.play("axe pickaxe swing")
		else:
			set_swing_collision_layer_and_position(item_name, _direction)
			animation = "swing_" + _direction.to_lower()
			player_animation_player.play("axe pickaxe swing")
		PlayerStats.decrease_energy()
		#sendAction(SWING, {"tool": item_name, "direction": direction})
		composite_sprites.set_player_animation(get_parent().character, animation, item_name)
		yield(player_animation_player, "animation_finished" )
		get_parent().state = MOVEMENT
		
func draw_bow(init_direction):
	is_drawing = true
	animation = "draw_" + init_direction.to_lower()
	player_animation_player.play("axe pickaxe swing")
	PlayerStats.decrease_energy()
	composite_sprites.set_player_animation(get_parent().character, animation, "bow")
	yield(player_animation_player, "animation_finished" )
	is_drawing = false
	is_releasing = true
	animation = "release_" + direction.to_lower()
	composite_sprites.set_player_animation(get_parent().character, animation, "bow release")
	player_animation_player.play("release bow")
	yield(player_animation_player, "animation_finished" )
	is_releasing = false
	PlayerInventory.remove_material("arrow", 1)
	shoot()
	get_parent().direction = direction
	get_parent().state = MOVEMENT
	
func shoot():
	var arrow = ArrowProjectile.instance()
	get_node("../../../").add_child(arrow)
	arrow.transform = $ArrowDirection.transform
	arrow.position = $ArrowDirection/Position2D.global_position
	arrow.velocity = get_global_mouse_position() - arrow.position
	

func set_swing_collision_layer_and_position(tool_name, direction):
	axe_pickaxe_swing.position = Util.set_swing_position(Vector2(0,0), direction)
	if tool_name == "wood axe" or tool_name == "stone axe" or tool_name == "iron axe" or tool_name == "bronze axe" or tool_name == "gold axe": 
		axe_pickaxe_swing.tool_name = tool_name
		axe_pickaxe_swing.set_collision_mask(8)
	elif tool_name == "wood pickaxe" or tool_name == "stone pickaxe" or tool_name == "iron pickaxe" or tool_name == "bronze pickaxe" or tool_name == "gold pickaxe": 
		axe_pickaxe_swing.tool_name = tool_name
		axe_pickaxe_swing.set_collision_mask(16)
		remove_hoed_tile(direction)
	elif tool_name == "wood hoe" or tool_name == "stone hoe" or tool_name == "iron hoe" or tool_name == "bronze hoe" or tool_name == "gold hoe": 
		axe_pickaxe_swing.tool_name = tool_name
		axe_pickaxe_swing.set_collision_mask(0)
		set_hoed_tile(direction)
	elif tool_name == "hammer":
		axe_pickaxe_swing.set_collision_mask(16384)
	elif tool_name == null:
		axe_pickaxe_swing.set_collision_mask(8)
		axe_pickaxe_swing.tool_name = "punch"

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
		Server.world.play_hoed_dirt_effect(location)
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

