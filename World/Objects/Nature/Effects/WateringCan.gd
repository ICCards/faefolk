extends AnimatedSprite



func _ready():
	start()


func start():
	play()
	yield(self, "animation_finished")
	queue_free()
