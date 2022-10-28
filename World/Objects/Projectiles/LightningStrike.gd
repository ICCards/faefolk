extends Node2D



func _ready():
	$Hitbox.tool_name = "lightning strike"
	$Hitbox.special_ability = "stun"
	$AnimationPlayer.play("play")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
