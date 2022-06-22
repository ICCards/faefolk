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
	player.initialize_camera_limits(Vector2(-100,-30), Vector2(730, 550))
	#player.initialize_character(value["c"])
	player.direction = "UP"
	player.name = str(value["id"])
	player.character = _character.new()
	player.character.LoadPlayerCharacter(value["c"]) 
	$Players.add_child(player)
	player.position = Vector2(190, 430)
		


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
		var new_day = bool(world_state["day"])
		if Server.day != new_day and Server.isLoaded:
			Server.day = new_day
			PlayerInventory.day_num = int(world_state["day_num"])
			PlayerInventory.season = str(world_state["season"])
			if new_day == false:
				pass
				#get_node("/root/World/Players/" + str(Server.player_id)).set_night()
			else:
				pass
			#	get_node("/root/World/Players/" + str(Server.player_id)).set_day()
			
		last_world_state = world_state["t"]
		world_state_buffer.append(world_state)


