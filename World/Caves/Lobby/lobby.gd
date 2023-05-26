extends Node2D

var world = {}
var server_data = {}
var is_changing_scene = false

const PORT = 65124
const URL = "localhost" #"157.245.88.190"
var enet_peer = ENetMultiplayerPeer.new()

@onready var CaveLight = load("res://World/Caves/Objects/CaveLight.tscn")


func _ready():
	initialize()
	Server.world = self
	
	
func initialize():
	init_client()
	set_cave_lights()
	
func init_client():
	enet_peer.create_client(URL,PORT)
	multiplayer.multiplayer_peer = enet_peer
	
	
func set_cave_lights():
	for loc in $TerrainTiles/Decoration.get_used_cells(0):
		var caveLight = CaveLight.instantiate()
		if $TerrainTiles/Decoration.get_cell_atlas_coords(0,loc) == Vector2i(53,26): 
			caveLight.type = "red"
		elif $TerrainTiles/Decoration.get_cell_atlas_coords(0,loc) == Vector2i(54,26): 
			caveLight.type = "yellow"
		elif $TerrainTiles/Decoration.get_cell_atlas_coords(0,loc) == Vector2i(55,26): 
			caveLight.type = "blue"
		$LightObjects.add_child(caveLight)
		caveLight.position = loc*16 + Vector2i(8,8)

@rpc
func send_server_data(data): 
	print("GOT SERVER DATA")
	server_data = data["server_data"]
