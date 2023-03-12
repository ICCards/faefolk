extends Node2D

var directions = ["down", "left", "up", "right"]
var direction_index: int = 0
var rotation_delay: bool = false
var variety_delay: bool = false
var mousePos := Vector2.ZERO 

var item_name
var item_category
var moving_object: bool
var state
var variety = 1

enum {
	ITEM,
	SEED,
	WALL,
	DOOR,
	FOUNDATION,
	ROTATABLE,
	CUSTOMIZABLE,
	CUSTOMIZABLE_ROTATABLE,
	FORAGE
}

var _uuid = load("res://helpers/UUID.gd")
@onready var uuid = _uuid.new()

func _ready():
	initialize()

func destroy():
	name = "removing"
	hide()
	set_physics_process(false)
	await get_tree().create_timer(0.25).timeout
	queue_free()


func _physics_process(delta):
	mousePos = (get_global_mouse_position() + Vector2(-8, -8)).snapped(Vector2(16,16))
	set_global_position(mousePos)
	match state:
		ITEM:
			place_item_state()
		SEED:
			place_seed_state()
		WALL:
			place_wall_state()
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
		FORAGE:
			place_forage_state()


func initialize():
	print(item_name)
	if item_name != "foundation" and item_name != "wall":
		item_category = JsonData.item_data[item_name]["ItemCategory"]
#	if item_name == "wood door" or item_name == "metal door" or item_name == "armored door":
#		state = DOOR
	
	if Constants.rotatable_object_atlas_tiles.keys().has(item_name):
		state = ROTATABLE
	elif Constants.customizable_rotatable_object_atlas_tiles.keys().has(item_name):
		state = CUSTOMIZABLE_ROTATABLE
	elif Constants.customizable_object_atlas_tiles.keys().has(item_name):
		state = CUSTOMIZABLE
	elif Constants.object_atlas_tiles.keys().has(item_name):
		state = ITEM
	elif item_category == "Seed":
		state = SEED
	elif item_name == "wall":
		state = WALL
	elif item_name == "foundation":
		state = FOUNDATION
	elif item_category == "Forage":
		state = FORAGE
	set_dimensions()


func set_dimensions():
	$TreeSeedToPlace.hide()
	$ForageItemToPlace.hide()
	match state:
		ITEM:
			Server.player_node.user_interface.get_node("ChangeRotation").hide()
			Server.player_node.user_interface.get_node("ChangeVariety").hide()
			$TileMap.show()
			$TileMap.set_cell(0,Vector2i(0,0),0,Constants.object_atlas_tiles[item_name])
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
				$ColorIndicator.tile_size =  Vector2(1,1)
		WALL:
			Server.player_node.user_interface.get_node("ChangeRotation").hide()
			Server.player_node.user_interface.get_node("ChangeVariety").hide()
			$TileMap.show()
			$TileMap.set_cell(0,Vector2i(0,0),0,Vector2i(0,88))
			$ColorIndicator.tile_size = Vector2(1,1)
		DOOR:
			Server.player_node.user_interface.get_node("ChangeRotation").show()
			Server.player_node.user_interface.get_node("ChangeVariety").hide()
		FOUNDATION:
			Server.player_node.user_interface.get_node("ChangeRotation").hide()
			Server.player_node.user_interface.get_node("ChangeVariety").hide()
			$TileMap.show()
			$TileMap.set_cell(0,Vector2i(0,0),0,Vector2i(1,90))
			$ColorIndicator.tile_size = Vector2(1,1)
		ROTATABLE:
			Server.player_node.user_interface.get_node("ChangeRotation").show()
			Server.player_node.user_interface.get_node("ChangeVariety").hide()
		CUSTOMIZABLE_ROTATABLE:
			Server.player_node.user_interface.get_node("ChangeRotation").show()
			Server.player_node.user_interface.get_node("ChangeVariety").show()
		CUSTOMIZABLE:
			Server.player_node.user_interface.get_node("ChangeRotation").hide()
			Server.player_node.user_interface.get_node("ChangeVariety").show()
		FORAGE:
			Server.player_node.user_interface.get_node("ChangeRotation").hide()
			Server.player_node.user_interface.get_node("ChangeVariety").hide()
			$ForageItemToPlace.show()
			$ForageItemToPlace.texture = load("res://Assets/Images/inventory_icons/Forage/"+item_name+".png")



func place_forage_state():
	var location = Tiles.valid_tiles.local_to_map(mousePos)
	var dimensions = Vector2(1,1)
	$ColorIndicator.tile_size = dimensions
	if not Tiles.validate_tiles(location, dimensions) or Tiles.validate_foundation_tiles(location, dimensions):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	else:
		$ColorIndicator.indicator_color = "Green"
		$ColorIndicator.set_indicator_color()
		if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use tool")):
			place_object(item_name, null, location, "forage")


