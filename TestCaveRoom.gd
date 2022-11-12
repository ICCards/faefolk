extends YSort


onready var Player = preload("res://World/Player/Player/Player.tscn")
const _character = preload("res://Global/Data/Characters.gd")

var rng = RandomNumberGenerator.new()

func spawnPlayerExample():
	var player = Player.instance()
	player.name = str(get_tree().get_network_unique_id())
	player.character = _character.new()
	player.character.LoadPlayerCharacter("human_male")
	$Players.add_child(player)
	player.spawn_position = Vector2(4*32,4*32)
	player.position =  Vector2(4*32,4*32)
	Server.player_node = player


func _ready():
	Server.world = self
	spawnPlayerExample()
	#set_nav()
	
func set_nav():
	for x in range(80):
		for y in range(80):
			if $Tiles/Walls.get_cellv(Vector2(x,y)) == -1:
				$Navigation2D/NavTiles.set_cellv(Vector2(x,y), 0)


