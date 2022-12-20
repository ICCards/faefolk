extends KinematicBody2D

onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var is_hostile_projectile: bool = false
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
	if is_hostile_projectile:
		$Hitbox.set_collision_mask(128+2048+8+16)
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -20)
	sound_effects.play()
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
	fade_out_sound()
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.hide()
	yield(get_tree().create_timer(3.0), "timeout")
	queue_free()


func destroy():
	if $AnimatedSprite.visible:
		$AnimatedSprite.stop()
		yield(get_tree().create_timer(0.5), "timeout")
		queue_free()
	


func set_particles():
	$TornadoParticles/P1.emitting = true
	$TornadoParticles/P2.emitting = true
	$TornadoParticles/P3.emitting = true
	$TrailParticles.position += Vector2(0,32)
	$TrailParticles/P1.direction = -target
	$TrailParticles/P2.direction = -target
	$TrailParticles/P3.direction = -target
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
	
func fade_out_sound():
	$Tween.interpolate_property(sound_effects, "volume_db", Sounds.return_adjusted_sound_db("sound", -20), -80, 3.0, 1, Tween.EASE_IN, 0)
	$Tween.start()
