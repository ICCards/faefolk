extends KinematicBody2D


var velocity = Vector2(0,0)
var speed = 500
var collided = false

func _physics_process(delta):
	if not collided:
		var collision_info = move_and_collide(velocity.normalized() * delta * speed)

func _ready():
	$AnimatedSprite.play("play")
	$Area2D.tool_name = "fire projectile"
	$Area2D.knockback_vector = Vector2.ZERO

func _on_Area2D_area_entered(area):
	collided = true
	destroy()

func _on_Timer_timeout():
	destroy()

func destroy():
	$AnimationPlayer.play("fade out")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
	
