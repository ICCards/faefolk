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


var valid_object_tiles
var valid_path_tiles
var hoed_tiles
var watered_tiles
var green_grass_tiles
var invisible_planted_crop_cells
var fence_tiles
var object_tiles
var path_tiles
var delta
var character

onready var TorchObject = preload("res://World/Objects/AnimatedObjects/TorchObject.tscn")
onready var PlantedCrop = preload("res://World/Objects/Farm/PlantedCrop.tscn")
onready var TileObjectHurtBox = preload("res://World/PlayerFarm/TileObjectHurtBox.tscn")
onready var PlayerHouseObject = preload("res://World/Objects/Farm/PlayerHouseObject.tscn")

onready var state = MOVEMENT

enum {
	MOVEMENT, 
	SWING
}

onready var direction = "DOWN"


func initialize_camera_limits(top_left, bottom_right):
	$Camera2D.limit_top = top_left.y
	$Camera2D.limit_left = top_left.x
	$Camera2D.limit_bottom = bottom_right.y
	$Camera2D.limit_right = bottom_right.x

var player_state
var animation = "idle_down"

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
	DayNightTimer.day_timer.connect("timeout", self, "set_night")
	DayNightTimer.night_timer.connect("timeout", self, "set_day")
	PlayerInventory.emit_signal("active_item_updated")
	Sounds.connect("volume_change", self, "set_new_music_volume")
	set_new_music_volume()





func set_new_music_volume():
	$BackgroundMusic.volume_db = Sounds.return_adjusted_sound_db("music", -32)
	$FootstepsSound.volume_db = Sounds.return_adjusted_sound_db("footstep", -10)
	


var rng = RandomNumberGenerator.new()
func _play_background_music():
	rng.randomize()
	$BackgroundMusic.stream = Sounds.background_music[rng.randi_range(0, Sounds.background_music.size() - 1)]
	$BackgroundMusic.play()
	$BackgroundMusic.volume_db =  Sounds.return_adjusted_sound_db("music", -32)
	yield($BackgroundMusic, "finished")
	_play_background_music()
	

var is_mouse_over_hotbar = false

func _process(_delta) -> void:
	delta = _delta
	var adjusted_position = get_global_mouse_position() - $Camera2D.get_camera_screen_center() 
	if adjusted_position.x > -240 and adjusted_position.x < 240 and adjusted_position.y > 210 and adjusted_position.y < 254:
		is_mouse_over_hotbar = true
	else:
		is_mouse_over_hotbar = false
	if PlayerInventory.viewInventoryMode == false:
		if $PickupZone.items_in_range.size() > 0:
			var pickup_item = $PickupZone.items_in_range.values()[0]
			pickup_item.pick_up_item(self)
			$PickupZone.items_in_range.erase(pickup_item)
		match state:
			MOVEMENT:
				movement_state(delta)
	else: 
		idle_state(direction)


#func _physics_process(delta):
#	DefinePlayerState()
#
#func DefinePlayerState():
#	player_state = {"T": Server.client_clock, "K": get_global_position(), "D": direction.to_lower()}
#	Server.message_send(player_state)

func _unhandled_input(event):
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
	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot) and PlayerInventory.viewInventoryMode == false and !is_mouse_over_hotbar:
		var item_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
		var itemCategory = JsonData.item_data[item_name]["ItemCategory"]
		if Input.is_action_pressed("mouse_click") and itemCategory == "Weapon" and setting == "World":
			state = SWING
			swing_state(event)
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
			Server.action("MOVEMENT",data)
		(SWING):
			pass
	
var path_index = 1
var selected_path

func get_object_variety(item_name):
	if item_name == "wood path" and path_index > 2:
		path_index = 1
	$PlaceItemsUI/ItemToPlace.texture = load("res://Assets/Images/placable_object_preview/" + item_name + str(path_index) + ".png")
	if item_name == "wood path":
		if Input.is_action_pressed("rotate"):
			path_index += 1
			if path_index == 3:
				path_index = 1
	elif item_name == "stone path":
		if Input.is_action_pressed("rotate"):
			path_index += 1
			if path_index == 5:
				path_index = 1


