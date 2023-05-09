extends Node2D

var directions = ["down", "left", "up", "right"]
var direction_index: int = 0
var rotation_delay: bool = false
var variety_delay: bool = false
var mousePos := Vector2.ZERO 

var item_name
var item_category
var moving_object: bool
var previous_moving_object_data
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
	FORAGE,
	WALL_ART
}

var _uuid = load("res://helpers/UUID.gd")
@onready var uuid = _uuid.new()

func _ready():
	initialize()

func destroy():
	Input.set_custom_mouse_cursor(load("res://Assets/mouse cursors/cursor.png"))
	name = "removing"
	hide()
	set_physics_process(false)
#	if moving_object:
#		MapData.add_object("placeable",previous_moving_object_data["id"],{"n":previous_moving_object_data["n"],"d":previous_moving_object_data["d"],"l":previous_moving_object_data["l"],"v":previous_moving_object_data["v"]})
#		PlaceObject.place_object_in_world(previous_moving_object_data["id"], previous_moving_object_data["n"], previous_moving_object_data["d"], previous_moving_object_data["l"], previous_moving_object_data["v"], false)
	call_deferred("queue_free")

func destroy_and_remove_previous_object():
	Input.set_custom_mouse_cursor(load("res://Assets/mouse cursors/cursor.png"))
	hide()
	set_physics_process(false)
	call_deferred("queue_free")

func _physics_process(delta):
	mousePos = (get_global_mouse_position()+Vector2(-8,-8)).snapped(Vector2(16,16))
	set_global_position(mousePos+Vector2(8,8))
	match state:
		ITEM:
			place_item_state()
		SEED:
			place_seed_state()
		WALL:
			place_wall_state()
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
		WALL_ART:
			place_wall_art_state()


func initialize():
	if moving_object:
		variety = previous_moving_object_data["v"]
		direction_index = directions.find(previous_moving_object_data["d"])
	if item_name != "foundation" and item_name != "wall":
		item_category = JsonData.item_data[item_name]["ItemCategory"]
	if item_name == "wall art":
		state = WALL_ART
	elif Constants.rotatable_object_atlas_tiles.keys().has(item_name):
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
	$Seeds.hide()
	$Objects.hide()
	match state:
		ITEM:
			Server.player_node.user_interface.get_node("ChangeRotation").hide()
			Server.player_node.user_interface.get_node("ChangeVariety").hide()
			$Objects.show()
			$Objects.set_cell(0,Vector2i(0,0),0,Constants.object_atlas_tiles[item_name])
			var dimensions = Constants.dimensions_dict[item_name]
			$ColorIndicator.tile_size = dimensions
		WALL_ART:
			Server.player_node.user_interface.get_node("ChangeRotation").hide()
			Server.player_node.user_interface.get_node("ChangeVariety").show()
			$Objects.show()
		SEED:
			Server.player_node.user_interface.get_node("ChangeRotation").hide()
			Server.player_node.user_interface.get_node("ChangeVariety").hide()
			item_name = item_name.left(item_name.length()-6)
			if Util.isFruitTree(item_name) or Util.isNonFruitTree(item_name):
				$TreeSeedToPlace.show()
				$TreeSeedToPlace.texture = load("res://Assets/Images/tree_sets/" + item_name + "/growing/sapling.png")
				$ColorIndicator.tile_size =  Vector2(2,2)
			else:
				$Seeds.show()
				$Seeds.set_cell(0,Vector2i(0,0),0,Constants.crop_atlas_tiles[item_name]["seeds"])
				$ColorIndicator.tile_size =  Vector2(1,1)
		WALL:
			Server.player_node.user_interface.get_node("ChangeRotation").hide()
			Server.player_node.user_interface.get_node("ChangeVariety").hide()
			$Objects.show()
			$Objects.set_cell(0,Vector2i(0,0),0,Vector2i(0,88))
			$ColorIndicator.tile_size = Vector2(1,1)
		FOUNDATION:
			Server.player_node.user_interface.get_node("ChangeRotation").hide()
			Server.player_node.user_interface.get_node("ChangeVariety").hide()
			$Objects.show()
			$Objects.set_cell(0,Vector2i(0,0),0,Vector2i(1,90))
			$ColorIndicator.tile_size = Vector2(1,1)
		ROTATABLE:
			$Objects.show()
			Server.player_node.user_interface.get_node("ChangeRotation").show()
			Server.player_node.user_interface.get_node("ChangeVariety").hide()
		CUSTOMIZABLE_ROTATABLE:
			$Objects.show()
			Server.player_node.user_interface.get_node("ChangeRotation").show()
			Server.player_node.user_interface.get_node("ChangeVariety").show()
		CUSTOMIZABLE:
			$Objects.show()
			Server.player_node.user_interface.get_node("ChangeRotation").hide()
			Server.player_node.user_interface.get_node("ChangeVariety").show()
		FORAGE:
			Server.player_node.user_interface.get_node("ChangeRotation").hide()
			Server.player_node.user_interface.get_node("ChangeVariety").hide()
			$ForageItemToPlace.show()
			$ForageItemToPlace.texture = load("res://Assets/Images/inventory_icons/Forage/"+item_name+".png")


