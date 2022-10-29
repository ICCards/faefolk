extends KinematicBody2D


var velocity = Vector2(0,0)
var speed = 500
var collided = false
var particles_transform
var debuff

func _physics_process(delta):
	if not collided:
		var collision_info = move_and_collide(velocity.normalized() * delta * speed)

func _ready():
	$Projectile.play("play")
	$Hitbox.tool_name = "fire projectile"
	$Hitbox.knockback_vector = Vector2.ZERO
	$TrailParticles.transform = particles_transform
	$TrailParticles.position += Vector2(0,32)
	yield(get_tree().create_timer(0.2), "timeout")
	if not collided:
		$TrailParticles/Particles.emitting = true
		$TrailParticles/Particles2.emitting = true
		$TrailParticles/Particles3.emitting = true



func _on_Area2D_area_entered(area):
	destroy()

func _on_Timer_timeout():
	if not collided:
		queue_free()

func destroy():
	collided = true
	$Projectile.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$TrailParticles/Particles.emitting = false
	$TrailParticles/Particles2.emitting = false
	$TrailParticles/Particles3.emitting = false
	if debuff:
		$Explosion.show()
		$Explosion.frame = 1
		$Explosion.play("explode")
		$Hitbox/CollisionShape2D.shape.radius = 80
		yield(get_tree().create_timer(0.5), "timeout")
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)
		yield($Explosion, "animation_finished")
		$Explosion.hide()
	else:
		$ExplosionParticles/Explosion.emitting = true
		$ExplosionParticles/Explosion/Shards.emitting = true
		$ExplosionParticles/Explosion/Smoke.emitting = true
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)
		$AnimationPlayer.play("fade out")
		yield($AnimationPlayer, "animation_finished")
	yield(get_tree().create_timer(2.0), "timeout")
	queue_free()
	
