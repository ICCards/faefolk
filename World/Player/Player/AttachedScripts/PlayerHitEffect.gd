extends Node2D

var rng = RandomNumberGenerator.new()

var amount

func _ready():
	$Label.text = str(amount)
	rng.randomize()
	$AnimationPlayer.play("Animate" + str(rng.randi_range(1,2)))
	yield($AnimationPlayer, "animation_finished")
	queue_free()
