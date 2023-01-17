extends KinematicBody2D

onready var animation_player = $CompositeSprites/AnimationPlayer
onready var sword_swing = $Swing/SwordSwing
onready var composite_sprites = $CompositeSprites
onready var holding_item = $HoldingItem

onready var actions = $Actions
onready var user_interface = $Camera2D/UserInterface
onready var sound_effects = $Sounds/SoundEffects

var running = false
var character
var current_building_item = null
var running_speed_change = 1.0

onready var state = MOVEMENT
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
	BOW_ARROW_SHOOTING
}

var cast_movement_direction = ""
var direction = "DOWN"
var rng = RandomNumberGenerator.new()
var animation = "idle_down"
var MAX_SPEED_DIRT := 13
var MAX_SPEED_PATH := 14.5
var DASH_SPEED := 55
var MAX_SPEED_SWIMMING := 12
var is_walking_on_dirt: bool = true
var is_swimming: bool = false
var poisoned: bool = false
var speed_buff_active: bool = false
var ACCELERATION := 6
var FRICTION := 8
var velocity := Vector2.ZERO
var input_vector
var is_building_world = false
onready var _character = load("res://Global/Data/Characters.gd")

func _ready():
	character = _character.new()
	character.LoadPlayerCharacter("human_male")
	PlayerData.connect("active_item_updated", self, "set_held_object")
	Server.player_node = self
	if is_building_world:
		state = DYING
		$Camera2D/UserInterface/LoadingScreen.show()
		yield(get_tree().create_timer(5.0), "timeout")
	state = MOVEMENT
	$Camera2D/UserInterface/LoadingScreen.hide()
	yield(get_tree(), "idle_frame")
	Server.isLoaded = true
	set_held_object()

func destroy():
	set_process(false)
	set_process_unhandled_input(false)
	state = DYING

func set_held_object():
	if PlayerData.normal_hotbar_mode:
		if PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot)):
			var item_name = PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][0]
			var item_category = JsonData.item_data[item_name]["ItemCategory"]
			if item_name == "torch":
				$TorchLight.enabled = true
			else:
				$TorchLight.enabled = false
			if item_category == "Placable object" or item_category == "Seed":
				actions.show_placable_object(item_name, item_category)
				return
			if item_name == "blueprint" and current_building_item != null:
				actions.show_placable_object(current_building_item, "BUILDING")
				return
		$TorchLight.enabled = false
		actions.destroy_placable_object()
	else:
		$TorchLight.enabled = false
		actions.destroy_placable_object()
		if PlayerData.player_data["combat_hotbar"].has(str(PlayerData.active_item_slot_combat_hotbar)):
			var item_name = PlayerData.player_data["combat_hotbar"][str(PlayerData.active_item_slot_combat_hotbar)][0]
			var item_category = JsonData.item_data[item_name]["ItemCategory"]
			if item_category == "Magic" or item_name == "bow" or item_name == "wood sword" or item_name == "stone sword" or item_name == "iron sword" or item_name == "gold sword" or item_name == "bronze sword":
				$Camera2D/UserInterface/CombatHotbar/MagicSlots.initialize(item_name)
				return
		$Camera2D/UserInterface/CombatHotbar/MagicSlots.hide()


func _process(_delta) -> void:
	if $Area2Ds/PickupZone.items_in_range.size() > 0:
		var pickup_item = $Area2Ds/PickupZone.items_in_range.values()[0]
		pickup_item.pick_up_item(self)
		$Area2Ds/PickupZone.items_in_range.erase(pickup_item)
	if state == MOVEMENT:
		movement_state(_delta)
	elif state == MAGIC_CASTING or state == BOW_ARROW_SHOOTING:
		magic_casting_movement_state(_delta)


func set_movement_speed_change():
	if state == MAGIC_CASTING or state == BOW_ARROW_SHOOTING:
		running_speed_change = 0.9
	elif (state == MAGIC_CASTING or state == BOW_ARROW_SHOOTING) and poisoned:
		running_speed_change = 0.7
	elif poisoned and speed_buff_active:
		running_speed_change = 1.0
	elif poisoned:
		running_speed_change = 0.8
	elif speed_buff_active and not running and state == MOVEMENT:
		running_speed_change = 1.25
	elif speed_buff_active and running and state == MOVEMENT:
		running_speed_change = 1.5
	elif running and state == MOVEMENT:
		running_speed_change = 1.25
	else:
		running_speed_change = 1.0


