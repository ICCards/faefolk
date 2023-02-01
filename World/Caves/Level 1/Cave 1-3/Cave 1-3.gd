extends YSort

var is_changing_scene: bool = false
var nav_node
var count = 0
var cave_chest_id = "level 1, room 3"

var NUM_BATS = 4
var NUM_SLIMES = 3
var NUM_SPIDERS = 3
var NUM_SKELETONS = 3
var map_size = 50

func _ready():
	Server.world = self
	BuildCaveLevel.build()
	BuildCaveLevel.update_navigation()

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

func _on_UpdateNavigation_timeout():
	BuildCaveLevel.update_navigation()

