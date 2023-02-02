extends AnimatedSprite



func _ready():
	call_deferred("play")
	yield(self, "animation_finished")
	queue_free()
