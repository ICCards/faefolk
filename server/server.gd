extends Node

#const DEFAULT_IP = "198.211.104.56"
#const DEFAULT_PORT = 443

const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 65124

# The URL we will connect to
var websocket_url = "ws://"+DEFAULT_IP+":"+str(DEFAULT_PORT)

# Our WebSocketClient instance
var _client = WebSocketClient.new()

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
var world
var map
var generated_map = {}
var player_state = "WORLD"
var day

func _ready():
	# Connect base signals to get notified of connection open, close, and errors.
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	# This signal is emitted when not using the Multiplayer API every time
	# a full packet is received.
	# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	_client.connect("data_received", self, "_on_data")

	# Initiate connection to the given URL.
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)

func _closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("Closed, clean: ", was_clean)
	set_process(false)

func _connected(proto = ""):
	# This is called on connection, "proto" will be the selected WebSocket
	# sub-protocol (which is optional)
	print("Connected with protocol: ", proto)
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.
	#_client.get_peer(1).put_packet("Test packet".to_utf8())
	print("Successfully connected to server")
	var data = {"d":OS.get_system_time_msecs()}
	var message = Util.toMessage("FetchServerTime",data)
	_client.get_peer(1).put_packet(message)
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.autostart = true
	timer.connect("timeout", self, "DetermineLatency")
	self.add_child(timer)
	
func DetermineLatency():
	var data = {"d":OS.get_system_time_msecs()}
	var message = Util.toMessage("DetermineLatency",data)
	_client.get_peer(1).put_packet(message)
	
func action(type,data):
	var value = {"d": data}
	value["t"] = type
	var message = Util.toMessage("action",value)
	_client.get_peer(1).put_packet(message)

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
	var key = map.keys()[mapPartsLoaded]
	var data = {"d":key}
	var value = Util.toMessage("getMap",data)
	print("getting map")
	print(value)
	_client.get_peer(1).put_packet(value)

func _on_data():
	var pkt = _client.get_peer(1).get_packet()
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	var result = Util.jsonParse(pkt)
	match result["n"]:
		("updateState"):
			if world != null:
				world.UpdateWorldState(result["d"])
		("ID"):
			print("got ID")
			player_id = str(result["d"])
			print(player_id)
		("SpawnPlayer"):
			player = result["d"]
		("ReturnServerTime"):
			var client_time = result["d"]["c"]
			var server_time = result["d"]["s"]
			latency = (OS.get_system_time_msecs() - client_time) / 2
			client_clock = server_time + latency
		("ReturnLatency"):
			var client_time = result["d"]
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
		("loadMap"):
			print("loading map")
			var key = map.keys()[mapPartsLoaded]
			print("Loaded " + key)
			map[key] = result["d"]
			mapPartsLoaded = mapPartsLoaded + 1
			if not mapPartsLoaded >= map.keys().size():
				key = map.keys()[mapPartsLoaded]
				var data = {"d":key}
				var message = Util.toMessage("getMap",data)
				_client.get_peer(1).put_packet(message)
			else:
				mapPartsLoaded = 0
				generated_map = map
		("CHANGE_TILE"):
			if isLoaded:
				var data = result["d"]
				world.ChangeTile(data)
		("ReceivedAction"):
			if not player_id == str(result["id"]):
				var message = result["m"]
				match message["t"]:
					"MOVEMENT":
						pass
					#	get_node("/root/PlayerHomeFarm/" + str(player_id)).MovePlayer(position, direction)
					"SWING":
						if isLoaded:
							if player_state == "WORLD":
								get_node("/root/World/Players/" + str(player_id)).Swing(message["tool"], message["d"])
							else:
								if get_node("/root/InsidePlayerHome/Players/").has_node(str(player_id)):
									get_node("/root/InsidePlayerHome/Players/" + str(player_id)).Swing(message["tool"], message["d"])
					"ON_HIT":
						if isLoaded:
							if player_state == "WORLD":
								get_node("/root/World/" + str(result["id"])).PlayEffect(player_id)
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
							get_node("/root/World").PlaceSeedInWorld(result["id"], result["n"], result["l"])

remote func ChangeTile(data):
	if isLoaded:
		get_node("/root/World").ChangeTile(data)

func _process(_delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()
