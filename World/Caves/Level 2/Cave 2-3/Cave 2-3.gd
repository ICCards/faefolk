extends YSort

onready var Bat = load("res://World/Enemies/Slime/Bat.tscn")

var is_changing_scene: bool = false
var nav_node
var count = 0
var NUM_BATS = 6
var NUM_SLIMES = 4
var NUM_SPIDERS = 4
var NUM_SKELETONS = 5
var map_size = 60

func _ready():
	Server.world = self
	BuildCaveLevel.build()
	Server.isLoaded = true
	update_navigation()

func advance_up_cave_level():
	if not is_changing_scene:
		BuildCaveLevel.is_player_going_down = false
		Server.player_node.destroy()
		is_changing_scene = true
		for node in $Projectiles.get_children():
			node.destroy()
		for node in $Enemies.get_children():
			node.destroy()
		SceneChanger.goto_scene("res://World/Caves/Level 2/Cave 2-2/Cave 2-2.tscn")

func advance_down_cave_level():
	if not is_changing_scene:
		BuildCaveLevel.is_player_going_down = true
		Server.player_node.destroy()
		is_changing_scene = true
		for node in $Projectiles.get_children():
			node.destroy()
		for node in $Enemies.get_children():
			node.destroy()
		SceneChanger.goto_scene("res://World/Caves/Level 2/Cave 2-4/Cave 2-4.tscn")
	 
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


