extends AnimatedSprite



func _ready():
	frame = 0
	playing = true
	yield(self, "animation_finished")
	frame = 0
	playing = true
	yield(self, "animation_finished")
	queue_free()
