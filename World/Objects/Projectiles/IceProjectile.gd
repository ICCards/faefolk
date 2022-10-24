extends KinematicBody2D


var velocity = Vector2(0,0)
var speed = 350
var collided = false

func _physics_process(delta):
	if not collided:
		var collision_info = move_and_collide(velocity.normalized() * delta * speed)


func _ready():
	$Area2D.tool_name = "ice spell"
	$Area2D.knockback_vector = Vector2.ZERO


func _on_Area2D_area_entered(area):
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	collided = true
	$AnimatedSprite.play("play")
	yield($AnimatedSprite, "animation_finished")
	queue_free()
