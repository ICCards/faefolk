extends KinematicBody2D

onready var animation_player = $CompositeSprites/AnimationPlayer
onready var sword_swing = $Swing/SwordSwing
onready var composite_sprites = $CompositeSprites
onready var holding_item = $HoldingItem

onready var Eating_particles = preload("res://World/Player/Player/AttachedScenes/EatingParticles.tscn")
onready var Fishing = preload("res://World/Player/Player/Fishing/Fishing.tscn")
onready var PlaceObjectScene = preload("res://World/Player/Player/AttachedScenes/PlaceObjectPreview.tscn") 

var running = false
var principal
var character 
var setting
var current_building_item = null
var running_speed_change = 1.0

var spawn_position

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
var is_sitting: bool = false
var poisoned: bool = false
var speed_buff_active: bool = false
var ACCELERATION := 6
var FRICTION := 8
var velocity := Vector2.ZERO
var input_vector
var counter = -1
var collisionMask = null
var direction_of_current_chair
var is_building_world = false

const _character = preload("res://Global/Data/Characters.gd")

func _ready():
	Settings.load_keys()
	character = _character.new()
	character.LoadPlayerCharacter("human_male")
	PlayerStats.connect("health_depleted", self, "player_death")
	PlayerInventory.emit_signal("active_item_updated")
	PlayerInventory.connect("active_item_updated", self, "set_held_object")
	Server.player_node = self
	if is_building_world:
		state = DYING
		$Camera2D/UserInterface/LoadingScreen.show()
		#yield(get_tree().create_timer(10.0), "timeout")
	state = MOVEMENT
	$Camera2D/UserInterface/LoadingScreen.hide()
	yield(get_tree(), "idle_frame")
	set_held_object()
	
func destroy():
	set_process(false)
	set_process_unhandled_input(false)
	state = DYING

func start_speed_buff(length):
	speed_buff_active = true
	$SpeedParticles/P1.emitting = true
	$SpeedParticles/P2.emitting = true
	$SpeedParticles/P3.emitting = true
	if $SpeedParticles/SpeedStateTimer.time_left == 0:
		$SpeedParticles/SpeedStateTimer.start(length)
	else:
		$SpeedParticles/SpeedStateTimer.start(length+$SpeedParticles/SpeedStateTimer.time_left)

func _on_SpeedStateTimer_timeout():
	speed_buff_active = false
	$SpeedParticles/P1.emitting = false
	$SpeedParticles/P2.emitting = false
	$SpeedParticles/P3.emitting = false

func start_poison_state():
	running = false
	$PoisonParticles/PoisonTimer.start()
	poisoned = true
	$PoisonParticles/P1.emitting = true
	$PoisonParticles/P2.emitting = true
	$PoisonParticles/P3.emitting = true
	composite_sprites.modulate = Color("009000")
	
func _on_PoisonTimer_timeout():
	stop_poison_state()

func stop_poison_state():
	poisoned = false
	$PoisonParticles/P1.emitting = false
	$PoisonParticles/P2.emitting = false
	$PoisonParticles/P3.emitting = false
	composite_sprites.modulate = Color("ffffff")
	if Input.is_action_pressed("sprint"):
		running = true

func teleport(portal_position):
	var adjusted_pos = input_vector*40
	if adjusted_pos == Vector2.ZERO:
		adjusted_pos = Vector2(0,40)
	if $Magic.portal_1_position == portal_position and $Magic.portal_2_position:
		position = $Magic.portal_2_position + adjusted_pos
	elif $Magic.portal_2_position == portal_position:
		position = $Magic.portal_1_position + adjusted_pos
	
func sleep(sleeping_bag_direction, pos):
	if state != SLEEPING:
		z_index = 1
		state = SLEEPING
		spawn_position = position
		position = pos
		animation_player.play("sleep")
		composite_sprites.set_player_animation(character, "sleep_" + sleeping_bag_direction)
		if sleeping_bag_direction == "left":
			composite_sprites.rotation_degrees = -90
		elif sleeping_bag_direction == "right":
			composite_sprites.rotation_degrees = 90
		elif sleeping_bag_direction == "up":
			composite_sprites.rotation_degrees = 180
		yield(animation_player, "animation_finished")
		z_index = 0
		composite_sprites.rotation_degrees = 0
		state = MOVEMENT
	
