extends YSort

var directions = ["down", "left", "up", "right"]
var couch_varieties = [1, 2, 3, 4]
var table_varieties = [1, 2, 3, 4]
var chair_varieties = [1, 2, 3, 4, 5, 6]
var rug_varieties = [1, 2, 3, 4, 5, 6, 7, 8]
var bed_varieties = [1, 2, 3, 4, 5, 6, 7, 8]
var vertical: bool = true
var direction_index: int = 0
var varieties_index: int = 0
var rotation_delay: bool = false
var variety_delay: bool = false
var mousePos := Vector2.ZERO 

var item_name
var item_category
var state
var variety

enum {
	TENT, 
	SLEEPING_BAG,
	ITEM,
	PATH,
	SEED,
	WALL,
	DOOR,
	FOUNDATION,
	ROTATABLE,
	CUSTOMIZABLE,
	CUSTOMIZABLE_ROTATABLE,
	GATE,
	FORAGE
}

var _uuid = load("res://helpers/UUID.gd")
onready var uuid = _uuid.new()

func _ready():
	initialize()


func destroy():
	name = "removing"
	hide()
	set_physics_process(false)
	yield(get_tree().create_timer(0.25), "timeout")
	queue_free()


func _physics_process(delta):
	mousePos = (get_global_mouse_position() + Vector2(-16, -16)).snapped(Vector2(32,32))
	set_global_position(mousePos)
	match state:
		SLEEPING_BAG:
			place_sleeping_bag_state()
		ITEM:
			place_item_state()
		SEED:
			place_seed_state()
		WALL:
			place_buildings_state()
		DOOR:
			place_door_state()
		FOUNDATION:
			place_foundation_state()
		ROTATABLE:
			place_rotatable_state()
		CUSTOMIZABLE_ROTATABLE:
			place_customizable_rotatable_state()
		CUSTOMIZABLE:
			place_customizable_state()
		GATE:
			place_gate_state()
		FORAGE:
			place_forage_state()


func initialize():
	mousePos = (get_global_mouse_position() + Vector2(-16, -16)).snapped(Vector2(32,32))
	set_global_position(mousePos)
	if item_name == "sleeping bag":
		state = SLEEPING_BAG
	elif item_name == "wood gate":
		state = GATE
	elif item_name == "furnace" or item_name == "tool cabinet" or item_name == "stone chest" or item_name == "wood chest" or \
	item_name == "workbench #1" or item_name == "workbench #2" or item_name == "workbench #3" or item_name == "stove #1" or item_name == "stove #2" or item_name == "stove #3" or\
	item_name == "grain mill #1" or item_name == "grain mill #2" or item_name == "grain mill #3" or item_name == "dresser" or item_name == "brewing table #1" or item_name == "brewing table #2" or item_name == "brewing table #3":
		state = ROTATABLE
	elif item_name == "wood door" or item_name == "metal door" or item_name == "armored door":
		state = DOOR
	elif item_name == "couch" or item_name == "chair" or item_name == "armchair" or item_name == "table":
		state = CUSTOMIZABLE_ROTATABLE
	elif item_name == "large rug" or item_name == "medium rug" or item_name == "small rug" or item_name == "bed" or item_name == "round table":
		state = CUSTOMIZABLE
	elif item_category == "Placable object":
		state = ITEM
	elif item_category == "Placable path":
		state = PATH
	elif item_category == "Seed":
		state = SEED
	elif item_category == "BUILDING" and item_name == "wall":
		state = WALL
	elif item_category == "BUILDING" and item_name == "foundation":
		state = FOUNDATION
	elif item_category == "Forage":
		state = FORAGE
	set_dimensions()


