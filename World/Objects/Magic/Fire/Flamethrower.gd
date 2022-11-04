extends Node2D


func _ready():
	$Hitbox.tool_name = "flamethrower"
	$Fire.emitting = true
	$Smoke.emitting = true
	$AnimationPlayer.play("play")
	yield(get_tree().create_timer(2.5), "timeout")
	$Fire.emitting = false
	$Smoke.emitting = false
