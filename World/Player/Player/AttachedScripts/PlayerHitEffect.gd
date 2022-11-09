extends Node2D

var rng = RandomNumberGenerator.new()

var amount

func _ready():
	if amount > 0:
		modulate = Color("00ff00")
	else:
		modulate = Color("ff0000")
	$Label.text = str(abs(amount))
	rng.randomize()
	$AnimationPlayer.play("Animate" + str(rng.randi_range(1,2)))
	yield($AnimationPlayer, "animation_finished")
	queue_free()
