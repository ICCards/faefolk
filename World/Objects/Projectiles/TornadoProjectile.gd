extends KinematicBody2D


var velocity = Vector2(1,0)
var speed = 350
var collided = false
var particles_transform

func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)

func _ready():
	$Hitbox.tool_name = "tornado spell"
	$AnimatedSprite.play("anim")
	set_particles()
	yield($AnimatedSprite, "animation_finished")
	stop_trail_particles()
	$AnimatedSprite.hide()
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	yield(get_tree().create_timer(4.0), "timeout")
	queue_free()

func set_particles():
	$TornadoParticles/P1.emitting = true
	$TornadoParticles/P2.emitting = true
	$TornadoParticles/P3.emitting = true
	$TrailParticles.position += Vector2(0,32)
	$TrailParticles/P1.transform = particles_transform
	$TrailParticles/P2.transform = particles_transform
	$TrailParticles/P3.transform = particles_transform
	$TrailParticles/P1.emitting = true
	$TrailParticles/P2.emitting = true
	$TrailParticles/P3.emitting = true
	
func stop_trail_particles():
	$TornadoParticles/P1.emitting = false
	$TornadoParticles/P2.emitting = false
	$TornadoParticles/P3.emitting = false
	$TrailParticles/P1.emitting = false
	$TrailParticles/P2.emitting = false
	$TrailParticles/P3.emitting = false
