extends YSort

onready var WindBoss = load("res://World/Caves/Bosses/WindBoss.tscn")

var is_changing_scene: bool = false
var nav_node
var count = 0
var NUM_BATS = 3
var NUM_SLIMES = 2
var NUM_SPIDERS = 2
var NUM_SKELETONS = 2
var map_size = 50

func _ready():
	Server.world = self
	BuildCaveLevel.build()
	Server.isLoaded = true
	BuildCaveLevel.update_navigation()
	spawn_boss()

func advance_up_cave_level(): 
	if not is_changing_scene:
		SceneChanger.advance_cave_level(get_tree().current_scene.filename, false)

func advance_down_cave_level():
	if not is_changing_scene:
		SceneChanger.advance_cave_level(get_tree().current_scene.filename, true)
	
func _on_SpawnBatTimer_timeout():
	if count < NUM_BATS and not is_changing_scene:
		BuildCaveLevel.spawn_bat()
		count += 1

func spawn_boss():
	if PlayerData.player_data["skill_experience"]["wind"] == 0:
		var boss = WindBoss.instance()
		boss.position = Vector2(rand_range(20,40), rand_range(20,40))*32
		$Enemies.add_child(boss)

func _on_UpdateNavigation_timeout():
	BuildCaveLevel.update_navigation()
