extends Node2D

@onready var InteractiveAreaNode = load("res://World/Building/Tiles/Attached nodes/interactive_area.tscn")
@onready var CampfireInteractiveAreaNode = load("res://World/Building/Tiles/Attached nodes/campfire_interactive_area.tscn")
@onready var BedInteractiveAreaNode = load("res://World/Building/Tiles/Attached nodes/bed_interactive_area.tscn")
@onready var DoorInteractiveAreaNode = load("res://World/Building/Tiles/Attached nodes/door_interactive_area.tscn")

@onready var interactives: Node = $Interactives
@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
@onready var movement_collision: CollisionShape2D = $Marker2D/MovementCollision/CollisionShape2D
@onready var hurt_box: CollisionShape2D = $Marker2D/HurtBox/CollisionShape2D
@onready var object_tiles: TileMap = $ObjectTiles

var rng := RandomNumberGenerator.new()
var thread := Thread.new()

var location
var item_name
var direction
var variety
var health


var is_player_sitting: bool = false

var temp_health = 3

func _ready():
	if Constants.object_atlas_tiles.keys().has(item_name):
		if Util.isStorageItem(item_name):
			object_tiles.set_cell(0,Vector2i(0,-1),0,Constants.object_atlas_tiles[item_name])
	elif Constants.autotile_object_atlas_tiles.keys().has(item_name):
		pass
	elif Constants.customizable_rotatable_object_atlas_tiles.keys().has(item_name):
		if Util.isStorageItem(item_name):
			object_tiles.set_cell(0,Vector2i(0,-1),0,Constants.customizable_rotatable_object_atlas_tiles[item_name][variety][direction])
	elif Constants.customizable_object_atlas_tiles.keys().has(item_name):
		if Util.isStorageItem(item_name):
			object_tiles.set_cell(0,location,0,Constants.customizable_object_atlas_tiles[item_name][variety])
	else:
		if Util.isStorageItem(item_name):
			object_tiles.set_cell(0,Vector2i(0,-1),0,Constants.rotatable_object_atlas_tiles[item_name][direction])
	set_dimensions()


#func _physics_process(delta):
#	if PlayerData.normal_hotbar_mode:
#		if PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot)):
#			var item_name = PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][0]
#			if item_name == "blueprint" and Server.player_node.current_building_item == "":
#				if $Marker2D/Btn.is_hovered():
#					Input.set_custom_mouse_cursor(load("res://Assets/mouse cursors/grabber.png"))

func set_dimensions():
	rng.randomize()
	item_name = Util.return_adjusted_item_name(item_name)
	$Marker2D.scale = Constants.dimensions_dict[item_name]
	if direction == "left" or direction == "right":
		Tiles.remove_valid_tiles(location, Vector2(Constants.dimensions_dict[item_name].y, Constants.dimensions_dict[item_name].x))
		$Marker2D.position.x = (Constants.dimensions_dict[item_name].y - 1) * 8
		$Marker2D.position.y = (Constants.dimensions_dict[item_name].x - 1) * -8
	else:
		Tiles.remove_valid_tiles(location, Constants.dimensions_dict[item_name])
		$Marker2D.position.x = (Constants.dimensions_dict[item_name].x - 1) * 8
		$Marker2D.position.y = (Constants.dimensions_dict[item_name].y - 1) * -8
	match direction:
		"left":
			$Marker2D.rotation_degrees = 90
		"up":
			$Marker2D.rotation_degrees = 180
		"right":
			$Marker2D.rotation_degrees = 270
	if item_name == "wood chest" or item_name == "stone chest":
		add_interactive_area_node("chest",name)
		if PlayerData.player_data["chests"].has(name):
			pass
		else:
			PlayerData.player_data["chests"][name] = {}
	elif item_name == "crate":
		add_campfire_interactive_area_node("crate")
		if PlayerData.player_data["chests"].has(name):
			pass
		else:
			PlayerData.player_data["chests"][name] = {}
	elif item_name == "barrel":
		add_campfire_interactive_area_node("barrel")
		if PlayerData.player_data["barrels"].has(name):
			pass
		else:
			PlayerData.player_data["barrels"][name] = {}
	elif item_name == "lamp":
		add_campfire_interactive_area_node("lamp")
	elif item_name == "fireplace":
		add_interactive_area_node("fireplace",name)
	elif item_name == "torch":
		$PointLight2D.set_deferred("enabled", true)
	elif item_name == "campfire":
		add_campfire_interactive_area_node("campfire")
		$PointLight2D.set_deferred("enabled", true)
		if PlayerData.player_data["campfires"].has(name):
			pass
		else:
			PlayerData.player_data["campfires"][name] = {}
	elif item_name == "workbench #1" or item_name == "workbench #2" or item_name == "workbench #3":
		add_interactive_area_node("workbench",item_name.left(-1))
	elif item_name == "stove #1" or item_name == "stove #2" or item_name == "stove #3":
		add_interactive_area_node("stove",item_name.right(1))
		if PlayerData.player_data["stoves"].has(name):
			pass
		else:
			PlayerData.player_data["stoves"][name] = {}
	elif item_name == "grain mill #1" or item_name == "grain mill #2" or item_name == "grain mill #3":
		add_interactive_area_node("grain mill",item_name.right(1))
		if PlayerData.player_data["grain_mills"].has(name):
			pass
		else:
			PlayerData.player_data["grain_mills"][name] = {}
	elif item_name == "brewing table #1" or item_name == "brewing table #2" or item_name == "brewing table #3":
		add_interactive_area_node("brewing table",item_name.right(1))
		if PlayerData.player_data["brewing_tables"].has(name):
			pass
		else:
			PlayerData.player_data["brewing_tables"][name] = {}
	elif item_name == "furnace":
		add_interactive_area_node("furnace",name)
		if PlayerData.player_data["furnaces"].has(name):
			pass
		else:
			PlayerData.player_data["furnaces"][name] = {}
	elif item_name == "tool cabinet":
		add_interactive_area_node(item_name,name)
		if PlayerData.player_data["chests"].has(name):
			pass
		else:
			PlayerData.player_data["chests"][name] = {}
	elif item_name == "bed":
		add_bed_interactive_area_node()
	elif item_name == "chair":
		add_interactive_area_node("chair",name)
	elif item_name == "large rug" or item_name == "medium rug" or item_name == "small rug" or item_name == "torch":
		movement_collision.set_deferred("disabled", true)
	elif item_name == "wood gate" or item_name == "stone gate" or item_name == "metal gate":
		add_door_interactive_area_node("gate")
	elif item_name == "wood door" or item_name == "metal door" or item_name == "armored door":
		add_door_interactive_area_node("door")


