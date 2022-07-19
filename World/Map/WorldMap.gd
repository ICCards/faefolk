extends Node2D



onready var GridSquareLabel = preload("res://World/Map/GridSquareLabel.tscn")
onready var playerIcon = $Map/PlayerIcon
onready var stormIcon = $Map/StormIcon
onready var miniMap = $Map
var player 
var rainStorm
var snowStorm
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
	SNOW
}

func initialize():
	$Camera2D.current = true
	$Camera2D.position = Vector2(800, 800)
	$Camera2D.zoom = Vector2(1.5, 1.5)
	get_node("/root/World/Players/" + Server.player_id + "/Camera2D/UserInterface/Hotbar").visible = false
	get_node("/root/World/RoamingStorm").visible = false
	get_node("/root/World/FullMapParticles").visible = false
	
func set_inactive():
	$Camera2D.current = false
	get_node("/root/World/Players/" + Server.player_id + "/Camera2D").current = true
	get_node("/root/World/Players/" + Server.player_id + "/Camera2D/UserInterface/Hotbar").visible = true
	get_node("/root/World/RoamingStorm").visible = true
	get_node("/root/World/FullMapParticles").visible = true

func _ready():
	wait_for_map()
	

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
	
func _process(delta):
	if Server.isLoaded:
		player = get_node("/root/World/Players/" + Server.player_id)
		playerIcon.position =  player.position
		playerIcon.scale = adjustedPlayerIconScale($Camera2D.zoom)
		set_direction(player.direction)
		change_label_size()
		rainStorm = get_node("/root/World/RoamingStorm")
		stormIcon.position = rainStorm.position
		
	
	
func change_label_size():
	for x in range(NUM_ROWS):
		for y in range(NUM_COLUMNS):
			get_node(alphabet[y] + str(x+1)).rect_scale = adjustedGridCoordinatesScale($Camera2D.zoom)
	
func adjustedGridCoordinatesScale(zoom):
	var percent_zoomed = zoom / Vector2(1.5, 1.5)
	return Vector2(0.5,0.5) * percent_zoomed
	
func adjustedPlayerIconScale(zoom):
	var percent_zoomed = zoom / Vector2(1.5, 1.5)
	return Vector2(40,40) * percent_zoomed
		
func set_direction(direction):
	match direction:
		"RIGHT":
			playerIcon.rotation_degrees = 0
		"LEFT":
			playerIcon.rotation_degrees = 180
		"DOWN":
			playerIcon.rotation_degrees = 90
		"UP":
			playerIcon.rotation_degrees = -90

func wait_for_map():
	if not Server.generated_map.empty():
		buildMap(Server.generated_map)
	else:
		yield(get_tree().create_timer(1.5), "timeout")
		wait_for_map()
		
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
