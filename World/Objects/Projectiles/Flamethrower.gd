extends Node2D


func _ready():
	$Area2D.tool_name = "flamethrower"
	$AnimationPlayer.play("play")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
