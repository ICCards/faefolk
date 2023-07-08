extends AnimatedSprite2D



func _ready():
	frame = 0
	play("loop")
	await get_tree().create_timer(10.0).timeout
	queue_free()
