extends AnimatedSprite2D


func _ready():
	play()
	await self.animation_finished
	queue_free()
