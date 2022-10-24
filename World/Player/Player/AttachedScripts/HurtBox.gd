extends Area2D

var health_to_subtract 
var rng = RandomNumberGenerator.new()

func _on_HurtBox_area_entered(area):
	rng.randomize()
	if area.name == "BearBite":
		health_to_subtract = rng.randi_range(12, 22)
	elif area.name == "BearClaw":
		health_to_subtract = rng.randi_range(4, 12)
	elif area.name == "BoarBite":
		health_to_subtract = rng.randi_range(8, 16)
	elif area.name == "ExplosionArea":
		health_to_subtract = 20
	else:
		health_to_subtract = 0
	PlayerStats.decrease_health(health_to_subtract)
	$AnimationPlayer.play("hit")
	$PlayerHitEffect/Label.text = str(health_to_subtract)
	$PlayerHitEffect/AnimationPlayer.play("Animate" + str(rng.randi_range(1,2)))