func place_customizable_state():
	var location = Tiles.valid_tiles.local_to_map(mousePos)
	var direction = directions[direction_index]
	var dimensions = Constants.dimensions_dict[item_name]
	get_variety_index(Constants.customizable_object_atlas_tiles[item_name].keys().size())
	$TileMap.set_cell(0,Vector2i(0,0),0,Constants.customizable_object_atlas_tiles[item_name][variety])
	$ColorIndicator.tile_size = dimensions
	if not Tiles.validate_tiles(location, dimensions) or not Tiles.validate_foundation_tiles(location, dimensions):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
		return
	else:
		$ColorIndicator.indicator_color = "Green"
		$ColorIndicator.set_indicator_color()
		if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use tool")):
			place_object(item_name, null, location, "placable", variety)

func place_customizable_rotatable_state():
	var location = Tiles.valid_tiles.local_to_map(mousePos)
	var direction = directions[direction_index]
	var dimensions = Constants.dimensions_dict[item_name]
	get_variety_index(Constants.customizable_rotatable_object_atlas_tiles[item_name].keys().size())
	get_rotation_index()
	await get_tree().process_frame
	$TileMap.set_cell(0,Vector2i(0,0),0,Constants.customizable_rotatable_object_atlas_tiles[item_name][variety][direction])
	if (direction == "up" or direction == "down"):
		$ColorIndicator.tile_size = dimensions
	else:
		$ColorIndicator.tile_size = Vector2(dimensions.y, dimensions.x)
	if not Tiles.validate_tiles(location, $ColorIndicator.tile_size) or not Tiles.validate_foundation_tiles(location, $ColorIndicator.tile_size):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
		return
	else:
		$ColorIndicator.indicator_color = "Green"
		$ColorIndicator.set_indicator_color()
		if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use tool")):
			place_object(item_name, directions[direction_index], location, "placable", variety)


func get_variety_index(num_varieties):
	if Input.is_action_pressed("change variety") and not variety_delay:
		variety_delay = true
		variety += 1
		if variety == num_varieties+1:
			variety = 1
		await get_tree().create_timer(0.25).timeout
		variety_delay = false


func place_rotatable_state():
	var location = Tiles.valid_tiles.local_to_map(mousePos)
	var direction = directions[direction_index]
	var dimensions = Constants.dimensions_dict[item_name]
	get_rotation_index()
	$TileMap.show()
	$TileMap.set_cell(0,Vector2i(0,0),0,Constants.rotatable_object_atlas_tiles[item_name][direction])
	if (direction == "up" or direction == "down"):
		$ColorIndicator.tile_size = dimensions
	else:
		$ColorIndicator.tile_size = Vector2(dimensions.y, dimensions.x)
	if not Tiles.validate_tiles(location, $ColorIndicator.tile_size):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
		return
	elif not Util.isObjectPlaceableOnGround(item_name) and not Tiles.validate_foundation_tiles(location, $ColorIndicator.tile_size): 
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
		return
	else:
		$ColorIndicator.indicator_color = "Green"
		$ColorIndicator.set_indicator_color()
		if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use tool")):
			place_object(item_name, directions[direction_index], location, "placable")


func place_door_state():
	$ItemToPlace.scale = Vector2(1, 1)
	get_rotation_index()
	var direction = directions[direction_index]
	var location = Tiles.valid_tiles.local_to_map(mousePos)
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
		if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use tool")):
			if direction == "up" or direction == "down":
				place_object(item_name, null, location, "placable")
			else:
				place_object(item_name + " side", null, location, "placable")


func place_foundation_state():
	if Server.world.name == "Overworld":
		var location = Tiles.valid_tiles.local_to_map(mousePos)
		if not Tiles.validate_tiles(location, Vector2(1,1)) or not Tiles.foundation_tiles.get_cell_atlas_coords(0,location)==Vector2i(-1,-1):
			$ColorIndicator.indicator_color = "Red"
			$ColorIndicator.set_indicator_color()
		else:
			$ColorIndicator.indicator_color = "Green"
			$ColorIndicator.set_indicator_color()
			if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use tool")):
				place_object(item_name, null, location, "placable")


func place_wall_state():
	if Server.world.name == "Overworld":
		$ColorIndicator.visible = true
		var location = Tiles.valid_tiles.local_to_map(mousePos)
		if not Tiles.return_if_valid_wall_cell(location, Tiles.wall_tiles) or not Tiles.validate_foundation_tiles(location,Vector2(1,1)) or not Tiles.validate_tiles(location, Vector2(1,1)):
			$ColorIndicator.indicator_color = "Red"
			$ColorIndicator.set_indicator_color()
		else:
			$ColorIndicator.indicator_color = "Green"
			$ColorIndicator.set_indicator_color()
			if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use tool")):
				place_object(item_name, null, location, "placable")


func get_rotation_index():
	if direction_index == null:
		direction_index = 0
	if Input.is_action_pressed("rotate") and not rotation_delay:
		rotation_delay = true
		direction_index += 1
		if direction_index == 4:
			direction_index = 0
		await get_tree().create_timer(0.25).timeout
		rotation_delay = false


