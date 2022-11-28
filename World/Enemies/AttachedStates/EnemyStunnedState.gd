extends Node


func start():
	if not get_parent().destroyed:
		get_node("../Electricity").show()
		$StunnedTimer.start()
		get_parent().stunned = true


func _on_StunnedTimer_timeout():
	get_node("../Electricity").hide()
	get_parent().stunned = false
