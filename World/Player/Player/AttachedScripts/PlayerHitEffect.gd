extends Node2D

var rng = RandomNumberGenerator.new()

var amount

func init(_amount):
	amount = _amount

func _ready():
	pass
#	$Label.text = str(int(amount))
#	rng.randomize()
#	$AnimationPlayer.play("Animate" + str(rng.randi_range(1,2)))
#	yield($AnimationPlayer, "animation_finished")
#	queue_free()
