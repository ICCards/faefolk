extends Node2D


var is_moving_object

onready var Player = preload( "res://World/Player/Player.tscn" )
onready var Player_template = preload( "res://World/Player/PlayerTemplate.tscn" )
const _character = preload("res://Global/Data/Characters.gd")
onready var DisplaceHouseObject = preload("res://World/InsidePlayerHouse/DisplayHouseObject.tscn")

var last_world_state = 0
var world_state_buffer = []
const interpolation_offset = 100
var decorations = []
var mark_for_despawn = []


func _ready(): 
	Server.player_state = "HOME"
	initialize_house_objects()
	Server.isLoaded = true
	spawnPlayer()
	
func _on_Doorway_area_entered(_area):
	Server.isLoaded = false
	SceneChanger.change_scene("res://World/World.tscn", "door")

	
func spawnPlayer():
	print('gettiing player')
	var value = Server.player
	print(value["c"])
	var player = Player.instance()
	#player.initialize_camera_limits(Vector2(0, 0), Vector2(1920, 1080))
	print(str(value["p"]))
	player.initialize_camera_limits(Vector2(-100,-50), Vector2(730, 530))
	#player.initialize_character(value["c"])
	player.name = str(value["id"])
	player.character = _character.new()
	player.character.LoadPlayerCharacter(value["c"]) 
	$Players.add_child(player)
	player.position = Vector2(200, 280)
		


func initialize_house_objects():
	for i in range(PlayerInventory.player_home.size()):
		var displayHouseObject = DisplaceHouseObject.instance()
		displayHouseObject.init(PlayerInventory.player_home[i][0], PlayerInventory.player_home[i][1])
		add_child(displayHouseObject)
		displayHouseObject.global_position = PlayerInventory.player_home[i][1] * 32 + Vector2(0,160)

func spawnNewPlayer(player):
	if not player.empty():
		if not has_node(str(player["id"])):
			print("spawning new player")
			print(player["p"])
			var new_player = Player_template.instance()
			new_player.position = (player["p"]) * 32
			new_player.name = str(player["id"])
			new_player.character = _character.new()
			new_player.character.LoadPlayerCharacter(player["c"]) 
			$Players.add_child(new_player)


func UpdateWorldState(world_state):					
	if world_state["t"] > last_world_state:
		last_world_state = world_state["t"]
		world_state_buffer.append(world_state)

func _physics_process(delta):
	var render_time = OS.get_system_time_msecs() - interpolation_offset
	if world_state_buffer.size() > 1:
		while world_state_buffer.size() > 2 and render_time > world_state_buffer[2].t:
			world_state_buffer.remove(0)
		if world_state_buffer.size() > 2:
			var interpolation_factor = float(render_time - world_state_buffer[1]["t"]) / float(world_state_buffer[2]["t"] - world_state_buffer[1]["t"])
			for player in world_state_buffer[2]["players"].keys():
				if str(player) == "t":
					continue
				if player == Server.player_id:
					continue
				if $Players.has_node(str(player)) and not player == Server.player_id:
					#print(player)
					#print(Server.player_id)
					
					if world_state_buffer[1]["players"].has(player):
						var new_position = lerp(world_state_buffer[1]["players"][player]["p"], world_state_buffer[2]["players"][player]["p"], interpolation_factor)
						$Players.get_node(str(player)).MovePlayer(new_position, world_state_buffer[1]["players"][player]["d"])
				else:
					if not mark_for_despawn.has(player):
						spawnNewPlayer(world_state_buffer[2]["players"][player])

		elif render_time > world_state_buffer[1].t:
			var extrapolation_factor = float(render_time - world_state_buffer[0]["t"]) / float(world_state_buffer[1]["t"] - world_state_buffer[0]["t"]) - 1.00
			for player in world_state_buffer[1]["players"].keys():
				if $Players.has_node(str(player)) and not player == Server.player_id:
					#print("player is me" + player == Server.player_id)
					print(Server.player_id)
					var position_delta = (world_state_buffer[1]["players"][player]["p"] - world_state_buffer[0]["players"][player]["p"])
					var new_position = world_state_buffer[1]["players"][player]["p"] + (position_delta * extrapolation_factor)
					$Players.get_node(str(player)).MovePlayer(new_position, world_state_buffer[1]["players"][player]["d"])


