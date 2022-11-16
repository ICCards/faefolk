extends YSort


onready var Bat = preload("res://World/Enemies/Slime/Bat.tscn")

var is_changing_scene: bool = false
var nav_node
var bat_count = 0
var maximum_bats = 4
var cave_chest_id = "level 1, room 3"
var NUM_SLIMES = 4
var NUM_SPIDERS = 3
var NUM_SKELETONS = 1

func _ready():
	nav_node = $Navigation2D
	Tiles.cave_wall_tiles = $Tiles/Walls
	Tiles.valid_tiles = $Tiles/ValidTiles
	Server.world = self
	BuildCaveLevel.build()
	Server.isLoaded = true

func advance_cave_level():
	if not is_changing_scene:
		Server.player_node.destroy()
		is_changing_scene = true
		for enemy in $Enemies.get_children():
			enemy.destroy()
		yield(get_tree().create_timer(1.0), "timeout")
		SceneChanger.goto_scene("res://World/Caves/Level 1/Cave 4/Cave 4.tscn")
	
func _on_SpawnBatTimer_timeout():
	if bat_count < maximum_bats:
		var locs = $Tiles/BatSpawnTiles.get_used_cells()
		locs.shuffle()
		var bat = Bat.instance()
		$Enemies.add_child(bat)
		bat.position = locs[0]*32
		bat_count += 1
