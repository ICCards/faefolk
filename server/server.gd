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

var map = {
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
}
var generated_map = {}
var chuck1 = {}

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
	rpc_unreliable_id(1, "getMap",Server.map.keys()[mapPartsLoaded])
	
	
	
	
func generate_map():
	rpc_unreliable_id(1, "getMap",Server.map.keys()[mapPartsLoaded])
	
	
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
		#set_chunk(generated_map)
		#get_node("/root/World").buildMap(map)
	
#func set_chunk(_map):
#	for position in map["dirt"]:
#		if positon.x < 75 and position.y < 75:
#			chuck1.append
#	for position in map["dark_grass"]:
#		_set_cell(sand, position.x, position.y, 0)
#		grass.set_cellv(position, 0)
#	for position in map["grass"]:
#		grass.set_cellv(position, 0)
#		darkGrass.set_cellv(position, 0)
#	for position in map["water"]:
#		darkGrass.set_cellv(position, 0)
#		water.set_cellv(position, 0)
#	for position in map["flower"]:
#		if is_valid_position(position):
#			var object = FlowerObject.instance()
#			object.position = sand.map_to_world(position)
#			add_child_below_node($Players,object)
#	for position in map["tree"]:
#		if is_valid_position(position):
#			treeTypes.shuffle()
#			var variety = treeTypes.front()
#			var object = TreeObject.instance()
#			object.initialize(variety, position, true)
#			object.position = sand.map_to_world(position)
#			add_child_below_node($Players,object)
#	for position in map["log"]:
#		if is_valid_position(position):
#			treeTypes.shuffle()
#			var variety = treeTypes.front()
#			var object = StumpObject.instance()
#			object.initialize(variety,position)
#			object.position = sand.map_to_world(position)
#			add_child_below_node($Players,object)
#	for position in map["stump"]:
#		if is_valid_position(position):
#			treeTypes.shuffle()
#			var variety = treeTypes.front()
#			var object = StumpObject.instance()
#			object.initialize(variety,position)
#			object.position = sand.map_to_world(position)
#			add_child_below_node($Players,object)
#	for position in map["ore_large"]:
#		if is_valid_position(position):
#			oreTypes.shuffle()
#			var variety = oreTypes.front()
#			var object = OreObject.instance()
#			object.initialize(variety,position,true)
#			object.position = sand.map_to_world(position)
#			add_child_below_node($Players,object)
#	for position in map["ore"]:
#		if is_valid_position(position):
#			oreTypes.shuffle()
#			var variety = oreTypes.front()
#			var object = SmallOreObject.instance()
#			object.initialize(variety,position)
#			object.position = sand.map_to_world(position)
#			add_child_below_node($Players,object)
#	for position in map["tall_grass"]:
#		if is_valid_position(position):
#			tall_grass_types.shuffle()
#			var variety = tall_grass_types.front()
#			var object = TallGrassObject.instance()
#			object.initialize(variety)
#			object.position = sand.map_to_world(position)
#			add_child_below_node($Players,object)


func _connected_fail():
	print("Failed to connect")
	

func _server_disconnected():
	print("Server disconnected")
	
remote func SpawnPlayer(_player):
	player = _player
	#get_node("/root/World").spawnPlayer(player)
	#get_node("/root/MainMenu").spawn_player_in_menu(player)

remote func DespawnPlayer(player_id):
	print('despawn player')
	#get_node("/root/World").DespawnPlayer(player_id)
	
#func message_send(message):
#	rpc_unreliable_id(1, "message_send", message)


remote func updateState(state):
	if isLoaded:
		get_node("/root/World").UpdateWorldState(state)
		


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
		
		


#remote func ReceiveCharacter(player, player_id):
#	print("Fetched  "+player.character)
#	print("player id  "+str(player_id))
#	if player_id == get_tree().get_network_unique_id():
#		get_node("/root/PlayerHomeFarm/Player").character.LoadPlayerCharacter(player.character) 

#func _getCharacterById(player_id):
	#rpc_id(1, "GetCharacterById", player_id)
	

#func _getCharacter():
	#rpc_id(1,"GetCharacter")
	
#remote func ReceivePlayerSwing(position, direction, tool_name, spawn_time, player_id):
	#print('receive playher swing')
	#if player_id == get_tree().get_network_unique_id():
		#pass
	#else:
		#get_node("/root/PlayerHomeFarm/" + str(player_id)).swing_dict[spawn_time] = {"Position": position, "Direction": direction, "ToolName": tool_name}
	
func action(type,data):
	rpc_unreliable_id(1, "action", type, data)
	
remote func ReceivedAction(time,player_id,type,data):
	if not player_id == get_tree().get_network_unique_id():
		match type:
			"MOVEMENT":
				pass
			#	get_node("/root/PlayerHomeFarm/" + str(player_id)).MovePlayer(position, direction)
			"SWING":
				print(player_id)
				print(type)
				print(data)
