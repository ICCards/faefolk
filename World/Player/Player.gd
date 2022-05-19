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

var valid_farm_tiles = null
var valid_object_tiles

onready var TorchObject = preload("res://World/Objects/Placables/TorchObject.tscn")


onready var state = MOVEMENT

enum {
	MOVEMENT, 
	SWING
}

onready var direction = "DOWN"

func _ready():
	setPlayerState(get_parent())
	setPlayerTexture('idle_down')
	$SoundEffects.play()
	_play_background_music()
	$Camera2D/UserInterface/Hotbar.visible = true
	init_day_night_cycle()
	DayNightTimer.day_timer.connect("timeout", self, "set_night")
	DayNightTimer.night_timer.connect("timeout", self, "set_day")


func _process(delta) -> void:
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


func _unhandled_input(event):
	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot) and PlayerInventory.viewInventoryMode == false:
		var item_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
		var itemCategory = JsonData.item_data[item_name]["ItemCategory"]
		if event.is_action_pressed("mouse_click") and itemCategory == "Weapon" and playerState == "Farm":
			state = SWING
			swing_state(event)
		if itemCategory == "Placable" and playerState == "Farm":
			place_item_state(event, item_name)
		else: 
			$PlaceItemsUI/ColorIndicator.visible = false
			$PlaceItemsUI/ItemToPlace.visible = false
	else: 
		$PlaceItemsUI/ColorIndicator.visible = false
		$PlaceItemsUI/ItemToPlace.visible = false


var is_colliding_other_object = false



func _on_PlaceItemBox_area_entered(area):
	is_colliding_other_object = true


func _on_PlaceItemBox_area_exited(area):
	if $PlaceItemsUI/PlaceItemBox.get_overlapping_areas().size() <= 0:
		is_colliding_other_object = false
	
func place_item_state(event, name):
	$PlaceItemsUI/ColorIndicator.visible = true
	$PlaceItemsUI/ItemToPlace.visible = true
	$PlaceItemsUI/ItemToPlace.texture = load("res://Assets/Images/dropped_item_icon/" + name + ".png")
	var mousePos = get_owner().get_global_mouse_position() + Vector2(-16, -16)
	mousePos = mousePos.snapped(Vector2(32,32))
	$PlaceItemsUI.set_global_position(mousePos)
	var location = valid_farm_tiles.world_to_map(mousePos)
	if is_colliding_other_object or valid_object_tiles.get_cellv(location) == -1 or position.distance_to(mousePos) > 150:
		$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/red_square.png")
	else:
		$PlaceItemsUI/ColorIndicator.texture = preload("res://Assets/Images/Misc/green_square.png")
		if event.is_action_pressed("mouse_click"):
			var torchObject = TorchObject.instance()
			torchObject.initialize(valid_farm_tiles.map_to_world(location))
			get_parent().add_child(torchObject)
			torchObject.position = mousePos + Vector2(16, 22)
			PlayerInventory.player_farm_objects.append(["torch", null, valid_farm_tiles.map_to_world(location), true])
			PlayerInventory.add_item_to_hotbar("torch", -1)


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
		$SoundEffects.stream_paused = true
			
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move_and_collide(velocity * MAX_SPEED)	


var swingActive = false
func swing_state(_delta):
		$SoundEffects.stream_paused = true
		if !swingActive:
				var toolName = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
				swingActive = true
				set_melee_collision_layer(toolName)
				toolEquippedSprite.set_texture(Characters.returnToolSprite(toolName, direction.to_lower()))
				setPlayerTexture("swing_" + direction.to_lower())
				animation_player.play("swing_" + direction.to_lower())
				yield(animation_player, "animation_finished" )
				toolEquippedSprite.texture = null
				state = MOVEMENT
				swingActive = false
		elif swingActive == true:
			pass
		else:
			state = MOVEMENT


func idle_state(dir):
	$SoundEffects.stream_paused = true
	setPlayerTexture("idle_" + dir.to_lower())

func walk_state(dir):
	$SoundEffects.stream_paused = false
	setPlayerTexture("walk_" + dir.to_lower())

func set_melee_collision_layer(toolName):
	if toolName == "axe": 
		$MeleeSwing.set_collision_mask(8)
	elif toolName == "pickaxe":
		$MeleeSwing.set_collision_mask(16)


func setPlayerTexture(var anim):
<<<<<<< HEAD
	bodySprite.set_texture(Global.body_sprites[anim])
	armsSprite.set_texture(Global.arms_sprites[anim])
	accessorySprite.set_texture(Global.acc_sprites[anim])
	headAttributeSprite.set_texture(Global.headAtr_sprites[anim])
	pantsSprite.set_texture(Global.pants_sprites[anim])
	shirtsSprite.set_texture(Global.shirts_sprites[anim])
	shoesSprite.set_texture(Global.shoes_sprites[anim])
=======
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
		valid_farm_tiles = get_node("/root/PlayerHomeFarm/GroundTiles/ValidTilesNature")
		valid_object_tiles = get_node("/root/PlayerHomeFarm/GroundTiles/ValidTilesForObjectPlacement")
	else:
		playerState = "Home"
		$SoundEffects.stream = Sounds.wood_footsteps



var sceneTransitionFlag = false
func _on_EnterDoors_area_entered(_area):
	sceneTransitionFlag = true

func _on_EnterDoors_area_exited(_area):
	sceneTransitionFlag = false


func _on_WoodAreas_area_entered(_area):
	$SoundEffects.stream = Sounds.wood_footsteps
	$SoundEffects.play()


func _on_WoodAreas_area_exited(_area):
	$SoundEffects.stream = Sounds.dirt_footsteps
	$SoundEffects.play()

>>>>>>> maxs_branch
