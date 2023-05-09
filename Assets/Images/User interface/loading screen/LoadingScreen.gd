extends Control


func initialize(time):
	show()
	$Bg.play("play")
	var tween = get_tree().create_tween()
	tween.tween_property($TextureProgressBar,"value",100,time)
	await get_tree().create_timer(time).timeout
	$Bg.stop()
	hide()
