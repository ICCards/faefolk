extends KinematicBody2D

onready var bodySprite = $CompositeSprites/Body
onready var armsSprite = $CompositeSprites/Arms
onready var accessorySprite = $CompositeSprites/Accessory
onready var headAttributeSprite = $CompositeSprites/HeadAtr
onready var pantsSprite = $CompositeSprites/Pants
onready var shirtsSprite = $CompositeSprites/Shirts
onready var shoesSprite = $CompositeSprites/Shoes
onready var toolEquippedSprite = $CompositeSprites/ToolEquipped
onready var animation_player = $CompositeSprites/AnimationPlayer
onready var day_night_animation_player = $Camera2D/DayNight/AnimationPlayer

onready var TorchObject = preload("res://World/Objects/AnimatedObjects/TorchObject.tscn")
onready var PlantedCrop = preload("res://World/Objects/Farm/PlantedCrop.tscn")
onready var TileObjectHurtBox = preload("res://World/PlayerFarm/TileObjectHurtBox.tscn")
onready var PlayerHouseObject = preload("res://World/Objects/Farm/PlayerHouse.tscn")

var valid_object_tiles
var hoed_tiles
var watered_tiles
var grass_tiles
var fence_tiles
var object_tiles
var path_tiles
var delta
var character
var path_index = 1
var setting

onready var state = MOVEMENT

enum {
	MOVEMENT, 
	SWING,
	PLACE_ITEM,
	PLACE_SEED,
	CHANGE_TILE
}

var direction = "DOWN"
var rng = RandomNumberGenerator.new()

var player_state
var animation = "idle_down"

var MAX_SPEED := 12.5
var ACCELERATION := 6
var FRICTION := 8
var velocity := Vector2.ZERO


func initialize_camera_limits(top_left, bottom_right):
	$Camera2D.limit_top = top_left.y
	$Camera2D.limit_left = top_left.x
	$Camera2D.limit_bottom = bottom_right.y
	$Camera2D.limit_right = bottom_right.x

func _ready():
	set_physics_process(false)
	set_player_setting(get_parent().get_parent())
	setPlayerTexture(animation)
	$FootstepsSound.stream = Sounds.current_footsteps_sound
	_play_background_music()
	$Camera2D/UserInterface/Hotbar.visible = true
	$Camera2D/UserInterface/PlayerStatsUI.visible = true
	$Camera2D/UserInterface/CurrentTimeUI.visible = true
	init_day_night_cycle()
	PlayerInventory.emit_signal("active_item_updated")
	Sounds.connect("volume_change", self, "set_new_music_volume")
	set_new_music_volume()



func set_new_music_volume():
	$BackgroundMusic.volume_db = Sounds.return_adjusted_sound_db("music", -32)
	$FootstepsSound.volume_db = Sounds.return_adjusted_sound_db("footstep", -10)
	

func _play_background_music():
	rng.randomize()
	$BackgroundMusic.stream = Sounds.background_music[rng.randi_range(0, Sounds.background_music.size() - 1)]
	$BackgroundMusic.play()
	$BackgroundMusic.volume_db =  Sounds.return_adjusted_sound_db("music", -32)
	yield($BackgroundMusic, "finished")
	_play_background_music()
	

func _process(_delta) -> void:
	delta = _delta
	if not PlayerInventory.viewInventoryMode and not PlayerInventory.openChestMode:
		if $PickupZone.items_in_range.size() > 0:
			var pickup_item = $PickupZone.items_in_range.values()[0]
			pickup_item.pick_up_item(self)
			$PickupZone.items_in_range.erase(pickup_item)
		match state:
			MOVEMENT:
				movement_state(delta)
	else: 
		idle_state(direction)