func player_death():
	if state != DYING:
		state = DYING
		stop_poison_state()
		composite_sprites.set_player_animation(character, "death_" + direction.to_lower(), null)
		animation_player.play("death")
		$Camera2D/UserInterface.death()
		$Area2Ds/PickupZone/CollisionShape2D.set_deferred("disabled", true) 
		$Camera2D/UserInterface/MagicStaffUI.hide()
		if has_node("Fishing"):
			get_node("Fishing").queue_free()
		drop_inventory_items()
		yield(animation_player, "animation_finished")
		respawn()
	
func drop_inventory_items():
	for item in PlayerInventory.hotbar.keys(): 
		InstancedScenes.initiateInventoryItemDrop(PlayerInventory.hotbar[item], position+Vector2(rand_range(-32,32), rand_range(-32,32)))
	for item in PlayerInventory.inventory.keys(): 
		InstancedScenes.initiateInventoryItemDrop(PlayerInventory.inventory[item], position+Vector2(rand_range(-32,32), rand_range(-32,32)))
	PlayerInventory.hotbar = {}
	PlayerInventory.inventory = {}
	
func respawn():
	position = spawn_position
	PlayerStats.energy = PlayerStats.energy_maximum
	PlayerStats.health = PlayerStats.health_maximum
	PlayerStats.emit_signal("health_changed")
	PlayerStats.emit_signal("energy_changed")
	animation_player.stop()
	$Camera2D/UserInterface.respawn()
	yield(get_tree().create_timer(0.5), "timeout")
	$Area2Ds/PickupZone/CollisionShape2D.set_deferred("disabled", false) 
	state = MOVEMENT


func show_set_button_dialogue():
	if not $Camera2D/UserInterface/EnterNewKey.visible:
		$Camera2D/UserInterface/EnterNewKey.show()
		
func hide_set_button_dialogue():
	if $Camera2D/UserInterface/EnterNewKey.visible:
		$Camera2D/UserInterface/EnterNewKey.hide()

	
func initialize_camera_limits(top_left, bottom_right):
	$Camera2D.limit_top = top_left.y
	$Camera2D.limit_left = top_left.x
	$Camera2D.limit_bottom = bottom_right.y
	$Camera2D.limit_right = bottom_right.x
	
func sendAction(action,data): 
	match action:
		(MOVEMENT):
			Server.action("MOVEMENT",data)
		(SWINGING):
			Server.action("SWING", data)

func set_held_object():
	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
		var item_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
		var item_category = JsonData.item_data[item_name]["ItemCategory"]
		if item_category == "Magic":
			$Magic.is_staff_held = true
			$Camera2D/UserInterface/MagicStaffUI.initialize(item_name)
			return
	$Magic.is_staff_held = false
	$Camera2D/UserInterface/MagicStaffUI.hide()


func _process(_delta) -> void:
	$PoisonParticles/P1.direction = -velocity
	$PoisonParticles/P2.direction = -velocity
	$PoisonParticles/P3.direction = -velocity
	$SpeedParticles/P1.direction = -velocity
	$SpeedParticles/P2.direction = -velocity
	$SpeedParticles/P3.direction = -velocity
	if $Area2Ds/PickupZone.items_in_range.size() > 0:
		var pickup_item = $Area2Ds/PickupZone.items_in_range.values()[0]
		pickup_item.pick_up_item(self)
		$Area2Ds/PickupZone.items_in_range.erase(pickup_item)
	set_movement_speed_change()
	if state == MOVEMENT:
		movement_state(_delta)
	elif state == MAGIC_CASTING or state == BOW_ARROW_SHOOTING:
		magic_casting_movement_state(_delta)
	else:
		$Sounds/FootstepsSound.stream_paused = true


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
	if not PlayerInventory.viewInventoryMode and \
		not PlayerInventory.interactive_screen_mode and \
		not PlayerInventory.chatMode and \
		not PlayerInventory.viewMapMode and \
		state == MOVEMENT and \
		Sounds.current_footsteps_sound != Sounds.swimming: 
			if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
				var item_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
				var item_category = JsonData.item_data[item_name]["ItemCategory"]
				if item_name == "blueprint" and event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
					$Camera2D/UserInterface/RadialBuildingMenu.initialize()
				elif item_name == "blueprint" and current_building_item != null:
					show_placable_object(current_building_item, "BUILDING")
				if event.is_action_pressed("mouse_click") and (item_name == "wood fishing rod" or item_name == "stone fishing rod" or item_name == "gold fishing rod"):
					fish()
				elif event.is_action_pressed("mouse_click") and (item_category == "Tool" or item_name == "hammer") and item_name != "bow":
					$Swing.swing(item_name, direction)
				elif item_category == "Potion" and event.is_action_pressed("mouse_click"):
					$Throwing.throw_potion(item_name, direction)
				elif event.is_action_pressed("mouse_click") and item_name == "bow":
					$Magic.draw_bow(direction)
				elif event.is_action_pressed("mouse_click") and item_category == "Magic":
					$Magic.cast_spell(item_name, direction)
				elif event.is_action_pressed("mouse_click") and (item_category == "Food" or item_category == "Fish" or item_category == "Crop"):
					eat(item_name)
				elif item_category == "Placable object" or item_category == "Placable path" or item_category == "Seed":
					show_placable_object(item_name, item_category)
				elif item_name != "blueprint":
					destroy_placable_object()
			else:
				destroy_placable_object()
				if event.is_action_pressed("mouse_click"): # punch
					$Swing.swing(null) 
	if event.is_action_pressed("sprint") and not poisoned:
		running = true
	elif event.is_action_released("sprint") and not poisoned:
		running = false