func place_path_state(event, item_name):
	get_object_variety(item_name)
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
	if valid_path_tiles.get_cellv(location) == -1 or valid_object_tiles.get_cellv(location) == -1 or position.distance_to(mousePos) > 120:
		$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/red_square.png")
	else:
		$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/green_square.png")
		if event.is_action_pressed("mouse_click"):
			place_path_object(item_name, path_index, location)


func place_path_object(item_name, variety, location):
	PlayerFarmApi.player_placable_paths.append([item_name, variety, location])
	PlayerInventory.remove_single_object_from_hotbar()
	valid_path_tiles.set_cellv(location, -1)
	var tileObjectHurtBox = TileObjectHurtBox.instance()
	tileObjectHurtBox.initialize(item_name, location)
	get_parent().call_deferred("add_child", tileObjectHurtBox)
	tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
	if item_name == "wood path":
		path_tiles.set_cellv(location, variety - 1)
	elif item_name == "stone path":
		path_tiles.set_cellv(location, variety + 1)


func place_item_state(event, item_name):
	$PlaceItemsUI/ColorIndicator.visible = true
	$PlaceItemsUI/ItemToPlace.visible = true
	$PlaceItemsUI/ItemToPlace.texture = load("res://Assets/Images/placable_object_preview/" + item_name + ".png")
	if item_name == "wood chest" or item_name == "stone chest":
		$PlaceItemsUI/ColorIndicator.scale = Vector2(2, 1)
	elif item_name == "house":
		$PlaceItemsUI/ColorIndicator.scale = Vector2(8, 4)
	else:
		$PlaceItemsUI/ColorIndicator.scale = Vector2(1, 1)

	var mousePos = get_parent().get_global_mouse_position() + Vector2(-16, -16)
	mousePos = mousePos.snapped(Vector2(32,32))
	$PlaceItemsUI.set_global_position(mousePos)
	var location = valid_object_tiles.world_to_map(mousePos)
	if item_name == "house":
		$PlaceItemsUI/ItemToPlace.rect_position = Vector2(-3, -301)
		$PlaceItemsUI/ItemToPlace.rect_scale = Vector2(0.9, 0.9)
	else:
		$PlaceItemsUI/ItemToPlace.rect_position = Vector2(0,-32)
		$PlaceItemsUI/ItemToPlace.rect_scale = Vector2(1, 1)
		
	if valid_object_tiles.get_cellv(location) == -1 or position.distance_to(mousePos) > 120:
		$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/red_square.png")
	elif (item_name == "wood chest" or item_name == "stone chest") and valid_object_tiles.get_cellv(location + Vector2(1,0)) == -1:
		$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/red_square.png")
#	elif item_name == "house":
#		if not check_valid_house_tiles(location):
#			$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/red_square.png")
	else:
		$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/green_square.png")
		if event.is_action_pressed("mouse_click"):
			place_placable_object(item_name, location)

func check_valid_house_tiles(location):
	var invalidFlag = false
	for x in range(9):
		for y in range(4):
			if valid_object_tiles.get_cellv( Vector2(x, y) + location) != -1:
				invalidFlag = false
				
			else: 
				invalidFlag = true
	return invalidFlag


