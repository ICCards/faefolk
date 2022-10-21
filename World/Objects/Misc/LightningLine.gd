extends Line2D



func _ready():
	$AnimationPlayer.play("fade")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
