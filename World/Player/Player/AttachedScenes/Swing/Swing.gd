extends Node2D


@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
@onready var sword_block: StaticBody2D = $SwordBlock
@onready var axe_pickaxe_swing: Area2D = $AxePickaxeSwing
@onready var sword_swing_area: Area2D = $SwordSwing
@onready var scythe_swing: Area2D = $ScytheSwing
@onready var watering_can_particles1 = $WateringCanParticles1
@onready var watering_can_particles2 = $WateringCanParticles2

@onready var player_animation_player = get_node("../CompositeSprites/AnimationPlayer")
@onready var player_animation_player2 = get_node("../CompositeSprites/AnimationPlayer2")
@onready var composite_sprites = get_node("../CompositeSprites")


var rng = RandomNumberGenerator.new()

var direction: String = "down"

enum {
	MOVEMENT, 
	SWINGING,
	EATING,
	FISHING,
	HARVESTING,
	DYING,
	SLEEPING,
	SITTING,
	MAGIC_CASTING,
	BOW_ARROW_SHOOTING,
	SWORD_SWINGING
}


func _ready():
	if not get_node("../").is_multiplayer_authority(): queue_free()

var thread = Thread.new()

func sword_swing(item_name,attack_index):
	if not thread.is_alive():
		thread.start(Callable(self,"whoAmISwordSwing").bind([item_name,attack_index]))

func whoAmISwordSwing(data):
	call_deferred("sword_swing_deferred",data[0],data[1])

func sword_swing_deferred(item_name,attack_index):
	if get_parent().state != SWORD_SWINGING:
		get_parent().state = SWORD_SWINGING
		if attack_index == 1:
			play_sword_swing_animation(item_name)
		elif attack_index == 2:
			play_sword_block_animation(item_name)
		get_parent().tool_name = item_name
		if get_parent().direction == "UP":
			get_node("../CompositeSprites/ToolEquipped").show_behind_parent = true
		else:
			get_node("../CompositeSprites/ToolEquipped").show_behind_parent = false
		await player_animation_player.animation_finished
		PlayerData.change_energy(-1)
		get_parent().state = MOVEMENT
		if get_node("../Magic").mouse_left_down and attack_index == 1:
			if valid_tool_health():
				sword_swing_deferred(item_name,1)
			else:
				swing(null)
			return
		elif get_node("../Magic").mouse_right_down and attack_index == 2:
			sword_swing_deferred(item_name,2)
			return
		sword_block.get_node("CollisionShape2D").set_deferred("disabled", true)
		thread.wait_to_finish()


func set_sword_block_position(direction):
	match direction:
		"DOWN":
			sword_block.set_deferred("rotation_degrees", 0)
			sword_block.set_deferred("position", Vector2(0,5))
		"UP":
			sword_block.set_deferred("rotation_degrees", 0)
			sword_block.set_deferred("position", Vector2(0,-21))
		"RIGHT":
			sword_block.set_deferred("rotation_degrees", 90)
			sword_block.set_deferred("position", Vector2(10,-8))
		"LEFT":
			sword_block.set_deferred("rotation_degrees", 90)
			sword_block.set_deferred("position", Vector2(-02,-8))


func set_sword_swing_position(direction):
	match direction:
		"DOWN":
			sword_swing_area.set_deferred("rotation_degrees", 90)
			sword_swing_area.set_deferred("position", Vector2(0,4))
		"UP":
			sword_swing_area.set_deferred("rotation_degrees", 90)
			sword_swing_area.set_deferred("position", Vector2(0,-22))
		"RIGHT":
			sword_swing_area.set_deferred("rotation_degrees", 0)
			sword_swing_area.set_deferred("position", Vector2(12,-8))
		"LEFT":
			sword_swing_area.set_deferred("rotation_degrees", 0)
			sword_swing_area.set_deferred("position", Vector2(-12,-8))

func set_scythe_swing_position(direction):
	match direction:
		"DOWN":
			scythe_swing.set_deferred("rotation_degrees", 90)
			scythe_swing.set_deferred("position", Vector2(0,8))
		"UP":
			scythe_swing.set_deferred("rotation_degrees", 90)
			scythe_swing.set_deferred("position", Vector2(0,-26))
		"RIGHT":
			scythe_swing.set_deferred("rotation_degrees", 0)
			scythe_swing.set_deferred("position", Vector2(16,-8))
		"LEFT":
			scythe_swing.set_deferred("rotation_degrees", 0)
			scythe_swing.set_deferred("position", Vector2(-16,-8))

