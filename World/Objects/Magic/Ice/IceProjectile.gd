extends KinematicBody2D

onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
onready var sound_effects2: AudioStreamPlayer2D = $SoundEffects2

var velocity = Vector2(0,0)
var speed = 350
var collided = false
var debuff
var projectile_transform


func _physics_process(delta):
	if not collided:
		var collision_info = move_and_collide(velocity.normalized() * delta * speed)

func _ready():
	sound_effects.stream = preload("res://Assets/Sound/Sound effects/Magic/Ice/cast.wav")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -14)
	sound_effects.play()
	$Projectile.transform = projectile_transform
	$TrailParticles.transform = projectile_transform
	$TrailParticles.position += Vector2(0,32)
	$Projectile.position += Vector2(0,32)
	$Projectile.scale = Vector2(2,2)
	$Hitbox.tool_name = "ice projectile"
	$Hitbox.knockback_vector = Vector2.ZERO
	yield(get_tree().create_timer(0.2), "timeout")
	if not collided:
		$TrailParticles/Particles.emitting = true
		$TrailParticles/Particles2.emitting = true
		$TrailParticles/Particles3.emitting = true


func _on_Area2D_area_entered(area):
	if not collided:
		destroy()

func destroy():
	collided = true
	$Projectile.hide()
	$TrailParticles/Particles.emitting = false
	$TrailParticles/Particles2.emitting = false
	$TrailParticles/Particles3.emitting = false
	sound_effects.stream = preload("res://Assets/Sound/Sound effects/Magic/Ice/explosion.wav")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -14)
	sound_effects.play()
	if debuff:
		$Hitbox/CollisionShape2D.shape.radius = 80
		$BuffedExplosionParticles.emitting = true
		$BuffedExplosionSprite.show()
		$BuffedExplosionSprite.playing = true
		sound_effects2.stream = preload("res://Assets/Sound/Sound effects/Magic/Ice/blizzard.wav")
		sound_effects2.volume_db = Sounds.return_adjusted_sound_db("sound", -18)
		sound_effects2.play()
		yield($BuffedExplosionSprite, "animation_finished")
		$BuffedExplosionSprite.hide()
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)
		$BuffedExplosionParticles.emitting = false
	else:
		$ExplosionParticles/Explosion.emitting = true
		$ExplosionParticles/Explosion/Shards.emitting = true
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	yield(get_tree().create_timer(3.0), "timeout")
	queue_free()


func _on_Hitbox_body_entered(body):
	destroy()
