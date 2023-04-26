extends Node2D

@onready var PlayerIcon = load("res://World/Map/player_icon.tscn")
@onready var GridSquareLabel = load("res://World/Map/GridSquareLabel.tscn")
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


#func _input(event):
#	if not PlayerData.interactive_screen_mode and not PlayerData.viewInventoryMode and not PlayerData.viewSaveAndExitMode and not PlayerData.chatMode and has_node("/root/Main"):
#		if event.is_action_pressed("open map"):
#			Server.player_node.actions.destroy_placeable_object()
#			#Server.world.get_node("WorldAmbience").call_deferred("hide")
#			initialize()
#		if event.is_action_released("open map"):
#			#Server.world.get_node("WorldAmbience").call_deferred("show")
#			set_inactive()
#			Server.player_node.call_deferred("set_held_object")

func initialize():
	show()
	PlayerData.viewMapMode = true
	Server.player_node.get_node("Camera2D").enabled = false
	$Camera2D.enabled = true
	Server.player_node.user_interface.get_node("Hotbar").call_deferred("hide") 
	Server.player_node.user_interface.get_node("CombatHotbar").call_deferred("hide")
#	for player in get_node("../Players").get_children():
#		if player.name != "MultiplayerSpawner":
#			add_player_icon(player.name)
	
func add_player_icon(player_name):
	if not $Map/Players.has_node(str(player_name)):
		var playerIcon = PlayerIcon.instantiate()
		playerIcon.name = player_name
		$Map/Players.add_child(playerIcon)

func set_inactive():
	hide()
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
	
#func _physics_process(delta):
#	if is_instance_valid(Server.player_node):
##		playerIcon.position = Server.player_node.position*2
##		playerIcon.scale = adjustedPlayerIconScale($Camera2D.zoom)
#		for player in $Map/Players.get_children():
#			#player.rotation_degrees = return_player_direction(get_node("../Players/"+player.name).direction)
#			player.position = get_node("../Players/"+player.name).position
			#player.scale = adjustedPlayerIconScale($Camera2D.zoom)
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


func return_player_direction(dir):
	match dir:
		"RIGHT":
			return 0
		"LEFT":
			return 180
		"DOWN":
			return 90
		"UP":
			return -90

func buildMap():
	var map = get_parent().world
	for chunk in map:
		for loc in map[chunk]["dirt"]:
			miniMap.set_cell(0,loc,Tiles.DIRT,Vector2i(0,0))
		for loc in map[chunk]["forest"]:
			miniMap.set_cell(0,loc,Tiles.FOREST,Vector2i(0,0))
		for loc in map[chunk]["plains"]:
			miniMap.set_cell(0,loc,Tiles.PLAINS,Vector2i(0,0))
		for loc in map[chunk]["beach"]:
			miniMap.set_cell(0,loc,Tiles.BEACH,Vector2i(0,0))
		for loc in map[chunk]["desert"]:
			miniMap.set_cell(0,loc,Tiles.DESERT,Vector2i(0,0))
		for loc in map[chunk]["snow"]:
			miniMap.set_cell(0,loc,Tiles.SNOW,Vector2i(0,0))
		for loc in map[chunk]["deep_ocean"]:
			miniMap.set_cell(0,loc,Tiles.DEEP_OCEAN,Vector2i(0,0))
	for x in range(MAP_WIDTH):
		for y in range(MAP_HEIGHT):
			if miniMap.get_cell_atlas_coords(0,Vector2i(x,y)) == Vector2i(-1,-1):
				miniMap.set_cell(0,Vector2i(x,y),Tiles.WATER,Vector2i(0,0))
	draw_grid()