func place_item_state():
	var location = Tiles.valid_tiles.local_to_map(mousePos)
	var dimensions = Constants.dimensions_dict[item_name]
	if not Tiles.validate_tiles(location, dimensions):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
		return
	elif not Util.isObjectPlaceableOnGround(item_name) and not Tiles.validate_foundation_tiles(location, dimensions): 
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
		return
	else:
		$ColorIndicator.indicator_color = "Green"
		$ColorIndicator.set_indicator_color()
		if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use tool")):
			place_object(item_name, null, location, "placable")

func place_seed_state():
	if Server.world.name == "Overworld":
		var location = Tiles.valid_tiles.local_to_map(mousePos)
		if Util.isNonFruitTree(item_name) or Util.isFruitTree(item_name):
			if not Tiles.validate_forest_tiles(location) or Server.player_node.position.distance_to(mousePos) > Constants.MIN_PLACE_OBJECT_DISTANCE:
				$ColorIndicator.indicator_color = "Red"
				$ColorIndicator.set_indicator_color()
			else:
				$ColorIndicator.indicator_color = "Green"
				$ColorIndicator.set_indicator_color()
				if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use tool")):
					place_object(item_name, null, location, "seed")
		else: # crops
			if Tiles.hoed_tiles.get_cell_atlas_coords(0,location) == Vector2i(-1,-1) or not Tiles.validate_tiles(location,Vector2i(1,1)):
				$ColorIndicator.indicator_color = "Red"
				$ColorIndicator.set_indicator_color()
			else:
				$ColorIndicator.indicator_color = "Green"
				$ColorIndicator.set_indicator_color()
				if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use tool")):
					place_object(item_name, null, location, "seed")	
	else:
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()


func place_object(item_name, direction, location, type, variety = null):
	if PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot)):
		if item_name != "wall" and item_name != "foundation" and not moving_object:
			PlayerData.remove_single_object_from_hotbar()
		var id = Uuid.v4()
		if type == "placable":
			if item_name == "wall" or item_name == "foundation":
				if PlayerData.returnSufficentCraftingMaterial("wood", 5) and item_name == "wall":
					$SoundEffects.stream = Sounds.place_object
					$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
					$SoundEffects.play()
					MapData.add_object("placeable",id,{"n":item_name,"v":"twig","l":str(location),"h":Stats.MAX_TWIG_BUILDING})
					PlayerData.remove_material("wood", 5)
					PlaceObject.place_building_object_in_world(id,item_name,null,"twig",location,Stats.MAX_TWIG_BUILDING)
				elif PlayerData.returnSufficentCraftingMaterial("wood", 2) and item_name == "foundation":
					$SoundEffects.stream = Sounds.place_object
					$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
					$SoundEffects.play()
					MapData.add_object("placeable",id, {"n":item_name,"v":"twig","l":str(location),"h":Stats.MAX_TWIG_BUILDING})
					PlayerData.remove_material("wood", 2)
					PlaceObject.place_building_object_in_world(id,item_name,null,"twig",location,Stats.MAX_TWIG_BUILDING)
				else:
					$SoundEffects.stream = load("res://Assets/Sound/Sound effects/Farming/ES_Error Tone Chime 6 - SFX Producer.mp3")
					$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -20)
					$SoundEffects.play()
			else:
				$SoundEffects.stream = Sounds.place_object
				$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
				$SoundEffects.play()
				MapData.add_object("placeable",id,{"n":item_name,"d":direction,"l":str(location),"v":variety})
				if item_name == "wood door" or item_name == "metal door" or item_name == "armored door":
					Tiles.object_tiles.set_cell(0,location,0,Constants.rotatable_object_atlas_tiles[item_name][direction])
					PlaceObject.place_building_object_in_world(id,item_name,direction,null,location,Stats.return_starting_door_health(item_name))
				else:
					PlaceObject.place_object_in_world(id, item_name, direction, location, variety)
		elif type == "seed":
			$SoundEffects.stream = load("res://Assets/Sound/Sound effects/Farming/place seed.mp3")
			$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
			$SoundEffects.play()
			if Util.isNonFruitTree(item_name) or Util.isFruitTree(item_name):
				PlaceObject.place_tree_in_world(id,item_name,location+Vector2(1,0),"forest",Stats.TREE_HEALTH,"sapling")
				MapData.add_object("tree",id,{"l":str(location),"h":Stats.TREE_HEALTH,"b":"forest","v":item_name,"p":"sapling"})
				MapData.add_object_to_chunk("tree",location,id)
			else:
				item_name = item_name.left(-6)
				var days_to_grow = JsonData.crop_data[item_name]["DaysToGrow"]
				MapData.add_object("crop",id,{"n":item_name,"l":str(location),"dh":days_to_grow,"dww":0,"rp":false})
				PlaceObject.place_seed_in_world(id, item_name, location, days_to_grow, 0, false)
		elif type == "forage":
			$SoundEffects.stream = load("res://Assets/Sound/Sound effects/Farming/place seed.mp3")
			$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
			$SoundEffects.play()
			MapData.add_object("forage",id,{"n":item_name,"l":str(location),"f":false})
			MapData.add_object_to_chunk("forage",location,id)
			PlaceObject.place_forage_in_world(id,item_name,location,false)
	if not PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot)):
		Server.player_node.set_held_object()