func swing(item_name):
	if get_parent().state != SWINGING:
		get_node("../Sounds/FootstepsSound").stream_paused = true
		get_parent().state = SWINGING
		if item_name == "stone watering can" or item_name == "bronze watering can" or item_name == "gold watering can":
			play_watering_can_animation(item_name)
		elif item_name == "scythe":
			if get_parent().direction == "UP":
				get_node("../CompositeSprites/ToolEquipped").show_behind_parent = true
			else:
				get_node("../CompositeSprites/ToolEquipped").show_behind_parent = false
			play_scythe_swing_animation()
		elif item_name == "arrow":
			get_parent().state = MOVEMENT
			return
		elif item_name == null:
			play_punch_animation()
		else:
			if item_name == "hammer" and has_node("../MoveObject"):
				get_parent().state = MOVEMENT
				return
			play_axe_pickaxe_swing_animation(item_name)
		if item_name == null: # set for server
			get_parent().tool_name = ""
		else:
			get_parent().tool_name = item_name
		await player_animation_player.animation_finished
		PlayerData.change_energy(-1)
		get_parent().state = MOVEMENT
		if get_node("../Magic").mouse_left_down:
			if valid_tool_health():
				swing(item_name)
			else:
				swing(null)
			return


func play_sword_swing_animation(item_name):
	if get_node("../Magic").player_fire_buff:
		sword_swing_area.special_ability = "fire"
	else:
		sword_swing_area.special_ability = ""
	get_parent().animation = "sword_swing_" + get_parent().direction.to_lower()
	sword_swing_area.tool_name = item_name
	composite_sprites.set_player_animation(get_parent().character, get_parent().animation, item_name)
	player_animation_player.play("sword_swing")
	set_sword_swing_position(get_parent().direction)
	sound_effects.stream = Sounds.sword_whoosh[rng.randi_range(0, Sounds.sword_whoosh.size()-1)]
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -4)
	sound_effects.play()
	await get_tree().create_timer(0.1).timeout
	sword_swing_area.get_node("CollisionShape2D").set_deferred("disabled", false)
	await get_tree().create_timer(0.2).timeout
	sword_swing_area.get_node("CollisionShape2D").set_deferred("disabled", true)

func play_sword_block_animation(item_name):
	get_parent().animation = "sword_block_" + get_parent().direction.to_lower()
	player_animation_player.play("sword_block")
	set_sword_block_position(get_parent().direction)
	composite_sprites.set_player_animation(get_parent().character, get_parent().animation, item_name)
	sword_block.get_node("CollisionShape2D").set_deferred("disabled", false)

func play_watering_can_animation(item_name):
	set_watered_tile()
	get_parent().animation = "watering_" + get_parent().direction.to_lower()
	player_animation_player.play("axe pickaxe swing")
	composite_sprites.set_player_animation(get_parent().character, get_parent().animation, item_name)

func play_scythe_swing_animation(): 
	set_scythe_swing_position(get_parent().direction)
	player_animation_player.play("scythe_swing")  #("scythe_swing_" + get_parent().direction.to_lower())
	get_parent().animation = "sword_swing_" + get_parent().direction.to_lower()
	sound_effects.stream = Sounds.sword_whoosh[rng.randi_range(0, Sounds.sword_whoosh.size()-1)]
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -4)
	sound_effects.play()
	composite_sprites.set_player_animation(get_parent().character, get_parent().animation, "scythe")
	await get_tree().create_timer(0.1).timeout
	scythe_swing.get_node("CollisionShape2D").set_deferred("disabled", false)
	await get_tree().create_timer(0.2).timeout
	scythe_swing.get_node("CollisionShape2D").set_deferred("disabled", true)
	
func play_axe_pickaxe_swing_animation(item_name):
	set_swing_collision_layer_and_position(item_name, get_parent().direction)
	get_parent().animation = "swing_" + get_parent().direction.to_lower()
	player_animation_player.play("axe pickaxe swing")
	composite_sprites.set_player_animation(get_parent().character, get_parent().animation, item_name)
	await get_tree().create_timer(0.6).timeout
	axe_pickaxe_swing.get_node("CollisionShape2D").set_deferred("disabled", false)
	await get_tree().create_timer(0.1).timeout
	axe_pickaxe_swing.get_node("CollisionShape2D").set_deferred("disabled", true)
	
func play_punch_animation():
	set_swing_collision_layer_and_position(null, get_parent().direction)
	get_parent().animation = "punch_" + get_parent().direction.to_lower()
	player_animation_player.play("punch")
	composite_sprites.set_player_animation(get_parent().character, get_parent().animation, "")
	await get_tree().create_timer(0.3).timeout
	axe_pickaxe_swing.get_node("CollisionShape2D").set_deferred("disabled", false)
	await get_tree().create_timer(0.1).timeout
	axe_pickaxe_swing.get_node("CollisionShape2D").set_deferred("disabled", true)



func set_swing_collision_layer_and_position(tool_name, direction):
	axe_pickaxe_swing.position = Util.set_swing_position(Vector2.ZERO, direction)
