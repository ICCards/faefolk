extends KinematicBody2D


var velocity = Vector2(1,0)
var speed = 350
var collided = false
var debuff
var projectile_transform


func _physics_process(delta):
	if not collided:
		var collision_info = move_and_collide(velocity.normalized() * delta * speed)

func _ready():
	$Projectile.transform = projectile_transform
	$TrailParticles.transform = projectile_transform
	$TrailParticles.position += Vector2(0,32)
	$Projectile.position += Vector2(0,32)
	$Projectile.scale = Vector2(2,2)
	$Hitbox.tool_name = "ice projectile"
	$Hitbox.knockback_vector = Vector2.ZERO
	yield(get_tree().create_timer(0.2), "timeout")
	if not collided:
		$TrailParticles/Particles.emitting = true
		$TrailParticles/Particles2.emitting = true
		$TrailParticles/Particles3.emitting = true


func _on_Area2D_area_entered(area):
	destroy()


func destroy():
	collided = true
	$Projectile.hide()
	$TrailParticles/Particles.emitting = false
	$TrailParticles/Particles2.emitting = false
	$TrailParticles/Particles3.emitting = false
	if debuff:
		$Hitbox/CollisionShape2D.shape.radius = 80
		$Explosion.show()
		$Explosion.playing = true
		yield(get_tree().create_timer(1.5), "timeout")
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)
		yield(get_tree().create_timer(2.5), "timeout")
		queue_free()
	else:
		$ExplosionParticles/Explosion.emitting = true
		$ExplosionParticles/Explosion/Shards.emitting = true
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)
		yield(get_tree().create_timer(4.0), "timeout")
		queue_free()


