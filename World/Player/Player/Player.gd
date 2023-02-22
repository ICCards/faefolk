extends CharacterBody2D

@onready var animation_player = $CompositeSprites/AnimationPlayer
@onready var sword_swing = $Swing/SwordSwing
@onready var composite_sprites = $CompositeSprites
@onready var holding_item = $CompositeSprites/HoldingItem

@onready var actions = $Actions
@onready var user_interface = $Camera2D/UserInterface
@onready var sound_effects = $Sounds/SoundEffects

var running = false
var character
var current_building_item = null
var running_speed_change = 1.0

@onready var state = MOVEMENT
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
	BOW_ARROW_SHOOTING,
	SWORD_SWINGING
}

var cast_movement_direction = ""
var direction = "DOWN"
var rng = RandomNumberGenerator.new()
var animation = "idle_down"
var MAX_SPEED_DIRT := 8
var MAX_SPEED_PATH := 9
var DASH_SPEED := 25
var MAX_SPEED_SWIMMING := 6
var is_walking_on_dirt: bool = true
var is_swimming: bool = false
var poisoned: bool = false
var speed_buff_active: bool = false
var ACCELERATION := 6
var FRICTION := 8
var input_vector
var is_building_world = false
@onready var _character = load("res://Global/Data/Characters.gd")

func _ready():
	character = _character.new()
	character.LoadPlayerCharacter("human_male")
	PlayerData.connect("active_item_updated",Callable(self,"set_held_object"))
	Server.player_node = self
	if is_building_world:
		state = DYING
		$Camera2D/UserInterface/LoadingScreen.show()
		await get_tree().create_timer(5.0).timeout
	state = MOVEMENT
	$Camera2D/UserInterface/LoadingScreen.hide()
	await get_tree().process_frame
	set_held_object()
	await get_tree().create_timer(0.25).timeout
	Server.isLoaded = true


func _input( event ):
	if event is InputEvent:
		if event.is_action_pressed("sprint"):
			running = true
		elif event.is_action_released("sprint"):
			running = false


func destroy():
	set_process(false)
	set_process_unhandled_input(false)
	state = DYING
	character.queue_free()

func set_held_object():
	if PlayerData.normal_hotbar_mode:
		if PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot)):
			var item_name = PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][0]
			set_current_object(item_name)
			return
	else:
		if PlayerData.player_data["combat_hotbar"].has(str(PlayerData.active_item_slot_combat_hotbar)):
			var item_name = PlayerData.player_data["combat_hotbar"][str(PlayerData.active_item_slot_combat_hotbar)][0]
			var item_category = JsonData.item_data[item_name]["ItemCategory"]
			if item_category == "Magic" or item_name == "bow" or item_name == "wood sword" or item_name == "stone sword" or item_name == "iron sword" or item_name == "gold sword" or item_name == "bronze sword":
				$Camera2D/UserInterface/CombatHotbar/MagicSlots.call_deferred("initialize", item_name)
			else:
				$Camera2D/UserInterface/CombatHotbar/MagicSlots.call_deferred("hide")
			set_current_object(item_name)
			return
	set_current_object(null)


func set_current_object(item_name):
	var item_category
	if item_name:
		item_category = JsonData.item_data[item_name]["ItemCategory"]
	else:
		item_category = null
	# Placable object
	if item_category == "Placable object" or item_category == "Seed" or (item_category == "Forage" and item_name != "raw egg"):
		actions.show_placable_object(item_name, item_category)
		return
	if item_name == "blueprint" and current_building_item != null:
		actions.show_placable_object(current_building_item, "BUILDING")
		return
	actions.destroy_placable_object()
	# Holding item
	if Util.valid_holding_item_category(item_category):
		holding_item.texture = load("res://Assets/Images/inventory_icons/" + item_category + "/" + item_name + ".png")
		holding_item.show()
		$HoldingTorch.set_inactive()
	elif item_name == "torch":
		holding_item.hide()
		$HoldingTorch.set_active()


func _process(_delta) -> void:
	if $Area2Ds/PickupZone.items_in_range.size() > 0:
		var pickup_item = $Area2Ds/PickupZone.items_in_range.values()[0]
		pickup_item.pick_up_item(self)
		$Area2Ds/PickupZone.items_in_range.erase(pickup_item)
	if state == MOVEMENT: #or state == MAGIC_CASTING or state == BOW_ARROW_SHOOTING or state == SWORD_SWINGING:
		movement_state(_delta)
	elif state == MAGIC_CASTING or state == BOW_ARROW_SHOOTING or state == SWORD_SWINGING:
		magic_casting_movement_state(_delta)


