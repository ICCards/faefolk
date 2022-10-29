extends KinematicBody2D


var velocity = Vector2(1,0)
var speed = 350
var collided = false

func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)

func _ready():
	$Hitbox.tool_name = "tornado spell"
	$AnimatedSprite.play("anim")
	$Trail.emitting = true
	yield($AnimatedSprite, "animation_finished")
	$Trail.emitting = false
	yield(get_tree().create_timer(2.0), "timeout")
	queue_free()

