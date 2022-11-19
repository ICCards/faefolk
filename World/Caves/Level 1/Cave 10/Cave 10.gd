extends YSort

onready var WindBoss = preload("res://World/Caves/Bosses/WindBoss.tscn")
onready var Bat = preload("res://World/Enemies/Slime/Bat.tscn")

var is_changing_scene: bool = false
var nav_node
var cave_chest_id = "level 1, room 7"
var count = 0
var NUM_BATS = 3
var NUM_SLIMES = 0
var NUM_SPIDERS = 0
var NUM_SKELETONS = 0


func _ready():
	randomize()
	nav_node = $Navigation2D
	Tiles.cave_wall_tiles = $Tiles/Walls
	Tiles.valid_tiles = $Tiles/ValidTiles
	Server.world = self
	BuildCaveLevel.build()
	Server.isLoaded = true
	yield(get_tree().create_timer(2.0), "timeout")
	spawn_boss()
	
func advance_up_cave_level():
	if not is_changing_scene:
		Server.player_node.destroy()
		is_changing_scene = true
		for enemy in $Enemies.get_children():
			enemy.destroy()
		SceneChanger.goto_scene("res://World/Caves/Level 1/Cave 9/Cave 9.tscn")

func _on_SpawnBatTimer_timeout():
	if count < NUM_BATS:
		var locs = $Tiles/BatSpawnTiles.get_used_cells()
		locs.shuffle()
		var bat = Bat.instance()
		$Enemies.add_child(bat)
		bat.position = locs[0]*32
		count += 1

func spawn_boss():
	var boss = WindBoss.instance()
	boss.position = Vector2(rand_range(20,40), rand_range(20,40))*32
	$Enemies.add_child(boss)

