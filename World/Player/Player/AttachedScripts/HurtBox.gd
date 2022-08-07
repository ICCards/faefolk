extends Area2D

onready var hitEffect = preload("res://World/Player/Player/PlayerHitEffect.tscn")
var health_to_subtract 
var rng = RandomNumberGenerator.new()

func _on_HurtBox_area_entered(area):
#	rng.randomize()
#	var health_to_subtract = rng.randi_range(6, 16)
#	PlayerStats.decrease_health(health_to_subtract)
	$AnimationPlayer.play("hit")
	$PlayerHitEffect/Label.text = str(health_to_subtract)
	$PlayerHitEffect/AnimationPlayer.play("Animate" + str(rng.randi_range(1,2)))
	
	
#	var hit = hitEffect.instance()
#	randomize()
#	hit.init(rand_range(8, 12))
#	print("Player pos = " + str(get_parent().global_position))
#	hit.position = get_node("/root/World/Players/" + Server.player_id).position  # get_parent().global_position
#	get_parent().get_parent().add_child(hit)
