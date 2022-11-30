extends YSort


onready var Bat = preload("res://World/Enemies/Slime/Bat.tscn")

var is_changing_scene: bool = false
var nav_node
var cave_chest_id = "level 1, room 9"
var count = 0
var NUM_BATS = 2
var NUM_SLIMES = 2
var NUM_SPIDERS = 1
var NUM_SKELETONS = 2
var map_size = 50


func _ready():
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
		SceneChanger.goto_scene("res://World/Caves/Level 1/Cave 8/Cave 8.tscn")

func advance_down_cave_level():
	if not is_changing_scene:
		BuildCaveLevel.is_player_going_down = true
		Server.player_node.destroy()
		is_changing_scene = true
		for enemy in $Enemies.get_children():
			enemy.destroy()
		SceneChanger.goto_scene("res://World/Caves/Level 1/Cave 10/Cave 10.tscn")
	
func _on_SpawnBatTimer_timeout():
	if count < NUM_BATS:
		var locs = $Tiles/BatSpawnTiles.get_used_cells()
		locs.shuffle()
		var bat = Bat.instance()
		$Enemies.add_child(bat)
		bat.position = locs[0]*32
		count += 1

func _on_UpdateNavigation_timeout():
	update_navigation()
	
func update_navigation():
	for x in range(map_size):
		for y in range(map_size):
			if Tiles.valid_tiles.get_cellv(Vector2(x,y)) != -1:
				$Navigation2D/NavTiles.set_cellv(Vector2(x,y), 0)

