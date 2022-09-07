extends YSort

var directions = ["down", "left", "up", "right"]
var vertical: bool = true
var direction_index: int = 0
var path_index: int = 1
var rotation_delay: bool = false
var mousePos := Vector2.ZERO 

var item_name
var item_category
var state

enum {
	TENT, 
	SLEEPING_BAG,
	ITEM,
	PATH,
	SEED,
	WALL,
	DOOR
}

func _ready():
	initialize()

func _process(delta):
	mousePos = (get_global_mouse_position() + Vector2(-16, -16)).snapped(Vector2(32,32))
	set_global_position(mousePos)
	match state:
		TENT:
			place_tent_state()
		SLEEPING_BAG:
			place_sleeping_bag_state()
		ITEM:
			place_item_state()
		PATH:
			place_path_state()
		SEED:
			place_seed_state()
		WALL:
			place_buildings_state()
		DOOR:
			place_double_door_state()


func initialize():
	if item_name == "tent":
		state = TENT
	elif item_name == "sleeping bag":
		state = SLEEPING_BAG
	elif item_category == "Placable object":
		state = ITEM
	elif item_category == "Placable path":
		state = PATH
	elif item_category == "Seed":
		state = SEED
	elif item_category == "BUILDING" and item_name == "wall":
		state = WALL
	elif item_category == "BUILDING" and item_name == "double door":
		state = DOOR
	set_dimensions()
	
func set_dimensions():
	$ItemToPlace.hide()
	$ScaledItemToPlace.hide()
	match state:
		TENT:
			$RotateIcon.visible = true
			$ItemToPlace.visible = true
			$ItemToPlace.rect_scale = Vector2(1, 1)
		SLEEPING_BAG:
			$RotateIcon.visible = true
			$ColorIndicator.tile_size = Vector2(2, 1)
			$ScaledItemToPlace.visible = true
			$ScaledItemToPlace.texture = load("res://Assets/Images/placable_object_preview/sleeping bag.png")
			$ScaledItemToPlace.rect_scale = Vector2(0.5, 0.5)
			$ScaledItemToPlace.rect_size = Vector2(128, 64)
			$ScaledItemToPlace.rect_position = Vector2(0,0)
		ITEM:
			$ItemToPlace.visible = true
			$ItemToPlace.texture = load("res://Assets/Images/placable_object_preview/" + item_name + ".png")
			if item_name == "house":
				$ColorIndicator.tile_size = Vector2(8, 4)
				$ItemToPlace.rect_position = Vector2(-3, -301)
				$ItemToPlace.rect_scale = Vector2(0.9, 0.9)
			elif item_name == "wood chest" or item_name == "stone chest" or item_name == "workbench" or item_name == "grain mill" or item_name == "stove":
				$ColorIndicator.tile_size = Vector2(2, 1)
			else:
				$ColorIndicator.tile_size = Vector2(1, 1)
		PATH:
			$ItemToPlace.visible = true
			$RotateIcon.visible = true
			$ItemToPlace.rect_position = Vector2(0,0)
			$ItemToPlace.rect_scale = Vector2(1, 1)
			$ColorIndicator.tile_size  = Vector2(1.0 , 1.0)
		SEED:
			$ItemToPlace.visible = true
			$ItemToPlace.texture = load("res://Assets/Images/crop_sets/" + item_name + "/seeds.png")
			$ColorIndicator.tile_size =  Vector2(1, 1)
			$ItemToPlace.rect_position = Vector2(0,0)
			$ItemToPlace.rect_scale = Vector2(1, 1)
		WALL:
			$ItemToPlace.visible = true
			$ItemToPlace.texture = load("res://Assets/Images/placable_object_preview/" + "stone wall" + ".png")
			$ColorIndicator.tile_size =  Vector2(1, 1)
			$ItemToPlace.rect_scale = Vector2(1, 1)
		DOOR:
			$ItemToPlace.visible = true
			$ItemToPlace.rect_scale = Vector2(1, 1)


#func sendAction(action,data): 
#	match action:
#		(MOVEMENT):
#			Server.action("MOVEMENT",data)
#		(SWING):
#			Server.action("SWING", data)
#		(PLACE_ITEM):
#			Server.action("PLACE_ITEM", data)


