extends Node2D

var rng = RandomNumberGenerator.new()

var amount
var is_player_hit: bool = false

func _ready():
	if amount > 0:
		modulate = Color("00ff00")
	else:
		if not is_player_hit:
			modulate = Color("ff0000")
	$Label.text = str(abs(amount))
	rng.randomize()
	$AnimationPlayer.play("Animate" + str(rng.randi_range(1,2)))
	await $AnimationPlayer.animation_finished
	queue_free()
