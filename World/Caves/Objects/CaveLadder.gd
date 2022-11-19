extends Node2D

var inside_area: bool = false
var is_down_ladder: bool = false

func _ready():
	$HealthBar.hide()
	$HealthBar/Progress.value = 0

func _physics_process(delta):
	if inside_area and Input.is_action_pressed("action"):
		$HealthBar.show()
		if $HealthBar/Progress.value == 200:
			if is_down_ladder:
				get_parent().advance_down_cave_level()
			else:
				get_parent().advance_up_cave_level()
		$HealthBar/Progress.value += 1
	else:
		if $HealthBar/Progress.value == 0:
			$HealthBar.hide()
			return
		$HealthBar/Progress.value -= 1


func _on_DetectPlayer_area_entered(area):
	inside_area = true

func _on_DetectPlayer_area_exited(area):
	inside_area = false
