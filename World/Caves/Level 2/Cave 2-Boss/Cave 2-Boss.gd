extends Node2D

@onready var FireBoss = load("res://World3D/Caves/Bosses/FireBoss.tscn")

var is_changing_scene: bool = false
var nav_node
var cave_chest_id = "level 1, room 10"
var count = 0
var NUM_BATS = 3
var NUM_SLIMES = 3
var NUM_SPIDERS = 3
var NUM_SKELETONS = 3
var map_size = 60


func _ready():
	randomize()
	Server.world = self
	BuildCaveLevel.build()
	BuildCaveLevel.update_navigation()
	spawn_boss()


func spawn_boss():
	if PlayerData.player_data["skill_experience"]["fire"] == 0:
		var boss = FireBoss.instantiate()
		boss.position = Vector2(randf_range(20,25), randf_range(20,25))*32
		$Enemies.add_child(boss)

func advance_up_cave_level(): 
	if not is_changing_scene:
		SceneChanger.advance_cave_level(get_tree().current_scene.filename, false)

func advance_down_cave_level():
	pass
#	if not is_changing_scene:
#		is_changing_scene = true
#		SceneChanger.advance_cave_level(get_tree().current_scene.filename, true)

func _on_SpawnBatTimer_timeout():
	if count < NUM_BATS and not is_changing_scene:
		BuildCaveLevel.spawn_bat()
		count += 1

func _on_UpdateNavigation_timeout():
	BuildCaveLevel.update_navigation()
