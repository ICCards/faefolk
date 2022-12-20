extends Node



func start(timer_length):
	get_parent().frozen = true
	$FrozenTimer.start(timer_length)


func _on_FrozenTimer_timeout():
	get_parent().frozen = false
