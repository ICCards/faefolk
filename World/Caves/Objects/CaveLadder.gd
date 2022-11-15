extends Node2D

var inside_area: bool = false

func _ready():
	$HealthBar.hide()
	$HealthBar/Progress.value = 0

func _physics_process(delta):
	if inside_area:
		$HealthBar.show()
		if $HealthBar/Progress.value == 200:
			get_parent().advance_cave_level()
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
