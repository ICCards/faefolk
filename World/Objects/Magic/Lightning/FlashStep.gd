extends AnimatedSprite2D


func _ready():
	frame = 0
	play()
	await self.animation_finished
	frame = 0
	play()
	await self.animation_finished
	queue_free()