func set_dimensions():
	$ItemToPlace.hide()
	$ScaledItemToPlace.hide()
	$TreeSeedToPlace.hide()
	$GateToPlace.hide()
	$ForageItemToPlace.hide()
	match state:
		SLEEPING_BAG:
			Server.player_node.user_interface.get_node("ChangeRotation").hide()
			Server.player_node.user_interface.get_node("ChangeVariety").hide()
			$ColorIndicator.tile_size = Vector2(2, 1)
			$ScaledItemToPlace.visible = true
			$ScaledItemToPlace.texture = load("res://Assets/Images/placable_object_preview/sleeping bag.png")
			$ScaledItemToPlace.rect_scale = Vector2(0.5, 0.5)
			$ScaledItemToPlace.rect_size = Vector2(128, 64)
			$ScaledItemToPlace.rect_position = Vector2(0,0)
		ITEM:
			Server.player_node.user_interface.get_node("ChangeRotation").hide()
			Server.player_node.user_interface.get_node("ChangeVariety").hide()
			$ItemToPlace.show()
			$ItemToPlace.texture = load("res://Assets/Images/placable_object_preview/" + item_name + ".png")
			var dimensions = Constants.dimensions_dict[item_name]
			$ColorIndicator.tile_size = dimensions
		SEED:
			Server.player_node.user_interface.get_node("ChangeRotation").hide()
			Server.player_node.user_interface.get_node("ChangeVariety").hide()
			if Util.isFruitTree(item_name) or Util.isNonFruitTree(item_name):
				$TreeSeedToPlace.texture = load("res://Assets/Images/tree_sets/" + item_name + "/growing/sapling.png")
				$ColorIndicator.tile_size =  Vector2(2,2)
				$TreeSeedToPlace.show()
			else:
				$ItemToPlace.show()
				$ItemToPlace.texture = load("res://Assets/Images/crop_sets/" + item_name + "/seeds.png")
				$ColorIndicator.tile_size =  Vector2(1,1)
		WALL:
			Server.player_node.user_interface.get_node("ChangeRotation").hide()
			Server.player_node.user_interface.get_node("ChangeVariety").hide()
			$ItemToPlace.show()
			$ItemToPlace.texture = load("res://Assets/Images/placable_object_preview/wall.png")
			$ColorIndicator.tile_size =  Vector2(1,1)
		DOOR:
			Server.player_node.user_interface.get_node("ChangeRotation").show()
			Server.player_node.user_interface.get_node("ChangeVariety").hide()
			$ItemToPlace.show()
		FOUNDATION:
			Server.player_node.user_interface.get_node("ChangeRotation").hide()
			Server.player_node.user_interface.get_node("ChangeVariety").hide()
			$ItemToPlace.show()
			$ItemToPlace.texture = load("res://Assets/Images/placable_object_preview/foundation.png")
			$ColorIndicator.tile_size = Vector2(1,1)
		ROTATABLE:
			Server.player_node.user_interface.get_node("ChangeRotation").show()
			Server.player_node.user_interface.get_node("ChangeVariety").hide()
			$ItemToPlace.show()
		CUSTOMIZABLE_ROTATABLE:
			Server.player_node.user_interface.get_node("ChangeRotation").show()
			Server.player_node.user_interface.get_node("ChangeVariety").show()
			$ItemToPlace.show()
		CUSTOMIZABLE:
			Server.player_node.user_interface.get_node("ChangeRotation").hide()
			Server.player_node.user_interface.get_node("ChangeVariety").show()
			$ItemToPlace.show()
		GATE:
			Server.player_node.user_interface.get_node("ChangeRotation").hide()
			Server.player_node.user_interface.get_node("ChangeVariety").hide()
			$GateToPlace.show()
		FORAGE:
			Server.player_node.user_interface.get_node("ChangeRotation").hide()
			Server.player_node.user_interface.get_node("ChangeVariety").hide()
			$ForageItemToPlace.show()
			$ForageItemToPlace.texture = load("res://Assets/Images/inventory_icons/Forage/"+item_name+".png")