func _unhandled_input(event):
	if !swingActive:
		if Input.is_action_pressed("ui_up"):
			direction = "UP"
		if Input.is_action_pressed("ui_down"):
			direction = "DOWN"
		if Input.is_action_pressed("ui_left"):
			direction = "LEFT"
		if Input.is_action_pressed("ui_right"):
			direction = "RIGHT"
		if !Input.is_action_pressed("ui_right") && !Input.is_action_pressed("ui_left")  && !Input.is_action_pressed("ui_up")  && !Input.is_action_pressed("ui_down"):
			idle_state(direction)
		if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot) and not PlayerInventory.viewInventoryMode and not PlayerInventory.openChestMode and Server.player_state == "WORLD": 
			var item_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
			var itemCategory = JsonData.item_data[item_name]["ItemCategory"]
			if Input.is_action_pressed("mouse_click") and itemCategory == "Weapon" and setting == "World":
				state = SWING
				swing_state(item_name)
			if itemCategory == "Placable object":
				place_item_state(event, item_name)
			elif itemCategory == "Placable path":
				place_path_state(event, item_name)
			elif itemCategory == "Seed":
				place_seed_state(event, item_name)
			else: 
				$PlaceItemsUI/ColorIndicator.visible = false
				$PlaceItemsUI/ItemToPlace.visible = false
				$PlaceItemsUI/RotateIcon.visible = false
		else: 
			$PlaceItemsUI/ColorIndicator.visible = false
			$PlaceItemsUI/ItemToPlace.visible = false
			$PlaceItemsUI/RotateIcon.visible = false

func sendAction(action,data): 
	match action:
		(MOVEMENT):
			pass
			Server.action("MOVEMENT",data)
		(SWING):
			Server.action("SWING", data)
		(PLACE_ITEM):
			Server.action("PLACE_ITEM", data)
		(CHANGE_TILE):
			Server.action("CHANGE_TILE", data)


func get_path_rotation(path_name):
	if path_name == "wood path" and path_index > 2:
		path_index = 1
	$PlaceItemsUI/ItemToPlace.texture = load("res://Assets/Images/placable_object_preview/" + path_name + str(path_index) + ".png")
	if path_name == "wood path":
		if Input.is_action_pressed("rotate"):
			path_index += 1
			if path_index == 3:
				path_index = 1
	elif path_name == "stone path":
		if Input.is_action_pressed("rotate"):
			path_index += 1
			if path_index == 5:
				path_index = 1


func place_path_state(event, item_name):
	get_path_rotation(item_name)
	$PlaceItemsUI/ColorIndicator.visible = true
	$PlaceItemsUI/ItemToPlace.visible = true
	$PlaceItemsUI/RotateIcon.visible = true
	$PlaceItemsUI/ItemToPlace.rect_position = Vector2(0,0)
	$PlaceItemsUI/ItemToPlace.rect_scale = Vector2(1, 1)
	$PlaceItemsUI/ColorIndicator.scale  = Vector2(1.0 , 1.0)
	var mousePos = get_parent().get_global_mouse_position() + Vector2(-16, -16)
	mousePos = mousePos.snapped(Vector2(32,32))
	$PlaceItemsUI.set_global_position(mousePos)
	var location = valid_object_tiles.world_to_map(mousePos)
	if path_tiles.get_cellv(location) != -1 or valid_object_tiles.get_cellv(location) == -1 or position.distance_to(mousePos) > 120:
		$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/red_square.png")
	else:
		$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/green_square.png")
		if event.is_action_pressed("mouse_click"):
			place_placable_object(item_name + str(path_index), location)