func _unhandled_input(event):
	if not PlayerData.viewInventoryMode and not PlayerData.viewSaveAndExitMode and not PlayerData.interactive_screen_mode and not PlayerData.viewMapMode and state == MOVEMENT and Sounds.current_footsteps_sound != Sounds.swimming: 
		if PlayerData.normal_hotbar_mode:
			if PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot)):
				var item_name = PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][0]
				var item_category = JsonData.item_data[item_name]["ItemCategory"]
				if item_name == "blueprint" and event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
					$Camera2D/UserInterface/RadialBuildingMenu.initialize()
				elif (event.is_action_pressed("mouse_click") or event.is_action_pressed("use_tool")):
					player_action(event, item_name, item_category)
			else:
				if (event.is_action_pressed("mouse_click") or event.is_action_pressed("use_tool")):
					player_action(event, null, null)
		else:
			if PlayerData.player_data["combat_hotbar"].has(str(PlayerData.active_item_slot_combat_hotbar)):
				var item_name = PlayerData.player_data["combat_hotbar"][str(PlayerData.active_item_slot_combat_hotbar)][0]
				var item_category = JsonData.item_data[item_name]["ItemCategory"]
				if event.is_action_pressed("mouse_click") or event.is_action_pressed("use_tool"):
					player_action(event, item_name, item_category)
			else:
				if event.is_action_pressed("mouse_click") or event.is_action_pressed("use_tool"):
					player_action(event, null, null)
	if event.is_action_pressed("sprint") and not poisoned:
		running = true
	elif event.is_action_released("sprint") and not poisoned:
		running = false



func player_action(event, item_name, item_category):
	if item_name == "wood fishing rod" or item_name == "stone fishing rod" or item_name == "gold fishing rod":
		actions.fish()
	elif (item_category == "Tool" or item_name == "hammer") and item_name != "bow":
		$Swing.swing(item_name, direction)
	elif item_category == "Potion":
		$Magic.throw_potion(item_name, direction)
	elif item_name == "bow":
		$Magic.draw_bow(direction)
	elif item_category == "Magic":
		$Magic.cast_spell(item_name, direction)
	elif item_category == "Food" or item_category == "Fish" or item_category == "Crop":
		actions.eat(item_name)
	elif item_name == null:
		$Swing.swing(null, direction) 


func magic_casting_movement_state(_delta):
	set_movement_speed_change()
	input_vector = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		cast_movement_direction = "up"
		input_vector.y -= 1.0
		direction = "UP"
	if Input.is_action_pressed("move_down"):
		cast_movement_direction = "down"
		input_vector.y += 1.0
		direction = "DOWN"
	if Input.is_action_pressed("move_left"):
		cast_movement_direction = "left"
		input_vector.x -= 1.0
		direction = "LEFT"
	if Input.is_action_pressed("move_right"):
		cast_movement_direction = "right"
		input_vector.x += 1.0
		direction = "RIGHT"
	if !Input.is_action_pressed("move_right") && !Input.is_action_pressed("move_left")  && !Input.is_action_pressed("move_up")  && !Input.is_action_pressed("move_down"):
		cast_movement_direction = ""
		pass
	if cast_movement_direction == "":
		$Sounds/FootstepsSound.stream_paused = true
	else:
		$Sounds/FootstepsSound.stream_paused = false
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION * _delta
		velocity = velocity.limit_length(MAX_SPEED_DIRT * _delta)
		velocity = velocity.move_toward(Vector2.ZERO, _delta/3)
		move_and_collide(velocity * MAX_SPEED_DIRT * running_speed_change)


func movement_state(delta):
	if (state == MAGIC_CASTING or state == MOVEMENT) and not PlayerData.viewInventoryMode and not PlayerData.interactive_screen_mode and not PlayerData.viewSaveAndExitMode:
		set_movement_speed_change()
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
			if is_walking_on_dirt:
				velocity = velocity.limit_length(MAX_SPEED_DIRT * delta)
			else:
				velocity = velocity.limit_length(MAX_SPEED_PATH * delta)
			sword_swing.knockback_vector = input_vector
		else:
			if Sounds.current_footsteps_sound != Sounds.swimming:
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta )
			else:
				velocity = velocity.move_toward(Vector2.ZERO, delta/3)
		if $Magic.dashing:
			move_and_collide(velocity * DASH_SPEED)
		elif not is_walking_on_dirt:
			move_and_collide(velocity * MAX_SPEED_PATH * running_speed_change)
		else:
			move_and_collide(velocity * MAX_SPEED_DIRT * running_speed_change)
	else:
		idle_state(direction)


func idle_state(_direction):
	$Sounds/FootstepsSound.stream_paused = true
	if state != DYING:
		if Sounds.current_footsteps_sound != Sounds.swimming:
			if state == MOVEMENT:
				animation_player.play("idle")
				if PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot)) and PlayerData.normal_hotbar_mode:
					var item_name = PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][0]
					var item_category = JsonData.item_data[item_name]["ItemCategory"]
					if Util.valid_holding_item_category(item_category):
						holding_item.show()
						holding_item.texture = load("res://Assets/Images/inventory_icons/" + item_category + "/" + item_name + ".png")
						animation = "holding_idle_" + _direction.to_lower()
						$HoldingTorch.hide()
					elif item_name == "torch":
						holding_item.hide()
						$HoldingTorch.show()
						animation = "holding_idle_" + _direction.to_lower()
					else:
						holding_item.hide()
						animation = "idle_" + _direction.to_lower()
						$HoldingTorch.hide()
				elif PlayerData.player_data["combat_hotbar"].has(str(PlayerData.active_item_slot_combat_hotbar)) and not PlayerData.normal_hotbar_mode:
					var item_name = PlayerData.player_data["combat_hotbar"][str(PlayerData.active_item_slot_combat_hotbar)][0]
					var item_category = JsonData.item_data[item_name]["ItemCategory"]
					if Util.valid_holding_item_category(item_category):
						holding_item.texture = load("res://Assets/Images/inventory_icons/" + item_category + "/" + item_name + ".png")
						holding_item.show()
						animation = "holding_idle_" + _direction.to_lower()
						$HoldingTorch.hide()
					else:
						$HoldingTorch.hide()
						holding_item.hide()
						animation = "idle_" + _direction.to_lower()
				else:
					$HoldingTorch.hide()
					holding_item.hide()
					animation = "idle_" + _direction.to_lower()
				composite_sprites.set_player_animation(character, animation, null)
		else:
			$Area2Ds/HurtBox.decrease_energy_or_health_while_sprinting()
			animation_player.play("swim")
			composite_sprites.set_player_animation(character, "swim_" + direction.to_lower(), "swim")


