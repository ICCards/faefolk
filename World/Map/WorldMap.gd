extends Node2D

@onready var GridSquareLabel = load("res://World/Map/GridSquareLabel.tscn")
@onready var playerIcon = $Map/PlayerIcon
@onready var stormIcon = $Map/StormIcon
@onready var stormIcon2 = $Map/StormIcon2
@onready var miniMap = $Map
var player 
var roamingStorm
var roamingStorm2
var direction
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
	SNOW,
	DEEP_OCEAN
}


func _input(event):
	if not PlayerData.interactive_screen_mode and not PlayerData.viewInventoryMode and has_node("/root/Overworld"):
		if event.is_action_pressed("open map"):
			Server.player_node.actions.destroy_placeable_object()
			Server.world.get_node("WorldAmbience").call_deferred("hide")
			call_deferred("show")
			call_deferred("initialize")
		if event.is_action_released("open map"):
			Server.world.get_node("WorldAmbience").call_deferred("show")
			call_deferred("hide")
			call_deferred("set_inactive")
			Server.player_node.call_deferred("set_held_object")

func initialize():
	PlayerData.viewMapMode = true
	Server.player_node.get_node("Camera2D").set_deferred("enabled", false)
	$Camera2D.set_deferred("enabled", true)
	Server.player_node.user_interface.get_node("Hotbar").call_deferred("hide") 
	Server.player_node.user_interface.get_node("CombatHotbar").call_deferred("hide")
	
func set_inactive():
	PlayerData.viewMapMode = false
	$Camera2D.set_deferred("enabled", false)
	Server.player_node.get_node("Camera2D").set_deferred("enabled", true)
	if PlayerData.normal_hotbar_mode:
		Server.player_node.user_interface.get_node("Hotbar").call_deferred("show") 
	else:
		Server.player_node.user_interface.get_node("CombatHotbar").call_deferred("show") 


func draw_grid():
	for x in range(NUM_ROWS):
		for height in range(MAP_HEIGHT):
			$Grid.set_cell(0,Vector2i((MAP_WIDTH/NUM_ROWS)*(x+1), height),0,Vector2i(0,0))
	for y in range(NUM_COLUMNS):
		for width in range(MAP_WIDTH):
			$Grid.set_cell(0, Vector2i(width,(MAP_HEIGHT/NUM_COLUMNS)*(y+1)),0,Vector2i(0,0))
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
		playerIcon.position = Server.player_node.position*2
		playerIcon.scale = adjustedPlayerIconScale($Camera2D.zoom)
		set_direction(Server.player_node.direction)
#		roamingStorm = get_node("/root/Overworld/RoamingStorm")
#		roamingStorm2 = get_node("/root/Overworld/RoamingStorm2")
#		stormIcon.position = roamingStorm.position
#		stormIcon2.position = roamingStorm2.position


func adjustedGridCoordinatesScale(zoom):
	var percent_zoomed = zoom / Vector2(1.5, 1.5)
	return Vector2(0.5,0.5) * percent_zoomed
	
func adjustedPlayerIconScale(zoom):
	var percent_zoomed = zoom / Vector2(0.8, 0.8)
	return Vector2(48,48) * percent_zoomed


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
	var map = MapData.terrain
	for loc in map["dirt"]:
		miniMap.set_cell(0,loc,Tiles.DIRT,Vector2i(0,0))
	for loc in map["forest"]:
		miniMap.set_cell(0,loc,Tiles.FOREST,Vector2i(0,0))
	for loc in map["plains"]:
		miniMap.set_cell(0,loc,Tiles.PLAINS,Vector2i(0,0))
	for loc in map["beach"]:
		miniMap.set_cell(0,loc,Tiles.BEACH,Vector2i(0,0))
	for loc in map["desert"]:
		miniMap.set_cell(0,loc,Tiles.DESERT,Vector2i(0,0))
	for loc in map["snow"]:
		miniMap.set_cell(0,loc,Tiles.SNOW,Vector2i(0,0))
	for loc in map["deep_ocean"]:
		miniMap.set_cell(0,loc,Tiles.DEEP_OCEAN,Vector2i(0,0))
	for x in range(MAP_WIDTH):
		for y in range(MAP_HEIGHT):
			if miniMap.get_cell_atlas_coords(0,Vector2i(x,y)) == Vector2i(-1,-1):
				miniMap.set_cell(0,Vector2i(x,y),Tiles.WATER,Vector2i(0,0))
	draw_grid()
