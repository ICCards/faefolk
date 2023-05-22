extends CharacterBody2D

var speed = 100
@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var collided = false
var is_hostile_projectile: bool = false

@export var sync_velocity: Vector2

var last_pos: Vector2

func _ready():
	last_pos = position
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -20)
	sound_effects.play()
	set_particles()
	$AnimatedSprite2D.play("start")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("middle")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("end")
	await $AnimatedSprite2D.animation_finished
	call_deferred("fade_out")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.hide()


func _physics_process(delta):
	move_and_collide(sync_velocity * delta * speed)

func set_particles():
	$TornadoParticles/Particles1.set_deferred("emitting", true)
	$TornadoParticles/Particles2.set_deferred("emitting", true)
	$TornadoParticles/Particles3.set_deferred("emitting", true)
	$TrailParticles/Particles1.direction = -sync_velocity
	$TrailParticles/Particles2.direction = -sync_velocity 
	$TrailParticles/Particles3.direction = -sync_velocity 
	$TrailParticles/Particles1.set_deferred("emitting", true)
	$TrailParticles/Particles2.set_deferred("emitting", true)
	$TrailParticles/Particles3.set_deferred("emitting", true)
	
func stop_particles():
	$TornadoParticles/Particles1.set_deferred("emitting", false)
	$TornadoParticles/Particles2.set_deferred("emitting", false)
	$TornadoParticles/Particles3.set_deferred("emitting", false)
	$TrailParticles/Particles1.set_deferred("emitting", false)
	$TrailParticles/Particles2.set_deferred("emitting", false)
	$TrailParticles/Particles3.set_deferred("emitting", false)
	
func fade_out():
	stop_particles()
	var tween = get_tree().create_tween()
	tween.tween_property(sound_effects, "volume_db", -80, 2.0)
	tween.tween_property($PointLight2D, "energy", 0.0, 2.0)
	tween.tween_property($PointLight2D, "color", Color("ffffff"), 2.0)