func set_movement_speed_change():
	if (state == MAGIC_CASTING or state == BOW_ARROW_SHOOTING) and poisoned:
		running_speed_change = 0.7
	elif state == MAGIC_CASTING or state == BOW_ARROW_SHOOTING:
		running_speed_change = 0.9
	elif poisoned and speed_buff_active:
		running_speed_change = 1.0
	elif poisoned:
		running_speed_change = 0.8
	elif speed_buff_active and not running and state == MOVEMENT:
		running_speed_change = 1.3
	elif speed_buff_active and running and state == MOVEMENT:
		running_speed_change = 1.6
	elif running and state == MOVEMENT:
		running_speed_change = 1.3
	else:
		running_speed_change = 1.0


func _unhandled_input(event):
	if not PlayerData.viewInventoryMode and not PlayerData.viewSaveAndExitMode and not PlayerData.interactive_screen_mode and not PlayerData.viewMapMode and state == MOVEMENT and Sounds.current_footsteps_sound != Sounds.swimming: 
		if PlayerData.normal_hotbar_mode:
			if PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot)):
				var item_name = PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][0]
				var item_category = JsonData.item_data[item_name]["ItemCategory"]
				if item_name == "blueprint" and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
					$Camera2D/UserInterface/RadialBuildingMenu.initialize()
				elif (event.is_action_pressed("mouse_click") or event.is_action_pressed("use tool")):
					player_action(item_name, item_category)
				elif (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT):
					if item_category == "Magic":
						$Magic.cast_spell(item_name, 2)
					elif item_name == "bow":
						$Magic.draw_bow(2)
					elif Util.isSword(item_name):
						$Swing.sword_swing(item_name, 2)
			else:
				if (event.is_action_pressed("mouse_click") or event.is_action_pressed("use tool")):
					player_action(null, null)
		else:
			if PlayerData.player_data["combat_hotbar"].has(str(PlayerData.active_item_slot_combat_hotbar)):
				var item_name = PlayerData.player_data["combat_hotbar"][str(PlayerData.active_item_slot_combat_hotbar)][0]
				var item_category = JsonData.item_data[item_name]["ItemCategory"]
				if event.is_action_pressed("mouse_click") or event.is_action_pressed("use tool"):
					player_action(item_name, item_category)
				elif item_category == "Magic" or item_name == "bow":
					if event.is_action_pressed("slot 1"):
						if item_category == "Magic":
							$Magic.cast_spell(item_name, 1)
						elif item_name == "bow":
							$Magic.draw_bow(1)
						elif Util.isSword(item_name):
							$Swing.sword_swing(item_name, 1)
					elif event.is_action_pressed("slot 2") or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT):
						if item_category == "Magic":
							$Magic.cast_spell(item_name, 2)
						elif item_name == "bow":
							$Magic.draw_bow(2)
						elif Util.isSword(item_name):
							$Swing.sword_swing(item_name, 2)
					elif event.is_action_pressed("slot 3"):
						if item_category == "Magic":
							$Magic.cast_spell(item_name, 3)
						elif item_name == "bow":
							$Magic.draw_bow(3)
						elif Util.isSword(item_name):
							$Swing.sword_swing(item_name, 1)
					elif event.is_action_pressed("slot 4"):
						if item_category == "Magic":
							$Magic.cast_spell(item_name, 4)
						elif item_name == "bow":
							$Magic.draw_bow(4)
						elif Util.isSword(item_name):
							$Swing.sword_swing(item_name, 1)
			else:
				if event.is_action_pressed("mouse_click") or event.is_action_pressed("use tool"):
					player_action(null, null)


func player_action(item_name, item_category):
	if item_name == "wood fishing rod" or item_name == "stone fishing rod" or item_name == "gold fishing rod":
		actions.fish()
	elif Util.isSword(item_name): 
		$Swing.sword_swing(item_name, user_interface.get_node("CombatHotbar/MagicSlots").selected_spell)
	elif (item_category == "Tool" or item_name == "hammer") and item_name != "bow":
		$Swing.swing(item_name)
	elif item_category == "Potion" or item_name == "raw egg":
		$Magic.throw_potion(item_name, direction)
	elif item_name == "bow":
		$Magic.draw_bow(user_interface.get_node("CombatHotbar/MagicSlots").selected_spell)
	elif item_category == "Magic":
		$Magic.cast_spell(item_name, user_interface.get_node("CombatHotbar/MagicSlots").selected_spell)
	elif item_category == "Food" or item_category == "Fish" or item_category == "Crop":
		actions.eat(item_name)
	elif item_name == null:
		$Swing.swing(null) 


