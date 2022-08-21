extends Node2D


onready var player_animation_player = get_node("../CompositeSprites/AnimationPlayer")
onready var composite_sprites = get_node("../CompositeSprites")
onready var dirt_tiles = get_node("/root/World/GeneratedTiles/DirtTiles")
onready var hoed_tiles = get_node("/root/World/FarmingTiles/HoedAutoTiles")
onready var watered_tiles = get_node("/root/World/FarmingTiles/WateredAutoTiles")

var animation

enum {
	MOVEMENT, 
	SWING,
	EAT,
	FISHING,
	CHANGE_TILE
}


func initialize(item_name, direction):
	if get_parent().state != SWING:
		get_parent().state = SWING
		if item_name == "stone watering can":
			animation = "watering_" + direction.to_lower()
		elif item_name == "wood sword":
			animation = "sword_swing_" + direction.to_lower()
		elif item_name == "fishing rod":
			animation = "cast_" + direction.to_lower()
		else:
			set_melee_collision_layer(item_name, direction)
			animation = "swing_" + direction.to_lower()
		PlayerStats.decrease_energy()
		#sendAction(SWING, {"tool": item_name, "direction": direction})
		composite_sprites.set_player_animation(get_parent().character, animation, item_name)
		player_animation_player.play(animation)
		yield(player_animation_player, "animation_finished" )
		get_parent().state = MOVEMENT
#		if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
#			var new_tool_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
#			var new_item_category = JsonData.item_data[new_tool_name]["ItemCategory"]
#			if Input.is_action_pressed("mouse_click") and new_item_category == "Weapon":
#				swing_state(new_tool_name)
#			else:
#				state = MOVEMENT
#		else: 
#			state = MOVEMENT


func set_melee_collision_layer(_tool, direction):
	if _tool == "wood axe": 
		$MeleeSwing.set_collision_mask(8)
	elif _tool == "wood pickaxe":
		$MeleeSwing.set_collision_mask(16)
		remove_hoed_tile(direction)
	elif _tool == "wood hoe":
		$MeleeSwing.set_collision_mask(0)
		set_hoed_tile(direction)


func set_hoed_tile(direction):
	var pos = Util.set_swing_position(get_position(), direction)
	var location = Tiles.valid_tiles.world_to_map(pos)
	if Tiles.valid_tiles.get_cellv(location) == -1 and \
	Tiles.isCenterBitmaskTile(location, dirt_tiles) and \
	Tiles.valid_tiles.get_cellv(location) != -1:
		yield(get_tree().create_timer(0.6), "timeout")
#		var id = get_node("/root/World").tile_ids["" + str(location.x) + "" + str(location.y)]
#		var data = {"id": id, "l": location}
#		Server.action("HOE", data)
		Stats.decrease_tool_health()
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/hoe.mp3")
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
		$SoundEffects.play()
		hoed_tiles.set_cellv(location, 0)
		hoed_tiles.update_bitmask_region()	


func remove_hoed_tile(direction):
	var pos = Util.set_swing_position(get_position(), direction)
	var location = hoed_tiles.world_to_map(pos)
	if hoed_tiles.get_cellv(location) != -1:
		yield(get_tree().create_timer(0.6), "timeout")
		Stats.decrease_tool_health()
#		var id = get_node("/root/World").tile_ids["" + str(location.x) + "" + str(location.y)]
#		var data = {"id": id, "l": location}
#		Server.action("PICKAXE", data)
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/hoe.mp3")
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
		$SoundEffects.play()
		watered_tiles.set_cellv(location, -1)
		hoed_tiles.set_cellv(location, -1)
		hoed_tiles.update_bitmask_region()	


