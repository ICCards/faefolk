extends Node2D


func _ready():
	$Hitbox.tool_name = "whirlwind spell"
	$AnimationPlayer.play("play")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
