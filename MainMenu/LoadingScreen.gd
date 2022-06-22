extends Node2D

func _ready():
	$AnimationPlayer.play("animate")

func animate_away():
	$AnimationPlayer.play("remove")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
