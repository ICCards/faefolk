extends CharacterBody2D

@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
var tween = get_tree().create_tween()

var is_hostile_projectile: bool = false
var speed = 350
var target 
var particles_transform

func _physics_process(delta):
	position = position.move_toward(target, delta * speed)
	if position == target:
		$TrailParticles/Particles1.emitting = false
		$TrailParticles/Particles2.emitting = false
		$TrailParticles/Particles3.emitting = false

func _ready():
	if is_hostile_projectile:
		$Hitbox.set_collision_mask(128+2048+8+16)
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -20)
	sound_effects.play()
	$Hitbox.tool_name = "lingering tornado"
	$AnimationPlayer.play("play")
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
	$Hitbox.queue_free()
	$AnimatedSprite2D.play("end")
	stop_trail_particles()
	fade_out_sound()
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.hide()
	await get_tree().create_timer(3.0).timeout
	queue_free()


func destroy():
	if $AnimatedSprite2D.visible:
		$AnimatedSprite2D.stop()
		await get_tree().create_timer(0.5).timeout
		queue_free()


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
	
func stop_trail_particles():
	$TornadoParticles/Particles1.emitting = false
	$TornadoParticles/Particles2.emitting = false
	$TornadoParticles/Particles3.emitting = false
	$TrailParticles/Particles1.emitting = false
	$TrailParticles/Particles2.emitting = false
	$TrailParticles/Particles3.emitting = false
	
func fade_out_sound():
	tween.tween_property(sound_effects, "volume_db", -80, 3.0)
	tween.tween_property($PointLight2D, "color", Color("00ffffff"), 3.0)
