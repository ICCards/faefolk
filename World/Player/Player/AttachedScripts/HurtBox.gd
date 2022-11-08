extends Area2D

onready var PlayerHitEffect = preload("res://World/Player/Player/AttachedScenes/PlayerHitEffect.tscn")

var health_to_subtract 
var health_to_add
var rng = RandomNumberGenerator.new()

func _on_HurtBox_area_entered(area):
	rng.randomize()
	if area.name == "PotionHitbox":
		if area.tool_name == "health potion":
			health_to_add = 20
		PlayerStats.increase_health(20)
			
		var hit_effect = PlayerHitEffect.instance()
		hit_effect.modulate = Color("00ff00")
		hit_effect.amount = health_to_add
		get_parent().add_child(hit_effect)
	else:
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
		var hit_effect = PlayerHitEffect.instance()
		hit_effect.modulate = Color("ff0000")
		hit_effect.amount = health_to_subtract
		get_parent().add_child(hit_effect)
		$AnimationPlayer.play("hit")
