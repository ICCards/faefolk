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


onready var TorchObject = preload("res://World/Objects/Placables/TorchObject.tscn")
onready var PlantedCrop = preload("res://World/Objects/Farm/PlantedCrop.tscn")
onready var TileObjectHurtBox = preload("res://World/PlayerFarm/TileObjectHurtBox.tscn")

onready var state = MOVEMENT

enum {
	MOVEMENT, 
	SWING
}

onready var direction = "DOWN"

func _ready():
	setPlayerState(get_parent())
	setPlayerTexture('idle_down')
	$FootstepsSound.play()
#	_play_background_music()
	$Camera2D/UserInterface/Hotbar.visible = true
	init_day_night_cycle()
	DayNightTimer.day_timer.connect("timeout", self, "set_night")
	DayNightTimer.night_timer.connect("timeout", self, "set_day")



var is_mouse_over_hotbar = false

func _process(delta) -> void:
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


func _input(event):
	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot) and PlayerInventory.viewInventoryMode == false and !is_mouse_over_hotbar:
		var item_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
		var itemCategory = JsonData.item_data[item_name]["ItemCategory"]
		if Input.is_action_pressed("mouse_click") and itemCategory == "Weapon" and playerState == "Farm":
			state = SWING
			swing_state(event)
		if itemCategory == "Placable object" and playerState == "Farm":
			place_item_state(event, item_name)
		elif itemCategory == "Placable path" and playerState == "Farm":
			place_path_state(event, item_name)
		elif itemCategory == "Seed" and playerState == "Farm":
			place_seed_state(event, item_name)
		else: 
			$PlaceItemsUI/ColorIndicator.visible = false
			$PlaceItemsUI/ItemToPlace.visible = false
	else: 
		$PlaceItemsUI/ColorIndicator.visible = false
		$PlaceItemsUI/ItemToPlace.visible = false

	
var placable_object_variety = 1

func get_object_variety(item_name):
	$PlaceItemsUI/ItemToPlace.texture = load("res://Assets/Images/placable_object_preview/" + item_name + str(placable_object_variety) + ".png")
	if item_name == "wood path":
		if Input.is_action_pressed("1 key"):
			placable_object_variety = 1
		elif Input.is_action_pressed("2 key"):
			placable_object_variety = 2
	elif item_name == "stone path":
		if Input.is_action_pressed("1 key"):
			placable_object_variety = 1
		elif Input.is_action_pressed("2 key"):
			placable_object_variety = 2
		elif Input.is_action_pressed("3 key"):
			placable_object_variety = 3
		elif Input.is_action_pressed("4 key"):
			placable_object_variety = 4


func place_path_state(event, item_name):
	get_object_variety(item_name)
	$PlaceItemsUI/ColorIndicator.visible = true
	$PlaceItemsUI/ItemToPlace.visible = true
	$PlaceItemsUI/ColorIndicator.scale.x = 1.0
	var mousePos = get_owner().get_global_mouse_position() + Vector2(-16, -16)
	mousePos = mousePos.snapped(Vector2(32,32))
	$PlaceItemsUI.set_global_position(mousePos)
	var location = valid_object_tiles.world_to_map(mousePos)
	if valid_path_tiles.get_cellv(location) == -1 or valid_object_tiles.get_cellv(location) == -1 or position.distance_to(mousePos) > 120:
		$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/red_square.png")
	else:
		$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/green_square.png")
		if event.is_action_pressed("mouse_click"):
			place_path_object(item_name, placable_object_variety, location)
			

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
		path_tiles.set_cellva(location, variety + 1)


func place_item_state(event, item_name):
	$PlaceItemsUI/ColorIndicator.visible = true
	$PlaceItemsUI/ItemToPlace.visible = true
	$PlaceItemsUI/ItemToPlace.texture = load("res://Assets/Images/placable_object_preview/" + item_name + ".png")
	if item_name == "large wood chest":
		$PlaceItemsUI/ColorIndicator.scale.x = 2.0
	else:
		$PlaceItemsUI/ColorIndicator.scale.x = 1.0
	var mousePos = get_owner().get_global_mouse_position() + Vector2(-16, -16)
	mousePos = mousePos.snapped(Vector2(32,32))
	$PlaceItemsUI.set_global_position(mousePos)
	var location = valid_object_tiles.world_to_map(mousePos)
	if valid_object_tiles.get_cellv(location) == -1 or position.distance_to(mousePos) > 120:
		$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/red_square.png")
	elif item_name == "large wood chest" and valid_object_tiles.get_cellv(location + Vector2(1,0)) == -1:
		$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/red_square.png")
	else:
		$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/green_square.png")
		if event.is_action_pressed("mouse_click"):
			place_placable_object(item_name, placable_object_variety, location)


func place_placable_object(name, variety, location):
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
	elif name == "large wood chest":
		var tileObjectHurtBox = TileObjectHurtBox.instance()
		tileObjectHurtBox.initialize(name, location)
		get_parent().call_deferred("add_child", tileObjectHurtBox)
		tileObjectHurtBox.global_position = fence_tiles.map_to_world(location) + Vector2(16, 16)
		object_tiles.set_cellv(location, 2)
		valid_object_tiles.set_cellv(location + Vector2(1, 0), -1)