func place_door_state():
	$RotateIcon.visible = true
	$ColorIndicator.visible = true
	$ColorIndicator.scale = Vector2(1, 1)
	$ItemToPlace.visible = true
	$ItemToPlace.rect_scale = Vector2(1, 1)
	get_rotation_index()
	var direction = directions[direction_index]
	var location = Tiles.valid_tiles.world_to_map(mousePos)
	if direction == "up" or direction == "down":
		$ItemToPlace.rect_position = Vector2(0,-32)
		$ItemToPlace.texture = load("res://Assets/Images/Animations/door/door/front/wood/1.png")
	else:
		$ItemToPlace.rect_position = Vector2(0,0)
		$ItemToPlace.texture = load("res://Assets/Images/Animations/door/door/side/stone/1.png")
	if (direction == "up" or direction == "down")  and not Tiles.validate_tiles(location, Vector2(1,1)):
		$ColorIndicator.indicator_color = "Red"
	elif (direction == "left" or direction == "right") and not Tiles.validate_tiles(location, Vector2(1,1)):
		$ColorIndicator.indicator_color = "Red"
	else:
		$ColorIndicator.indicator_color = "Green"
		if Input.is_action_pressed("mouse_click"):
			if direction == "up" or direction == "down":
				place_object("door", location, "placable")
			else:
				place_object("door side", location, "placable")


func place_double_door_state():
	$RotateIcon.visible = true
	$ColorIndicator.visible = true
	$ItemToPlace.visible = true
	$ItemToPlace.rect_scale = Vector2(1, 1)
	get_rotation_index()
	var direction = directions[direction_index]
	var location = Tiles.valid_tiles.world_to_map(mousePos)
	if direction == "up" or direction == "down":
		$ColorIndicator.tile_size = Vector2(2, 1)
		$ItemToPlace.texture = load("res://Assets/Images/placable_object_preview/stone door front.png")
	else:
		$ColorIndicator.tile_size = Vector2(1, 2)
		$ItemToPlace.texture = load("res://Assets/Images/placable_object_preview/stone door side.png")
	if (direction == "up" or direction == "down")  and not Tiles.validate_tiles(location, Vector2(2,1)):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	elif (direction == "left" or direction == "right") and not Tiles.validate_tiles(location, Vector2(1,2)):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	else:
		$ColorIndicator.indicator_color = "Green"
		$ColorIndicator.set_indicator_color()
		if Input.is_action_pressed("mouse_click"):
			if direction == "up" or direction == "down":
				place_object("door front", location, "placable")
			else:
				place_object("door side", location, "placable")


func place_buildings_state():
	$ColorIndicator.visible = true
	$ColorIndicator.tile_size = Vector2(1, 1)
	var location = Tiles.valid_tiles.world_to_map(mousePos)
	if not Tiles.validate_tiles(location, Vector2(1,1)) or not Tiles.return_if_valid_wall_cell(location, Tiles.building_tiles):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	else:
		$ColorIndicator.indicator_color = "Green"
		$ColorIndicator.set_indicator_color()
		if Input.is_action_pressed("mouse_click"):
			place_object(item_name, location, "placable")

func place_sleeping_bag_state():
	get_rotation_index()
	var direction = directions[direction_index]
	var location = Tiles.valid_tiles.world_to_map(mousePos)
	if direction == "up":
		$ColorIndicator.tile_size = Vector2(1, 2)
		$ScaledItemToPlace.rect_position = Vector2(32,-32)
		$ScaledItemToPlace.rect_rotation = 90
		$ScaledItemToPlace.flip_v = false
	elif direction == "down":
		$ColorIndicator.tile_size = Vector2(1, 2)
		$ScaledItemToPlace.rect_position = Vector2(0,32)
		$ScaledItemToPlace.rect_rotation = 270
		$ScaledItemToPlace.flip_v = false
	elif direction == "left":
		$ColorIndicator.tile_size = Vector2(2, 1)
		$ScaledItemToPlace.rect_position = Vector2(64,32)
		$ScaledItemToPlace.rect_rotation = 180
		$ScaledItemToPlace.flip_v = true
	elif direction == "right":
		$ColorIndicator.tile_size = Vector2(2, 1)
		$ScaledItemToPlace.rect_position = Vector2(0,0)
		$ScaledItemToPlace.rect_rotation = 0
		$ScaledItemToPlace.flip_v = false
	if Server.player_node.position.distance_to(mousePos) > 120:
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	elif (direction == "up" or direction == "down") and not Tiles.validate_tiles(location, Vector2(1,2)):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	elif (direction == "left" or direction == "right") and not Tiles.validate_tiles(location, Vector2(2,1)):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	else:
		$ColorIndicator.indicator_color = "Green"
		$ColorIndicator.set_indicator_color()
		if Input.is_action_pressed("mouse_click"):
			place_object("sleeping bag " + direction, location, "placable")


