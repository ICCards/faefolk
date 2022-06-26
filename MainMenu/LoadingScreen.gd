extends Node2D



#func _ready():
#	$AnimationPlayer.play("animate")

func set_phase(phase):
	$Control/BuildingWorld.text = phase
	$AnimationPlayer.play("animate")
