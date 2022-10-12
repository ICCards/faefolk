extends KinematicBody2D


var velocity = Vector2(-1,0)
var speed = 375
var collided = false

func _physics_process(delta):
	if not collided:
		var collision_info = move_and_collide(velocity.normalized() * delta * speed)

func _ready():
	$Area2D.knockback_vector = velocity
	yield(get_tree().create_timer(2.0), "timeout")
	$AnimationPlayer.play("fade out")
	yield($AnimationPlayer, "animation_finished")
	queue_free()


func _on_Area2D_area_entered(area):
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	collided = true
