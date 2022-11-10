extends YSort


onready var Player = preload("res://World/Player/Player/Player.tscn")
const _character = preload("res://Global/Data/Characters.gd")

var rng = RandomNumberGenerator.new()

func spawnPlayerExample():
	var player = Player.instance()
	player.name = str(get_tree().get_network_unique_id())
	player.character = _character.new()
	player.character.LoadPlayerCharacter("human_male")
	add_child(player)
	player.spawn_position = Vector2(32*32,32*32)
	player.position =  Vector2(6*32,6*32)


func _ready():
	spawnPlayerExample()
	set_nav()
	
func set_nav():
	for x in range(80):
		for y in range(80):
			if $Tiles/Walls.get_cellv(Vector2(x,y)) == -1:
				$Navigation2D/NavTiles.set_cellv(Vector2(x,y), 0)


