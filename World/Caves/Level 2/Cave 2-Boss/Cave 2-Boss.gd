extends YSort


onready var FireBoss = load("res://World/Caves/Bosses/FireBoss.tscn")
onready var Bat = load("res://World/Enemies/Slime/Bat.tscn")

func _ready():
	randomize()
	Server.world = self
	BuildCaveLevel.build()
	Server.isLoaded = true
	update_navigation()
	spawn_boss()


func spawn_boss():
	if PlayerData.player_data["skill_experience"]["wind"] == 0:
		var boss = FireBoss.instance()
		boss.position = Vector2(rand_range(20,25), rand_range(20,25))*32
		$Enemies.add_child(boss)


var is_changing_scene: bool = false
var nav_node
var cave_chest_id = "level 1, room 10"
var count = 0
var NUM_BATS = 3
var NUM_SLIMES = 3
var NUM_SPIDERS = 3
var NUM_SKELETONS = 3
var map_size = 60

func advance_up_cave_level():
	if not is_changing_scene:
		BuildCaveLevel.is_player_going_down = false
		Server.player_node.destroy()
		is_changing_scene = true
		for node in $Projectiles.get_children():
			node.destroy()
		for node in $Enemies.get_children():
			node.destroy()
		SceneChanger.goto_scene("res://World/Caves/Level 2/Cave 2-7/Cave 2-7.tscn")

func advance_down_cave_level():
	pass
#	if not is_changing_scene:
#		BuildCaveLevel.is_player_going_down = true
#		Server.player_node.destroy()
#		is_changing_scene = true
#		for node in $Projectiles.get_children():
#			node.destroy()
#		for node in $Enemies.get_children():
#			node.destroy()
#		SceneChanger.goto_scene("res://World/Caves/Level 2/Cave 10-5/Cave 10-5.tscn")

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
	for x in range(60):
		for y in range(60):
			if Tiles.valid_tiles.get_cellv(Vector2(x,y)) != -1:
				$Navigation2D/NavTiles.set_cellv(Vector2(x,y), 0)
