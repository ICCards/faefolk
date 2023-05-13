extends Control


func initialize(time):
	if Server.world.has_node("InitLoadScreen"):
		Server.world.get_node("InitLoadScreen").queue_free()
	show()
	$Bg.play("play")
	var tween = get_tree().create_tween()
	tween.tween_property($TextureProgressBar,"value",100,time)
	await get_tree().create_timer(time).timeout
	$Bg.stop()
	hide()