#	if get_node("../Magic").player_fire_buff:
#		axe_pickaxe_swing.special_ability = "fire"
#	else:
#		axe_pickaxe_swing.special_ability = ""
	if tool_name == "wood axe" or tool_name == "stone axe" or tool_name == "iron axe" or tool_name == "bronze axe" or tool_name == "gold axe": 
		axe_pickaxe_swing.tool_name = tool_name
		axe_pickaxe_swing.set_collision_layer(8)
	elif tool_name == "wood pickaxe" or tool_name == "stone pickaxe" or tool_name == "iron pickaxe" or tool_name == "bronze pickaxe" or tool_name == "gold pickaxe": 
		axe_pickaxe_swing.tool_name = tool_name
		axe_pickaxe_swing.set_collision_layer(16)
		remove_hoed_tile(direction)
	elif tool_name == "wood hoe" or tool_name == "stone hoe" or tool_name == "iron hoe" or tool_name == "bronze hoe" or tool_name == "gold hoe": 
		axe_pickaxe_swing.tool_name = tool_name
		axe_pickaxe_swing.set_collision_layer(0)
		set_hoed_tile(direction)
	elif tool_name == "hammer":
		axe_pickaxe_swing.tool_name = tool_name
		axe_pickaxe_swing.set_collision_layer(16384)
	elif tool_name == null:
		axe_pickaxe_swing.set_collision_layer(8)
		axe_pickaxe_swing.tool_name = "punch"


func set_hoed_tile(direction):
	if Server.world.name == "Main":
		var pos = Util.set_swing_position(global_position, direction)
		var location = Tiles.valid_tiles.local_to_map(pos)
		if Tiles.valid_tiles.get_cell_atlas_coords(0,location) == Constants.VALID_TILE_ATLAS_CORD and \
		Tiles.hoed_tiles.get_cell_atlas_coords(0,location) == Vector2i(-1,-1) and \
		Tiles.isCenterBitmaskTile(location, Tiles.dirt_tiles) and \
		Tiles.foundation_tiles.get_cell_atlas_coords(0,location) == Vector2i(-1,-1):
			await get_tree().create_timer(0.6).timeout
			MapData.set_hoed_tile(location)
			InstancedScenes.play_hoed_dirt_effect(location)
			Stats.decrease_tool_health()
			sound_effects.stream = load("res://Assets/Sound/Sound effects/Farming/hoe.mp3")
			sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
			sound_effects.play()
			#Tiles.hoed_tiles.set_cells_terrain_connect(0,[location],0,0)


func remove_hoed_tile(direction):
	if Server.world.name == "Main":
		var pos = Util.set_swing_position(global_position, direction)
		var location = Tiles.hoed_tiles.local_to_map(pos)
		if Tiles.hoed_tiles.get_cell_atlas_coords(0,location) != Vector2i(-1,-1):
			await get_tree().create_timer(0.6).timeout
			MapData.remove_hoed_tile(location)
			Stats.decrease_tool_health()
			sound_effects.stream = load("res://Assets/Sound/Sound effects/Farming/hoe.mp3")
			sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
			sound_effects.play()
#			Tiles.watered_tiles.set_cells_terrain_connect(0,[location],0,-1)
#			Tiles.hoed_tiles.set_cells_terrain_connect(0,[location],0,-1)


func set_watered_tile():
	if Server.world.name == "Main":
		direction = get_parent().direction
		var pos = Util.set_swing_position(global_position, direction)
		var location = Tiles.valid_tiles.local_to_map(pos)
		if Tiles.ocean_tiles.get_cell_atlas_coords(0,location) != Vector2i(-1,-1) or Tiles.is_well_tile(location, direction):
			sound_effects.stream = load("res://Assets/Sound/Sound effects/Farming/water fill.mp3")
			sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
			sound_effects.play()
			Stats.refill_watering_can(PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][0])
		elif return_current_tool_health() >= 1:
			Stats.decrease_tool_health()
			sound_effects.stream = load("res://Assets/Sound/Sound effects/Farming/water.mp3")
			sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
			sound_effects.play()
			await get_tree().create_timer(0.2).timeout
			InstancedScenes.play_watering_can_effect(location)
			if direction != "UP":
				watering_can_particles1.position = Util.returnAdjustedWateringCanPariclePos(direction)
				watering_can_particles1.emitting = true
				watering_can_particles2.position = Util.returnAdjustedWateringCanPariclePos(direction)
				watering_can_particles2.emitting = true
			await get_tree().create_timer(0.4).timeout
			watering_can_particles1.emitting = false
			watering_can_particles2.emitting = false
			if Tiles.hoed_tiles.get_cell_atlas_coords(0,location) != Vector2i(-1,-1):
				MapData.set_watered_tile(location)
				#Tiles.watered_tiles.set_cells_terrain_connect(0,[location],0,0)
		else: 
			sound_effects.stream = load("res://Assets/Sound/Sound effects/Farming/ES_Error Tone Chime 6 - SFX Producer.mp3")
			sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
			sound_effects.play()


func valid_tool_health():
	if PlayerData.normal_hotbar_mode:
		return PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot))
	else:
		return PlayerData.player_data["combat_hotbar"].has(str(PlayerData.active_item_slot_combat_hotbar))

func return_current_tool_health():
	if PlayerData.normal_hotbar_mode:
		return PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][2]
	else:
		return PlayerData.player_data["combat_hotbar"][str(PlayerData.active_item_slot_combat_hotbar)][2]
