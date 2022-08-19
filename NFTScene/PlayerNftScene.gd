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
var MAX_SPEED := 12.5
var ACCELERATION := 6
var FRICTION := 8
var velocity := Vector2.ZERO
var input_vector
var counter = -1
var collisionMask = null
var is_daytime = true
const LENGTH_OF_DAY = 300

const _character = preload("res://Global/Data/Characters.gd")

func _ready():
	PlayerInventory.player = self
	Sounds.connect("volume_change", self, "set_new_music_volume")
	PlayerInventoryNftScene.emit_signal("active_item_updated")
	start_day_night_cycle()


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
			elif itemCategory == "Placable object":
				$PlaceItemsUI.place_item_state(item_name)
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
		set_melee_collision_layer(item_name)
		animation = "swing_" + direction.to_lower()
		swingActive = true
		$CompositeSprites.set_player_animation(character, animation, item_name)
		animation_player.play(animation)
		yield(animation_player, "animation_finished" )
		if PlayerInventoryNftScene.hotbar.has(PlayerInventoryNftScene.active_item_slot):
			var new_tool_name = PlayerInventoryNftScene.hotbar[PlayerInventoryNftScene.active_item_slot][0]
			var new_item_category = JsonData.item_data[new_tool_name]["ItemCategory"]
			if Input.is_mouse_button_pressed( 1 ) and new_item_category == "Weapon":
				swingActive = false
				swing_state(new_tool_name)
			else:
				swingActive = false
				state = MOVEMENT
		else: 
			swingActive = false
			state = MOVEMENT
	elif swingActive == true:
		pass
	else:
		swingActive = false
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


func set_melee_collision_layer(_tool):
	if _tool == "wood axe": 
		$MeleeSwing.set_collision_mask(8)
	elif _tool == "wood pickaxe":
		$MeleeSwing.set_collision_mask(16)

func start_day_night_cycle():
	yield(get_tree().create_timer(LENGTH_OF_DAY), "timeout")
	if is_daytime:
		$Camera2D/WeatherEffects/AnimationPlayer.play("set night")
	else:
		$Camera2D/WeatherEffects/AnimationPlayer.play_backwards("set night")
	yield($Camera2D/WeatherEffects/AnimationPlayer, "animation_finished")
	is_daytime = not is_daytime
	start_day_night_cycle()


