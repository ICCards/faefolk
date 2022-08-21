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
var swingActive = false
var fishingActive = false
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
var MAX_SPEED := 12.5
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
	set_username("")
	Sounds.connect("volume_change", self, "set_new_music_volume")
	PlayerStats.connect("health_depleted", self, "player_death")
	PlayerInventory.emit_signal("active_item_updated")
	if has_node("/root/World"):
		set_tile_nodes()
	#IC.getUsername(principal,username_callback)
	
	
#reset object state to that in a given game_state, executed once per rollback 
func reset_state(game_state : Dictionary):
	#check if this object exists within the checked game_state
	if game_state.has(name):
		position.x = game_state[name]['x']
		position.y = game_state[name]['y']
		counter = game_state[name]['counter']
		collisionMask = game_state[name]['collisionMask']
	else:
		queue_free()


func frame_start():
	pass
	#code to run at beginning of frame
	#collisionMask = Rect2(Vector2(position.x - rectExtents.x, position.y - rectExtents.y), Vector2(rectExtents.x, rectExtents.y) * 2)


func input_update(input, game_state : Dictionary):
	pass
#	#calculate state of object for the given input
#	var vect = Vector2(0, 0)
#
#	#Collision detection for InputControl children that can pass through each other
##    for object in game_state:
##        if object != name:
##            if collisionMask.intersects(game_state[object]['collisionMask']):
##                counter += 1
#	if !swingActive and not PlayerInventory.chatMode:
#		animation_player.play("movement")
#		if input.local_input[0]: #W
#			vect.y -= 7
#			direction = "UP"
#			walk_state(direction)
#		if input.local_input[2]: #S
#			vect.y += 7
#			direction = "DOWN"
#			walk_state(direction)
#		if input.local_input[1]: #A
#			vect.x -= 7
#			direction = "LEFT"
#			walk_state(direction)
#		if input.local_input[3]: #D
#			vect.x += 7
#			direction = "RIGHT"
#			walk_state(direction)
#		if input.local_input[5]:
#			idle_state(direction)
#
#	#move_and_collide for "solid" stationary objects
#	var collision = move_and_collide(vect)
#	if collision:
#		vect = vect.slide(collision.normal)
#		move_and_collide(vect)
#	#print(position)
#	#collisionMask = Rect2(Vector2(position.x - rectExtents.x, position.y - rectExtents.y), Vector2(rectExtents.x, rectExtents.y) * 2)

func frame_end():
	pass
	#code to run at end of frame (after all input_update calls)
	#label.text = str(counter)


func get_state():
	#return dict of state variables to be stored in Frame_States
	return {'x': position.x, 'y': position.y, 'counter': counter, 'collisionMask': collisionMask}
	
	
func set_tile_nodes():
	valid_tiles = get_node("/root/World/WorldNavigation/ValidTiles")
	path_tiles = get_node("/root/World/PlacableTiles/PathTiles")
	object_tiles = get_node("/root/World/PlacableTiles/ObjectTiles")
	fence_tiles = get_node("/root/World/PlacableTiles/FenceTiles")
	hoed_tiles = get_node("/root/World/FarmingTiles/HoedAutoTiles")
	watered_tiles = get_node("/root/World/FarmingTiles/WateredAutoTiles")
	ocean_tiles = get_node("/root/World/GeneratedTiles/AnimatedOceanTiles")
	dirt_tiles = get_node("/root/World/GeneratedTiles/DirtTiles")
	
func sleep(direction_of_sleeping_bag):
	print("sleep")
	if not is_player_sleeping:
		position += Vector2(0, 6)
		is_player_sleeping = true
		$CompositeSprites/AnimationPlayer.play("sleep")
		$CompositeSprites.set_player_animation(character, "sleep_" + direction_of_sleeping_bag.to_lower())
	
