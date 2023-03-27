extends CharacterBody2D

@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var speed = 125
var collided = false
var is_hostile_projectile: bool = false

var _uuid = load("res://helpers/UUID.gd")
@onready var uuid = _uuid.new()

func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)

func _ready():
	$Hitbox.id = uuid.v4()
	if is_hostile_projectile:
		$Hitbox.set_collision_layer(128+2048+8+16)
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -20)
	sound_effects.play()
	$Hitbox.tool_name = "tornado spell"
	$Hitbox.knockback_vector = velocity / 150
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

func set_particles():
	$TornadoParticles/Particles1.set_deferred("emitting", true)
	$TornadoParticles/Particles2.set_deferred("emitting", true)
	$TornadoParticles/Particles3.set_deferred("emitting", true)
	$TrailParticles/Particles1.direction = -velocity
	$TrailParticles/Particles2.direction = -velocity 
	$TrailParticles/Particles3.direction = -velocity 
	$TrailParticles/Particles1.set_deferred("emitting", true)
	$TrailParticles/Particles2.set_deferred("emitting", true)
	$TrailParticles/Particles3.set_deferred("emitting", true)
	
func stop_trail_particles():
	$TornadoParticles/Particles1.set_deferred("emitting", false)
	$TornadoParticles/Particles2.set_deferred("emitting", false)
	$TornadoParticles/Particles3.set_deferred("emitting", false)
	$TrailParticles/Particles1.set_deferred("emitting", false)
	$TrailParticles/Particles2.set_deferred("emitting", false)
	$TrailParticles/Particles3.set_deferred("emitting", false)
	
func fade_out():
	stop_trail_particles()
	$AnimatedSprite2D.call_deferred("hide")
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	var tween = get_tree().create_tween()
	tween.tween_property(sound_effects, "volume_db", -80, 2.0)
	tween.tween_property($PointLight2D, "energy", 0.0, 2.0)
	await get_tree().create_timer(2.0).timeout
	uuid.call_deferred("queue_free")
	call_deferred("queue_free")
