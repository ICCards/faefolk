extends Area2D

var health_to_subtract 
var rng = RandomNumberGenerator.new()

func _on_HurtBox_area_entered(area):
	rng.randomize()
	if area.name == "BearBite":
		health_to_subtract = rng.randi_range(12, 20)
	elif area.name == "BearClaw":
		health_to_subtract = rng.randi_range(8, 12)
	elif area.name == "BoarBite":
		health_to_subtract = rng.randi_range(8, 16)
	elif area.name == "ExplosionArea":
		health_to_subtract = 20
	elif area.name == "DeerAttack":
		health_to_subtract = rng.randi_range(6, 12)
	else:
		health_to_subtract = 0
	PlayerStats.decrease_health(health_to_subtract)
	get_node("../../Camera2D").player_hit_screen_shake()
	$AnimationPlayer.play("hit")
	get_node("../PlayerHitEffect/Label").text = str(health_to_subtract)
	get_node("../PlayerHitEffect/AnimationPlayer").play("Animate" + str(rng.randi_range(1,2)))
