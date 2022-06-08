extends Node

const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 3234

var network = NetworkedMultiplayerENet.new()
var selected_IP
var selected_port

var latency = 0
var client_clock = 0
var delta_latency = 0
var decimal_collector : float = 0
var latency_array = []

var local_player_id = 0
sync var players = {}
sync var player_data = {}

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func _physics_process(delta):
    client_clock += int(delta*1000) + delta_latency
    delta_latency -= delta
    if decimal_collector >= 1.00:
        client_clock += 1
        decimal_collector -= 1.00
	
func _connect_to_server():
	get_tree().connect("connected_to_server", self, "_connected_ok")
	network.create_client(selected_IP, selected_port)
	get_tree().set_network_peer(network)
	
func _player_connected(id):
	print("Player: " + str(id) + " Connected")
	
func _player_disconnected(id):
	print("Player: " + str(id) + " Disconnected")
	if get_tree().get_root().has_node("World"):
		get_tree().get_root().get_node("World").delete_player(id)
	
func _connected_ok():
    print("Successfully connected to server")
    rpc_id(1, "FetchServerTime", OS.get_system_time_msecs())
    var timer = Timer.new()
    timer.wait_time = 0.5
    timer.autostart = true
    timer.connect("timeout", self, "DetermineLatency")
    self.add_child(timer)
	
func _connected_fail():
	print("Failed to connect")
	
func _server_disconnected():
	print("Server Disconnected")

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
        print("New Latency ", latency)
        print("Delta Latency ", delta_latency)
        latency_array.clear()