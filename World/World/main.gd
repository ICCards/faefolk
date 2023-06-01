extends Node2D


const PORT = 65124
const URL = "localhost" #"157.245.88.190"
var enet_peer = ENetMultiplayerPeer.new()

var terrain = {
	"ocean": [],
	"deep_ocean": [],
	"plains": [],
	"forest": [],
	"desert": [],
	"dirt": [],
	"snow": [],
	"beach":[],
	"wet_sand":[],
}
var world = {}
var server_data = {}

var connected_peer_ids = []
var is_changing_scene = false


func _ready():
	init_world()

var counter = 0

func convertArrayToVector(value):
	var newArray = [];
	for loc in value:
		var vec = str_to_var("Vector2i" + loc)
		newArray.append(vec)
	return newArray

func get_world_data(result, response_code, headers, body):
	enet_peer.create_client(URL,PORT)
	multiplayer.multiplayer_peer = enet_peer
	await get_tree().create_timer(1.0).timeout
	
	print("GOT TERRAIN DATA FROM HTTP")
	var data = JSON.parse_string(body.get_string_from_utf8())
	terrain.snow = convertArrayToVector(data.terrain.snow)
	terrain.desert  = convertArrayToVector(data.terrain.desert)
	terrain.forest = convertArrayToVector(data.terrain.forest)
	terrain.plains = convertArrayToVector(data.terrain.plains)
	terrain.dirt = convertArrayToVector(data.terrain.dirt)
	terrain.wet_sand = convertArrayToVector(data.terrain.wet_sand)
	terrain.ocean = convertArrayToVector(data.terrain.ocean)
	terrain.deep_ocean = convertArrayToVector(data.terrain.deep_ocean)
	terrain.beach = convertArrayToVector(data.terrain.beach)

	$WorldBuilder/BuildTerrain.initialize()
	
#	$WorldBuilder/SpawnAnimal.initialize()

@rpc
func send_server_data(data): 
	print("GOT SERVER DATA")
	server_data = data["server_data"]

func init_world():
	print("INIT WORLD")
	Server.world = self
	set_map_tiles()
	set_valid_tiles()
	initialize_empty_world_data()
	$HTTPRequest.request_completed.connect(get_world_data)
	$HTTPRequest.request("http://"+URL+":8080/getData")
#	enet_peer.create_client(URL,PORT)
#	multiplayer.multiplayer_peer = enet_peer
	
	#$WorldMap.buildMap()

func initialize_empty_world_data():
	for column in range(12):
		for row in ["A","B","C","D","E","F","G","H","I","J","K","L"]:
			world[row+str(column+1)] = {
				"tree": {},
				"stump": {},
				"log": {},
				"ore_large": {},
				"ore": {},
				"tall_grass": {},
				"forage": {},
				"animal": {},
				"crop": {},
				"tile": {},
				"placeable": {}}


func set_valid_tiles():
	for x in range(1000):
		for y in range(1000):
			$TerrainTiles/ValidTiles.set_cell(0,Vector2(x,y),0,Constants.VALID_TILE_ATLAS_CORD,0)


func set_map_tiles():
	Tiles.valid_tiles = $TerrainTiles/ValidTiles
	Tiles.hoed_tiles = $FarmingTiles/HoedTiles
	Tiles.watered_tiles = $FarmingTiles/WateredTiles
	Tiles.ocean_tiles = $TerrainTiles/ShallowOcean
	Tiles.deep_ocean_tiles = $TerrainTiles/DeepOcean
	Tiles.dirt_tiles = $TerrainTiles/Dirt
	Tiles.wall_tiles = $BuildingTiles/WallTiles
	Tiles.foundation_tiles = $BuildingTiles/FoundationTiles
	Tiles.object_tiles = $BuildingTiles/ObjectTiles
	Tiles.wet_sand_tiles = $TerrainTiles/WetSand
	Tiles.forest_tiles = $TerrainTiles/Forest