func place_item_state(event, item_name):
	$PlaceItemsUI/ColorIndicator.visible = true
	$PlaceItemsUI/ItemToPlace.visible = true
	$PlaceItemsUI/ItemToPlace.texture = load("res://Assets/Images/placable_object_preview/" + item_name + ".png")
	var mousePos = get_global_mouse_position() + Vector2(-16, -16)
	mousePos = mousePos.snapped(Vector2(32,32))
	$PlaceItemsUI.set_global_position(mousePos)
	var location = valid_object_tiles.world_to_map(mousePos)
	
	if item_name == "house":
		$PlaceItemsUI/ColorIndicator.scale = Vector2(8, 4)
		$PlaceItemsUI/ItemToPlace.rect_position = Vector2(-3, -301)
		$PlaceItemsUI/ItemToPlace.rect_scale = Vector2(0.9, 0.9)
	elif item_name == "wood chest" or item_name == "stone chest":
		$PlaceItemsUI/ColorIndicator.scale = Vector2(2, 1)
		$PlaceItemsUI/ItemToPlace.rect_position = Vector2(0,-32)
		$PlaceItemsUI/ItemToPlace.rect_scale = Vector2(1, 1)
	else:
		$PlaceItemsUI/ColorIndicator.scale = Vector2(1, 1)
		$PlaceItemsUI/ItemToPlace.rect_position = Vector2(0,-32)
		$PlaceItemsUI/ItemToPlace.rect_scale = Vector2(1, 1)
		
	if valid_object_tiles.get_cellv(location) == -1 or position.distance_to(mousePos) > 120:
		$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/red_square.png")
	elif (item_name == "wood chest" or item_name == "stone chest") and valid_object_tiles.get_cellv(location + Vector2(1,0)) == -1:
		$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/red_square.png")
	elif item_name == "house":
		if not validate_house_tiles(location):
			$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/red_square.png")
		else:
			$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/green_square.png")
			if event.is_action_pressed("mouse_click"):
				place_placable_object(item_name, location)
	else:
		$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/green_square.png")
		if event.is_action_pressed("mouse_click"):
			place_placable_object(item_name, location)

func validate_house_tiles(_location):
	var loc = _location
	var active = false
	if not active:
		active = true
		for x in range(8):
			for y in range(4):
				if valid_object_tiles.get_cellv( Vector2(x, -y) + loc) == -1: 
					return false
					break
		return true


func place_placable_object(item_name, location):
	rng.randomize()
	var id = Uuid.v4()
	var data = {"id": id, "n": item_name, "l": location, "t": "placable"}
	sendAction(PLACE_ITEM, data)
	PlayerInventory.remove_single_object_from_hotbar()
	match item_name:
		"torch":
			var torchObject = TorchObject.instance()
			torchObject.name = str(id)
			torchObject.initialize(location)
			get_parent().get_parent().call_deferred("add_child", torchObject, true)
			torchObject.position = valid_object_tiles.map_to_world(location) + Vector2(16, 22)
			valid_object_tiles.set_cellv(location, -1)
		"wood fence":
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			get_parent().get_parent().call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
			fence_tiles.set_cellv(location, 0)
			fence_tiles.update_bitmask_region()
			valid_object_tiles.set_cellv(location, -1)
		"wood barrel":
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			get_parent().get_parent().call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
			object_tiles.set_cellv(location, 0)
			valid_object_tiles.set_cellv(location, -1)
		"wood box":
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			get_parent().get_parent().call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
			object_tiles.set_cellv(location, 1)
			valid_object_tiles.set_cellv(location, -1)
		"wood chest":
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			get_parent().get_parent().call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
			object_tiles.set_cellv(location, 2)
			valid_object_tiles.set_cellv(location, -1)
			valid_object_tiles.set_cellv(location + Vector2(1, 0), -1)
		"stone chest":
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			get_parent().get_parent().call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
			object_tiles.set_cellv(location, 5)
			valid_object_tiles.set_cellv(location, -1)
			valid_object_tiles.set_cellv(location + Vector2(1, 0), -1)
		"house":
			var playerHouseObject = PlayerHouseObject.instance()
			playerHouseObject.name = str(id)
			Server.player_house_position = location
			get_parent().get_parent().call_deferred("add_child", playerHouseObject, true)
			playerHouseObject.global_position = fence_tiles.map_to_world(location) + Vector2(6,6)
			set_player_house_invalid_tiles(location)
		"wood path1":
			path_tiles.set_cellv(location, 0)
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			get_parent().get_parent().call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
		"wood path2":
			path_tiles.set_cellv(location, 1)
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			get_parent().get_parent().call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
		"stone path1":
			path_tiles.set_cellv(location, 2)
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			get_parent().get_parent().call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
		"stone path2":
			path_tiles.set_cellv(location, 3)
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			get_parent().get_parent().call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
		"stone path3":
			path_tiles.set_cellv(location, 4)
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			get_parent().get_parent().call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
		"stone path4":
			path_tiles.set_cellv(location, 5)
			var tileObjectHurtBox = TileObjectHurtBox.instance()
			tileObjectHurtBox.name = str(id)
			tileObjectHurtBox.initialize(item_name, location)
			get_parent().get_parent().call_deferred("add_child", tileObjectHurtBox, true)
			tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
	
		