func place_wall_art_state():
	var location = Tiles.valid_tiles.local_to_map(mousePos)
	var dimensions = Vector2(1,1)
	$ColorIndicator.tile_size = dimensions
	get_variety_index(Constants.customizable_object_atlas_tiles[item_name].keys().size())
	$Objects.set_cell(0,Vector2i(0,0),0,Constants.customizable_object_atlas_tiles[item_name][variety])
	if not Tiles.object_tiles.get_cell_atlas_coords(0,location) == Vector2i(-1,-1) or Tiles.wall_tiles.get_cell_atlas_coords(0,location) == Vector2i(-1,-1):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
	else:
		$ColorIndicator.indicator_color = "Green"
		$ColorIndicator.set_indicator_color()
		if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use tool")):
			place_object(item_name, null, location, "placeable", variety)


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
	$Objects.set_cell(0,Vector2i(0,0),0,Constants.customizable_object_atlas_tiles[item_name][variety])
	$ColorIndicator.tile_size = dimensions
	if not Tiles.validate_tiles(location, dimensions) or not Tiles.validate_foundation_tiles(location, dimensions):
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()
		return
	else:
		$ColorIndicator.indicator_color = "Green"
		$ColorIndicator.set_indicator_color()
		if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use tool")):
			place_object(item_name, null, location, "placeable", variety)

func place_customizable_rotatable_state():
	var location = Tiles.valid_tiles.local_to_map(mousePos)
	var direction = directions[direction_index]
	var dimensions = Constants.dimensions_dict[item_name]
	get_variety_index(Constants.customizable_rotatable_object_atlas_tiles[item_name].keys().size())
	get_rotation_index()
	await get_tree().process_frame
	$Objects.set_cell(0,Vector2i(0,0),0,Constants.customizable_rotatable_object_atlas_tiles[item_name][variety][direction])
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
			place_object(item_name, directions[direction_index], location, "placeable", variety)


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
	$Objects.set_cell(0,Vector2i(0,0),0,Constants.rotatable_object_atlas_tiles[item_name][direction])
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
			place_object(item_name, directions[direction_index], location, "placeable")



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
				place_object(item_name, null, location, "placeable")


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
				place_object(item_name, null, location, "placeable")


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
			place_object(item_name, null, location, "placeable")

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
					place_object(item_name, null, location, "tree")
		else: # crops
			if Tiles.hoed_tiles.get_cell_atlas_coords(0,location) == Vector2i(-1,-1) or Tiles.valid_tiles.get_cell_atlas_coords(0,location) == Vector2i(-1,-1) or Server.player_node.position.distance_to((location+Vector2i(1,1))*16) > Constants.MIN_PLACE_OBJECT_DISTANCE:
				$ColorIndicator.indicator_color = "Red"
				$ColorIndicator.set_indicator_color()
			else:
				$ColorIndicator.indicator_color = "Green"
				$ColorIndicator.set_indicator_color()
				if (Input.is_action_pressed("mouse_click") or Input.is_action_pressed("use tool")):
					place_object(item_name, null, location, "crop")
	else:
		$ColorIndicator.indicator_color = "Red"
		$ColorIndicator.set_indicator_color()


func place_object(item_name, direction, location, type, variety = null):
	if PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot)):
		if item_name != "wall" and item_name != "foundation" and not moving_object:
			PlayerData.remove_single_object_from_hotbar()
		var id = Uuid.v4()
		if type == "placeable":
			if item_name == "wall" or item_name == "foundation":
				if PlayerData.returnSufficentCraftingMaterial("wood", 5) and item_name == "wall":
					$SoundEffects.stream = Sounds.place_object
					$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
					$SoundEffects.play()
					MapData.add_object("placeable",id,{"n":item_name,"l":location,"h":Stats.MAX_TWIG_BUILDING,"t":"twig"})
					PlayerData.remove_material("wood", 5)
				elif PlayerData.returnSufficentCraftingMaterial("wood", 2) and item_name == "foundation":
					$SoundEffects.stream = Sounds.place_object
					$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
					$SoundEffects.play()
					MapData.add_object("placeable",id,{"n":item_name,"l":location,"h":Stats.MAX_TWIG_BUILDING,"t":"twig"})
					PlayerData.remove_material("wood", 2)
				else:
					$SoundEffects.stream = load("res://Assets/Sound/Sound effects/Farming/ES_Error Tone Chime 6 - SFX Producer.mp3")
					$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -20)
					$SoundEffects.play()
			else:
				$SoundEffects.stream = Sounds.place_object
				$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
				$SoundEffects.play()
				if item_name == "wood door" or item_name == "metal door" or item_name == "armored door":
					MapData.add_object("placeable",id, {"n":item_name,"v":variety,"l":location,"h":Stats.return_starting_door_health(item_name),"d":direction,"o":false})
				elif moving_object:
					MapData.add_object("placeable",previous_moving_object_data["id"],{"n":item_name,"d":direction,"l":location,"v":variety,"h":3,"o":false})
					Server.player_node.actions.destroy_moveable_object()
				else:
					MapData.add_object("placeable",id,{"n":item_name,"d":direction,"l":location,"v":variety,"h":3,"o":false})
		elif type == "tree":
			$SoundEffects.stream = load("res://Assets/Sound/Sound effects/Farming/place seed.mp3")
			$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
			$SoundEffects.play()
			MapData.add_object("tree",id,{"l":location+Vector2i(1,0),"h":Stats.TREE_HEALTH,"b":"forest","v":item_name,"p":"sapling"})
		elif type == "crop":
			$SoundEffects.stream = load("res://Assets/Sound/Sound effects/Farming/place seed.mp3")
			$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
			$SoundEffects.play()
			var days_to_grow = JsonData.crop_data[item_name]["DaysToGrow"]
			MapData.add_object("crop",id,{"n":item_name,"l":location,"dh":days_to_grow,"dww":0,"rp":false})
		elif type == "forage":
			$SoundEffects.stream = load("res://Assets/Sound/Sound effects/Farming/place seed.mp3")
			$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
			$SoundEffects.play()
			MapData.add_object("forage",id,{"n":item_name,"l":location,"f":false})
	if not PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot)):
		Server.player_node.set_held_object()
