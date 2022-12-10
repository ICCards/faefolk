extends Node2D

onready var Player = load("res://World/Player/Player/Player.tscn")
onready var _character = load("res://Global/Data/Characters.gd")

var direction = "down"


func _ready():
	set_direction()
	spawnPlayer()
	
	
func set_direction():
	match direction:
		"down":
			$Tent.rotation_degrees = 0
		"left":
			$Tent.rotation_degrees = 90
		"up":
			$Tent.rotation_degrees = 180
		"right":
			$Tent.rotation_degrees = 270
			
	
func spawnPlayer():
	var value = Server.player
	var player = Player.instance()
	player.initialize_camera_limits(Vector2(-50,-30), Vector2(780, 550))
	player.name = Server.player_id
	player.position = returnPlayerSpawnPoint()
	player.character = _character.new()
	player.character.LoadPlayerCharacter(Server.character) 
	$Players.add_child(player)
	
func returnPlayerSpawnPoint():
	match direction:
		"down":
			return Vector2(519,296)
		"left":
			return Vector2(-60,0)
		"up":
			return Vector2(0,-60)
		"right":
			return Vector2(60,0)

func _on_ExitTentArea_area_entered(area):
	SceneChanger.goto_scene("res://World/World/World.tscn")
