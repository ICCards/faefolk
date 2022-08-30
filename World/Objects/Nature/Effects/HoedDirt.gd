extends AnimatedSprite



func _ready():
	play()
	yield(self, "animation_finished")
	queue_free()
