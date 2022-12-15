extends Area2D

onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

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
var amount_to_heal = 0
var amount_to_diminish = 0
var regeneration_increment
var poison_increment

func _on_HurtBox_area_entered(area):
	if get_node("../../").state != DYING:
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
				yield($AnimationPlayer, "animation_finished")
				if not get_node("../../Magic").ice_shield_active:
					$CollisionShape2D.set_deferred("disabled", false)
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
			PlayerData.change_health(health_to_add)
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
				get_node("../../PoisonParticles").start_poison_state()
				diminish_HOT(area.name)
				$AnimationPlayer.play("hit")
				get_node("../../Camera2D").player_hit_screen_shake()
				yield($AnimationPlayer, "animation_finished")
				if not get_node("../../Magic").ice_shield_active:
					$CollisionShape2D.set_deferred("disabled", false)
				return
			elif area.name == "Hitbox":
				health_to_subtract = Stats.return_tool_damage(area.tool_name)
			else:
				health_to_subtract = 0
			$AnimationPlayer.play("hit")
			PlayerData.change_health(-health_to_subtract)
			get_node("../../Camera2D").player_hit_screen_shake()
			InstancedScenes.player_hit_effect(-health_to_subtract, get_node("../../").position)
			yield($AnimationPlayer, "animation_finished")
			if not get_node("../../Magic").ice_shield_active:
				$CollisionShape2D.set_deferred("disabled", false)


func diminish_HOT(type):
	match type:
		"poison potion I":
			amount_to_diminish += PlayerData.health_maximum * 0.08
		"poison potion II":
			amount_to_diminish += PlayerData.health_maximum * 0.2
		"poison potion III":
			amount_to_diminish += PlayerData.health_maximum * 0.32
		"SlimeHit":
			amount_to_diminish += PlayerData.health_maximum * 0.08
	poison_increment = int(ceil(amount_to_diminish / 4))
	if int(amount_to_diminish) > 0 and get_node("../../").state != DYING:
		if amount_to_diminish < poison_increment:
			PlayerData.change_health(-amount_to_diminish)
			InstancedScenes.player_hit_effect(-amount_to_diminish, get_node("../../").position)
			amount_to_diminish = 0
		else:
			PlayerData.change_health(-poison_increment)
			InstancedScenes.player_hit_effect(-poison_increment, get_node("../../").position)
			amount_to_diminish -= poison_increment
		$PoisonTimer.start(2)
	

func start_HOT(type):
	match type:
		"regeneration potion I":
			amount_to_heal += (PlayerData.health_maximum - PlayerData.player_data["health"]) / 10
		"regeneration potion II":
			amount_to_heal += (PlayerData.health_maximum - PlayerData.player_data["health"]) / 4
		"regeneration potion III":
			amount_to_heal += (PlayerData.health_maximum - PlayerData.player_data["health"]) / 2
	if amount_to_heal > 0:
		regeneration_increment = int(ceil(amount_to_heal / 4))
		if regeneration_increment == 0:
			regeneration_increment = 1
		if amount_to_heal < regeneration_increment:
			PlayerData.change_health(amount_to_heal)
			InstancedScenes.player_hit_effect(amount_to_heal, get_node("../../").position)
			amount_to_heal = 0
		else:
			PlayerData.change_health(regeneration_increment)
			InstancedScenes.player_hit_effect(regeneration_increment, get_node("../../").position)
			amount_to_heal -= regeneration_increment
		$RegenerationTimer.start()


func _on_PoisonTimer_timeout():
	if int(amount_to_diminish) > 0 and get_node("../../").state != DYING:
		if amount_to_diminish < poison_increment:
			PlayerData.change_health(-amount_to_diminish)
			InstancedScenes.player_hit_effect(-amount_to_diminish, get_node("../../").position)
			amount_to_diminish = 0
			$PoisonTimer.stop()
		else:
			PlayerData.change_health(-poison_increment)
			InstancedScenes.player_hit_effect(-poison_increment, get_node("../../").position)
			amount_to_diminish -= poison_increment


func _on_RegenerationTimer_timeout():
	if int(amount_to_heal) > 0 and get_node("../../").state != DYING:
		if amount_to_heal < regeneration_increment:
			PlayerData.change_health(amount_to_heal)
			InstancedScenes.player_hit_effect(amount_to_heal, get_node("../../").position)
			amount_to_heal = 0
			$RegenerationTimer.stop()
		else:
			PlayerData.change_health(regeneration_increment)
			InstancedScenes.player_hit_effect(regeneration_increment, get_node("../../").position)
			amount_to_heal -= regeneration_increment

var temp = 0
func decrease_energy_or_health_while_sprinting():
	temp += 1
	if temp > 1000:
		temp = 0
		if PlayerData.player_data["energy"] == 0:
			rng.randomize()
			var amt = rng.randi_range(1,3)
			$AnimationPlayer.play("hit")
			InstancedScenes.player_hit_effect(-amt, position)
			PlayerData.change_health(-amt)
		else:
			PlayerData.change_energy(-1)


func play_sound_effect():
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Player/ow.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	sound_effects.play()
