extends Control

#func _ready():
#	$AnimationPlayer.play("animate")
#
#func set_phase(phase):
#	$Control/BuildingWorld.text = phase
#	$AnimationPlayer.play("animate")


func initialize(time):
	print("INIT LOADING SCREEN")
	show()
	$Bg.play("play")
	var tween = get_tree().create_tween()
	tween.tween_property($TextureProgressBar,"value",100,time)
	await get_tree().create_timer(time).timeout
	$Bg.stop()
	hide()