func player_death():
	if not is_player_dead:
		is_player_dead = true
		$CompositeSprites.set_player_animation(character, "death_" + direction.to_lower(), null)
		animation_player.play("death")
		yield(animation_player, "animation_finished")
		PlayerStats.health = PlayerStats.health_maximum
		PlayerStats.emit_signal("health_changed")
		animation_player.stop()
		is_player_dead = false
		$Camera2D/UserInterface/DeathEffect.visible = false

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
		$Timer.stop()
		$Timer.start()
		yield($Timer, "timeout")
		$MessageBubble.visible = false
	else:
		$MessageBubble.text = ""
		$MessageBubble.text = message
		$Timer.start()
		yield($Timer, "timeout")
		$MessageBubble.visible = false

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
	if not PlayerInventory.viewInventoryMode and not PlayerInventory.interactive_screen_mode and state == MOVEMENT:
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
		not swingActive and \
		not is_player_dead and \
		not is_player_sleeping: 
			var item_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
			var itemCategory = JsonData.item_data[item_name]["ItemCategory"]
			if item_name == "blueprint" and current_building_item == "wall":
				$PlaceItemsUI.place_buildings_state(current_building_item)
			elif item_name == "blueprint" and current_building_item == "double door":
				$PlaceItemsUI.place_double_door_state()
			else: 
				current_building_item = null
			if Input.is_action_pressed("mouse_click") and item_name == "fishing rod":
				$DetectPathType/FootstepsSound.stream_paused = true
				$Fishing.initialize()
			elif Input.is_action_pressed("mouse_click") and itemCategory == "Tool":
				swing_state(item_name)
			elif Input.is_action_pressed("mouse_click") and itemCategory == "Food":
				eat(item_name)
			elif itemCategory == "Placable object" and item_name == "tent":
				$PlaceItemsUI.place_tent_state()
			elif itemCategory == "Placable object" and item_name == "sleeping bag":
				$PlaceItemsUI.place_sleeping_bag_state()
			elif itemCategory == "Placable object":
				$PlaceItemsUI.place_item_state(item_name)
			elif itemCategory == "Placable path":
				$PlaceItemsUI.place_path_state(item_name, path_tiles)
			elif itemCategory == "Seed":
				$PlaceItemsUI.place_seed_state(item_name, hoed_tiles)
	else: 
		$PlaceItemsUI.set_invisible()
	



func eat(item_name):
	if not eatingActive:
		eatingActive = true
		PlayerStats.eat(item_name)
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

func movement_state(delta):
	if !swingActive and not PlayerInventory.chatMode and not is_player_dead and not is_player_sleeping and state == MOVEMENT:
		input_vector = Vector2.ZERO	
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
			sword_swing.knockback_vector = input_vector
		else:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		move_and_collide(velocity * MAX_SPEED)	



#func fishing_state():
#	if not fishingActive:
#		fishingActive = true
#		$DetectPathType/FootstepsSound.stream_paused = true
#		state = FISHING
#		animation = "cast_" + direction.to_lower()
#		$CompositeSprites.set_player_animation(character, animation, "fishing rod cast")
#		$Fishing.direction = direction
#		$Fishing.start()
#	elif $Fishing.is_casted:
#		$Fishing.stop()

func swing_state(item_name):
	if not swingActive:
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
		$DetectPathType/FootstepsSound.stream_paused = true
		PlayerStats.decrease_energy()
		sendAction(SWING, {"tool": item_name, "direction": direction})
		swingActive = true
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
	if state == MOVEMENT:
		animation_player.play("idle")
		$DetectPathType/FootstepsSound.stream_paused = true
		if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
			var item_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
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
	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
		var item_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
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
		Stats.refill_watering_can(PlayerInventory.hotbar[PlayerInventory.active_item_slot][0])
	elif PlayerInventory.hotbar[PlayerInventory.active_item_slot][2] >= 1:
		Stats.decrease_tool_health()
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
	#		var id = get_node("/root/World").tile_ids["" + str(location.x) + "" + str(location.y)]
	#		var data = {"id": id, "l": location}
	#		Server.action("WATER", data)
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
#		var id = get_node("/root/World").tile_ids["" + str(location.x) + "" + str(location.y)]
#		var data = {"id": id, "l": location}
#		Server.action("HOE", data)
		Stats.decrease_tool_health()
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


#func init_day_night_cycle(_time_elapsed):
#	if setting == "World":
#		if _time_elapsed <= 24:
#			$Camera2D/DayNight.color =  Color("#ffffff")
#		else:
#			$Camera2D/DayNight.color = Color("#00070e")
#	else:
#		$Camera2D/DayNight.visible = false
#
#func set_night():
#	day_night_animation_player.play("set night")
#func set_day():
#	day_night_animation_player.play_backwards("set night")

