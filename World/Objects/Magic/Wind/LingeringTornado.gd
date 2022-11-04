extends KinematicBody2D


var velocity = Vector2(0,0)
var speed = 350
var target 
var particles_transform

func _physics_process(delta):
	position = position.move_toward(target, delta * speed)
	if position == target:
		$TrailParticles/P1.emitting = false
		$TrailParticles/P2.emitting = false
		$TrailParticles/P3.emitting = false

func _ready():
	$Hitbox.tool_name = "lingering tornado"
	$AnimationPlayer.play("play")
	$AnimatedSprite.play("start")
	set_particles()
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("middle")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("middle")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("middle")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("middle")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("middle")
	yield($AnimatedSprite, "animation_finished")
	$Hitbox.queue_free()
	$AnimatedSprite.play("end")
	stop_trail_particles()
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.hide()
	yield(get_tree().create_timer(3.0), "timeout")
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