func place_forage_state():
	var location = Tiles.valid_tiles.world_to_map(mousePos)
	var dimensions = Vector2(1,1)
	$ColorIndicator.tile_size = dimensions
	if not Tiles.validate_tiles(location, dimensions) or Server.player_node.position.distance_to(mousePos) > Constants.MIN_PLACE_OBJECT_DISTANCE or Tiles.validate_foundation_tiles(location, dimensions):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	else:
		$ColorIndicator.indicator_color = "Green"
		$ColorIndicator.set_indicator_color()
		if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use_tool")):
			place_object(item_name, null, location, "forage")


func place_gate_state():
	var location = Tiles.valid_tiles.world_to_map(mousePos)
	var direction = directions[direction_index]
	var dimensions = Constants.dimensions_dict[item_name]
#	get_rotation_index()
	#$ItemToPlace.texture = load("res://Assets/Images/placable_object_preview/" +  item_name + "/" + direction + ".png")
	if (direction == "up" or direction == "down"):
		$ColorIndicator.tile_size = dimensions
	else:
		$ColorIndicator.tile_size = Vector2(dimensions.y, dimensions.x)
	if Server.player_node.position.distance_to(mousePos) > Constants.MIN_PLACE_OBJECT_DISTANCE:
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	elif (direction == "up" or direction == "down") and (not Tiles.validate_tiles(location, dimensions)):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	elif (direction == "left" or direction == "right") and (not Tiles.validate_tiles(location, Vector2(dimensions.y,dimensions.x))):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	else:
		$ColorIndicator.indicator_color = "Green"
		$ColorIndicator.set_indicator_color()
		if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use_tool")):
			place_object(item_name, directions[direction_index], location, "placable")


func place_customizable_state():
	var location = Tiles.valid_tiles.world_to_map(mousePos)
	var direction = directions[direction_index]
	var dimensions = Constants.dimensions_dict[item_name]
	if item_name == "large rug" or item_name == "medium rug" or item_name == "small rug":
		variety = rug_varieties[varieties_index]
		get_variety_index(rug_varieties.size())
	elif item_name == "bed":
		variety = bed_varieties[varieties_index]
		get_variety_index(bed_varieties.size())
	elif item_name == "round table":
		variety = table_varieties[varieties_index]
		get_variety_index(table_varieties.size())
	$ItemToPlace.texture = load("res://Assets/Images/placable_object_preview/" +  item_name + "/" + str(variety) + ".png")
	$ColorIndicator.tile_size = dimensions
	if Server.player_node.position.distance_to(mousePos) > Constants.MIN_PLACE_OBJECT_DISTANCE:
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	elif not Tiles.validate_tiles(location, dimensions) or not Tiles.validate_foundation_tiles(location, dimensions):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	else:
		$ColorIndicator.indicator_color = "Green"
		$ColorIndicator.set_indicator_color()
		if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use_tool")):
			place_object(item_name+str(variety), null, location, "placable")

func place_customizable_rotatable_state():
	var location = Tiles.valid_tiles.world_to_map(mousePos)
	var direction = directions[direction_index]
	var dimensions = Constants.dimensions_dict[item_name]
	if item_name == "couch" or item_name == "armchair":
		variety = couch_varieties[varieties_index]
		get_variety_index(couch_varieties.size())
	elif item_name == "chair":
		variety = chair_varieties[varieties_index]
		get_variety_index(chair_varieties.size())
	elif item_name == "table":
		variety = table_varieties[varieties_index]
		get_variety_index(table_varieties.size())
	get_rotation_index()
	$ItemToPlace.texture = load("res://Assets/Images/placable_object_preview/" +  item_name + "/" + str(variety) + "/"  + direction + ".png")
	if (direction == "up" or direction == "down"):
		$ColorIndicator.tile_size = dimensions
	else:
		$ColorIndicator.tile_size = Vector2(dimensions.y, dimensions.x)
	if Server.player_node.position.distance_to(mousePos) > Constants.MIN_PLACE_OBJECT_DISTANCE:
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	elif (direction == "up" or direction == "down") and (not Tiles.validate_tiles(location, dimensions) or not Tiles.validate_foundation_tiles(location, dimensions)):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	elif (direction == "left" or direction == "right") and (not Tiles.validate_tiles(location, Vector2(dimensions.y,dimensions.x)) or not Tiles.validate_foundation_tiles(location, Vector2(dimensions.y,dimensions.x))):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	else:
		$ColorIndicator.indicator_color = "Green"
		$ColorIndicator.set_indicator_color()
		if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use_tool")):
			place_object(item_name+str(variety), directions[direction_index], location, "placable")


