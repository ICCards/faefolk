extends KinematicBody2D


var velocity = Vector2(0,0)
var speed = 350
var collided = false

func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)

func _ready():
	if velocity.x < 0:
		$AnimatedSprite.flip_h = true
	$Hitbox.tool_name = "tornado spell"
	$AnimatedSprite.play("anim")
	yield($AnimatedSprite, "animation_finished")
	queue_free()

