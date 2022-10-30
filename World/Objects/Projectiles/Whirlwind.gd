extends Node2D


func _ready():
	$Hitbox.tool_name = "whirlwind spell"
	$AnimationPlayer.play("play")
	yield($AnimationPlayer, "animation_finished")
	queue_free()


func fade_out():
	$Tween.interpolate_property($AnimatedSprite, "modulate:a", 1.0, 0.0, 0.5, 3, 1)
	$Tween.start()