func show_placable_object(item_name, item_category):
	if item_category == "Seed":
		item_name.erase(item_name.length() - 6, 6)
	if not has_node("PlaceObject"): # does not exist yet, add to scene tree
		var placeObject = PlaceObjectScene.instance()
		placeObject.name = "PlaceObject"
		placeObject.item_name = item_name
		placeObject.item_category = item_category
		placeObject.position = (get_global_mouse_position() + Vector2(-16, -16)).snapped(Vector2(32,32))
		add_child(placeObject)
	else:
		if get_node("PlaceObject").item_name != item_name: # exists but item changed
			get_node("PlaceObject").item_name = item_name
			get_node("PlaceObject").item_category = item_category
			get_node("PlaceObject").initialize()


func harvest_crop(item_name):
	state = HARVESTING
	var anim = "harvest_" + direction.to_lower()
	holding_item.texture = load("res://Assets/Images/inventory_icons/Crop/" + item_name + ".png")
	composite_sprites.set_player_animation(Server.player_node.character, anim)
	animation_player.play(anim)
	yield(animation_player, "animation_finished")
	state = MOVEMENT
	
func harvest_forage(item_name):
	state = HARVESTING
	var anim = "harvest_" + direction.to_lower()
	holding_item.texture = load("res://Assets/Images/Forage/" + item_name + ".png")
	composite_sprites.set_player_animation(Server.player_node.character, anim)
	animation_player.play(anim)
	yield(animation_player, "animation_finished")
	state = MOVEMENT


func destroy_placable_object():
	if has_node("PlaceObject"):
		get_node("Camera2D/UserInterface/ChangeRotation").hide()
		get_node("Camera2D/UserInterface/ChangeVariety").hide()
		get_node("PlaceObject").destroy()


func sit(adjusted_position, direction_of_chair):
	direction_of_current_chair = direction_of_chair
	is_sitting = true
	state = SITTING
	position = adjusted_position
	composite_sprites.set_player_animation(character, "sit_"+direction_of_current_chair, null)
	animation_player.play("sit_"+direction_of_current_chair)
	yield(animation_player, "animation_finished")
	is_sitting = false

func stand_up():
	if not is_sitting:
		animation_player.play_backwards("sit_"+direction_of_current_chair)
		yield(animation_player, "animation_finished")
		state = MOVEMENT

func eat(item_name):
	destroy_placable_object()
	if state != EATING:
		$Sounds/SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Player/eat.wav")
		$Sounds/SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -8)
		$Sounds/SoundEffects.play()
		state = EATING
		PlayerInventory.remove_single_object_from_hotbar()
		var eating_paricles = Eating_particles.instance()
		eating_paricles.item_name = item_name
		add_child(eating_paricles)
		composite_sprites.set_player_animation(character, "eat", null)
		animation_player.play("eat")
		yield(animation_player, "animation_finished")
		$CompositeSprites/Body.hframes = 4
		$CompositeSprites/Arms.hframes = 4
		$CompositeSprites/Pants.hframes = 4
		$CompositeSprites/Shoes.hframes = 4
		$CompositeSprites/Shirts.hframes = 4
		$CompositeSprites/HeadAtr.hframes = 4
		state = MOVEMENT

