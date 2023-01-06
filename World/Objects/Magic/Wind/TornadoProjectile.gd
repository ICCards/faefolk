extends KinematicBody2D

onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var velocity = Vector2(1,0)
var speed = 350
var collided = false
var destroyed = false
var is_hostile_projectile: bool = false

var _uuid = load("res://helpers/UUID.gd")
onready var uuid = _uuid.new()

func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)

func _ready():
	$Hitbox.id = uuid.v4()
	if is_hostile_projectile:
		$Hitbox.set_collision_mask(128+2048+8+16)
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


func destroy():
	if not destroyed:
		destroyed = true
		$AnimatedSprite.stop()
		queue_free()

func set_particles():
	$TornadoParticles/P1.emitting = true
	$TornadoParticles/P2.emitting = true
	$TornadoParticles/P3.emitting = true
	$TrailParticles.position += Vector2(0,32)
	$TrailParticles/P1.direction = -velocity
	$TrailParticles/P2.direction = -velocity 
	$TrailParticles/P3.direction = -velocity 
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


func _on_Timer_timeout():
	destroy()
