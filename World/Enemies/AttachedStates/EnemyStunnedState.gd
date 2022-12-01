extends Node


func start():
	if not get_parent().destroyed:
		get_node("../Electricity").show()
		$StunnedTimer.start()
		get_parent().stunned = true
		get_parent().sound_effects.stop()
		if get_parent().name.substr(1,4) == "Deer" or get_parent().name.substr(1,4) == "Bear" or get_parent().name.substr(1,4) == "Wolf" or get_parent().name.substr(1,4) == "Boar"  or get_parent().name.substr(1,4) == "Skel":
			get_parent().animation_player.stop(false)


func _on_StunnedTimer_timeout():
	get_node("../Electricity").hide()
	get_parent().stunned = false
	get_parent().sound_effects.play()
	if get_parent().name.substr(1,4) == "Deer" or get_parent().name.substr(1,4) == "Bear" or get_parent().name.substr(1,4) == "Wolf" or get_parent().name.substr(1,4) == "Boar" or get_parent().name.substr(1,4) == "Skel":
		get_parent().animation_player.play()