func set_player_house_invalid_tiles(location):
	for x in range(8):
		for y in range(4):
			valid_object_tiles.set_cellv(location + Vector2(x, -y), -1)


func place_seed_state(event, item_name):
	item_name.erase(item_name.length() - 6, 6)
	$PlaceItemsUI/ColorIndicator.visible = true
	$PlaceItemsUI/ItemToPlace.visible = true
	$PlaceItemsUI/ItemToPlace.texture = load("res://Assets/Images/crop_sets/" + item_name + "/seeds.png")
	$PlaceItemsUI/ColorIndicator.scale =  Vector2(1, 1)
	$PlaceItemsUI/ItemToPlace.rect_position = Vector2(0,0)
	$PlaceItemsUI/ItemToPlace.rect_scale = Vector2(1, 1)
		
	var mousePos = get_global_mouse_position() + Vector2(-16, -16)
	mousePos = mousePos.snapped(Vector2(32,32))
	$PlaceItemsUI.set_global_position(mousePos)
	var location = valid_object_tiles.world_to_map(mousePos)
	if hoed_tiles.get_cellv(location) == -1 or valid_object_tiles.get_cellv(location) == -1 or position.distance_to(mousePos) > 120:
		$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/red_square.png")
	else:	
		$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/green_square.png")
		if event.is_action_pressed("mouse_click"):
			var id = Uuid.v4()
			var data = {"id": id, "n": item_name, "l": location, "t": "seed", "d": JsonData.crop_data[item_name]["DaysToGrow"], "w": false, "r": false, "dead": false}
			sendAction(PLACE_ITEM, data)
			$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/place seed 3.mp3")
			$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
			$SoundEffects.play()
			PlayerInventory.remove_single_object_from_hotbar()
			valid_object_tiles.set_cellv(location, -1)
			var plantedCrop = PlantedCrop.instance()
			plantedCrop.name = str(id)
			plantedCrop.initialize(item_name, location, JsonData.crop_data[item_name]["DaysToGrow"], false, false)
			get_parent().add_child(plantedCrop, true)
			plantedCrop.global_position = mousePos + Vector2(0, 16)

