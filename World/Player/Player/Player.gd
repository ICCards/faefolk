extends KinematicBody2D

onready var animation_player = $CompositeSprites/AnimationPlayer
onready var day_night_animation_player = $Camera2D/DayNight/AnimationPlayer
onready var tween = $Tween

var valid_tiles
var hoed_tiles
var watered_tiles
var grass_tiles
var fence_tiles
var object_tiles
var path_tiles
var principal
var character 
var setting
var is_mouse_over_hotbar
var username_callback = JavaScript.create_callback(self, "_username_callback")

onready var state = MOVEMENT

enum {
	MOVEMENT, 
	SWING,
	CHANGE_TILE
}

var direction = "DOWN"
var rng = RandomNumberGenerator.new()

var animation = "idle_down"
var MAX_SPEED := 12.5
var ACCELERATION := 6
var FRICTION := 8
var velocity := Vector2.ZERO

#const _character = preload("res://Global/Data/Characters.gd")

func _ready():
	set_username("")
	#IC.getUsername(principal,username_callback)
	set_player_setting(get_parent().get_parent())
	_play_background_music()
	$Camera2D/UserInterface.initialize_user_interface()
	PlayerInventory.emit_signal("active_item_updated")
	Sounds.connect("volume_change", self, "set_new_music_volume")
	
	
