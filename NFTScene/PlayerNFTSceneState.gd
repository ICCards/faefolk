extends KinematicBody2D


onready var animation_player = $CompositeSprites/AnimationPlayer
onready var sword_swing = $SwordSwing

var valid_tiles
var path_tiles 
var object_tiles 
var fence_tiles
var hoed_tiles 
var watered_tiles 
var ocean_tiles 
var dirt_tiles 

var principal
var character 
var setting
var is_mouse_over_hotbar
var is_player_dead = false
var is_player_sleeping = false
var isCastingForFish = false
var isWaitingForFish = false
var isReelingInFish = false
var isFishOnHook = false
var swingActive = false
var eatingActive = false
var current_building_item = null
var username_callback = JavaScript.create_callback(self, "_username_callback")

onready var state = MOVEMENT

enum {
	MOVEMENT, 
	SWING,
	EAT,
	FISHING,
	CHANGE_TILE
}

var direction = "DOWN"
var rng = RandomNumberGenerator.new()

var animation = "idle_down"
var MAX_SPEED := 40 #12.5
var ACCELERATION := 6
var FRICTION := 8
var velocity := Vector2.ZERO
var input_vector
var counter = -1
var collisionMask = null

var color1
var color2
var color3
var color4
var color5
var color6
var color7
var color8

const _character = preload("res://Global/Data/Characters.gd")

func _ready():
	PlayerInventory.player = self
	Sounds.connect("volume_change", self, "set_new_music_volume")
	PlayerInventoryNftScene.emit_signal("active_item_updated")
	if has_node("/root/World"):
		set_tile_nodes()

func initialize_camera_limits(top_left, bottom_right):
	$Camera2D.limit_top = top_left.y
	$Camera2D.limit_left = top_left.x
	$Camera2D.limit_bottom = bottom_right.y
	$Camera2D.limit_right = bottom_right.x
		
func set_tile_nodes():
	valid_tiles = get_node("/root/World/WorldNavigation/ValidTiles")
	path_tiles = get_node("/root/World/PlacableTiles/PathTiles")
	object_tiles = get_node("/root/World/PlacableTiles/ObjectTiles")
	fence_tiles = get_node("/root/World/PlacableTiles/FenceTiles")
	hoed_tiles = get_node("/root/World/FarmingTiles/HoedAutoTiles")
	watered_tiles = get_node("/root/World/FarmingTiles/WateredAutoTiles")
	ocean_tiles = get_node("/root/World/GeneratedTiles/AnimatedOceanTiles")
	dirt_tiles = get_node("/root/World/GeneratedTiles/DirtTiles")
	
func set_new_music_volume():
	if Sounds.current_footsteps_sound == Sounds.stone_footsteps:
		$DetectPathType/FootstepsSound.volume_db = Sounds.return_adjusted_sound_db("footstep", 0)
	else: 
		$DetectPathType/FootstepsSound.volume_db = Sounds.return_adjusted_sound_db("footstep", -10)

func _process(_delta) -> void:
	var adjusted_position = get_global_mouse_position() - $Camera2D.get_camera_screen_center() 
	if adjusted_position.x > -240 and adjusted_position.x < 240 and adjusted_position.y > 210 and adjusted_position.y < 254:
		is_mouse_over_hotbar = true
		$PlaceItemsUI.set_invisible()
	else:
		is_mouse_over_hotbar = false
	if not PlayerInventoryNftScene.viewInventoryMode and not PlayerInventoryNftScene.interactive_screen_mode:
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
	if PlayerInventoryNftScene.hotbar.has(PlayerInventoryNftScene.active_item_slot) and \
		not PlayerInventoryNftScene.viewInventoryMode: 
			var item_name = PlayerInventoryNftScene.hotbar[PlayerInventoryNftScene.active_item_slot][0]
			var itemCategory = JsonData.item_data[item_name]["ItemCategory"]
			if Input.is_action_pressed("mouse_click") and itemCategory == "Tool":
				swing_state(item_name)
			elif Input.is_action_pressed("mouse_click") and itemCategory == "Food":
				eat(item_name)
			elif itemCategory == "Placable object":
				$PlaceItemsUI.place_item_state(item_name)
			elif itemCategory == "Seed":
				$PlaceItemsUI.place_seed_state(item_name, hoed_tiles)
	else: 
		$PlaceItemsUI.set_invisible()
		