func add_interactive_area_node(object_name,level = null):
	var interactiveAreaNode = InteractiveAreaNode.instantiate()
	interactiveAreaNode.object_level = level
	interactiveAreaNode.object_name = object_name
	interactiveAreaNode.name = name
	$Marker2D.call_deferred("add_child", interactiveAreaNode)

func add_campfire_interactive_area_node(object_name):
	var campfireInteractiveAreaNode = CampfireInteractiveAreaNode.instantiate()
	campfireInteractiveAreaNode.object_name = object_name
	campfireInteractiveAreaNode.name = name
	$Marker2D.call_deferred("add_child", campfireInteractiveAreaNode)
	
func add_bed_interactive_area_node():
	var bedInteractiveAreaNode = BedInteractiveAreaNode.instantiate()
	bedInteractiveAreaNode.object_position = location*16
	bedInteractiveAreaNode.object_name = "bed"
	bedInteractiveAreaNode.name = name
	$Marker2D.call_deferred("add_child", bedInteractiveAreaNode)
	
func add_door_interactive_area_node(type):
	var doorInteractiveAreaNode = DoorInteractiveAreaNode.instantiate()
	doorInteractiveAreaNode.object_name = type
	doorInteractiveAreaNode.name = name
	$Marker2D.call_deferred("add_child", doorInteractiveAreaNode)

func return_adjusted_chair_position(direction):
	match item_name:
		"chair":
			match direction:
				"down":
					return position+Vector2(16,0)
				"up":
					return position+Vector2(16,-32)
				"left":
					return position+Vector2(-4,0)
				"right":
					return position+Vector2(36,0)
		"armchair":
			match direction:
				"down":
					return position+Vector2(32,0)
				"up":
					return position+Vector2(32,-48)
				"left":
					return position+Vector2(8,0)
				"right":
					return position+Vector2(56,0)
		"couch":
			match direction:
				"down":
					if Server.player_node.position.x - 32 > position.x:
						return position+Vector2(64,0)
					else:
						return position+Vector2(32,0)
				"up":
					return position+Vector2(32,-48)
				"left":
					if Server.player_node.position.y + 48 < position.y:
						return position+Vector2(8,-32)
					else:
						return position+Vector2(8,0)
				"right":
					return position+Vector2(56,0)
				

func _on_HurtBox_area_entered(area):
	if area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	if check_if_has_items() and temp_health != 0:
		sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/Building/wood/wood hit.mp3"))
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound",0))
		sound_effects.call_deferred("play")
		$AnimationPlayer.call_deferred("play","shake")
		temp_health -= 1
		$ResetTempHealthTimer.call_deferred("start")
	else:
