extends YSort

var is_changing_scene: bool = false

var NUM_BATS = 0
var NUM_SLIMES = 0
var NUM_SPIDERS = 0
var NUM_SKELETONS = 0
var map_size = 50
var nav_node

func _ready():
	Server.world = self
	BuildCaveLevel.build()
	Server.isLoaded = true
	BuildCaveLevel.update_navigation()

func advance_up_cave_level(): 
	if not is_changing_scene:
		SceneChanger.advance_cave_level(get_tree().current_scene.filename, false)

func advance_down_cave_level():
	if not is_changing_scene:
		SceneChanger.advance_cave_level(get_tree().current_scene.filename, true)
