extends YSort

onready var Bat = preload("res://World/Enemies/Slime/Bat.tscn")

var nav_node
var count = 0
var cave_chest_id = "level 1, room 2"

var NUM_BATS = 5
var NUM_SLIMES = 2
var NUM_SPIDERS = 2
var NUM_SKELETONS = 2
var is_changing_scene = false


func _ready():
	nav_node = $Navigation2D
	Tiles.cave_wall_tiles = $Tiles/Walls
	Tiles.valid_tiles = $Tiles/ValidTiles
	Server.world = self
	BuildCaveLevel.build()
	Server.isLoaded = true

func advance_up_cave_level():
	if not is_changing_scene:
		BuildCaveLevel.is_player_going_down = false
		Server.player_node.destroy()
		is_changing_scene = true
		for enemy in $Enemies.get_children():
			enemy.destroy()
		SceneChanger.goto_scene("res://World/Caves/Level 1/Cave 1/Cave 1.tscn")

func advance_down_cave_level():
	if not is_changing_scene:
		BuildCaveLevel.is_player_going_down = true
		Server.player_node.destroy()
		is_changing_scene = true
		for enemy in $Enemies.get_children():
			enemy.destroy()
		SceneChanger.goto_scene("res://World/Caves/Level 1/Cave 3/Cave 3.tscn")
	
	
func _on_SpawnBatTimer_timeout():
	if count < NUM_BATS:
		var locs = $Tiles/BatSpawnTiles.get_used_cells()
		locs.shuffle()
		var bat = Bat.instance()
		$Enemies.add_child(bat)
		bat.position = locs[0]*32 + Vector2(16,16)
		count += 1
	