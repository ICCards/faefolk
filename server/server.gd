extends Node

const DEFAULT_IP = "wss.faefolk.app/ws"
const DEFAULT_PORT = 65124

#const DEFAULT_IP = "127.0.0.1"
#const DEFAULT_PORT = 65124

# The URL we will connect to
var websocket_url = "wss://"+DEFAULT_IP+":"+str(DEFAULT_PORT)

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
var player = {}
var player_id
var mapPartsLoaded = 0
var player_house_position
var world
var map
var generated_map = {}
var player_state = "WORLD"
var day
var num_day = 1
var username

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
	if value["t"] == "ON_HIT":
		print(data)
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
		("ReceiveMessage"):	
			if world != null:		
				Chat.ReceiveMessage(result["id"], result["d"])
			else:
				Chat.message_history.append([result["id"], result["d"]])
		("updateState"):
			if world != null:
				world.UpdateWorldState(result["d"])
		("ID"):
			print("got ID")
			player_id = str(result["d"])
			print(player_id)
		("SpawnPlayer"):
			print("spawn player called from srever")
			print(result["d"])
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
		("ChangeTile"):
			if isLoaded:
				var data = result["d"]
				world.ChangeTile(data)
		("PLACE_ITEM"):
			var item = result["d"]["item"]
			var id = result["d"]["id"]
			var player = result["id"]
			var loc = Util.string_to_vector2(result["d"]["l"])
			if player_id != str(player):
				match item:
					"seed":
						PlaceObject.place_seed_in_world(id, result["d"]["name"], loc, result["d"]["d"])
					"placable":
						PlaceObject.place_object_in_world(id, result["d"]["name"], loc)
							
										
		("ReceivedAction"):
			if not player_id == str(result["id"]):
				match result["t"]:
					"SWING":
						if isLoaded:
							if player_state == "WORLD":
								get_node("/root/World/Players/" + str(result["id"])).Swing(result["d"]["tool"], result["d"]["direction"])
							
					"ON_HIT":
						if isLoaded:
							if player_state == "WORLD":
								var id = str(result["d"]["id"])
								print("onhit")
								print(result["d"])
								if player_id != str(player):
									if world.has_node(id):
										world.get_node(id).PlayEffect(player_id)

func _process(_delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()
