extends KinematicBody2D

onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var velocity = Vector2(1,0)
var speed = 350
var collided = false
var particles_transform
var is_hostile_projectile: bool = false

func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)

func _ready():
	if is_hostile_projectile:
		$Hitbox.set_collision_mask(128+2048+8)
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -20)
	sound_effects.play()
	$Hitbox.tool_name = "tornado spell"
	$Hitbox.knockback_vector = velocity / 150
	$AnimatedSprite.play("anim")
	set_particles()
	yield($AnimatedSprite, "animation_finished")
	fade_out_sound()
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
	$TrailParticles/P1.direction = -velocity #particles_transform
	$TrailParticles/P2.direction = -velocity #particles_transform
	$TrailParticles/P3.direction = -velocity #particles_transform
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
