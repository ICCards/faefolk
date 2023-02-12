extends Node2D

@onready var GridSquareLabel = load("res://World3D/Map/GridSquareLabel.tscn")
@onready var playerIcon = $Map/PlayerIcon
@onready var stormIcon = $Map/StormIcon
@onready var stormIcon2 = $Map/StormIcon2
@onready var miniMap = $Map
var player 
var roamingStorm
var roamingStorm2
var direction
var is_first_time_opened = false
const NUM_COLUMNS = 8
const NUM_ROWS = 8
const MAP_WIDTH = 1000
const MAP_HEIGHT = 1000
const alphabet = ["A", "B", "C", "D", "E", "F", "G", "H"]

enum Tiles {
	DIRT,
	PLAINS,
	FOREST,
	WATER,
	BEACH,
	DESERT,
	SNOW
}

func _input(event):
	if not PlayerData.interactive_screen_mode and not PlayerData.viewInventoryMode and not PlayerData.viewSaveAndExitMode and has_node("/root/World3D"):
		if event.is_action_pressed("open_map"):
			Server.player_node.actions.destroy_placable_object()
			Server.world.get_node("WorldAmbience").call_deferred("hide")
			call_deferred("show")
			call_deferred("initialize")
		if event.is_action_released("open_map"):
			Server.world.get_node("WorldAmbience").call_deferred("show")
			call_deferred("hide")
			call_deferred("set_inactive")
			Server.player_node.call_deferred("set_held_object")


#func toggle_map():
#	PlayerData.viewMapMode = !PlayerData.viewMapMode
#	$WorldMap.visible = !$WorldMap.visible
#	if $WorldMap.visible:
#		$WorldMap.initialize()
#	else:
#		$WorldMap.set_inactive()


func initialize():
	PlayerData.viewMapMode = true
	$Camera2D.set_deferred("current", true)
	Server.player_node.user_interface.get_node("Hotbar").call_deferred("hide") 
	Server.player_node.user_interface.get_node("CombatHotbar").call_deferred("hide")
	if not is_first_time_opened:
		is_first_time_opened = true
		$Camera2D.set_deferred("position", Vector2(800, 800))
		$Camera2D.set_deferred("zoom",  Vector2(1.2, 1.2))
	
func set_inactive():
	PlayerData.viewMapMode = false
	$Camera2D.set_deferred("current", false)
	Server.player_node.get_node("Camera2D").set_deferred("current", true)
	if PlayerData.normal_hotbar_mode:
		Server.player_node.user_interface.get_node("Hotbar").call_deferred("show") 
	else:
		Server.player_node.user_interface.get_node("CombatHotbar").call_deferred("show") 


func draw_grid():
	for x in range(NUM_ROWS):
		for height in range(MAP_HEIGHT):
			$Grid.set_cell((MAP_WIDTH/NUM_ROWS) * (x+1), height, 0)
	for y in range(NUM_COLUMNS):
		for width in range(MAP_WIDTH):
			$Grid.set_cell(width, (MAP_HEIGHT/NUM_COLUMNS) * (y+1), 0)
	draw_grid_labels()
	
func draw_grid_labels():
	for x in range(NUM_ROWS):
		for y in range(NUM_COLUMNS):
			var gridSquareLabel = GridSquareLabel.instantiate()
			gridSquareLabel.initialize(alphabet[y] + str(x+1))
			gridSquareLabel.name = str(alphabet[y] + str(x+1))
			gridSquareLabel.position = Vector2(x*200, y*200) + Vector2(2, 2)
			add_child(gridSquareLabel)
	
func _physics_process(delta):
	if is_instance_valid(Server.player_node):
		playerIcon.position = Server.player_node.position
		playerIcon.scale = adjustedPlayerIconScale($Camera2D.zoom)
		set_direction(Server.player_node.direction)
		roamingStorm = get_node("/root/World3D/RoamingStorm")
		roamingStorm2 = get_node("/root/World3D/RoamingStorm2")
		stormIcon.position = roamingStorm.position
		stormIcon2.position = roamingStorm2.position


func adjustedGridCoordinatesScale(zoom):
	var percent_zoomed = zoom / Vector2(1.5, 1.5)
	return Vector2(0.5,0.5) * percent_zoomed
	
func adjustedPlayerIconScale(zoom):
	var percent_zoomed = zoom / Vector2(0.8, 0.8)
	return Vector2(32,32) * percent_zoomed


func set_direction(dir):
	match dir:
		"RIGHT":
			playerIcon.rotation_degrees = 0
		"LEFT":
			playerIcon.rotation_degrees = 180
		"DOWN":
			playerIcon.rotation_degrees = 90
		"UP":
			playerIcon.rotation_degrees = -90

func buildMap():
	var map = MapData.world
	for loc_string in map["dirt"]:
		var loc = Util.string_to_vector2(loc_string)
		miniMap.set_cellv(loc, Tiles.DIRT)
	for loc_string in map["forest"]:
		var loc = Util.string_to_vector2(loc_string)
		miniMap.set_cellv(loc , Tiles.FOREST)
	for loc_string in map["plains"]:
		var loc = Util.string_to_vector2(loc_string)
		miniMap.set_cellv(loc , Tiles.PLAINS)
	for loc_string in map["beach"]:
		var loc = Util.string_to_vector2(loc_string)
		miniMap.set_cellv(loc , Tiles.BEACH)
	for loc_string in map["desert"]:
		var loc = Util.string_to_vector2(loc_string)
		miniMap.set_cellv(loc , Tiles.DESERT)
	for loc_string in map["snow"]:
		var loc = Util.string_to_vector2(loc_string)
		miniMap.set_cellv(loc , Tiles.SNOW)
	for x in range(MAP_WIDTH):
		for y in range(MAP_HEIGHT):
			if miniMap.get_cell(x, y) == -1:
				miniMap.set_cellv(Vector2(x,y),Tiles.WATER)
	draw_grid()
