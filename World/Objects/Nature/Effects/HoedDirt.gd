extends AnimatedSprite2D



func _ready():
	call_deferred("play")
	await self.animation_finished
	queue_free()