func _physics_process(delta):
	var ocean = get_node("/root/World/GeneratedTiles/AnimatedBeachBorder")
	if ocean.get_cellv(ocean.world_to_map(position)) != -1:
		MAX_SPEED = 11.5
		tween.interpolate_property($HidePlayerMask, "position",
		$HidePlayerMask.position, Vector2(0,8), 0.05,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		if Tiles.isCenterBitmaskTile(ocean.world_to_map(position), ocean) and Tiles.isCenter16Tiles(ocean.world_to_map(position), ocean):
			MAX_SPEED = 9.5
			tween.interpolate_property($HidePlayerMask, "position",
			$HidePlayerMask.position, Vector2(0,-14), 0.05,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
		elif Tiles.isCenterBitmaskTile(ocean.world_to_map(position), ocean):
			tween.interpolate_property($HidePlayerMask, "position",
			$HidePlayerMask.position, Vector2(0,-2), 0.05,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
	else: 
		MAX_SPEED = 12.5
		tween.interpolate_property($HidePlayerMask, "position",
		$HidePlayerMask.position, Vector2(0,20), 0.05,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	
	
func _username_callback(args):
	# Get the first argument (the DOM event in our case).
	var js_event = args[0]
	#	var player_id = json["id"]
	#	var principal = json["principal"]
	set_username(js_event)	
	
func DisplayMessageBubble(message):
	$MessageBubble.visible = true
	if $Timer.time_left > 0:
		$MessageBubble.text = ""
		$MessageBubble.text = message
		#adjust_bubble_position($MessageBubble.get_line_count())
		$Timer.stop()
		$Timer.start()
		yield($Timer, "timeout")
		$MessageBubble.visible = false
	else:
		$MessageBubble.text = ""
		$MessageBubble.text = message
		$Timer.start()
		#adjust_bubble_position($MessageBubble.get_line_count())
		yield($Timer, "timeout")
		$MessageBubble.visible = false

func adjust_bubble_position(lines):
	$MessageBubble.rect_position = $MessageBubble.rect_position + Vector2(0, 4 * (lines - 1))

	
func set_username(username):
	Server.username = username
	$Username.text = str(username)	
	
func initialize_camera_limits(top_left, bottom_right):
	$Camera2D.limit_top = top_left.y
	$Camera2D.limit_left = top_left.x
	$Camera2D.limit_bottom = bottom_right.y
	$Camera2D.limit_right = bottom_right.x
	
func sendAction(action,data): 
	match action:
		(MOVEMENT):
			Server.action("MOVEMENT",data)
		(SWING):
			Server.action("SWING", data)

func set_new_music_volume():
	$BackgroundMusic.volume_db = Sounds.return_adjusted_sound_db("music", -36)
	if Sounds.current_footsteps_sound == Sounds.stone_footsteps:
		$DetectPathType/FootstepsSound.volume_db = Sounds.return_adjusted_sound_db("footstep", 0)
	else: 
		$DetectPathType/FootstepsSound.volume_db = Sounds.return_adjusted_sound_db("footstep", -10)
	
	
func _play_background_music():
	rng.randomize()
	$BackgroundMusic.stream = Sounds.background_music[rng.randi_range(0, Sounds.background_music.size() - 1)]
	$BackgroundMusic.play()
	$BackgroundMusic.volume_db =  Sounds.return_adjusted_sound_db("music", -32)
	yield($BackgroundMusic, "finished")
	_play_background_music()
	
	
func _process(_delta) -> void:
	var adjusted_position = get_global_mouse_position() - $Camera2D.get_camera_screen_center() 
	if adjusted_position.x > -240 and adjusted_position.x < 240 and adjusted_position.y > 210 and adjusted_position.y < 254:
		is_mouse_over_hotbar = true
	else:
		is_mouse_over_hotbar = false
	if not PlayerInventory.viewInventoryMode and not PlayerInventory.interactive_screen_mode:
		if $PickupZone.items_in_range.size() > 0:
			var pickup_item = $PickupZone.items_in_range.values()[0]
			pickup_item.pick_up_item(self)
			$PickupZone.items_in_range.erase(pickup_item)
		match state:
			MOVEMENT:
				movement_state(_delta)
	else: 
		idle_state(direction)

func _unhandled_input(event):
	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot) and \
		not PlayerInventory.viewInventoryMode and \
		not PlayerInventory.interactive_screen_mode and \
		Server.player_state == "WORLD" and \
		not PlayerInventory.chatMode and \
		not PlayerInventory.viewMapMode and \
		not is_mouse_over_hotbar and \
		not swingActive: 
			var item_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
			var itemCategory = JsonData.item_data[item_name]["ItemCategory"]
			if Input.is_action_pressed("mouse_click") and itemCategory == "Weapon" and setting == "World":
				swing_state(item_name)
			if itemCategory == "Placable object":
				$PlaceItemsUI.place_item_state(event, item_name, valid_tiles)
			elif itemCategory == "Placable path":
				$PlaceItemsUI.place_path_state(event, item_name, valid_tiles, path_tiles)
			elif itemCategory == "Seed":
				$PlaceItemsUI.place_seed_state(event, item_name, valid_tiles, hoed_tiles)
	else: 
		$PlaceItemsUI.set_invisible()

func movement_state(delta):
	if !swingActive and not PlayerInventory.chatMode:
		animation_player.play("movement")
		var input_vector = Vector2.ZERO			
		if Input.is_action_pressed("move_up"):
			input_vector.y -= 1.0
			direction = "UP"
			walk_state(direction)
			var data = {"p":get_global_position(),"d":direction,"t":Server.client_clock}
			sendAction(MOVEMENT,data)
		if Input.is_action_pressed("move_down"):
			input_vector.y += 1.0
			direction = "DOWN"
			walk_state(direction)
			var data = {"p":position,"d":direction,"t":Server.client_clock}
			sendAction(MOVEMENT,data)
		if Input.is_action_pressed("move_left"):
			input_vector.x -= 1.0
			direction = "LEFT"
			walk_state(direction)
			var data = {"p":position,"d":direction,"t":Server.client_clock}
			sendAction(MOVEMENT,data)
		if Input.is_action_pressed("move_right"):
			input_vector.x += 1.0
			direction = "RIGHT"
			walk_state(direction)
			var data = {"p":position,"d":direction,"t":Server.client_clock}
			sendAction(MOVEMENT,data)		
		if !Input.is_action_pressed("move_right") && !Input.is_action_pressed("move_left")  && !Input.is_action_pressed("move_up")  && !Input.is_action_pressed("move_down"):
			idle_state(direction)
			var data = {"p":position,"d":direction,"t":Server.client_clock}
			sendAction(MOVEMENT,data)
		input_vector = input_vector.normalized()
		if input_vector != Vector2.ZERO:
			velocity += input_vector * ACCELERATION * delta
			velocity = velocity.clamped(MAX_SPEED * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		move_and_collide(velocity * MAX_SPEED)	

var swingActive = false
func swing_state(item_name):
		$DetectPathType/FootstepsSound.stream_paused = true
		if !swingActive:
			state = SWING
			PlayerStats.decrease_energy()
			sendAction(SWING, {"tool": item_name, "direction": direction})
			swingActive = true
			set_melee_collision_layer(item_name)
			animation = "swing_" + direction.to_lower()
			$CompositeSprites.set_player_animation(character, animation, item_name)
			animation_player.play(animation)
			yield(animation_player, "animation_finished" )
			swingActive = false
			if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
				var new_tool_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
				var new_item_category = JsonData.item_data[new_tool_name]["ItemCategory"]
				if Input.is_action_pressed("mouse_click") and new_item_category == "Weapon":
					swing_state(new_tool_name)
				else:
					state = MOVEMENT
			else: 
				state = MOVEMENT
		elif swingActive == true:
			pass
		else:
			state = MOVEMENT

func idle_state(_direction):
	$DetectPathType/FootstepsSound.stream_paused = true
	animation = "idle_" + _direction.to_lower()
	$CompositeSprites.set_player_animation(character, animation, null)

func walk_state(_direction):
	$DetectPathType/FootstepsSound.stream_paused = false
	animation = "walk_" + _direction.to_lower()
	$CompositeSprites.set_player_animation(character, animation, null)

func set_melee_collision_layer(_tool):
	if _tool == "axe": 
		$MeleeSwing.set_collision_mask(8)
	elif _tool == "pickaxe":
		$MeleeSwing.set_collision_mask(16)
		remove_hoed_tile()
	elif _tool == "hoe":
		$MeleeSwing.set_collision_mask(0)
		set_hoed_tile()
	elif _tool == "bucket":
		$MeleeSwing.set_collision_mask(0)
		set_watered_tile()

func set_watered_tile():
	$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/water.mp3")
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
	$SoundEffects.play()
	var pos = Util.set_swing_position(get_position(), direction)
	var location = hoed_tiles.world_to_map(pos)
	if hoed_tiles.get_cellv(location) != -1:
		yield(get_tree().create_timer(0.2), "timeout")
		var id = get_node("/root/World").tile_ids["" + str(location.x) + "" + str(location.y)]
		var data = {"id": id, "l": location}
		Server.action("WATER", data)
		watered_tiles.set_cellv(location, 0)
		watered_tiles.update_bitmask_region()

func set_hoed_tile():
	var pos = Util.set_swing_position(get_position(), direction)
	var location = hoed_tiles.world_to_map(pos)
	if hoed_tiles.get_cellv(location) == -1 and valid_tiles.get_cellv(location) != -1 and grass_tiles.get_cellv(location) == -1 and path_tiles.get_cellv(location) == -1:
		yield(get_tree().create_timer(0.6), "timeout")
		var id = get_node("/root/World").tile_ids["" + str(location.x) + "" + str(location.y)]
		var data = {"id": id, "l": location}
		Server.action("HOE", data)
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/hoe.mp3")
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
		$SoundEffects.play()
		hoed_tiles.set_cellv(location, 0)
		hoed_tiles.update_bitmask_region()	

func remove_hoed_tile():
	var pos = Util.set_swing_position(get_position(), direction)
	var location = hoed_tiles.world_to_map(pos)
	if hoed_tiles.get_cellv(location) != -1:
		yield(get_tree().create_timer(0.6), "timeout")
		var id = get_node("/root/World").tile_ids["" + str(location.x) + "" + str(location.y)]
		var data = {"id": id, "l": location}
		Server.action("PICKAXE", data)
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/hoe.mp3")
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
		$SoundEffects.play()
		watered_tiles.set_cellv(location, -1)
		hoed_tiles.set_cellv(location, -1)
		hoed_tiles.update_bitmask_region()	

func init_day_night_cycle(_time_elapsed):
	if setting == "World":
		if _time_elapsed <= 24:
			$Camera2D/DayNight.color =  Color("#ffffff")
		else:
			$Camera2D/DayNight.color = Color("#1c579e")
	else:
		$Camera2D/DayNight.visible = false

func set_night():
	day_night_animation_player.play("set night")
func set_day():
	day_night_animation_player.play_backwards("set night")

func set_player_setting(ownerNode):
	if str(ownerNode).substr(0, 5) == "World":
		setting = "World"
		$DetectPathType/FootstepsSound.stream = Sounds.dirt_footsteps
		$DetectPathType/FootstepsSound.volume_db = Sounds.return_adjusted_sound_db("footstep", -4)
		$DetectPathType/FootstepsSound.play()
		valid_tiles = get_node("/root/World/GeneratedTiles/ValidTiles")
		path_tiles = get_node("/root/World/PlacableTiles/PathTiles")
		object_tiles = get_node("/root/World/PlacableTiles/ObjectTiles")
		fence_tiles = get_node("/root/World/PlacableTiles/FenceTiles")
		hoed_tiles = get_node("/root/World/FarmingTiles/HoedAutoTiles")
		watered_tiles = get_node("/root/World/FarmingTiles/WateredAutoTiles")
		grass_tiles = get_node("/root/World/GeneratedTiles/GreenGrassTiles")
	else:
		setting = "InsidePlayerHome"
		$DetectPathType/FootstepsSound.stream = Sounds.wood_footsteps
		$DetectPathType/FootstepsSound.volume_db = Sounds.return_adjusted_sound_db("footstep", -10)
		$DetectPathType/FootstepsSound.play()

