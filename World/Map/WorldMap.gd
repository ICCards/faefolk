extends Node2D

onready var GridSquareLabel = load("res://World/Map/GridSquareLabel.tscn")
onready var playerIcon = $Map/PlayerIcon
onready var stormIcon = $Map/StormIcon
onready var stormIcon2 = $Map/StormIcon2
onready var miniMap = $Map
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
	if not PlayerData.interactive_screen_mode and not PlayerData.viewInventoryMode and has_node("/root/World"):
		if event.is_action_pressed("open_map"):
			show()
			initialize()
		if event.is_action_released("open_map"):
			hide()
			set_inactive()

func toggle_map():
	PlayerData.viewMapMode = !PlayerData.viewMapMode
	$WorldMap.visible = !$WorldMap.visible
	if $WorldMap.visible:
		$WorldMap.initialize()
	else:
		$WorldMap.set_inactive()


func initialize():
	PlayerData.viewMapMode = true
	$Camera2D.current = true
	Server.player_node.get_node("Camera2D/UserInterface/Hotbar").visible = false
	if not is_first_time_opened:
		is_first_time_opened = true
		$Camera2D.position = Vector2(800, 800)
		$Camera2D.zoom = Vector2(1.5, 1.5)
	
func set_inactive():
	PlayerData.viewMapMode = false
	$Camera2D.current = false
	Server.player_node.get_node("Camera2D").current = true
	Server.player_node.get_node("Camera2D/UserInterface/Hotbar").visible = true

func _ready():
	if has_node("/root/World"):
		buildMap(MapData.world)

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
			var gridSquareLabel = GridSquareLabel.instance()
			gridSquareLabel.initialize(alphabet[y] + str(x+1))
			gridSquareLabel.name = str(alphabet[y] + str(x+1))
			gridSquareLabel.rect_position = Vector2(x*200, y*200) + Vector2(2, 2)
			add_child(gridSquareLabel)
	
func _physics_process(delta):
	if Server.player_node:
		playerIcon.position =  Server.player_node.position
		playerIcon.scale = adjustedPlayerIconScale($Camera2D.zoom)
		set_direction(Server.player_node.direction)
		roamingStorm = get_node("/root/World/RoamingStorm")
		roamingStorm2 = get_node("/root/World/RoamingStorm2")
		stormIcon.position = roamingStorm.position
		stormIcon2.position = roamingStorm2.position


func adjustedGridCoordinatesScale(zoom):
	var percent_zoomed = zoom / Vector2(1.5, 1.5)
	return Vector2(0.5,0.5) * percent_zoomed
	
func adjustedPlayerIconScale(zoom):
	var percent_zoomed = zoom / Vector2(1.5, 1.5)
	return Vector2(40,40) * percent_zoomed


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
		
func buildMap(map):
	for id in map["dirt"]:
		var loc = Util.string_to_vector2(map["dirt"][id])
		miniMap.set_cellv(loc, Tiles.DIRT)
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["forest"]:
		var loc = Util.string_to_vector2(map["forest"][id])
		miniMap.set_cellv(loc , Tiles.FOREST)
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["plains"]:
		var loc = Util.string_to_vector2(map["plains"][id])
		miniMap.set_cellv(loc , Tiles.PLAINS)
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["beach"]:
		var loc = Util.string_to_vector2(map["beach"][id])
		miniMap.set_cellv(loc , Tiles.BEACH)
	for id in map["desert"]:
		var loc = Util.string_to_vector2(map["desert"][id])
		miniMap.set_cellv(loc , Tiles.DESERT)
	for id in map["snow"]:
		var loc = Util.string_to_vector2(map["snow"][id])
		miniMap.set_cellv(loc , Tiles.SNOW)
	for x in range(MAP_WIDTH):
		for y in range(MAP_HEIGHT):
			if miniMap.get_cell(x, y) == -1:
				miniMap.set_cellv(Vector2(x,y),Tiles.WATER)
	draw_grid()
