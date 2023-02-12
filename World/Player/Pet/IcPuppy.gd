extends CharacterBody2D


var rng = RandomNumberGenerator.new()
var direction = "down"

func _physics_process(delta):
	if Server.player_node:
		if position.distance_to(Server.player_node.position) > 75 and position.distance_to(Server.player_node.position) < 600:
			$CollisionShape2D.disabled = false
			var velocity = Server.player_node.global_position - global_position
			if abs(velocity.y) > abs(velocity.x):
				$AnimatedSprite2D.offset = Vector2(0, 0)
				if velocity.y > 0:
					direction = "down"
				else: 
					direction = "up"
				$AnimatedSprite2D.play("walk " + direction)
			else: 
				$AnimatedSprite2D.offset = Vector2(0, -6)
				if velocity.x > 0:
					direction = "right"
					$AnimatedSprite2D.play("walk right")
					$AnimatedSprite2D.flip_h = false
				else: 
					direction = "left"
					$AnimatedSprite2D.play("walk right")
					$AnimatedSprite2D.flip_h = true
			set_velocity(velocity)
			move_and_slide()
			velocity = velocity
		elif position.distance_to(Server.player_node.position) > 600:
			rng.randomize()
			set_position(Server.player_node.position + Vector2(rng.randi_range(-80, 80), rng.randi_range(-80, 80)))
		else: 
			$AnimatedSprite2D.playing = false
#			if direction == "left":
#				#$AnimatedSprite2D.flip_h = true
#				#$AnimatedSprite2D.play("idle right")
#
#			else: 
#				#$AnimatedSprite2D.play("idle " + direction)



func _on_VisibilityNotifier2D_viewport_entered(viewport):
	$AnimatedSprite2D.playing = true


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	$AnimatedSprite2D.playing = false
