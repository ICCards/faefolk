extends Node2D

@onready var Fishing = load("res://World/Player/Player/Fishing/Fishing.tscn")
@onready var PlaceObjectScene = load("res://World/Building/PlaceObjectPreview.tscn") 
@onready var Eating_particles = load("res://World/Player/Player/AttachedScenes/EatingParticles.tscn")

@onready var sound_effects: AudioStreamPlayer = $SoundEffects

var direction_of_current_chair: String = ""
var sitting: bool = false

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
	BOW_ARROW_SHOOTING
}


var game_state: GameState
var current_interactive_node = null


func _ready():
	PlayerData.connect("health_depleted",Callable(self,"player_death"))


func _input(event):
	if not is_multiplayer_authority(): return
	if Server.player_node.state == 0 and get_parent().user_interface.holding_item == null and not PlayerData.viewMapMode:
		if event.is_action_pressed("action") and not PlayerData.viewInventoryMode and not PlayerData.viewSaveAndExitMode:
			if $DetectInteractiveArea.get_overlapping_areas().size() > 0:
				for new_node in $DetectInteractiveArea.get_overlapping_areas():
					if is_instance_valid(new_node):
						if current_interactive_node == null:
							current_interactive_node = new_node
						elif current_interactive_node.object_name == "crop" and new_node.object_name != "crop":
							current_interactive_node = new_node
						elif current_interactive_node.object_name == "crop" and new_node.object_name == "crop" and get_parent().position.distance_to(new_node.position) < get_parent().position.distance_to(current_interactive_node.position):
							current_interactive_node = new_node
						elif current_interactive_node.object_name == "forage" and new_node.object_name != "forage":
							current_interactive_node = new_node
						elif current_interactive_node.object_name == "forage" and new_node.object_name == "forage" and get_parent().position.distance_to(new_node.position) < get_parent().position.distance_to(current_interactive_node.position):
							current_interactive_node = new_node
			if current_interactive_node:
				match current_interactive_node.object_name:
					"bed":
						sleep(current_interactive_node.object_position)
					"tree":
						current_interactive_node.harvest()
					"crop":
						harvest_crop(current_interactive_node)
					"forage":
						harvest_forage(current_interactive_node)
					"crate":
						get_parent().user_interface.toggle_crate(current_interactive_node.name)
					"barrel":
						get_parent().user_interface.toggle_barrel(current_interactive_node.name)
					"workbench":
						get_parent().user_interface.toggle_workbench(current_interactive_node.object_level)
					"grain mill":
						get_parent().user_interface.toggle_grain_mill(current_interactive_node.name, current_interactive_node.object_level)
					"stove":
						get_parent().user_interface.toggle_stove(current_interactive_node.name, current_interactive_node.object_level)
					"chest":
						get_parent().user_interface.toggle_chest(current_interactive_node.name)
					"furnace":
						get_parent().user_interface.toggle_furnace(current_interactive_node.name)
					"tool cabinet":
						get_parent().user_interface.toggle_tc(current_interactive_node.name)
					"campfire":
						get_parent().user_interface.toggle_campfire(current_interactive_node.name)
					"brewing table":
						get_parent().user_interface.toggle_brewing_table(current_interactive_node.name, current_interactive_node.object_level)
					"chair":
						sit("chair",current_interactive_node.object_position,current_interactive_node.object_direction)
					"armchair":
						sit("armchair",current_interactive_node.object_position,current_interactive_node.object_direction)
					"door":
						Server.world.get_node("PlaceableObjects/"+current_interactive_node.name).interactives.toggle_door()
					"gate":
						Server.world.get_node("PlaceableObjects/"+current_interactive_node.name).interactives.toggle_gate()
					"lamp":
						Server.world.get_node("PlaceableObjects/"+current_interactive_node.name).interactives.toggle_lamp()
					"fireplace":
						Server.world.get_node("PlaceableObjects/"+current_interactive_node.name).interactives.toggle_fireplace()
			current_interactive_node = null
	elif Server.player_node.state == SITTING and event.is_action_pressed("action"):
		stand_up()



func teleport(portal_position):
	var adjusted_pos = get_parent().input_vector*40
	if adjusted_pos == Vector2.ZERO:
		adjusted_pos = Vector2(0,40)
	if get_node("../Magic").portal_1_position == portal_position and get_node("../Magic").portal_2_position:
		get_parent().position = get_node("../Magic").portal_2_position + adjusted_pos
	elif get_node("../Magic").portal_2_position == portal_position:
		get_parent().position = get_node("../Magic").portal_1_position + adjusted_pos


