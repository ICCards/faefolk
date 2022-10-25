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
	SITTING
}

var direction = "DOWN"
var rng = RandomNumberGenerator.new()
var animation = "idle_down"
var MAX_SPEED_DIRT := 13
var MAX_SPEED_PATH := 14.5
var MAX_SPEED_SWIMMING := 12
var is_walking_on_dirt: bool = true
var is_swimming: bool = false
var is_sitting: bool = false
var ACCELERATION := 6
var FRICTION := 8
var velocity := Vector2.ZERO
var input_vector
var counter = -1
var collisionMask = null
var direction_of_current_chair


const _character = preload("res://Global/Data/Characters.gd")

func _ready():
	Settings.load_keys()
	character = _character.new()
	character.LoadPlayerCharacter("human_male")
	PlayerStats.connect("health_depleted", self, "player_death")
	PlayerInventory.emit_signal("active_item_updated")
	Server.player_node = self
	
	
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
	
	
func sleep(sleeping_bag_direction, pos):
	if state != SLEEPING:
		z_index = 1
		state = SLEEPING
		spawn_position = position
		position = pos
		animation_player.play("sleep")
		composite_sprites.set_player_animation(character, "sleep_" + "down")
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
		composite_sprites.set_player_animation(character, "death_" + direction.to_lower(), null)
		animation_player.play("death")
		$Camera2D/UserInterface.death()
		$Area2Ds/PickupZone/CollisionShape2D.set_deferred("disabled", true) 
		if has_node("Fishing"):
			get_node("Fishing").queue_free()
		drop_inventory_items()
		yield(animation_player, "animation_finished")
		respawn()
	
func drop_inventory_items():
	for item in PlayerInventory.hotbar.keys(): 
		InstancedScenes.initiateInventoryItemDrop(PlayerInventory.hotbar[item], position)
	for item in PlayerInventory.inventory.keys(): 
		InstancedScenes.initiateInventoryItemDrop(PlayerInventory.inventory[item], position)
	PlayerInventory.hotbar = {}
	PlayerInventory.inventory = {}
	
func respawn():
	position = spawn_position
	PlayerStats.health = PlayerStats.health_maximum
	PlayerStats.emit_signal("health_changed")
	animation_player.stop()
	$Camera2D/UserInterface.respawn()
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


func _process(_delta) -> void:
	if $Area2Ds/PickupZone.items_in_range.size() > 0:
		var pickup_item = $Area2Ds/PickupZone.items_in_range.values()[0]
		pickup_item.pick_up_item(self)
		$Area2Ds/PickupZone.items_in_range.erase(pickup_item)
	if state == MOVEMENT:
		movement_state(_delta)
	else:
		$Sounds/FootstepsSound.stream_paused = true


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
				if item_name == "lightning staff":
					$Camera2D/UserInterface/MagicStaffUI.show()
				else:
					$Camera2D/UserInterface/MagicStaffUI.initialize(item_name)
				if event.is_action_pressed("mouse_click") and (item_name == "wood fishing rod" or item_name == "stone fishing rod" or item_name == "gold fishing rod"):
					fish()
				elif event.is_action_pressed("mouse_click") and (item_category == "Tool" or item_name == "hammer"):
					swing(item_name)
				elif item_name == "lightning staff" and event.is_action_pressed("mouse_click"):
					$Swing.cast_spell("lightning spell", direction)
				elif event.is_action_pressed("mouse_click") and (item_category == "Food" or item_category == "Fish" or item_category == "Crop"):
					eat(item_name)
				elif item_category == "Placable object" or item_category == "Placable path" or item_category == "Seed":
					show_placable_object(item_name, item_category)
				elif item_name != "blueprint":
					destroy_placable_object()
			else:
				destroy_placable_object()
				if event.is_action_pressed("mouse_click"): # punch
					swing(null) 
	if event.is_action_pressed("sprint"):
		running_speed_change = 1.25
		running = true
	elif event.is_action_released("sprint"):
		running_speed_change = 1.0
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

func swing(item_name):
	destroy_placable_object()
	$Swing.swing(item_name, direction)

func eat(item_name):
	destroy_placable_object()
	if state != EATING:
		state = EATING
		PlayerInventory.remove_single_object_from_hotbar()
		var eating_paricles = Eating_particles.instance()
		eating_paricles.item_name = item_name
		add_child(eating_paricles)
		composite_sprites.set_player_animation(character, "eat", null)
		animation_player.play("eat")
		yield(animation_player, "animation_finished")
		state = MOVEMENT

func fish():
	destroy_placable_object()
	if state != FISHING:
		PlayerStats.decrease_energy()
		state = FISHING
		var fishing = Fishing.instance()
		fishing.fishing_rod_type = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
		add_child(fishing)


func movement_state(delta):
	if state == MOVEMENT and \
	not PlayerInventory.chatMode and \
	not PlayerInventory.viewInventoryMode and \
	not PlayerInventory.interactive_screen_mode:
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
		if is_walking_on_dirt:
			move_and_collide(velocity * MAX_SPEED_DIRT * running_speed_change)
		else:
			move_and_collide(velocity * MAX_SPEED_PATH * running_speed_change)
	else:
		idle_state(direction)


func idle_state(_direction):
	$Sounds/FootstepsSound.stream_paused = true
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
			$Area2Ds/HurtBox/PlayerHitEffect/Label.text = str(amt)
			$Area2Ds/HurtBox/PlayerHitEffect/AnimationPlayer.play("Animate" + str(rng.randi_range(1,2)))
			PlayerStats.decrease_health(amt)
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


