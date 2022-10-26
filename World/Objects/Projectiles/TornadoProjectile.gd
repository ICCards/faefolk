extends KinematicBody2D


var velocity = Vector2(0,0)
var speed = 350
var collided = false

func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)

func _ready():
	if velocity.x < 0:
		$AnimatedSprite.flip_v = true
	$Area2D.tool_name = "tornado spell"
	#$Area2D.knockback_vector = velocity
	$AnimatedSprite.play("anim")
	yield($AnimatedSprite, "animation_finished")
#	$AnimatedSprite.play("middle")
#	yield($AnimatedSprite, "animation_finished")
##	$AnimatedSprite.play("middle")
##	yield($AnimatedSprite, "animation_finished")
#	$AnimatedSprite.play("end")
#	yield($AnimatedSprite, "animation_finished")
	queue_free()


func _on_Area2D_area_entered(area):
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	collided = true
