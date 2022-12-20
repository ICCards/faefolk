extends Node2D

var poison_increment = 0
var amount_to_diminish = 0

func _physics_process(delta):
	if not get_parent().poisoned:
		return
	$PoisonParticles/P1.direction = -get_parent().velocity
	$PoisonParticles/P2.direction = -get_parent().velocity
	$PoisonParticles/P3.direction = -get_parent().velocity

func start(type):
	start_poison_state()
	match type:
		"poison potion I":
			amount_to_diminish = get_parent().STARTING_HEALTH * 0.08
		"poison arrow":
			amount_to_diminish = get_parent().STARTING_HEALTH * 0.08
		"poison potion II":
			amount_to_diminish = get_parent().STARTING_HEALTH * 0.2
		"poison potion III":
			amount_to_diminish = get_parent().STARTING_HEALTH * 0.32
	poison_increment = int(ceil(amount_to_diminish / 4))
	amount_to_diminish = int(amount_to_diminish)
	while int(amount_to_diminish) > 0 and not get_parent().destroyed:
		if amount_to_diminish < poison_increment:
			get_parent().health -= amount_to_diminish
			InstancedScenes.player_hit_effect(-amount_to_diminish, get_parent().position)
			amount_to_diminish = 0
		else:
			get_parent().health -= poison_increment
			InstancedScenes.player_hit_effect(-poison_increment, get_parent().position)
			amount_to_diminish -= poison_increment
		if get_parent().health <= 0 and not get_parent().destroyed:
			get_parent().destroy()
		else:
			yield(get_tree().create_timer(1.5), "timeout")


func start_poison_state():
	$PoisonedTimer.start(6)
	$PoisonParticles/P1.emitting = true
	$PoisonParticles/P2.emitting = true
	$PoisonParticles/P3.emitting = true
	get_parent().poisoned = true

func stop_poison_state():
	$PoisonParticles/P1.emitting = false
	$PoisonParticles/P2.emitting = false
	$PoisonParticles/P3.emitting = false
	get_parent().poisoned = false


func _on_PoisonedTimer_timeout():
	stop_poison_state()