func place_placable_object(name, location):
	PlayerFarmApi.player_placable_objects.append([name, location])
	PlayerInventory.remove_single_object_from_hotbar()
	valid_object_tiles.set_cellv(location, -1)
	if name == "torch":
		var torchObject = TorchObject.instance()
		torchObject.initialize(location)
		get_parent().add_child(torchObject)
		torchObject.position = valid_object_tiles.map_to_world(location) + Vector2(16, 22)
	elif name == "wood fence":
		var tileObjectHurtBox = TileObjectHurtBox.instance()
		tileObjectHurtBox.initialize(name, location)
		get_parent().call_deferred("add_child", tileObjectHurtBox)
		tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
		fence_tiles.set_cellv(location, 0)
		fence_tiles.update_bitmask_region()
	elif name == "wood barrel":
		var tileObjectHurtBox = TileObjectHurtBox.instance()
		tileObjectHurtBox.initialize(name, location)
		get_parent().call_deferred("add_child", tileObjectHurtBox)
		tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
		object_tiles.set_cellv(location, 0)
	elif name == "wood box":
		var tileObjectHurtBox = TileObjectHurtBox.instance()
		tileObjectHurtBox.initialize(name, location)
		get_parent().call_deferred("add_child", tileObjectHurtBox)
		tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
		object_tiles.set_cellv(location, 1)
	elif name == "wood chest":
		var tileObjectHurtBox = TileObjectHurtBox.instance()
		tileObjectHurtBox.initialize(name, location)
		get_parent().call_deferred("add_child", tileObjectHurtBox)
		tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
		object_tiles.set_cellv(location, 2)
		valid_object_tiles.set_cellv(location + Vector2(1, 0), -1)
	elif name == "stone chest":
		var tileObjectHurtBox = TileObjectHurtBox.instance()
		tileObjectHurtBox.initialize(name, location)
		get_parent().call_deferred("add_child", tileObjectHurtBox)
		tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
		object_tiles.set_cellv(location, 5)
		valid_object_tiles.set_cellv(location + Vector2(1, 0), -1)
	elif name == "house":
		var playerHouseObject = PlayerHouseObject.instance()
		get_parent().call_deferred("add_child", playerHouseObject)
		playerHouseObject.global_position = fence_tiles.map_to_world(location) + Vector2(6,6)
		set_player_house_invalid_tiles(location)
		
func set_player_house_invalid_tiles(location):
	for x in range(8):
		for y in range(4):
			valid_object_tiles.set_cellv(location + Vector2(x, -y), -1)


func place_seed_state(event, name):
	name.erase(name.length() - 6, 6)
	$PlaceItemsUI/ColorIndicator.visible = true
	$PlaceItemsUI/ItemToPlace.visible = true
	$PlaceItemsUI/ItemToPlace.texture = load("res://Assets/Images/crop_sets/" + name + "/seeds.png")
	$PlaceItemsUI/ColorIndicator.scale =  Vector2(1, 1)
	var mousePos = get_owner().get_global_mouse_position() + Vector2(-16, -16)
	mousePos = mousePos.snapped(Vector2(32,32))
	$PlaceItemsUI.set_global_position(mousePos)
	var location = valid_object_tiles.world_to_map(mousePos)
	if hoed_tiles.get_cellv(location) == -1 or invisible_planted_crop_cells.get_cellv(location) != -1 or position.distance_to(mousePos) > 120:
		$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/red_square.png")
	else:	
		$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/green_square.png")
		if event.is_action_pressed("mouse_click"):
			$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/place seed 3.mp3")
			$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
			$SoundEffects.play()
			invisible_planted_crop_cells.set_cellv(location, 0)
			PlayerInventory.remove_single_object_from_hotbar()
			PlayerFarmApi.planted_crops.append([name, location, !watered_tiles.get_cellv(location), JsonData.crop_data[name]["DaysToGrow"], false, false])
			var plantedCrop = PlantedCrop.instance()
			plantedCrop.initialize(name, location, JsonData.crop_data[name]["DaysToGrow"], false, false)
			get_parent().add_child(plantedCrop)
			plantedCrop.global_position = mousePos + Vector2(0, 16)

var MAX_SPEED := 12.5
var ACCELERATION := 6
var FRICTION := 8
var velocity := Vector2.ZERO

func movement_state(delta):
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
func swing_state(event):
		$FootstepsSound.stream_paused = true
		if !swingActive:
				PlayerStats.decrease_energy()
				var tool_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
				swingActive = true
				set_melee_collision_layer(tool_name)
				toolEquippedSprite.set_texture(Images.returnToolSprite(tool_name, direction.to_lower()))
				animation = "swing_" + direction.to_lower()
				setPlayerTexture(animation)
				animation_player.play(animation)
				yield(animation_player, "animation_finished" )
				toolEquippedSprite.texture = null
				swingActive = false
				var newToolName = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
				var newItemCategory = JsonData.item_data[newToolName]["ItemCategory"]
				if Input.is_action_pressed("mouse_click") and newItemCategory == "Weapon":
					swing_state(event)
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
		#remove_hoed_tile()
	elif toolName == "hoe":
		$MeleeSwing.set_collision_mask(0)
		#set_hoed_tile()
	elif toolName == "bucket":
		$MeleeSwing.set_collision_mask(0)
		#set_watered_tile()

