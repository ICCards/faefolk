extends YSort


onready var Bat = load("res://World/Enemies/Slime/Bat.tscn")

var is_changing_scene: bool = false
var nav_node
var cave_chest_id = "level 1, room 7"
var count = 0
var NUM_BATS = 3
var NUM_SLIMES = 3
var NUM_SPIDERS = 0
var NUM_SKELETONS = 3
var map_size = 50


func _ready():
	Server.world = self
	BuildCaveLevel.build()
	Server.isLoaded = true
	BuildCaveLevel.update_navigation()

func advance_up_cave_level():
	if not is_changing_scene:
		PlayerData.spawn_at_cave_exit = true
		Server.player_node.destroy()
		is_changing_scene = true
		for node in $Projectiles.get_children():
			node.destroy()
		for node in $Enemies.get_children():
			node.destroy()
		SceneChanger.goto_scene("res://World/Caves/Level 1/Cave 1-6/Cave 1-6.tscn")

func advance_down_cave_level():
	if not is_changing_scene:
		PlayerData.spawn_at_cave_entrance = true
		Server.player_node.destroy()
		is_changing_scene = true
		for node in $Projectiles.get_children():
			node.destroy()
		for node in $Enemies.get_children():
			node.destroy()
		SceneChanger.goto_scene("res://World/Caves/Level 1/Cave 1-Boss/Cave 1-Boss.tscn")
	
func _on_SpawnBatTimer_timeout():
	if count < NUM_BATS:
		BuildCaveLevel.spawn_bat()
		count += 1

func _on_UpdateNavigation_timeout():
	BuildCaveLevel.update_navigation()