func get_variety_index(num_varieties):
	if varieties_index == null:
		varieties_index = 0
	if Input.is_action_pressed("change_variety") and not variety_delay:
		variety_delay = true
		varieties_index += 1
		if varieties_index == num_varieties:
			varieties_index = 0
		yield(get_tree().create_timer(0.25), "timeout")
		variety_delay = false


func place_rotatable_state():
	var location = Tiles.valid_tiles.world_to_map(mousePos)
	var direction = directions[direction_index]
	var dimensions = Constants.dimensions_dict[item_name]
	get_rotation_index()
	$ItemToPlace.texture = load("res://Assets/Images/placable_object_preview/" +  item_name + "/" + direction + ".png")
	if (direction == "up" or direction == "down"):
		$ColorIndicator.tile_size = dimensions
	else:
		$ColorIndicator.tile_size = Vector2(dimensions.y, dimensions.x)
	if Server.player_node.position.distance_to(mousePos) > Constants.MIN_PLACE_OBJECT_DISTANCE:
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	elif (direction == "up" or direction == "down") and (not Tiles.validate_tiles(location, dimensions) or not Tiles.validate_foundation_tiles(location, dimensions)):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	elif (direction == "left" or direction == "right") and (not Tiles.validate_tiles(location, Vector2(dimensions.y,dimensions.x)) or not Tiles.validate_foundation_tiles(location, Vector2(dimensions.y,dimensions.x))):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	else:
		$ColorIndicator.indicator_color = "Green"
		$ColorIndicator.set_indicator_color()
		if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use_tool")):
			place_object(item_name, directions[direction_index], location, "placable")


func place_foundation_state():
	if Server.world.name == "World":
		var location = Tiles.valid_tiles.world_to_map(mousePos)
		if Tiles.foundation_tiles.get_cellv(location) != -1 or Server.player_node.position.distance_to(mousePos) > Constants.MIN_PLACE_OBJECT_DISTANCE:
			$ColorIndicator.indicator_color = "Red"
			$ColorIndicator.set_indicator_color()
		elif not Tiles.validate_tiles(location, Vector2(1,1)):
			$ColorIndicator.indicator_color = "Red"
			$ColorIndicator.set_indicator_color()
		else:
			$ColorIndicator.indicator_color = "Green"
			$ColorIndicator.set_indicator_color()
			if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use_tool")):
				place_object(item_name, null, location, "placable")


func place_door_state():
	$ItemToPlace.rect_scale = Vector2(1, 1)
	get_rotation_index()
	var direction = directions[direction_index]
	var location = Tiles.valid_tiles.world_to_map(mousePos)
	if direction == "up" or direction == "down":
		$ColorIndicator.tile_size = Vector2(2, 1)
		$ItemToPlace.texture = load("res://Assets/Images/placable_object_preview/" + item_name + ".png")
	else:
		$ColorIndicator.tile_size = Vector2(1, 2)
		$ItemToPlace.texture = load("res://Assets/Images/placable_object_preview/" + item_name + " side.png")
	if (direction == "up" or direction == "down")  and (not Tiles.validate_tiles(location, Vector2(2,1)) or not Tiles.validate_foundation_tiles(location,Vector2(2,1))):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	elif (direction == "left" or direction == "right") and (not Tiles.validate_tiles(location, Vector2(1,2)) or not Tiles.validate_foundation_tiles(location,Vector2(1,2))):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	elif Server.player_node.position.distance_to(mousePos) > 120:
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	else:
		$ColorIndicator.indicator_color = "Green"
		$ColorIndicator.set_indicator_color()
		if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use_tool")):
			if direction == "up" or direction == "down":
				place_object(item_name, null, location, "placable")
			else:
				place_object(item_name + " side", null, location, "placable")