func set_watered_tile():
	$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/water.mp3")
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
	$SoundEffects.play()
	var pos = adjust_position_from_direction(get_position())
	var location = hoed_tiles.world_to_map(pos)
	if hoed_tiles.get_cellv(location) != -1:
		PlayerFarmApi.add_watered_tile(location)
		watered_tiles.set_cellv(location, 0)
		watered_tiles.update_bitmask_region()

#func set_hoed_tile():
#	var pos = adjust_position_from_direction(get_position())
#	var location = hoed_tiles.world_to_map(pos)
#	if hoed_tiles.get_cellv(location) == -1 and valid_object_tiles.get_cellv(location) != -1 and green_grass_tiles.get_cellv(location) == -1 and valid_path_tiles.get_cellv(location) != -1:
#		yield(get_tree().create_timer(0.6), "timeout")
#		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/hoe.mp3")
#		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
#		$SoundEffects.play()
#		hoed_tiles.set_cellv(location, 0)
#		valid_object_tiles.set_cellv(location, -1)
#		hoed_tiles.update_bitmask_region()	
#
#func remove_hoed_tile():
#	var pos = adjust_position_from_direction(get_position())
#	var location = hoed_tiles.world_to_map(pos)
#	if hoed_tiles.get_cellv(location) != -1:
#		yield(get_tree().create_timer(0.6), "timeout")
#		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/hoe.mp3")
#		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
#		$SoundEffects.play()
#		PlayerFarmApi.remove_crop(location)
#		invisible_planted_crop_cells.set_cellv(location, -1)
#		watered_tiles.set_cellv(location, -1)
#		hoed_tiles.set_cellv(location, -1)
#		valid_object_tiles.set_cellv(location, 0)
#		hoed_tiles.update_bitmask_region()	


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
	


func init_day_night_cycle():
	if setting == "World":
		if DayNightTimer.is_daytime:
			$Camera2D/DayNight.color = Color("#ffffff")
		else:
			$Camera2D/DayNight.color = Color("#1c579e")
	else:
		$Camera2D/DayNight.visible = false

func set_night():
	day_night_animation_player.play("set night")
func set_day():
	day_night_animation_player.play_backwards("set night")


var setting

func set_player_setting(ownerNode):
	print(str(ownerNode).substr(0, 5))
	if str(ownerNode).substr(0, 5) == "World":
		setting = "World"
		$FootstepsSound.stream = Sounds.dirt_footsteps
		$FootstepsSound.volume_db = Sounds.return_adjusted_sound_db("footstep", -10)
		$FootstepsSound.play()
		valid_object_tiles = get_node("/root/World/GeneratedTiles/ValidTiles")
		path_tiles = get_node("/root/World/PlacableTiles/PathTiles")
		object_tiles = get_node("/root/World/PlacableTiles/ObjectTiles")
		fence_tiles = get_node("/root/World/PlacableTiles/FenceTiles")

##		hoed_tiles = get_node("/root/PlayerHomeFarm/GroundTiles/HoedAutoTiles")
##		watered_tiles = get_node("/root/PlayerHomeFarm/GroundTiles/WateredAutoTiles")
##		green_grass_tiles = get_node("/root/PlayerHomeFarm/GroundTiles/GreenGrassTiles")
##		invisible_planted_crop_cells = get_node("/root/PlayerHomeFarm/GroundTiles/InvisiblePlantedCropCells")
##		valid_path_tiles = get_node("/root/PlayerHomeFarm/GroundTiles/ValidTilesForPathPlacement")
	else:
		setting = "InsidePlayerHome"
		$FootstepsSound.stream = Sounds.wood_footsteps
		$FootstepsSound.volume_db = Sounds.return_adjusted_sound_db("footstep", -10)
		$FootstepsSound.play()



var sceneTransitionFlag = false
func _on_EnterDoors_area_entered(_area):
	sceneTransitionFlag = true

func _on_EnterDoors_area_exited(_area):
	sceneTransitionFlag = false




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
