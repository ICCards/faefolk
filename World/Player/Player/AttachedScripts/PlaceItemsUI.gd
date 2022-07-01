extends Node2D

var path_index = 1
enum {
	MOVEMENT, 
	SWING,
	PLACE_ITEM,
	CHANGE_TILE
}

func set_invisible():
	$ColorIndicator.visible = false
	$ItemToPlace.visible = false
	$RotateIcon.visible = false
	
func sendAction(action,data): 
	match action:
		(MOVEMENT):
			Server.action("MOVEMENT",data)
		(SWING):
			Server.action("SWING", data)
		(PLACE_ITEM):
			Server.action("PLACE_ITEM", data)


func place_item_state(event, item_name, valid_tiles):
	$ColorIndicator.visible = true
	$ItemToPlace.visible = true
	$ItemToPlace.texture = load("res://Assets/Images/placable_object_preview/" + item_name + ".png")
	var mousePos = (get_global_mouse_position() + Vector2(-16, -16)).snapped(Vector2(32,32))
	set_global_position(mousePos)
	var location = valid_tiles.world_to_map(mousePos)
	if item_name == "house":
		$ColorIndicator.scale = Vector2(8, 4)
		$ItemToPlace.rect_position = Vector2(-3, -301)
		$ItemToPlace.rect_scale = Vector2(0.9, 0.9)
	elif item_name == "wood chest" or item_name == "stone chest":
		$ColorIndicator.scale = Vector2(2, 1)
		$ItemToPlace.rect_position = Vector2(0,-32)
		$ItemToPlace.rect_scale = Vector2(1, 1)
	elif item_name == "campfire": 
		$ItemToPlace.rect_scale = Vector2(1.4, 1.4)
		$ColorIndicator.scale = Vector2(1, 1)
		$ItemToPlace.rect_position = Vector2(-8,-40)
	else:
		$ColorIndicator.scale = Vector2(1, 1)
		$ItemToPlace.rect_position = Vector2(0,-32)
		$ItemToPlace.rect_scale = Vector2(1, 1)
		
	if valid_tiles.get_cellv(location) == -1 or get_parent().position.distance_to(mousePos) > 120:
		$ColorIndicator.texture = preload("res://Assets/Images/Misc/red_square.png")
	elif (item_name == "wood chest" or item_name == "stone chest") and valid_tiles.get_cellv(location + Vector2(1,0)) == -1:
		$ColorIndicator.texture = preload("res://Assets/Images/Misc/red_square.png")
	elif item_name == "house" and not Util.validate_house_tiles(location, valid_tiles):
		$ColorIndicator.texture = preload("res://Assets/Images/Misc/red_square.png")
	else:
		$ColorIndicator.texture = preload("res://Assets/Images/Misc/green_square.png")
		if event.is_action_pressed("mouse_click"):
			place_object(item_name, location, "placable")
			
func place_path_state(event, item_name, valid_object_tiles, path_tiles):
	get_path_rotation(item_name)
	$ColorIndicator.visible = true
	$ItemToPlace.visible = true
	$RotateIcon.visible = true
	$ItemToPlace.rect_position = Vector2(0,0)
	$ItemToPlace.rect_scale = Vector2(1, 1)
	$ColorIndicator.scale  = Vector2(1.0 , 1.0)
	var mousePos = (get_global_mouse_position() + Vector2(-16, -16)).snapped(Vector2(32,32))
	set_global_position(mousePos)
	var location = valid_object_tiles.world_to_map(mousePos)
	if path_tiles.get_cellv(location) != -1 or valid_object_tiles.get_cellv(location) == -1 or get_parent().position.distance_to(mousePos) > 120:
		$ColorIndicator.texture = preload("res://Assets/Images/Misc/red_square.png")
	else:
		$ColorIndicator.texture = preload("res://Assets/Images/Misc/green_square.png")
		if event.is_action_pressed("mouse_click"):
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
			
func place_seed_state(event, item_name, valid_object_tiles, hoed_tiles):
	item_name.erase(item_name.length() - 6, 6)
	$ColorIndicator.visible = true
	$ItemToPlace.visible = true
	$ItemToPlace.texture = load("res://Assets/Images/crop_sets/" + item_name + "/seeds.png")
	$ColorIndicator.scale =  Vector2(1, 1)
	$ItemToPlace.rect_position = Vector2(0,0)
	$ItemToPlace.rect_scale = Vector2(1, 1)
	var mousePos = (get_global_mouse_position() + Vector2(-16, -16)).snapped(Vector2(32,32))
	set_global_position(mousePos)
	var location = valid_object_tiles.world_to_map(mousePos)
	if hoed_tiles.get_cellv(location) == -1 or valid_object_tiles.get_cellv(location) == -1 or get_parent().position.distance_to(mousePos) > 120:
		$ColorIndicator.texture = preload("res://Assets/Images/Misc/red_square.png")
	else:	
		$ColorIndicator.texture = preload("res://Assets/Images/Misc/green_square.png")
		if event.is_action_pressed("mouse_click"):
			place_object(item_name, location, "seed")	
			
func place_object(item_name, location, type):
	PlayerInventory.remove_single_object_from_hotbar()
	var id = Uuid.v4()
	if type == "placable":
		var data = {"id": id, "name": item_name, "l": location, "item": type}
		sendAction(PLACE_ITEM, data)
		$SoundEffects.stream = Sounds.place_object
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
		$SoundEffects.play()
		PlaceObject.place_object_in_world(id, item_name, location)
	elif type == "seed":
		var tile_id = get_node("/root/World").tile_ids["" + str(location.x) + "" + str(location.y)]
		var data = {"id": id, "name": item_name, "l": location, "item": type, "d": JsonData.crop_data[item_name]["DaysToGrow"], "g": tile_id}
		sendAction(PLACE_ITEM, data)
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/place seed 3.mp3")
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
		$SoundEffects.play()
		PlaceObject.place_seed_in_world(id, item_name, location, JsonData.crop_data[item_name]["DaysToGrow"])