func place_tent_state():
	get_rotation_index()
	var direction = directions[direction_index]
	$ItemToPlace.texture = load("res://Assets/Images/placable_object_preview/tent " + direction + ".png")
	if direction == "up" or direction == "down":
		$ColorIndicator.tile_size = Vector2(4, 4)
		$ItemToPlace.rect_position = Vector2(0,-160)
	else:
		$ColorIndicator.tile_size = Vector2(6, 3)
		$ItemToPlace.rect_position = Vector2(0,-64)
	var location = Tiles.valid_tiles.world_to_map(mousePos)
	if Server.player_node.position.distance_to(mousePos) > 120:
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	elif (direction == "up" or direction == "down") and not Tiles.validate_tiles(location, Vector2(4,4)):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	elif (direction == "left" or direction == "right") and not Tiles.validate_tiles(location, Vector2(6,3)):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	else:
		$ColorIndicator.indicator_color = "Green"
		$ColorIndicator.set_indicator_color()
		if Input.is_action_pressed("mouse_click"):
			place_object("tent " + direction, location, "placable")
	
func get_rotation_index():
	if direction_index == null:
		direction_index = 0
	if Input.is_action_pressed("rotate") and not rotation_delay:
		rotation_delay = true
		direction_index += 1
		if direction_index == 4:
			direction_index = 0
		yield(get_tree().create_timer(0.25), "timeout")
		rotation_delay = false


func place_item_state():
	var location = Tiles.valid_tiles.world_to_map(mousePos)
	if Tiles.valid_tiles.get_cellv(location) != 0 or Server.player_node.position.distance_to(mousePos) > 120:
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	elif (item_name == "wood chest" or item_name == "stone chest" or item_name == "workbench" or item_name == "grain mill" or item_name == "stove") and Tiles.valid_tiles.get_cellv(location + Vector2(1,0)) != 0:
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	elif item_name == "house" and not Tiles.validate_tiles(location, Vector2(8,4)):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	else:
		$ColorIndicator.indicator_color = "Green"
		$ColorIndicator.set_indicator_color()
		if Input.is_action_pressed("mouse_click"):
			place_object(item_name, location, "placable")


func place_path_state():
	get_path_rotation(item_name)
	var location = Tiles.valid_tiles.world_to_map(mousePos)
	if Tiles.path_tiles.get_cellv(location) != -1 or Tiles.valid_tiles.get_cellv(location) != 0 or Server.player_node.position.distance_to(mousePos) > 120:
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	else:
		$ColorIndicator.indicator_color = "Green"
		$ColorIndicator.set_indicator_color()
		if Input.is_action_pressed("mouse_click"):
			place_object(item_name + str(path_index), location, "placable")


func get_path_rotation(path_name):
	if path_name == "wood path" and path_index > 2:
		path_index = 1
	$ItemToPlace.texture = load("res://Assets/Images/placable_object_preview/" + path_name + str(path_index) + ".png")
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


func place_seed_state():
	var location = Tiles.valid_tiles.world_to_map(mousePos)
	if Tiles.hoed_tiles.get_cellv(location) == -1 or Tiles.valid_tiles.get_cellv(location) != 0 or Server.player_node.position.distance_to(mousePos) > 120:
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	else:	
		$ColorIndicator.indicator_color = "Green"
		$ColorIndicator.set_indicator_color()
		if Input.is_action_pressed("mouse_click"):
			place_object(item_name, location, "seed")	


func place_object(item_name, location, type):
	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
		if item_name != "wall" and item_name != "door front" and item_name != "door side":
			PlayerInventory.remove_single_object_from_hotbar()
		var id = Uuid.v4()
		if type == "placable":
	#		var data = {"id": id, "name": item_name, "l": location, "item": type}
	#		sendAction(PLACE_ITEM, data)
			$SoundEffects.stream = Sounds.place_object
			$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
			$SoundEffects.play()
			if item_name == "wall" or item_name == "door front" or item_name == "door side":
				PlaceObject.place_building_object_in_world(id, item_name, location)
			else:
				PlaceObject.place_object_in_world(id, item_name, location)
		elif type == "seed":
	#		var tile_id = get_node("/root/World").tile_ids["" + str(location.x) + "" + str(location.y)]
	#		var data = {"id": id, "name": item_name, "l": location, "item": type, "d": JsonData.crop_data[item_name]["DaysToGrow"], "g": tile_id}
	#		sendAction(PLACE_ITEM, data)
			$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/place seed 3.mp3")
			$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
			$SoundEffects.play()
			PlaceObject.place_seed_in_world(id, item_name, location, JsonData.crop_data[item_name]["DaysToGrow"])
	if not PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
		Server.player_node.destroy_placable_object()