func place_buildings_state():
	if Server.world.name == "World":
		$ColorIndicator.visible = true
		$ColorIndicator.tile_size = Vector2(1,1)
		var location = Tiles.valid_tiles.world_to_map(mousePos)
		if not Tiles.validate_tiles(location,Vector2(1,1)) or \
		not Tiles.return_if_valid_wall_cell(location, Tiles.wall_tiles) or \
		not Tiles.validate_foundation_tiles(location,Vector2(1,1)) or \
		Server.player_node.position.distance_to(mousePos) > Constants.MIN_PLACE_OBJECT_DISTANCE:
			$ColorIndicator.indicator_color = "Red"
			$ColorIndicator.set_indicator_color()
		else:
			$ColorIndicator.indicator_color = "Green"
			$ColorIndicator.set_indicator_color()
			if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use_tool")):
				place_object(item_name, null, location, "placable")

func place_sleeping_bag_state():
	#get_rotation_index()
	#var direction = directions[direction_index]
	var direction = "down"
	var location = Tiles.valid_tiles.world_to_map(mousePos)
#	if direction == "up":
#		$ColorIndicator.tile_size = Vector2(1, 2)
#		$ScaledItemToPlace.rect_position = Vector2(32,-32)
#		$ScaledItemToPlace.rect_rotation = 90
#		$ScaledItemToPlace.flip_v = false
	if direction == "down":
		$ColorIndicator.tile_size = Vector2(1, 2)
		$ScaledItemToPlace.rect_position = Vector2(0,32)
		$ScaledItemToPlace.rect_rotation = 270
		$ScaledItemToPlace.flip_v = false
#	elif direction == "left":
#		$ColorIndicator.tile_size = Vector2(2, 1)
#		$ScaledItemToPlace.rect_position = Vector2(64,32)
#		$ScaledItemToPlace.rect_rotation = 180
#		$ScaledItemToPlace.flip_v = true
#	elif direction == "right":
#		$ColorIndicator.tile_size = Vector2(2, 1)
#		$ScaledItemToPlace.rect_position = Vector2(0,0)
#		$ScaledItemToPlace.rect_rotation = 0
#		$ScaledItemToPlace.flip_v = false
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
		if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use_tool")):
			place_object("sleeping bag", direction, location, "placable")

	
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
	var dimensions = Constants.dimensions_dict[item_name]
	if not Tiles.validate_tiles(location, dimensions) or Server.player_node.position.distance_to(mousePos) > Constants.MIN_PLACE_OBJECT_DISTANCE:
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	elif (item_name != "campfire" and item_name != "torch" and item_name != "well" and item_name != "wood fence" and item_name != "wood gate"): 
		if not Tiles.validate_foundation_tiles(location, dimensions):
			$ColorIndicator.indicator_color = "Red"
			$ColorIndicator.set_indicator_color()
		else:
			$ColorIndicator.indicator_color = "Green"
			$ColorIndicator.set_indicator_color()
			if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use_tool")):
				place_object(item_name, null, location, "placable")
	else:
		$ColorIndicator.indicator_color = "Green"
		$ColorIndicator.set_indicator_color()
		if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use_tool")):
			place_object(item_name, null, location, "placable")