func movement_state(delta):
	if !swingActive and not PlayerInventory.chatMode and not is_player_dead and not is_player_sleeping and state == MOVEMENT:
		input_vector = Vector2.ZERO	
		if Input.is_action_pressed("move_up"):
			input_vector.y -= 1.0
			direction = "UP"
			walk_state(direction)
		if Input.is_action_pressed("move_down"):
			input_vector.y += 1.0
			direction = "DOWN"
			walk_state(direction)
		if Input.is_action_pressed("move_left"):
			input_vector.x -= 1.0
			direction = "LEFT"
			walk_state(direction)
		if Input.is_action_pressed("move_right"):
			input_vector.x += 1.0
			direction = "RIGHT"
			walk_state(direction)
		if !Input.is_action_pressed("move_right") && !Input.is_action_pressed("move_left")  && !Input.is_action_pressed("move_up")  && !Input.is_action_pressed("move_down"):
			idle_state(direction)
		input_vector = input_vector.normalized()
		if input_vector != Vector2.ZERO:
			velocity += input_vector * ACCELERATION * delta
			velocity = velocity.clamped(MAX_SPEED * delta)
			sword_swing.knockback_vector = input_vector
		else:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		move_and_collide(velocity * MAX_SPEED)	


func swing_state(item_name):
	$DetectPathType/FootstepsSound.stream_paused = true
	if !swingActive:
		state = SWING
		if item_name == "stone watering can":
			animation = "watering_" + direction.to_lower()
		elif item_name == "wood sword":
			animation = "sword_swing_" + direction.to_lower()
		elif item_name == "fishing rod":
			animation = "cast_" + direction.to_lower()
		else:
			set_melee_collision_layer(item_name)
			animation = "swing_" + direction.to_lower()
		swingActive = true
		$CompositeSprites.set_player_animation(character, animation, item_name)
		animation_player.play(animation)
		yield(animation_player, "animation_finished" )
		swingActive = false
		if PlayerInventoryNftScene.hotbar.has(PlayerInventoryNftScene.active_item_slot):
			var new_tool_name = PlayerInventoryNftScene.hotbar[PlayerInventoryNftScene.active_item_slot][0]
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
	if state == MOVEMENT:
		animation_player.play("idle")
		$DetectPathType/FootstepsSound.stream_paused = true
		if PlayerInventoryNftScene.hotbar.has(PlayerInventoryNftScene.active_item_slot):
			var item_name = PlayerInventoryNftScene.hotbar[PlayerInventoryNftScene.active_item_slot][0]
			var item_category = JsonData.item_data[item_name]["ItemCategory"]
			if item_category == "Resource" or item_category == "Seed" or item_category == "Food":
				$HoldingItem.visible = true
				$HoldingItem.texture = load("res://Assets/Images/inventory_icons/" + item_category + "/" + item_name + ".png")
				animation = "holding_idle_" + _direction.to_lower()
			else:
				$HoldingItem.visible = false
				animation = "idle_" + _direction.to_lower()
		else:
			$HoldingItem.visible = false
			animation = "idle_" + _direction.to_lower()
		$CompositeSprites.set_player_animation(character, animation, null)

func walk_state(_direction):
	animation_player.play("movement")
	$DetectPathType/FootstepsSound.stream_paused = false
	if PlayerInventoryNftScene.hotbar.has(PlayerInventoryNftScene.active_item_slot):
		var item_name = PlayerInventoryNftScene.hotbar[PlayerInventoryNftScene.active_item_slot][0]
		var item_category = JsonData.item_data[item_name]["ItemCategory"]
		if item_category == "Resource" or item_category == "Seed" or item_category == "Food":
			$HoldingItem.texture = load("res://Assets/Images/inventory_icons/" + item_category + "/" + item_name + ".png")
			$HoldingItem.visible = true
			animation = "holding_walk_" + _direction.to_lower()
		else:
			$HoldingItem.visible = false
			animation = "walk_" + _direction.to_lower()
	else:
		$HoldingItem.visible = false
		animation = "walk_" + _direction.to_lower()
	$CompositeSprites.set_player_animation(character, animation, null)
	
func eat(item_name):
	if not eatingActive:
		eatingActive = true
		state = EAT
		play_eating_particles(item_name)
		$CompositeSprites.set_player_animation(character, "eat", item_name)
		animation_player.play("eat")
		yield(animation_player, "animation_finished")
		$EatingParticles/EatingParticles1.emitting = false
		$EatingParticles/EatingParticles2.emitting = false
		$EatingParticles/EatingParticles3.emitting = false
		$EatingParticles/EatingParticles4.emitting = false
		$EatingParticles/EatingParticles5.emitting = false
		$EatingParticles/EatingParticles6.emitting = false
		$EatingParticles/EatingParticles7.emitting = false
		$EatingParticles/EatingParticles8.emitting = false
		eatingActive = false
		state = MOVEMENT
		