func place_seed_state(event, name):
	name.erase(name.length() - 6, 6)
	$PlaceItemsUI/ColorIndicator.visible = true
	$PlaceItemsUI/ItemToPlace.visible = true
	$PlaceItemsUI/ItemToPlace.texture = load("res://Assets/Images/crop_sets/" + name + "/seeds.png")
	$PlaceItemsUI/ColorIndicator.scale.x = 1.0
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
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1.0
		direction = "DOWN"
		walk_state(direction)
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1.0
		direction = "LEFT"
		walk_state(direction)
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1.0
		direction = "RIGHT"
		walk_state(direction)		
	if !Input.is_action_pressed("ui_right") && !Input.is_action_pressed("ui_left")  && !Input.is_action_pressed("ui_up")  && !Input.is_action_pressed("ui_down"):
		idle_state(direction)
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
				var toolName = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
				swingActive = true
				set_melee_collision_layer(toolName)
				toolEquippedSprite.set_texture(Characters.returnToolSprite(toolName, direction.to_lower()))
				setPlayerTexture("swing_" + direction.to_lower())
				animation_player.play("swing_" + direction.to_lower())
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
	setPlayerTexture("idle_" + dir.to_lower())

func walk_state(dir):
	$FootstepsSound.stream_paused = false
	setPlayerTexture("walk_" + dir.to_lower())

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
	$SoundEffects.play()
	var pos = adjust_position_from_direction(get_position())
	var location = hoed_tiles.world_to_map(pos)
	if hoed_tiles.get_cellv(location) != -1:
		PlayerFarmApi.add_watered_tile(location)
		watered_tiles.set_cellv(location, 0)
		watered_tiles.update_bitmask_region()

func set_hoed_tile():
	var pos = adjust_position_from_direction(get_position())
	var location = hoed_tiles.world_to_map(pos)
	if hoed_tiles.get_cellv(location) == -1 and valid_object_tiles.get_cellv(location) != -1 and green_grass_tiles.get_cellv(location) == -1 and valid_path_tiles.get_cellv(location) != -1:
		yield(get_tree().create_timer(0.6), "timeout")
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/hoe.mp3")
		$SoundEffects.play()
		hoed_tiles.set_cellv(location, 0)
		valid_object_tiles.set_cellv(location, -1)
		hoed_tiles.update_bitmask_region()	

func remove_hoed_tile():
	var pos = adjust_position_from_direction(get_position())
	var location = hoed_tiles.world_to_map(pos)
	if hoed_tiles.get_cellv(location) != -1:
		yield(get_tree().create_timer(0.6), "timeout")
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/hoe.mp3")
		$SoundEffects.play()
		PlayerFarmApi.remove_crop(location)
		invisible_planted_crop_cells.set_cellv(location, -1)
		watered_tiles.set_cellv(location, -1)
		hoed_tiles.set_cellv(location, -1)
		valid_object_tiles.set_cellv(location, 0)
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
	bodySprite.set_texture(Characters.body_sprites[anim])
	armsSprite.set_texture(Characters.arms_sprites[anim])
	accessorySprite.set_texture(Characters.acc_sprites[anim])
	headAttributeSprite.set_texture(Characters.headAtr_sprites[anim])
	pantsSprite.set_texture(Characters.pants_sprites[anim])
	shirtsSprite.set_texture(Characters.shirts_sprites[anim])
	shoesSprite.set_texture(Characters.shoes_sprites[anim])
	
var rng = RandomNumberGenerator.new()
func _play_background_music():
	rng.randomize()
	$BackgroundMusic.stream = Sounds.background_music[rng.randi_range(0, Sounds.background_music.size() - 1)]
	$BackgroundMusic.play()
	yield($BackgroundMusic, "finished")
	_play_background_music()
	


func init_day_night_cycle():
	if playerState == "Farm":
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


var playerState
func setPlayerState(ownerNode):
	if str(ownerNode).substr(0, 14) == "PlayerHomeFarm":
		playerState = "Farm"
		valid_object_tiles = get_node("/root/PlayerHomeFarm/GroundTiles/ValidTilesForObjectPlacement")
		hoed_tiles = get_node("/root/PlayerHomeFarm/GroundTiles/HoedAutoTiles")
		watered_tiles = get_node("/root/PlayerHomeFarm/GroundTiles/WateredAutoTiles")
		green_grass_tiles = get_node("/root/PlayerHomeFarm/GroundTiles/GreenGrassTiles")
		fence_tiles = get_node("/root/PlayerHomeFarm/DecorationTiles/FenceAutoTile")
		object_tiles = get_node("/root/PlayerHomeFarm/DecorationTiles/PlacableObjectTiles")
		invisible_planted_crop_cells = get_node("/root/PlayerHomeFarm/GroundTiles/InvisiblePlantedCropCells")
		path_tiles = get_node("/root/PlayerHomeFarm/DecorationTiles/PlacablePathTiles")
		valid_path_tiles = get_node("/root/PlayerHomeFarm/GroundTiles/ValidTilesForPathPlacement")
	else:
		playerState = "Home"
		$FootstepsSound.stream = Sounds.wood_footsteps



var sceneTransitionFlag = false
func _on_EnterDoors_area_entered(_area):
	sceneTransitionFlag = true

func _on_EnterDoors_area_exited(_area):
	sceneTransitionFlag = false


func _on_WoodAreas_area_entered(_area):
	$FootstepsSound.stream = Sounds.wood_footsteps
	$FootstepsSound.play()


func _on_WoodAreas_area_exited(_area):
	$FootstepsSound.stream = Sounds.dirt_footsteps
	$FootstepsSound.play()