func magic_casting_movement_state(_delta):
	set_movement_speed_change()
	input_vector = Vector2.ZERO
	if Input.is_action_pressed("move up"):
		cast_movement_direction = "up"
		input_vector.y -= 1.0
		direction = "UP"
	if Input.is_action_pressed("move down"):
		cast_movement_direction = "down"
		input_vector.y += 1.0
		direction = "DOWN"
	if Input.is_action_pressed("move left"):
		cast_movement_direction = "left"
		input_vector.x -= 1.0
		direction = "LEFT"
	if Input.is_action_pressed("move right"):
		cast_movement_direction = "right"
		input_vector.x += 1.0
		direction = "RIGHT"
	if !Input.is_action_pressed("move right") && !Input.is_action_pressed("move left")  && !Input.is_action_pressed("move up")  && !Input.is_action_pressed("move down"):
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
	if not PlayerData.viewInventoryMode and not PlayerData.interactive_screen_mode and not PlayerData.viewSaveAndExitMode:
		set_movement_speed_change()
		input_vector = Vector2.ZERO
		if Input.is_action_pressed("move up"):
			input_vector.y -= 1.0
			direction = "UP"
			walk_state(direction)
		if Input.is_action_pressed("move down"):
			input_vector.y += 1.0
			direction = "DOWN"
			walk_state(direction)
		if Input.is_action_pressed("move left"):
			input_vector.x -= 1.0
			direction = "LEFT"
			walk_state(direction)
		if Input.is_action_pressed("move right"):
			input_vector.x += 1.0
			direction = "RIGHT"
			walk_state(direction)
		if !Input.is_action_pressed("move right") && !Input.is_action_pressed("move left")  && !Input.is_action_pressed("move up")  && !Input.is_action_pressed("move down"):
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
	animation_player.play("idle loop")
	if Sounds.current_footsteps_sound != Sounds.swimming:
		if state == MOVEMENT:
			if PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot)) and PlayerData.normal_hotbar_mode:
				var item_name = PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][0]
				var item_category = JsonData.item_data[item_name]["ItemCategory"]
				if Util.valid_holding_item_category(item_category) or item_name == "torch":
					animation = "holding_idle_" + _direction.to_lower()
				else:
					animation = "idle_" + _direction.to_lower()
			elif PlayerData.player_data["combat_hotbar"].has(str(PlayerData.active_item_slot_combat_hotbar)) and not PlayerData.normal_hotbar_mode:
				var item_name = PlayerData.player_data["combat_hotbar"][str(PlayerData.active_item_slot_combat_hotbar)][0]
				var item_category = JsonData.item_data[item_name]["ItemCategory"]
				if Util.valid_holding_item_category(item_category):
					animation = "holding_idle_" + _direction.to_lower()
				else:
					animation = "idle_" + _direction.to_lower()
			else:
				animation = "idle_" + _direction.to_lower()
			composite_sprites.set_player_animation(character, animation, null)
	else:
		$Area2Ds/HurtBox.decrease_energy_or_health_while_sprinting()
		composite_sprites.set_player_animation(character, "swim_" + direction.to_lower(), "swim")


func walk_state(_direction):
	animation_player.play("walk loop")
	$Sounds/FootstepsSound.stream_paused = false
	if Sounds.current_footsteps_sound != Sounds.swimming and not running:
		if PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot)) and PlayerData.normal_hotbar_mode:
			var item_name = PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][0]
			var item_category = JsonData.item_data[item_name]["ItemCategory"]
			if Util.valid_holding_item_category(item_category) or item_name == "torch":
				animation = "holding_walk_" + _direction.to_lower()
			else:
				animation = "walk_" + _direction.to_lower()
		elif PlayerData.player_data["combat_hotbar"].has(str(PlayerData.active_item_slot_combat_hotbar)) and not PlayerData.normal_hotbar_mode:
			var item_name = PlayerData.player_data["combat_hotbar"][str(PlayerData.active_item_slot_combat_hotbar)][0]
			var item_category = JsonData.item_data[item_name]["ItemCategory"]
			if Util.valid_holding_item_category(item_category):
				animation = "holding_walk_" + _direction.to_lower()
			else:
				animation = "walk_" + _direction.to_lower()
		else:
			animation = "walk_" + _direction.to_lower()
		composite_sprites.set_player_animation(character, animation, null)
	elif running and Sounds.current_footsteps_sound != Sounds.swimming:
		if state != DYING:
			$Area2Ds/HurtBox.decrease_energy_or_health_while_sprinting()
			animation = "run_" + _direction.to_lower()
			composite_sprites.set_player_animation(character, animation, null)
	elif Sounds.current_footsteps_sound == Sounds.swimming:
		$Area2Ds/HurtBox.decrease_energy_or_health_while_sprinting()
		composite_sprites.set_player_animation(character, "swim_" + direction.to_lower(), "swim")