func play_eating_particles(item_name):
	var itemImage = Image.new()
	itemImage.load("res://Assets/Images/inventory_icons/Food/" + item_name + ".png")
	itemImage.lock()
	set_pixel_colors(itemImage)
	yield(get_tree().create_timer(0.1), "timeout")
	$EatingParticles/EatingParticles1.color = color1
	$EatingParticles/EatingParticles2.color = color2
	$EatingParticles/EatingParticles3.color = color3
	$EatingParticles/EatingParticles4.color = color4
	$EatingParticles/EatingParticles5.color = color5
	$EatingParticles/EatingParticles6.color = color6
	$EatingParticles/EatingParticles7.color = color7
	$EatingParticles/EatingParticles8.color = color8
	$EatingParticles/EatingParticles1.emitting = true
	$EatingParticles/EatingParticles2.emitting = true
	$EatingParticles/EatingParticles3.emitting = true
	$EatingParticles/EatingParticles4.emitting = true
	$EatingParticles/EatingParticles5.emitting = true
	$EatingParticles/EatingParticles6.emitting = true
	$EatingParticles/EatingParticles7.emitting = true
	$EatingParticles/EatingParticles8.emitting = true

func set_pixel_colors(itemImage):
	color1 = return_pixel_color(itemImage)
	color2 = return_pixel_color(itemImage)
	color3 = return_pixel_color(itemImage)
	color4 = return_pixel_color(itemImage)
	color5 = return_pixel_color(itemImage)
	color6 = return_pixel_color(itemImage)
	color7 = return_pixel_color(itemImage)
	color8 = return_pixel_color(itemImage)
	
func return_pixel_color(image):
	rng.randomize()
	var tempColor = Color(image.get_pixel(rng.randi_range(8, 24), rng.randi_range(8, 24)))
	if tempColor != Color(0,0,0,0):
		return tempColor
	else:
		tempColor = Color(image.get_pixel(rng.randi_range(8, 24), rng.randi_range(8, 24)))
		if tempColor != Color(0,0,0,0):
			return tempColor
		else:
			return Color(0,0,0,0)

func set_melee_collision_layer(_tool):
	if _tool == "wood axe": 
		$MeleeSwing.set_collision_mask(8)
	elif _tool == "wood pickaxe":
		$MeleeSwing.set_collision_mask(16)
		remove_hoed_tile()
	elif _tool == "wood hoe":
		$MeleeSwing.set_collision_mask(0)
		set_hoed_tile()
		
		
func set_watered_tile():
	var pos = Util.set_swing_position(get_position(), direction)
	var location = hoed_tiles.world_to_map(pos)
	if ocean_tiles.get_cellv(location) != -1:
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/water fill.mp3")
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
		$SoundEffects.play()
	elif PlayerInventoryNftScene.hotbar[PlayerInventoryNftScene.active_item_slot][2] >= 1:
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/water.mp3")
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
		$SoundEffects.play()
		if direction != "UP":
			$CompositeSprites/WateringCanParticles.position = Util.returnAdjustedWateringCanPariclePos(direction)
			$CompositeSprites/WateringCanParticles.emitting = true
			$CompositeSprites/WateringCanParticles2.position = Util.returnAdjustedWateringCanPariclePos(direction)
			$CompositeSprites/WateringCanParticles2.emitting = true
		yield(get_tree().create_timer(0.4), "timeout")
		$CompositeSprites/WateringCanParticles.emitting = false
		$CompositeSprites/WateringCanParticles2.emitting = false
		if hoed_tiles.get_cellv(location) != -1:
			watered_tiles.set_cellv(location, 0)
			watered_tiles.update_bitmask_region()
	else: 
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/ES_Error Tone Chime 6 - SFX Producer.mp3")
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
		$SoundEffects.play()


func set_hoed_tile():
	var pos = Util.set_swing_position(get_position(), direction)
	var location = hoed_tiles.world_to_map(pos)
	if hoed_tiles.get_cellv(location) == -1 and \
	Tiles.isCenterBitmaskTile(location, dirt_tiles) and \
	valid_tiles.get_cellv(location) != -1:
		yield(get_tree().create_timer(0.6), "timeout")
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
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/hoe.mp3")
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
		$SoundEffects.play()
		watered_tiles.set_cellv(location, -1)
		hoed_tiles.set_cellv(location, -1)
		hoed_tiles.update_bitmask_region()	
