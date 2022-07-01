extends KinematicBody2D

onready var player = get_node("/root/World/Players/" + Server.player_id)
var rng = RandomNumberGenerator.new()

func _physics_process(delta):
	if position.distance_to(player.position) > 75 and position.distance_to(player.position) < 600:
		$CollisionShape2D.disabled = false
		var velocity = player.global_position - global_position
		if velocity.x > 0:
			$AnimatedSprite.flip_h = false
		else: 
			$AnimatedSprite.flip_h = true
		velocity = move_and_slide(velocity)
	elif position.distance_to(player.position) > 600:
		rng.randomize()
		set_position(player.position + Vector2(rng.randi_range(-80, 80), rng.randi_range(-80, 80)))


