extends Area2D

enum {
	MOVEMENT, 
	SWINGING,
	EATING,
	FISHING,
	HARVESTING,
	DYING,
	SLEEPING,
	SITTING,
	MAGIC_CASTING,
	BOW_ARROW_SHOOTING
}

var health_to_subtract 
var health_to_add
var rng = RandomNumberGenerator.new()
var amount_to_heal
var amount_to_diminish

func _on_HurtBox_area_entered(area):
	rng.randomize()
	if area.name == "PotionHitbox":
		if area.tool_name == "health potion I":
			health_to_add = 4
		elif area.tool_name == "health potion II":
			health_to_add = 12
		elif area.tool_name == "health potion III":
			health_to_add = 30
		elif area.tool_name == "destruction potion I":
			$AnimationPlayer.play("hit")
			health_to_add = -Stats.DESTRUCTION_POTION_I
		elif area.tool_name == "destruction potion II":
			$AnimationPlayer.play("hit")
			health_to_add = -Stats.DESTRUCTION_POTION_II
		elif area.tool_name == "destruction potion III":
			$AnimationPlayer.play("hit")
			health_to_add = -Stats.DESTRUCTION_POTION_III
		elif area.tool_name == "regeneration potion I" or area.tool_name == "regeneration potion II" or area.tool_name == "regeneration potion III":
			start_HOT(area.tool_name)
			return
		elif area.tool_name == "poison potion I" or area.tool_name == "poison potion II" or area.tool_name == "poison potion III":
			get_node("../../").start_poison_state()
			$AnimationPlayer.play("hit")
			diminish_HOT(area.tool_name)
			return
		elif area.tool_name == "speed potion I" or area.tool_name == "speed potion II" or area.tool_name == "speed potion III":
			match area.tool_name:
				"speed potion I":
					get_node("../../").start_speed_buff(5)
				"speed potion II":
					get_node("../../").start_speed_buff(15)
				"speed potion III":
					get_node("../../").start_speed_buff(40)
			return
		PlayerStats.change_health(health_to_add)
		InstancedScenes.player_hit_effect(health_to_add, get_node("../../").position)
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
		elif area.name == "WolfClaw":
			health_to_subtract = rng.randi_range(4, 8)
		elif area.name == "WolfBite":
			health_to_subtract = rng.randi_range(8, 12)
		elif area.name == "BatHit":
			health_to_subtract = rng.randi_range(8, 12)
		elif area.name == "SpiderHit":
			health_to_subtract = rng.randi_range(8, 12)
		elif area.name == "SlimeHit":
			get_node("../../").start_poison_state()
			diminish_HOT(area.name)
			$AnimationPlayer.play("hit")
			get_node("../../Camera2D").player_hit_screen_shake()
			return
		elif area.name == "Hitbox" and area.tool_name == "fire projectile":
			health_to_subtract = Stats.FIRE_PROJECTILE_DAMAGE
		else:
			health_to_subtract = 0
		$AnimationPlayer.play("hit")
		PlayerStats.change_health(-health_to_subtract)
		get_node("../../Camera2D").player_hit_screen_shake()
		InstancedScenes.player_hit_effect(-health_to_subtract, get_node("../../").position)


func diminish_HOT(type):
	match type:
		"poison potion I":
			amount_to_diminish = PlayerStats.health_maximum * 0.08
		"poison potion II":
			amount_to_diminish = PlayerStats.health_maximum * 0.2
		"poison potion III":
			amount_to_diminish = PlayerStats.health_maximum * 0.32
		"SlimeHit":
			amount_to_diminish = PlayerStats.health_maximum * 0.08
	var increment = int(ceil(amount_to_diminish / 4))
	while int(amount_to_diminish) > 0 and get_node("../../").state != DYING:
		if amount_to_diminish < increment:
			PlayerStats.change_health(-amount_to_diminish)
			InstancedScenes.player_hit_effect(-amount_to_diminish, get_node("../../").position)
			amount_to_diminish = 0
		else:
			PlayerStats.change_health(-increment)
			InstancedScenes.player_hit_effect(-increment, get_node("../../").position)
			amount_to_diminish -= increment
		yield(get_tree().create_timer(2.0), "timeout")
	

func start_HOT(type):
	match type:
		"regeneration potion I":
			amount_to_heal = (PlayerStats.health_maximum - PlayerStats.health) / 10
		"regeneration potion II":
			amount_to_heal = (PlayerStats.health_maximum - PlayerStats.health) / 4
		"regeneration potion III":
			amount_to_heal = (PlayerStats.health_maximum - PlayerStats.health) / 2
	if amount_to_heal > 0:
		var increment = int(ceil(amount_to_heal / 4))
		if increment == 0:
			increment = 1
		while int(amount_to_heal) > 0:
			if amount_to_heal < increment:
				PlayerStats.change_health(amount_to_heal)
				InstancedScenes.player_hit_effect(amount_to_heal, get_node("../../").position)
				amount_to_heal = 0
			else:
				PlayerStats.change_health(increment)
				InstancedScenes.player_hit_effect(increment, get_node("../../").position)
				amount_to_heal -= increment
			yield(get_tree().create_timer(1.0), "timeout")
