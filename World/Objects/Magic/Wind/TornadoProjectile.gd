extends CharacterBody2D

@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var speed = 125
var collided = false
var destroyed = false
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
	$AnimatedSprite2D.call_deferred("play", "anim")
	call_deferred("set_particles")
	await $AnimatedSprite2D.animation_finished
	call_deferred("fade_out_sound")
	call_deferred("stop_trail_particles")
	$AnimatedSprite2D.call_deferred("hide")
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)


func destroy():
	if not destroyed:
		uuid.queue_free()
		destroyed = true
		$AnimatedSprite2D.call_deferred("stop")
		queue_free()

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
	
func fade_out_sound():
	var tween = get_tree().create_tween()
	tween.tween_property(sound_effects, "volume_db", -80, 3.0)
	tween.tween_property($PointLight2D, "energy", 0.0, 3.0)

func _on_Timer_timeout():
	destroy()
