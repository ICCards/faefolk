extends Node2D

func _physics_process(delta):
	$P1.direction = -get_parent().velocity
	$P2.direction = -get_parent().velocity
	$P3.direction = -get_parent().velocity

func start_poison_state():
	get_parent().running = false
	$PoisonTimer.start()
	get_parent().poisoned = true
	$P1.emitting = true
	$P2.emitting = true
	$P3.emitting = true
	get_parent().composite_sprites.modulate = Color("009000")

func _on_PoisonTimer_timeout():
	stop_poison_state()

func stop_poison_state():
	get_parent().poisoned = false
	$P1.emitting = false
	$P2.emitting = false
	$P3.emitting = false
	get_parent().composite_sprites.modulate = Color("ffffff")
	if Input.is_action_pressed("sprint"):
		get_parent().running = true
