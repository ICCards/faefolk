extends Node2D

var inside_area: bool = false
var is_down_ladder: bool = true

func _ready():
	$HealthBar.hide()
	$HealthBar/Progress.value = 0


func _physics_process(delta):
	if Server.player_node:
		if inside_area and Input.is_action_pressed("action") and Server.player_node.state == 0 and not PlayerData.viewInventoryMode and not PlayerData.interactive_screen_mode and not PlayerData.viewMapMode:
			$HealthBar.show()
			if $HealthBar/Progress.value == 200:
				if is_down_ladder:
					set_physics_process(false)
					advance_down_cave_level()
				else:
					set_physics_process(false)
					advance_up_cave_level()
			$HealthBar/Progress.value += 1
		else:
			if $HealthBar/Progress.value == 0:
				$HealthBar.hide()
				return
			$HealthBar/Progress.value -= 2


func advance_down_cave_level():
	match Server.world.name:
		"Overworld":
			PlayerData.enter_cave_position = Server.player_node.position
			SceneChanger.destroy_current_scene()
			SceneChanger.goto_scene("res://World/Caves/Lobby/lobby.tscn")

func advance_up_cave_level():
	match Server.world.name:
		"Lobby":
			PlayerData.spawn_at_cave_entrance = true
			SceneChanger.destroy_current_scene()
			SceneChanger.goto_scene("res://World/Overworld/Overworld.tscn")


func _on_DetectPlayer_area_entered(area):
	inside_area = true
func _on_DetectPlayer_area_exited(area):
	inside_area = false