func place_seed_state():
	if Server.world.name == "World":
		var location = Tiles.valid_tiles.world_to_map(mousePos)
		if Util.isNonFruitTree(item_name) or Util.isFruitTree(item_name):
			if not Tiles.validate_forest_tiles(location) or Server.player_node.position.distance_to(mousePos) > Constants.MIN_PLACE_OBJECT_DISTANCE:
				$ColorIndicator.indicator_color = "Red"
				$ColorIndicator.set_indicator_color()
			else:
				$ColorIndicator.indicator_color = "Green"
				$ColorIndicator.set_indicator_color()
				if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use_tool")):
					place_object(item_name, null, location, "seed")	
		else: # crops
			if Tiles.hoed_tiles.get_cellv(location) == -1 or Tiles.valid_tiles.get_cellv(location) != 0 or Server.player_node.position.distance_to(mousePos) > Constants.MIN_PLACE_OBJECT_DISTANCE:
				$ColorIndicator.indicator_color = "Red"
				$ColorIndicator.set_indicator_color()
			else:
				$ColorIndicator.indicator_color = "Green"
				$ColorIndicator.set_indicator_color()
				if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use_tool")):
					place_object(item_name, null, location, "seed")	
	else:
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()


func place_object(item_name, direction, location, type):
	if PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot)):
		if item_name != "wall" and item_name != "foundation":
			PlayerData.remove_single_object_from_hotbar()
		var id = Uuid.v4()
		if type == "placable":
			if item_name == "wall" or item_name == "foundation":
				if PlayerData.returnSufficentCraftingMaterial("wood", 5) and item_name == "wall":
					$SoundEffects.stream = Sounds.place_object
					$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
					$SoundEffects.play()
					MapData.add_placable(id, {"n":item_name,"v":"twig","l":str(location),"h":Stats.MAX_TWIG_BUILDING})
					PlayerData.remove_material("wood", 5)
					PlaceObject.place_building_object_in_world(id,item_name,"twig",location,Stats.MAX_TWIG_BUILDING)
				elif PlayerData.returnSufficentCraftingMaterial("wood", 2) and item_name == "foundation":
					$SoundEffects.stream = Sounds.place_object
					$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
					$SoundEffects.play()
					MapData.add_placable(id, {"n":item_name,"v":"twig","l":str(location),"h":Stats.MAX_TWIG_BUILDING})
					PlayerData.remove_material("wood", 2)
					PlaceObject.place_building_object_in_world(id,item_name,"twig",location,Stats.MAX_TWIG_BUILDING)
				else:
					$SoundEffects.stream = load("res://Assets/Sound/Sound effects/Farming/ES_Error Tone Chime 6 - SFX Producer.mp3")
					$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -20)
					$SoundEffects.play()
			else:
				$SoundEffects.stream = Sounds.place_object
				$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
				$SoundEffects.play()
				MapData.add_placable(id, {"n":item_name,"d":direction,"l":str(location)})
				PlaceObject.place_object_in_world(id, item_name, direction, location)
		elif type == "seed":
			$SoundEffects.stream = load("res://Assets/Sound/Sound effects/Farming/place seed.mp3")
			$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
			$SoundEffects.play()
			if Util.isNonFruitTree(item_name) or Util.isFruitTree(item_name):
				PlaceObject.place_tree_in_world(id,item_name,location+Vector2(1,0),"forest",Stats.TREE_HEALTH,"sapling")
				MapData.add_tree(id,{"l":str(location),"h":Stats.TREE_HEALTH,"b":"forest","v":item_name,"p":"sapling"})
				MapData.add_object_to_chunk("tree",location,id)
			else:
				var days_to_grow = JsonData.crop_data[item_name]["DaysToGrow"]
				MapData.add_crop(id,{"n":item_name,"l":str(location),"dh":days_to_grow,"dww":0,"rp":false})
				PlaceObject.place_seed_in_world(id, item_name, location, days_to_grow, 0, false)
		elif type == "forage":
			$SoundEffects.stream = load("res://Assets/Sound/Sound effects/Farming/place seed.mp3")
			$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
			$SoundEffects.play()
			MapData.add_forage(id,{"n":item_name,"l":str(location),"f":false})
			MapData.add_object_to_chunk("forage",location,id)
			PlaceObject.place_forage_in_world(id,item_name,location,false)
	if not PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot)):
		Server.player_node.set_held_object()
		Server.player_node.actions.destroy_placable_object()
