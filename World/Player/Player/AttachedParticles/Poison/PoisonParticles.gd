extends Node2D

func _physics_process(delta):
	$Parts1.direction = -get_parent().velocity
	$Parts2.direction = -get_parent().velocity
	$Parts3.direction = -get_parent().velocity

func start_poison_state():
	get_parent().running = false
	$PoisonTimer.start()
	get_parent().poisoned = true
	$Parts1.emitting = true
	$Parts2.emitting = true
	$Parts3.emitting = true
	get_parent().composite_sprites.modulate = Color("009000")

func _on_PoisonTimer_timeout():
	stop_poison_state()

func stop_poison_state():
	get_parent().poisoned = false
	$Parts1.emitting = false
	$Parts2.emitting = false
	$Parts3.emitting = false
	get_parent().composite_sprites.modulate = Color("ffffff")
	if Input.is_action_pressed("sprint"):
		get_parent().running = true
