extends Node2D



func _ready():
	$Explosion.emitting = true
	$Explosion/Shards.emitting = true
	$Explosion/Smoke.emitting = true
	yield(get_tree().create_timer(2.0), "timeout")
	queue_free()