func fish():
	destroy_placable_object()
	if state != FISHING:
		PlayerStats.decrease_energy()
		state = FISHING
		var fishing = Fishing.instance()
		fishing.fishing_rod_type = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
		add_child(fishing)


func magic_casting_movement_state(_delta):
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
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION * _delta
		velocity = velocity.limit_length(MAX_SPEED_DIRT * _delta)
		velocity = velocity.move_toward(Vector2.ZERO, _delta/3)
		move_and_collide(velocity * MAX_SPEED_DIRT * running_speed_change)


func movement_state(delta):
	if (state == MAGIC_CASTING or state == MOVEMENT) and \
	not PlayerInventory.chatMode and \
	not PlayerInventory.viewInventoryMode and \
	not PlayerInventory.interactive_screen_mode:
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
		elif is_walking_on_dirt:
			move_and_collide(velocity * MAX_SPEED_DIRT * running_speed_change)
		else:
			move_and_collide(velocity * MAX_SPEED_PATH * running_speed_change)
	else:
		idle_state(direction)


func idle_state(_direction):
	$Sounds/FootstepsSound.stream_paused = true
	if state != DYING:
		if Sounds.current_footsteps_sound != Sounds.swimming:
			if state == MOVEMENT:
				animation_player.play("idle")
				if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
					var item_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
					var item_category = JsonData.item_data[item_name]["ItemCategory"]
					if Util.valid_holding_item_category(item_category):
						holding_item.show()
						holding_item.texture = load("res://Assets/Images/inventory_icons/" + item_category + "/" + item_name + ".png")
						animation = "holding_idle_" + _direction.to_lower()
					else:
						holding_item.hide()
						animation = "idle_" + _direction.to_lower()
				else:
					holding_item.hide()
					animation = "idle_" + _direction.to_lower()
				composite_sprites.set_player_animation(character, animation, null)
		else:
			animation_player.play("swim")
			composite_sprites.set_player_animation(character, "swim_" + direction.to_lower(), "swim")

func walk_state(_direction):
	if state != DYING:
		$Sounds/FootstepsSound.stream_paused = false
		if Sounds.current_footsteps_sound != Sounds.swimming and not running:
			animation_player.play("walk")
			if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
				var item_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
				var item_category = JsonData.item_data[item_name]["ItemCategory"]
				if Util.valid_holding_item_category(item_category):
					holding_item.texture = load("res://Assets/Images/inventory_icons/" + item_category + "/" + item_name + ".png")
					holding_item.show()
					animation = "holding_walk_" + _direction.to_lower()
				else:
					holding_item.hide()
					animation = "walk_" + _direction.to_lower()
			else:
				holding_item.hide()
				animation = "walk_" + _direction.to_lower()
			composite_sprites.set_player_animation(character, animation, null)
		elif running and Sounds.current_footsteps_sound != Sounds.swimming:
			decrease_energy_or_health()
			animation_player.play("sprint")
			animation = "run_" + _direction.to_lower()
			composite_sprites.set_player_animation(character, animation, null)
			check_if_holding_item()
		else:
			animation_player.play("swim")
			composite_sprites.set_player_animation(character, "swim_" + direction.to_lower(), "swim")


var temp = 0
func decrease_energy_or_health():
	temp += 1
	if temp > 500:
		temp = 0
		if PlayerStats.energy == 0:
			rng.randomize()
			var amt = rng.randi_range(1,3)
			$Area2Ds/HurtBox/AnimationPlayer.play("hit")
			InstancedScenes.player_hit_effect(-amt, position)
			PlayerStats.change_health(-amt)
		else:
			PlayerStats.decrease_energy()

func check_if_holding_item():
	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
		var item_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
		var item_qt = PlayerInventory.hotbar[PlayerInventory.active_item_slot][1]
		var item_category = JsonData.item_data[item_name]["ItemCategory"]
		if Util.valid_holding_item_category(item_category):
			holding_item.hide()
			PlayerInventory.hotbar.erase(PlayerInventory.active_item_slot)
			$Camera2D/UserInterface/Hotbar.initialize_hotbar()
			InstancedScenes.initiateInventoryItemDrop([item_name, item_qt, null], position)


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




