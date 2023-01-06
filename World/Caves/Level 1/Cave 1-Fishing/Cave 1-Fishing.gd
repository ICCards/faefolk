extends YSort

var is_changing_scene: bool = false

var NUM_BATS = 0
var NUM_SLIMES = 0
var NUM_SPIDERS = 0
var NUM_SKELETONS = 0
var map_size = 50
var nav_node

func _ready():
	randomize()
	Server.world = self
	BuildCaveLevel.build()
	Server.isLoaded = true

func advance_up_cave_level():
	if not is_changing_scene:
		SceneChanger.goto_scene("res://World/Caves/Level 1/Cave 1-Boss/Cave 1-Boss.tscn")

func advance_down_cave_level():
	if not is_changing_scene:
		SceneChanger.goto_scene("res://World/Caves/Level 2/Cave 2-1/Cave 2-1.tscn")



