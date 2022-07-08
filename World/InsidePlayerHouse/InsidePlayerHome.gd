extends Node2D


var is_moving_object

onready var Player = preload("res://World/Player/Player/Player.tscn")
onready var Player_template = preload("res://World/Player/PlayerTemplate/PlayerTemplate.tscn")
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
	Server.world = self
	spawnPlayer()
	
func _on_Doorway_area_entered(_area):
	Server.isLoaded = false
	Server.world = null
	SceneChanger.goto_scene("res://World/World/World.tscn")

	
func spawnPlayer():
	print('gettiing player')
	#var player = Server.player_node
	#Server.world.remove_child(player)
	var value = Server.player
	var player = Player.instance()
	player.initialize_camera_limits(Vector2(-50,-30), Vector2(780, 550))
	player.name = str(value["id"])
	player.principal = value["principal"]
	player.direction = "UP"
	player.position = Vector2(190, 430)
	player.character = _character.new()
	player.character.LoadPlayerCharacter(value["c"]) 
	$Players.add_child(player)
#	player.initialize_camera_limits(Vector2(-50,-30), Vector2(780, 550))
#	player.direction = "UP"
#	player.name = Server.player_id #str(value["id"])
#	player.character = _character.new()
#	player.character.LoadPlayerCharacter(value["c"]) 
#	$Players.add_child(player)
#	player.position = Vector2(190, 430)


func initialize_house_objects():
	for i in range(PlayerInventory.player_home.size()):
		var displayHouseObject = DisplaceHouseObject.instance()
		displayHouseObject.init(PlayerInventory.player_home[i][0], PlayerInventory.player_home[i][1])
		add_child(displayHouseObject)
		displayHouseObject.global_position = PlayerInventory.player_home[i][1] * 32 + Vector2(0,160)

#func spawnNewPlayer(player):
#	if not player.empty():
#		if not has_node(str(player["id"])):
#			print("spawning new player")
#			print(player["p"])
#			var new_player = Player_template.instance()
#			new_player.position = (player["p"]) * 32
#			new_player.name = str(player["id"])
#			new_player.character = _character.new()
#			new_player.character.LoadPlayerCharacter(player["c"]) 
#			$Players.add_child(new_player)

func UpdateWorldState(world_state):					
	if world_state["t"] > last_world_state:
		get_node("Players/" + Server.player_id + "/Camera2D/UserInterface/CurrentTime").update_time(int(world_state["time_elapsed"]))


