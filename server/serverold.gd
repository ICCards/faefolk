extends Node

const DEFAULT_IP = "198.211.104.56"
const DEFAULT_PORT = 45124

#const DEFAULT_IP = "127.0.0.1"
#const DEFAULT_PORT = 65124

var network = NetworkedMultiplayerENet.new()
var selected_IP
var selected_port

var latency = 0
var client_clock = 0
var delta_latency = 0
var decimal_collector : float = 0
var latency_array = []
var isSpawned = false
var local_player_id = 0
var isLoaded = false
var player
var player_id
var mapPartsLoaded = 0
var player_house_position

var map = {}
var generated_map = {}
var player_state = "WORLD"

func _ready():
	_connect_to_server()
	
func _connect_to_server():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	network.create_client(DEFAULT_IP, DEFAULT_PORT)
	get_tree().set_network_peer(network)
	
func _player_connected(id):
	print("New Player " + str(id) + " Connected")
#	if get_node("/root/World").mark_for_despawn.has(id):
#		get_node("/root/World").mark_for_despawn.erase(id)
	
func _player_disconnected(player_id):
	print("Player " + str(player_id) + " Disonnected")
	

func _connected_ok():
	print("Successfully connected to server")
	rpc_id(1, "FetchServerTime", OS.get_system_time_msecs())
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.autostart = true
	timer.connect("timeout", self, "DetermineLatency")
	self.add_child(timer)
	player_id = get_tree().get_network_unique_id()
	print(player_id)
	#rpc_unreliable_id(1, "getMap",Server.map.keys()[mapPartsLoaded])
	
	
	
	
func generate_map():
	map = {
	"dirt":[],
	"grass":[],
	"dark_grass":[],
	"tall_grass":[],
	"water":[],
	"tree":[],
	"ore_large":[],
	"ore":[],
	"log":[],
	"stump":[],
	"flower":[],
	"tile": []
	}
	rpc_unreliable_id(1, "getMap",map.keys()[mapPartsLoaded])
	
	
remote func loadMap(value):
	var key = map.keys()[mapPartsLoaded]
	print("Loaded " + key)
	map[key] = value
	mapPartsLoaded = mapPartsLoaded + 1
	if not mapPartsLoaded >= map.keys().size():
		rpc_unreliable_id(1, "getMap",map.keys()[mapPartsLoaded])
	else:
		mapPartsLoaded = 0
		generated_map = map


func _connected_fail():
	print("Failed to connect")
	

func _server_disconnected():
	print("Server disconnected")
	
remote func SpawnPlayer(_player):
	player = _player
	print("PLAYER " + str(player))
	#get_node("/root/World").spawnPlayer(player)
	#get_node("/root/MainMenu").spawn_player_in_menu(player)

remote func DespawnPlayer(player_id):
	print('despawn player')
	#get_node("/root/World").DespawnPlayer(player_id)
	
#func message_send(message):
#	rpc_unreliable_id(1, "message_send", message)


remote func updateState(state):
	if isLoaded:
		if player_state == "WORLD":
			get_node("/root/World").UpdateWorldState(state)
#		elif player_state == "HOME":
#			get_node("/root/InsidePlayerHome").UpdateWorldState(state)
#


func _physics_process(delta):
	client_clock += int(delta*1000) + delta_latency
	delta_latency -=  delta_latency
	delta_latency += (delta * 1000) - int(delta * 1000)
	if decimal_collector >= 1.00:
		client_clock += 1
		decimal_collector -= 1.00


remote func ReturnServerTime(server_time,client_time):
	latency = (OS.get_system_time_msecs() - client_time) / 2
	client_clock = server_time + latency

func DetermineLatency():
	rpc_id(1,"DetermineLatency", OS.get_system_time_msecs())

remote func ReturnLatency(client_time):
	latency_array.append((OS.get_system_time_msecs() - client_time)/2)
	if latency_array.size() == 9:
		var total_latency = 0
		latency_array.sort()
		var mid_point = latency_array[4]
		for i in range(latency_array.size()-1,-1,-1):
			if latency_array[i] > (2 * mid_point) and latency_array[i] > 20:
				latency_array.remove(i)
			else:
				total_latency += latency_array[i]
		delta_latency = (total_latency / latency_array.size())
		#print("New Latency ", latency)
		latency_array.clear()
	
func action(type,data):
	rpc_unreliable_id(1, "action", type, data)
	
	
remote func ReceivedAction(time,player_id,type,data):
#	print(str(generated_map[data["n"]][data["id"]]["h"]))
	#get_node("/root/World/" + str(data["id"])).PlayEffect(generated_map[data["n"]][data["id"]]["h"], player_id)
	if not player_id == get_tree().get_network_unique_id():
		match type:
			"MOVEMENT":
				pass
			#	get_node("/root/PlayerHomeFarm/" + str(player_id)).MovePlayer(position, direction)
			"SWING":
				if isLoaded:
					if player_state == "WORLD":
						get_node("/root/World/Players/" + str(player_id)).Swing(data["tool"], data["direction"])
					else:
						if get_node("/root/InsidePlayerHome/Players/").has_node(str(player_id)):
							get_node("/root/InsidePlayerHome/Players/" + str(player_id)).Swing(data["tool"], data["direction"])
			"ON_HIT":
				if isLoaded:
					if player_state == "WORLD":
						get_node("/root/World/" + str(data["id"])).PlayEffect(player_id)
#					else:
#						get_node("/root/InsidePlayerHome/" + str(data["id"])).PickUpItem()
			"PLACE_ITEM":
				pass
#				if isLoaded:
#					if player_state == "WORLD":
#						get_node("/root/World").PlaceItemInWorld(data["id"], data["n"], data["l"])
#					else:
#						get_node("/root/InsidePlayerHome").PlaceItemInHouse(data["id"], data["n"], data["l"])
			"PLACE_SEED":
				if isLoaded:
					get_node("/root/World").PlaceSeedInWorld(data["id"], data["n"], data["l"])

				
remote func ChangeTile(data):
	if isLoaded:
		get_node("/root/World").ChangeTile(data)
