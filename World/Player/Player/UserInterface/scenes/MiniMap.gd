extends Node2D


onready var miniMap = $Map
var player 
var direction

enum Tiles {
	DIRT,
	GRASS,
	DARK_GRASS,
	WATER,
	BEACH,
	DESERT,
	SNOW
}

func initialize():
	print("mini map camera current")
	$Map/Player/MiniCam.current = true
	
func set_inactive():
	$Map/Player/MiniCam.current = false


func _process(delta):
	player = get_node("/root/World/Players/" + Server.player_id)
	$Map/Player.position =  player.position
	set_direction(player.direction)
	
#func _process(delta):
#	#player = get_node("/root/World/Players/" + Server.player_id)
#	$Map/Player.position = Vector2(500,500)
#	set_direction("DOWN")

func set_direction(direction):
	match direction:
		"RIGHT":
			$Map/Player.rotation_degrees = 0
		"LEFT":
			$Map/Player.rotation_degrees = 180
		"DOWN":
			$Map/Player.rotation_degrees = 90
		"UP":
			$Map/Player.rotation_degrees = -90

#func _ready():
#	print("BUILD MINI MAP")
#	buildMap(Server.generated_map)

func buildMap(map):
	for id in map["dirt"]:
		var loc = map["dirt"][id]
		miniMap.set_cellv(loc, Tiles.DIRT)
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["forest"]:
		var loc = map["forest"][id]
		miniMap.set_cellv(loc , Tiles.GRASS)
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["plains"]:
		var loc = map["plains"][id]
		miniMap.set_cellv(loc , Tiles.DARK_GRASS)
	yield(get_tree().create_timer(0.5), "timeout")
	for id in map["beach"]:
		var loc = map["beach"][id]
		miniMap.set_cellv(loc , Tiles.BEACH)
	for id in map["desert"]:
		var loc = map["desert"][id]
		miniMap.set_cellv(loc , Tiles.DESERT)
	for id in map["snow"]:
		var loc = map["snow"][id]
		miniMap.set_cellv(loc , Tiles.SNOW)
	for x in range(1000):
		for y in range(1000):
			if miniMap.get_cell(x, y) == -1:
				miniMap.set_cellv(Vector2(x,y),Tiles.WATER)

#	for id in map["water"]:
#		var loc = Util.string_to_vector2(map["water"][id])
#		miniMap.set_cellv(loc , Tiles.WATER)
