extends KinematicBody2D

onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var velocity = Vector2(0,0)
var speed = 500
var collided = false
var debuff
var is_hostile_projectile: bool = false

func _physics_process(delta):
	if not collided:
		var collision_info = move_and_collide(velocity.normalized() * delta * speed)

func _ready():
	if is_hostile_projectile:
		$Hitbox.set_collision_mask(2+8+16+128)
	sound_effects.stream = preload("res://Assets/Sound/Sound effects/Magic/Fire/cast.wav")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -8)
	sound_effects.play()
	$Projectile.play("play")
	$Hitbox.tool_name = "fire projectile"
	$TrailParticles.position += Vector2(0,32)
	$TrailParticles/P1.direction = -velocity
	$TrailParticles/P2.direction = -velocity 
	$TrailParticles/P3.direction = -velocity 
	yield(get_tree().create_timer(0.2), "timeout")
	if not collided:
		$TrailParticles/P1.emitting = true
		$TrailParticles/P2.emitting = true
		$TrailParticles/P3.emitting = true

func destroy():
	if is_instance_valid(self):
		queue_free()

func _on_Area2D_area_entered(area):
	projectile_collided()

func _on_Timer_timeout():
	if not collided and is_instance_valid(self):
		queue_free()

func projectile_collided():
	if not collided:
		collided = true
		$Projectile.hide()
		$CollisionShape2D.set_deferred("disabled", true)
		$TrailParticles/P1.emitting = false
		$TrailParticles/P2.emitting = false
		$TrailParticles/P3.emitting = false
		if debuff:
			$Hitbox.set_collision_mask(264192) # scythe layer break
			sound_effects.stream = preload("res://Assets/Sound/Sound effects/Magic/Fire/explosion.mp3")
			sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -18)
			sound_effects.play()
			$Explosion.show()
			$Explosion.frame = 1
			$Explosion.play("explode")
			$Hitbox/CollisionShape2D.shape.radius = 80
			yield(get_tree().create_timer(0.5), "timeout")
			$Hitbox/CollisionShape2D.set_deferred("disabled", true)
			yield($Explosion, "animation_finished")
			$Explosion.hide()
		else:
			sound_effects.stream = preload("res://Assets/Sound/Sound effects/Magic/Fire/fireball.wav")
			sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -8)
			sound_effects.play()
			$ExplosionParticles/Explosion.emitting = true
			$ExplosionParticles/Explosion/Shards.emitting = true
			$ExplosionParticles/Explosion/Smoke.emitting = true
			$Hitbox/CollisionShape2D.set_deferred("disabled", true)
			yield(get_tree().create_timer(0.5), "timeout")
		yield(get_tree().create_timer(1.5), "timeout")
		destroy()

func _on_Hitbox_body_entered(body):
	projectile_collided()
