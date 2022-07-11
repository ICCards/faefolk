extends KinematicBody2D

onready var player = get_node("/root/World/Players/" + Server.player_id)
var rng = RandomNumberGenerator.new()
var direction = "down"

func _ready():
	$AnimatedSprite.frames = Images.randomKitty

func _physics_process(delta):
	if position.distance_to(player.position) > 75 and position.distance_to(player.position) < 600:
		$CollisionShape2D.disabled = false
		var velocity = player.global_position - global_position
		if abs(velocity.y) > abs(velocity.x):
			$AnimatedSprite.offset = Vector2(0, 0)
			if velocity.y > 0:
				direction = "down"
			else: 
				direction = "up"
			$AnimatedSprite.play("walk " + direction)
		else: 
			$AnimatedSprite.offset = Vector2(0, -6)
			if velocity.x > 0:
				direction = "right"
				$AnimatedSprite.play("walk right")
				$AnimatedSprite.flip_h = false
			else: 
				direction = "left"
				$AnimatedSprite.play("walk right")
				$AnimatedSprite.flip_h = true
		velocity = move_and_slide(velocity)
	elif position.distance_to(player.position) > 600:
		rng.randomize()
		set_position(player.position + Vector2(rng.randi_range(-80, 80), rng.randi_range(-80, 80)))
	else: 
		if direction == "left":
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("idle right")
		else: 
			$AnimatedSprite.play("idle " + direction)



func _on_VisibilityNotifier2D_viewport_entered(viewport):
	print('entered')
	$AnimatedSprite.playing = true


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	print('exited')
	$AnimatedSprite.playing = false