#		$PointLight2D.set_deferred("enabled", false)
#		$FurnaceSmoke.call_deferred("hide")
		if $Marker2D.has_node(str(name)):
			$Marker2D.get_node(name+ "/CollisionShape2D").set_deferred("disabled", true)
		hurt_box.set_deferred("disabled", true)
		movement_collision.set_deferred("disabled", true)
		if item_name == "wood chest" or item_name == "stone chest" or item_name == "tool cabinet":
			drop_items_in_chest()
			sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/objects/break wood.mp3"))
		elif item_name == "grain mill #1" or item_name == "grain mill #2" or item_name == "grain mill #3":
			drop_items_in_grain_mill()
			sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/objects/break stone.mp3"))
		elif item_name == "stove #1" or item_name == "stove #2" or item_name == "stove #3":
			drop_items_in_stove()
			sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/objects/break stone.mp3"))
		elif item_name == "furnace":
			drop_items_in_furnace()
			sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/objects/break stone.mp3"))
		elif item_name == "campfire":
			drop_items_in_campfire()
			sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/objects/break stone.mp3"))
		else: 
			sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/objects/break wood.mp3"))
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -16))
		sound_effects.call_deferred("play")
		var dimensions = Constants.dimensions_dict[item_name]
		if direction == "left" or direction == "right":
			Tiles.add_valid_tiles(location, Vector2(dimensions.y, dimensions.x))
		else:
			Tiles.add_valid_tiles(location, dimensions)
		Tiles.object_tiles.erase_cell(0,location)
		InstancedScenes.intitiateItemDrop(item_name, position, 1)
		MapData.remove_object("placeable",name)
		await sound_effects.finished
		queue_free()

func check_if_has_items():
	if item_name == "wood chest" or item_name == "stone chest" or item_name == "wood box" or item_name == "tool cabinet":
		return PlayerData.player_data["chests"][name].keys().size() > 0
	elif item_name == "furnace":
		return PlayerData.player_data["furnaces"][name].keys().size() > 0
	elif item_name == "wood barrel":
		return PlayerData.player_data["wood_barrels"][name].keys().size() > 0
	elif item_name == "stove #1" or item_name == "stove #2" or item_name == "stove #3":
		return PlayerData.player_data["stoves"][name].keys().size() > 0
	elif item_name == "grain mill #1" or item_name == "grain mill #2" or item_name == "grain mill #3":
		return PlayerData.player_data["grain_mills"][name].keys().size() > 0
	elif item_name == "campfire":
		return PlayerData.player_data["campfires"][name].keys().size() > 0
	return false


func drop_items_in_campfire():
	for item in PlayerData.player_data["campfires"][name].keys():
		InstancedScenes.initiateInventoryItemDrop(PlayerData.player_data["campfires"][name][item], position)
	PlayerData.player_data["campfires"].erase(name)

func drop_items_in_stove():
	for item in PlayerData.player_data["stoves"][name].keys():
		InstancedScenes.initiateInventoryItemDrop(PlayerData.player_data["stoves"][name][item], position)
	PlayerData.player_data["stoves"].erase(name)

func drop_items_in_grain_mill():
	for item in PlayerData.player_data["grain_mills"][name].keys():
		InstancedScenes.initiateInventoryItemDrop(PlayerData.player_data["grain_mills"][name][item], position)
	PlayerData.player_data["grain_mills"].erase(name)

func drop_items_in_chest():
	for item in PlayerData.player_data["chests"][name].keys():
		InstancedScenes.initiateInventoryItemDrop(PlayerData.player_data["chests"][name][item], position)
	PlayerData.player_data["chests"].erase(name)

func drop_items_in_furnace():
	for item in PlayerData.player_data["furnaces"][name].keys():
		InstancedScenes.initiateInventoryItemDrop(PlayerData.player_data["furnaces"][name][item], position)
	PlayerData.player_data["furnaces"].erase(name)


func _on_ResetTempHealthTimer_timeout():
	temp_health = 3

func _on_btn_pressed():
	pass
#	if PlayerData.normal_hotbar_mode:
#		if PlayerData.player_data["hotbar"].has(str(PlayerData.active_item_slot)):
#			var item_name = PlayerData.player_data["hotbar"][str(PlayerData.active_item_slot)][0]
#			if item_name == "blueprint" and Server.player_node.current_building_item == "":
#				Tiles.object_tiles.erase_cell(0,location)
#				MapData.remove_object("placeable",name)
#				Server.player_node.actions.move_placable_object(item_name,location)
#				Sounds.play_pick_up_placeable_object()
#				queue_free()
	

func _on_btn_mouse_exited():
	Input.set_custom_mouse_cursor(load("res://Assets/mouse cursors/cursor.png"))
