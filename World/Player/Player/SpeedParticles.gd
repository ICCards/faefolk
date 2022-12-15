extends Node2D


func _physics_process(delta):
	$P1.direction = -get_parent().velocity
	$P2.direction = -get_parent().velocity
	$P3.direction = -get_parent().velocity

func start_speed_buff(length):
	get_parent().speed_buff_active = true
	$P1.emitting = true
	$P2.emitting = true
	$P3.emitting = true
	if $SpeedStateTimer.time_left == 0:
		$SpeedStateTimer.start(length)
	else:
		$SpeedStateTimer.start(length+$SpeedParticles/SpeedStateTimer.time_left)

func _on_SpeedStateTimer_timeout():
	stop_speed_buff()

func stop_speed_buff():
	get_parent().speed_buff_active = false
	$P1.emitting = false
	$P2.emitting = false
	$P3.emitting = false
