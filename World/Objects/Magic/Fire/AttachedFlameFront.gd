extends AnimatedSprite



func _ready():
	frame = 0
	playing = true
	yield(get_tree().create_timer(10.0), "timeout")
	queue_free()