func walk_state(_direction):
	if state != DYING:
		$Sounds/FootstepsSound.stream_paused = false
		if Sounds.current_footsteps_sound != Sounds.swimming and not running:
			animation_player.play("walk")
			if PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot)) and PlayerData.normal_hotbar_mode:
				var item_name = PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][0]
				var item_category = JsonData.item_data[item_name]["ItemCategory"]
				if Util.valid_holding_item_category(item_category):
					holding_item.texture = load("res://Assets/Images/inventory_icons/" + item_category + "/" + item_name + ".png")
					holding_item.show()
					animation = "holding_walk_" + _direction.to_lower()
					$HoldingTorch.hide()
				elif item_name == "torch":
					holding_item.hide()
					$HoldingTorch.show()
					animation = "holding_walk_" + _direction.to_lower()
				else:
					holding_item.hide()
					animation = "walk_" + _direction.to_lower()
					$HoldingTorch.hide()
			elif PlayerData.player_data["combat_hotbar"].has(str(PlayerData.active_item_slot_combat_hotbar)) and not PlayerData.normal_hotbar_mode:
				var item_name = PlayerData.player_data["combat_hotbar"][str(PlayerData.active_item_slot_combat_hotbar)][0]
				var item_category = JsonData.item_data[item_name]["ItemCategory"]
				if Util.valid_holding_item_category(item_category):
					holding_item.texture = load("res://Assets/Images/inventory_icons/" + item_category + "/" + item_name + ".png")
					holding_item.show()
					animation = "holding_walk_" + _direction.to_lower()
					$HoldingTorch.hide()
				else:
					holding_item.hide()
					animation = "walk_" + _direction.to_lower()
					$HoldingTorch.hide()
			else:
				holding_item.hide()
				animation = "walk_" + _direction.to_lower()
				$HoldingTorch.hide()
			composite_sprites.set_player_animation(character, animation, null)
		elif running and Sounds.current_footsteps_sound != Sounds.swimming:
			$Area2Ds/HurtBox.decrease_energy_or_health_while_sprinting()
			animation_player.play("sprint")
			animation = "run_" + _direction.to_lower()
			composite_sprites.set_player_animation(character, animation, null)
			check_if_holding_item()
		elif Sounds.current_footsteps_sound == Sounds.swimming:
			$Area2Ds/HurtBox.decrease_energy_or_health_while_sprinting()
			holding_item.hide()
			$HoldingTorch.hide()
			animation_player.play("swim")
			composite_sprites.set_player_animation(character, "swim_" + direction.to_lower(), "swim")


func check_if_holding_item():
	if PlayerData.normal_hotbar_mode:
		if PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot)):
			var item_name = PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][0]
			var item_qt = PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][1]
			var item_category = JsonData.item_data[item_name]["ItemCategory"]
			if Util.valid_holding_item_category(item_category) or item_name == "torch":
				$HoldingTorch.hide()
				holding_item.hide()
				PlayerData.player_data["hotbar"].erase(str(PlayerData.active_item_slot))
				$Camera2D/UserInterface/Hotbar.initialize_hotbar()
				InstancedScenes.initiateInventoryItemDrop([item_name, item_qt, null], position)
				set_held_object()
	else:
		if PlayerData.player_data["combat_hotbar"].has(str(PlayerData.active_item_slot_combat_hotbar)):
			var item_name = PlayerData.player_data["combat_hotbar"][str(PlayerData.active_item_slot_combat_hotbar)][0]
			var item_qt = PlayerData.player_data["combat_hotbar"][str(PlayerData.active_item_slot_combat_hotbar)][1]
			var item_category = JsonData.item_data[item_name]["ItemCategory"]
			if Util.valid_holding_item_category(item_category) or item_name == "torch":
				$HoldingTorch.hide()
				holding_item.hide()
				PlayerData.player_data["combat_hotbar"].erase(str(PlayerData.active_item_slot_combat_hotbar))
				$Camera2D/UserInterface/CombatHotbar.initialize()
				InstancedScenes.initiateInventoryItemDrop([item_name, item_qt, null], position)
				set_held_object()
			
