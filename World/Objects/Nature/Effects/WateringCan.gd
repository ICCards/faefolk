extends AnimatedSprite2D



func _ready():
	play("play")
	await self.animation_finished
	call_deferred("queue_free")
