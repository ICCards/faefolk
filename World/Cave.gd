extends YSort


onready var Player = preload("res://World/Player/Player/Player.tscn")
const _character = preload("res://Global/Data/Characters.gd")
var file_name = "res://CaveRooms.json"
var cut_out_walls = []
var large_shrub = []
var small_shrub = []
var lights = []
var dimensions = 50
var room_dict = {}

var rng = RandomNumberGenerator.new()

func spawnPlayerExample():
	var player = Player.instance()
	player.name = str(get_tree().get_network_unique_id())
	player.character = _character.new()
	player.character.LoadPlayerCharacter("human_male")
	add_child(player)
	player.spawn_position = Vector2(12*32,12*32)
	player.position = Vector2(0,0) 

func _ready():
	rng.randomize()
	spawnPlayerExample()
	create_room()
	#save_room()


func create_room():
	for loc in JsonData.cave_room_data["ROOM_#1"]["walls"]:
		$Walls.set_cellv(Util.string_to_vector2(loc), -1)
	for loc in JsonData.cave_room_data["ROOM_#1"]["small shrub"]:
		$Shrubs.set_cellv(Util.string_to_vector2(loc), rng.randi_range(1,2))
	for loc in JsonData.cave_room_data["ROOM_#1"]["large shrub"]:
		$Shrubs.set_cellv(Util.string_to_vector2(loc), 0)
	for loc in JsonData.cave_room_data["ROOM_#1"]["lights"]:
		$Lights.set_cellv(Util.string_to_vector2(loc), 0)
	for loc in JsonData.cave_room_data["ROOM_#2"]["walls"]:
		$Walls.set_cellv(Util.string_to_vector2(loc)+Vector2(50,0), -1)
	for loc in JsonData.cave_room_data["ROOM_#2"]["small shrub"]:
		$Shrubs.set_cellv(Util.string_to_vector2(loc)+Vector2(50,0), rng.randi_range(1,2))
	for loc in JsonData.cave_room_data["ROOM_#2"]["large shrub"]:
		$Shrubs.set_cellv(Util.string_to_vector2(loc)+Vector2(50,0), 0)
	for loc in JsonData.cave_room_data["ROOM_#2"]["lights"]:
		$Lights.set_cellv(Util.string_to_vector2(loc)+Vector2(50,0), 0)
	$Walls.update_bitmask_region()

func save_room():
	for x in range(dimensions):
		for y in range(dimensions):
			if not $Walls.get_used_cells().has(Vector2(x,y)):
				cut_out_walls.append(Vector2(x,y))
	for loc in $Shrubs.get_used_cells():
		if $Shrubs.get_cellv(loc) == 0:
			large_shrub.append(loc)
		else:
			small_shrub.append(loc)
	for loc in $Lights.get_used_cells():
		lights.append(loc)
	room_dict = {"ROOM_#1" : { "openings": ["top left", "middle right"], "walls" : cut_out_walls, "large shrub": large_shrub, "small shrub": small_shrub, "lights": lights}}
	save_keys()

func save_keys():
	var file = File.new()
	file.open(file_name,File.WRITE)
	file.store_string(to_json(room_dict))
	file.close()
	pass
	
