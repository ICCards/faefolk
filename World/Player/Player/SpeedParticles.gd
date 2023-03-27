extends Node2D


func _physics_process(delta):
	$Parts1.direction = -get_parent().velocity
	$Parts2.direction = -get_parent().velocity
	$Parts3.direction = -get_parent().velocity

func start_speed_buff(length):
	get_parent().speed_buff_active = true
	$Parts1.emitting = true
	$Parts2.emitting = true
	$Parts3.emitting = true
	if $SpeedStateTimer.time_left == 0:
		$SpeedStateTimer.start(length)
	else:
		$SpeedStateTimer.start(length+$SpeedStateTimer.time_left)

func _on_SpeedStateTimer_timeout():
	stop_speed_buff()

func stop_speed_buff():
	get_parent().speed_buff_active = false
	$Parts1.emitting = false
	$Parts2.emitting = false
	$Parts3.emitting = false
