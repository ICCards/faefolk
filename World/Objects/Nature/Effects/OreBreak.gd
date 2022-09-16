extends Node2D

var variety

func _ready():
	start()

func start():
	if variety == "Stone":
		$Particles.modulate = Color("c29c6b")
	$Smoke.play()
	$Particles.play()
	yield($Particles, "animation_finished")
	queue_free()
