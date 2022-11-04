extends Node2D



func _ready():
	$Hitbox.tool_name = "earthquake"
	$AnimationPlayer.play("play")
	yield($Golem, "animation_finished")
	get_parent().emit_signal("spell_finished")
	queue_free()
