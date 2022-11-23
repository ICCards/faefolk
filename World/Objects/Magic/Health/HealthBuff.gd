extends Node2D



func _ready():
	$Effect.frame = 0
	$Effect.playing = true
	yield($Effect, "animation_finished")
	queue_free()