func eat(item_name):
	if get_parent().state != get_parent().EATING:
		get_node("../Sounds/FootstepsSound").stream_paused = true
		sound_effects.stream = load("res://Assets/Sound/Sound effects/Player/eat.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
		sound_effects.play()
		get_parent().state = get_parent().EATING
		PlayerData.remove_single_object_from_hotbar()
		var eating_paricles = Eating_particles.instantiate()
		eating_paricles.item_name = item_name
		get_parent().add_child(eating_paricles)
		get_parent().composite_sprites.set_player_animation(Server.player_node.character, "eat", null)
		get_parent().animation_player.play("eat")
		await get_parent().animation_player.animation_finished
		get_parent().composite_sprites.get_node("Body").hframes = 4
		get_parent().composite_sprites.get_node("Arms").hframes = 4
		get_parent().composite_sprites.get_node("Pants").hframes = 4
		get_parent().composite_sprites.get_node("Shoes").hframes = 4
		get_parent().composite_sprites.get_node("Shirts").hframes = 4
		get_parent().composite_sprites.get_node("HeadAtr").hframes = 4
		get_parent().state = get_parent().MOVEMENT


func harvest_crop(crop_node):
	if get_parent().state != HARVESTING:
		get_node("../Sounds/FootstepsSound").stream_paused = true
		crop_node.harvest()
		get_parent().state = HARVESTING
		PlayerData.player_data["skill_experience"]["farming"] += 1
		Sounds.play_harvest_sound()
		var anim = "harvest_" + get_parent().direction.to_lower()
		get_parent().holding_item.texture = load("res://Assets/Images/inventory_icons/Crop/" + crop_node.crop_name + ".png")
		get_parent().composite_sprites.set_player_animation(Server.player_node.character, anim)
		get_parent().animation_player.play(anim)
		await get_parent().animation_player.animation_finished
		get_parent().state = get_parent().MOVEMENT


func harvest_forage(forage_node):
	if get_parent().state != HARVESTING:
		get_node("../Sounds/FootstepsSound").stream_paused = true
		forage_node.hide()
		get_parent().state = HARVESTING
		if forage_node.first_placement:
			PlayerData.player_data["collections"]["forage"][forage_node.item_name] += 1
			PlayerData.player_data["skill_experience"]["foraging"] += 1
		if forage_node.item_name != "raw egg":
			Tiles.add_valid_tiles(forage_node.location)
			MapData.remove_object("forage",forage_node.name)
		Sounds.play_harvest_sound()
		get_parent().state = get_parent().HARVESTING
		var anim = "harvest_" + get_parent().direction.to_lower()
		get_parent().holding_item.texture =load("res://Assets/Images/inventory_icons/Forage/"+forage_node.item_name+".png")
		get_parent().composite_sprites.set_player_animation(Server.player_node.character, anim)
		get_parent().animation_player.play(anim)
		await get_parent().animation_player.animation_finished
		if PlayerDataHelpers.can_item_be_added_to_inventory(forage_node.item_name, 1):
			Server.player_node.user_interface.get_node("ItemPickUpDialogue").item_picked_up(forage_node.item_name, 1)
			PlayerData.pick_up_item(forage_node.item_name, 1, null)
		else:
			Server.player_node.user_interface.get_node("ItemPickUpDialogue").item_picked_up("Inventory full!", 1)
			InstancedScenes.initiateInventoryItemDrop([forage_node.item_name, 1, null], forage_node.position)
		forage_node.call_deferred("queue_free")
		get_parent().state = get_parent().MOVEMENT


func sit(chair_name,chair_position,chair_direction):
	get_node("../Sounds/FootstepsSound").stream_paused = true
	direction_of_current_chair = chair_direction
	sitting = true
	get_parent().state = get_parent().SITTING
	get_parent().position = return_adjusted_chair_position(chair_name,chair_position,chair_direction)
	get_parent().composite_sprites.set_player_animation(Server.player_node.character, "sit_"+chair_direction, null)
	get_parent().animation_player.play("sit_"+chair_direction)
	await get_parent().animation_player.animation_finished
	await get_tree().process_frame
	get_parent().composite_sprites.set_player_animation(Server.player_node.character, "sit_idle_"+chair_direction, null)
	get_parent().animation_player.play("sit_idle")
	sitting = false


func stand_up():
	if not sitting:
		get_parent().composite_sprites.set_player_animation(Server.player_node.character, "sit_"+direction_of_current_chair, null)
		get_parent().animation_player.play_backwards("sit_"+direction_of_current_chair)
		await get_parent().animation_player.animation_finished
		get_parent().state = get_parent().MOVEMENT

func return_adjusted_chair_position(_chair_name,_pos,_direction):
	match _chair_name:
		"chair":
			match _direction:
				"down":
					return _pos+Vector2i(8,16)
				"up":
					return _pos+Vector2i(8,0)
				"left":
					return _pos+Vector2i(-2,16)
				"right":
					return _pos+Vector2i(18,16)
		"armchair":
			match _direction:
				"down":
					return _pos+Vector2i(16,16)
				"up":
					return _pos+Vector2i(16,-4)
				"left":
					return _pos+Vector2i(16,16)
				"right":
					return _pos+Vector2i(24,16)
#		"couch":
#			match _direction:
#				"down":
#					if Server.player_node.position.x - 32 > position.x:
#						return position+Vector2(64,0)
#					else:
#						return position+Vector2(32,0)
#				"up":
#					return position+Vector2(32,-48)
#				"left":
#					if Server.player_node.position.y + 48 < position.y:
#						return position+Vector2(8,-32)
#					else:
#						return position+Vector2(8,0)
#				"right":
#					return position+Vector2(56,0)


func player_death():
	if get_parent().state != get_parent().DYING:
		sound_effects.stream = load("res://Assets/Sound/Sound effects/Player/death.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
		sound_effects.play()
		get_node("../Magic").invisibility_active = true
		get_parent().state = get_parent().DYING
		get_node("../Sounds/FootstepsSound").stream_paused = true
		get_node("../PoisonParticles").stop_poison_state()
		get_node("../SpeedParticles").stop_speed_buff()
		get_parent().composite_sprites.set_player_animation(Server.player_node.character, "death_" + get_parent().direction.to_lower(), null)
		get_parent().animation_player.play("death")
		get_node("../Camera2D/UserInterface").death()
		get_node("../Area2Ds/PickupZone/CollisionShape2D").set_deferred("disabled", true) 
		if has_node("../Fishing"):
			get_node("../Fishing").queue_free()
		drop_inventory_items()
		await get_parent().animation_player.animation_finished
		respawn()


func drop_inventory_items():
	for item in PlayerData.player_data["hotbar"].keys(): 
		InstancedScenes.initiateInventoryItemDrop(PlayerData.player_data["hotbar"][item], get_parent().position+Vector2(randf_range(-32,32), randf_range(-32,32)))
	for item in PlayerData.player_data["inventory"].keys(): 
		InstancedScenes.initiateInventoryItemDrop(PlayerData.player_data["inventory"][item], get_parent().position+Vector2(randf_range(-32,32), randf_range(-32,32)))
	for item in PlayerData.player_data["combat_hotbar"].keys():
		InstancedScenes.initiateInventoryItemDrop(PlayerData.player_data["combat_hotbar"][item], get_parent().position+Vector2(randf_range(-32,32), randf_range(-32,32)))
	PlayerData.player_data["hotbar"] = {}
	PlayerData.player_data["inventory"] = {}
	PlayerData.player_data["combat_hotbar"] = {}


func respawn():
	PlayerData.reset_player_stats()
	get_parent().position = PlayerData.player_data["respawn_location"]*16
	get_parent().animation_player.stop()
	get_node("../Camera2D/UserInterface").respawn()
	await get_tree().create_timer(0.5).timeout
	get_node("../Area2Ds/PickupZone/CollisionShape2D").set_deferred("disabled", false) 
	get_parent().state = get_parent().MOVEMENT
	get_parent().set_held_object()
	get_node("../Magic").invisibility_active = false


func fish():
	if get_parent().state != get_parent().FISHING:
		get_node("../Sounds/FootstepsSound").stream_paused = true
		PlayerData.change_energy(-1)
		get_parent().state = get_parent().FISHING
		var fishing = Fishing.instantiate()
		fishing.fishing_rod_type = PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][0]
		get_parent().call_deferred("add_child", fishing)

func sleep(sleeping_bag_pos):
	if get_parent().state != get_parent().SLEEPING:
		var player_enter_position = Server.player_node.position
		get_node("../Sounds/FootstepsSound").stream_paused = true
		get_parent().z_index = 1
		get_parent().state = get_parent().SLEEPING
		get_parent().position = sleeping_bag_pos + Vector2i(16,8)
		get_parent().animation_player.play("sleep")
		get_parent().composite_sprites.set_player_animation(get_parent().character, "sleep_down")
		get_parent().user_interface.get_node("SleepEffect/AnimationPlayer").play("sleep")
		await get_parent().user_interface.get_node("SleepEffect/AnimationPlayer").animation_finished
		sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/save/save-game.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects.play()
		PlayerData.player_data["current_save_location"] = player_enter_position/16
		PlayerData.player_data["current_save_scene"] = "res://World/Overworld/Overworld.tscn"
		PlayerData.player_data["respawn_scene"] = "res://World/Overworld/Overworld.tscn"
		PlayerData.player_data["respawn_location"] = player_enter_position/16
		await get_tree().process_frame
		game_state = GameState.new()
		game_state.world_state = MapData.world
		game_state.cave_state = MapData.caves
		game_state.player_state = PlayerData.player_data
		game_state.save_state()
		get_parent().position = player_enter_position
		get_parent().z_index = 0
		get_parent().composite_sprites.rotation_degrees = 0
		get_parent().state = get_parent().MOVEMENT


func move_placeable_object(data):
	var placeObject = PlaceObjectScene.instantiate()
	placeObject.name = "MoveObject"
	placeObject.previous_moving_object_data = data
	placeObject.item_name = data["n"]
	placeObject.moving_object = true
	placeObject.position = (get_global_mouse_position() + Vector2(-16, -16)).snapped(Vector2(16,16))
	get_node("../").add_child(placeObject)

func show_placeable_object(item_name, item_category):
	if Server.world.name == "Overworld":
		if not has_node("../PlaceObject"): # does not exist yet, add to scene tree
			var placeObject = PlaceObjectScene.instantiate()
			placeObject.name = "PlaceObject"
			placeObject.item_name = item_name
			placeObject.moving_object = false
			placeObject.position = (get_global_mouse_position() + Vector2(-16, -16)).snapped(Vector2(16,16))
			get_node("../").add_child(placeObject)
		else:
			if get_node("../PlaceObject").item_name != item_name and not has_node("../MoveObject"): # exists but item changed
				get_node("../PlaceObject").item_name = item_name
				get_node("../PlaceObject").item_category = item_category
				get_node("../PlaceObject").initialize()
#	else:
#		if item_name == "campfire" or item_name == "torch":
#			if not has_node("../PlaceObject"): # does not exist yet, add to scene tree
#				var placeObject = PlaceObjectScene.instantiate()
#				placeObject.name = "PlaceObject"
#				placeObject.moving_object = false
#				placeObject.position = (get_global_mouse_position() + Vector2(-16, -16)).snapped(Vector2(16,16))
#				get_node("../").add_child(placeObject)
#			else:
#				if get_node("../PlaceObject").item_name != item_name: # exists but item changed
#					get_node("../PlaceObject").item_name = item_name
#					get_node("../PlaceObject").item_category = item_category
#					get_node("../PlaceObject").initialize()
#	else:
#		destroy_placeable_object()

#func destroy_movable_object():
#	if has_node("../PlaceObject"):
#		get_node("../Camera2D/UserInterface/ChangeRotation").hide()
#		get_node("../Camera2D/UserInterface/ChangeVariety").hide()
#		get_node("../PlaceObject").destroy()

func destroy_moveable_object():
	if has_node("../MoveObject"):
		get_node("../Camera2D/UserInterface/ChangeRotation").hide()
		get_node("../Camera2D/UserInterface/ChangeVariety").hide()
		get_node("../MoveObject").destroy_and_remove_previous_object()

func destroy_placeable_object():
	if has_node("../PlaceObject"):
		get_node("../Camera2D/UserInterface/ChangeRotation").hide()
		get_node("../Camera2D/UserInterface/ChangeVariety").hide()
		get_node("../PlaceObject").destroy()
	elif has_node("../MoveObject"):
		get_node("../Camera2D/UserInterface/ChangeRotation").hide()
		get_node("../Camera2D/UserInterface/ChangeVariety").hide()
		get_node("../MoveObject").destroy()

