extends Node2D



func _ready():
	$Area2D.tool_name = "ice spear"
	$AnimationPlayer.play("play")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