func movement_state(delta):
	if !swingActive:
		animation_player.play("movement")
		var input_vector = Vector2.ZERO			
		if Input.is_action_pressed("ui_up"):
			input_vector.y -= 1.0
			direction = "UP"
			walk_state(direction)
			var data = {"p":get_global_position(),"d":direction,"t":Server.client_clock}
			sendAction(MOVEMENT,data)
		if Input.is_action_pressed("ui_down"):
			input_vector.y += 1.0
			direction = "DOWN"
			walk_state(direction)
			var data = {"p":position,"d":direction,"t":Server.client_clock}
			sendAction(MOVEMENT,data)
		if Input.is_action_pressed("ui_left"):
			input_vector.x -= 1.0
			direction = "LEFT"
			walk_state(direction)
			var data = {"p":position,"d":direction,"t":Server.client_clock}
			sendAction(MOVEMENT,data)
		if Input.is_action_pressed("ui_right"):
			input_vector.x += 1.0
			direction = "RIGHT"
			walk_state(direction)
			var data = {"p":position,"d":direction,"t":Server.client_clock}
			sendAction(MOVEMENT,data)		
		if !Input.is_action_pressed("ui_right") && !Input.is_action_pressed("ui_left")  && !Input.is_action_pressed("ui_up")  && !Input.is_action_pressed("ui_down"):
			idle_state(direction)
			var data = {"p":position,"d":direction,"t":Server.client_clock}
			sendAction(MOVEMENT,data)
			$FootstepsSound.stream_paused = true
				
		input_vector = input_vector.normalized()
		
		if input_vector != Vector2.ZERO:
			velocity += input_vector * ACCELERATION * delta
			velocity = velocity.clamped(MAX_SPEED * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			
		move_and_collide(velocity * MAX_SPEED)	

var swingActive = false
func swing_state(item_name):
		$FootstepsSound.stream_paused = true
		if !swingActive:
				sendAction(SWING, {"tool": item_name, "direction": direction})
				swingActive = true
				set_melee_collision_layer(item_name)
				toolEquippedSprite.set_texture(Images.returnToolSprite(item_name, direction.to_lower()))
				animation = "swing_" + direction.to_lower()
				setPlayerTexture(animation)
				animation_player.play(animation)
				yield(animation_player, "animation_finished" )
				toolEquippedSprite.texture = null
				swingActive = false
				if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
					var newToolName = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
					var newItemCategory = JsonData.item_data[newToolName]["ItemCategory"]
					if Input.is_action_pressed("mouse_click") and newItemCategory == "Weapon":
						swing_state(newToolName)
					else:
						state = MOVEMENT
				else: 
					state = MOVEMENT
		elif swingActive == true:
			pass
		else:
			state = MOVEMENT


func idle_state(dir):
	$FootstepsSound.stream_paused = true
	animation = "idle_" + dir.to_lower()
	setPlayerTexture(animation)

func walk_state(dir):
	$FootstepsSound.stream_paused = false
	animation = "walk_" + dir.to_lower()
	setPlayerTexture(animation)

func set_melee_collision_layer(toolName):
	if toolName == "axe": 
		$MeleeSwing.set_collision_mask(8)
	elif toolName == "pickaxe":
		$MeleeSwing.set_collision_mask(16)
		remove_hoed_tile()
	elif toolName == "hoe":
		$MeleeSwing.set_collision_mask(0)
		set_hoed_tile()
	elif toolName == "bucket":
		$MeleeSwing.set_collision_mask(0)
		set_watered_tile()

func set_watered_tile():
	$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/water.mp3")
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
	$SoundEffects.play()
	var pos = adjust_position_from_direction(get_position())
	var location = hoed_tiles.world_to_map(pos)
	if hoed_tiles.get_cellv(location) != -1:
		var id = get_node("/root/World").tile_ids["" + str(location.x) + "" + str(location.y)]
		var data = {"id": id, "l": location}
		Server.action("WATER", data)
		watered_tiles.set_cellv(location, 0)
		watered_tiles.update_bitmask_region()

func set_hoed_tile():
	var pos = adjust_position_from_direction(get_position())
	var location = hoed_tiles.world_to_map(pos)
	if hoed_tiles.get_cellv(location) == -1 and valid_object_tiles.get_cellv(location) != -1 and grass_tiles.get_cellv(location) == -1 and path_tiles.get_cellv(location) == -1:
		
		var id = get_node("/root/World").tile_ids["" + str(location.x) + "" + str(location.y)]
		var data = {"id": id, "l": location}
		Server.action("HOE", data)
		yield(get_tree().create_timer(0.6), "timeout")
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/hoe.mp3")
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
		$SoundEffects.play()
		hoed_tiles.set_cellv(location, 0)
		hoed_tiles.update_bitmask_region()	

func remove_hoed_tile():
	var pos = adjust_position_from_direction(get_position())
	var location = hoed_tiles.world_to_map(pos)
	if hoed_tiles.get_cellv(location) != -1:
		var id = get_node("/root/World").tile_ids["" + str(location.x) + "" + str(location.y)]
		var data = {"id": id, "l": location}
		Server.action("PICKAXE", data)
		yield(get_tree().create_timer(0.6), "timeout")
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/hoe.mp3")
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
		$SoundEffects.play()
		valid_object_tiles.set_cellv(location, 0)
		watered_tiles.set_cellv(location, -1)
		hoed_tiles.set_cellv(location, -1)
		hoed_tiles.update_bitmask_region()	


func adjust_position_from_direction(pos):
	if direction == "UP":
		pos += Vector2(0, -36)
	elif direction == "DOWN":
		pos += Vector2(0, 20)
	elif direction == "LEFT":
		pos += Vector2(-32, -8)
	elif direction == "RIGHT":
		pos += Vector2(32, -8)
	return pos
	
func setPlayerTexture(var anim):
	bodySprite.set_texture(character.body_sprites[anim])
	armsSprite.set_texture(character.arms_sprites[anim])
	accessorySprite.set_texture(character.acc_sprites[anim])
	headAttributeSprite.set_texture(character.headAtr_sprites[anim])
	pantsSprite.set_texture(character.pants_sprites[anim])
	shirtsSprite.set_texture(character.shirts_sprites[anim])
	shoesSprite.set_texture(character.shoes_sprites[anim])

#
func init_day_night_cycle():
	if setting == "World":
		if get_node("/root/World").day:
			$Camera2D/DayNight.color =  Color("#1c579e")#Color("#ffffff")
		else:
			$Camera2D/DayNight.color = Color("#1c579e")
	else:
		$Camera2D/DayNight.visible = false

func set_night():
	day_night_animation_player.play("set night")
	init_day_night_cycle()
func set_day():
	day_night_animation_player.play_backwards("set night")
	init_day_night_cycle()
	PlayerInventory.emit_signal("update_time")


func set_player_setting(ownerNode):
	if str(ownerNode).substr(0, 5) == "World":
		setting = "World"
		$FootstepsSound.stream = Sounds.dirt_footsteps
		$FootstepsSound.volume_db = Sounds.return_adjusted_sound_db("footstep", -10)
		$FootstepsSound.play()
		valid_object_tiles = get_node("/root/World/GeneratedTiles/ValidTiles")
		path_tiles = get_node("/root/World/PlacableTiles/PathTiles")
		object_tiles = get_node("/root/World/PlacableTiles/ObjectTiles")
		fence_tiles = get_node("/root/World/PlacableTiles/FenceTiles")
		hoed_tiles = get_node("/root/World/FarmingTiles/HoedAutoTiles")
		watered_tiles = get_node("/root/World/FarmingTiles/WateredAutoTiles")
		grass_tiles = get_node("/root/World/GeneratedTiles/GreenGrassTiles")
	else:
		setting = "InsidePlayerHome"
		$FootstepsSound.stream = Sounds.wood_footsteps
		$FootstepsSound.volume_db = Sounds.return_adjusted_sound_db("footstep", -10)
		$FootstepsSound.play()




func _on_DetectWoodArea_area_entered(area):
	if Sounds.current_footsteps_sound != Sounds.wood_footsteps:
		Sounds.current_footsteps_sound = Sounds.wood_footsteps
		$FootstepsSound.stream = Sounds.current_footsteps_sound
		$FootstepsSound.volume_db = Sounds.return_adjusted_sound_db("footstep", -10)
		$FootstepsSound.play()


func _on_DetectWoodArea_area_exited(area):
	if $DetectPathUI/DetectWoodPath.get_overlapping_areas().size() <= 0 and $DetectPathUI/DetectStonePath.get_overlapping_areas().size() <= 0:
		Sounds.current_footsteps_sound = Sounds.dirt_footsteps
		$FootstepsSound.stream = Sounds.current_footsteps_sound
		$FootstepsSound.volume_db = Sounds.return_adjusted_sound_db("footstep", -10)
		$FootstepsSound.play()


func _on_DetectStonePath_area_entered(area):
	if Sounds.current_footsteps_sound != Sounds.stone_footsteps:
		Sounds.current_footsteps_sound = Sounds.stone_footsteps
		$FootstepsSound.stream = Sounds.current_footsteps_sound
		$FootstepsSound.volume_db = Sounds.return_adjusted_sound_db("footstep", 0)
		$FootstepsSound.play()



func _on_DetectStonePath_area_exited(area):
	if $DetectPathUI/DetectStonePath.get_overlapping_areas().size() <= 0 and $DetectPathUI/DetectWoodPath.get_overlapping_areas().size() <= 0:
		Sounds.current_footsteps_sound = Sounds.dirt_footsteps
		$FootstepsSound.stream = Sounds.current_footsteps_sound
		$FootstepsSound.volume_db = Sounds.return_adjusted_sound_db("footstep", -10)
		$FootstepsSound.play()



func _on_EnterDoors_area_exited(area:Area2D):
	pass # Replace with function body.

func _on_EnterDoors_area_entered(area:Area2D):
	pass # Replace with function body.
