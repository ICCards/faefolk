extends KinematicBody2D


var velocity = Vector2(1,0)
var speed = 350
var collided = false
var debuff

func _physics_process(delta):
	if not collided:
		var collision_info = move_and_collide(velocity.normalized() * delta * speed)

func _ready():
	$Hitbox/CollisionShape2D.shape.radius = 16
	$Particles.emitting = true
	$Particles2.emitting = true
	$Particles3.emitting = true
	$Hitbox.tool_name = "ice projectile"
	$Hitbox.knockback_vector = Vector2.ZERO

func destroy():
	collided = true
	$Projectile.hide()
	$Particles.emitting = false
	$Particles2.emitting = false
	$Particles3.emitting = false
	$Hitbox/CollisionShape2D.shape.radius = 80
	$Explosion.show()
	$Explosion.playing = true
	yield(get_tree().create_timer(4.0), "timeout")
	queue_free()
	

func _on_Hitbox_area_entered(area):
	destroy()
