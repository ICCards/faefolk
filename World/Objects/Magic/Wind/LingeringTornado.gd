extends CharacterBody2D

@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var speed = 100
@export var target: Vector2

func _physics_process(delta):
	position = position.move_toward(target, delta * speed)
	if position == target:
		$TrailParticles/Particles1.emitting = false
		$TrailParticles/Particles2.emitting = false
		$TrailParticles/Particles3.emitting = false

func _ready():
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -20)
	sound_effects.play()
	$AnimatedSprite2D.play("start")
	set_particles()
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("middle")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("middle")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("middle")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("middle")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("middle")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("end")
	fade_out()
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.hide()

func set_particles():
	$TornadoParticles/Particles1.emitting = true
	$TornadoParticles/Particles2.emitting = true
	$TornadoParticles/Particles3.emitting = true
	$TrailParticles/Particles1.direction = -target
	$TrailParticles/Particles2.direction = -target
	$TrailParticles/Particles3.direction = -target
	$TrailParticles/Particles1.emitting = true
	$TrailParticles/Particles2.emitting = true
	$TrailParticles/Particles3.emitting = true
	
func stop_particles():
	$TornadoParticles/Particles1.emitting = false
	$TornadoParticles/Particles2.emitting = false
	$TornadoParticles/Particles3.emitting = false
	$TrailParticles/Particles1.emitting = false
	$TrailParticles/Particles2.emitting = false
	$TrailParticles/Particles3.emitting = false
	
func fade_out():
	stop_particles()
	var tween = get_tree().create_tween()
	tween.tween_property(sound_effects, "volume_db", -80, 2.0)
	tween.tween_property($PointLight2D, "color", Color("00ffffff"), 2.0)
	tween.tween_property($PointLight2D, "energy", 0.0, 2.0)
