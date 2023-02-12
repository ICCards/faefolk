extends CharacterBody2D

@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
@onready var sound_effects2: AudioStreamPlayer2D = $SoundEffects2
var tween = get_tree().create_tween()
#var velocity = Vector2(0,0)
var speed = 350
var collided = false
var destroyed = false
var debuff
var projectile_transform


func _physics_process(delta):
	if not collided:
		var collision_info = move_and_collide(velocity.normalized() * delta * speed)

func _ready():
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Magic/Ice/cast.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -14)
	sound_effects.play()
	$Projectile.transform = projectile_transform
	$TrailParticles.transform = projectile_transform
	$TrailParticles.position += Vector2(0,32)
	$Projectile.position += Vector2(0,32)
	$Projectile.scale = Vector2(2,2)
	$Hitbox.tool_name = "ice projectile"
	$Hitbox.knockback_vector = Vector2.ZERO
	await get_tree().create_timer(0.2).timeout
	if not collided:
		$TrailParticles/GPUParticles3D.emitting = true
		$TrailParticles/Particles2.emitting = true
		$TrailParticles/Particles3.emitting = true


func _on_Area2D_area_entered(area):
	if not collided:
		projectile_collided()

func projectile_collided():
	collided = true
	$Projectile.hide()
	$TrailParticles/GPUParticles3D.emitting = false
	$TrailParticles/Particles2.emitting = false
	$TrailParticles/Particles3.emitting = false
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Magic/Ice/explosion.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -14)
	sound_effects.play()
	if debuff:
		$Hitbox/CollisionShape2D.shape.radius = 80
		$BuffedExplosionParticles.emitting = true
		$BuffedExplosionSprite.show()
		$BuffedExplosionSprite.playing = true
		sound_effects2.stream = load("res://Assets/Sound/Sound effects/Magic/Ice/blizzard.mp3")
		sound_effects2.volume_db = Sounds.return_adjusted_sound_db("sound", -18)
		sound_effects2.play()
		await $BuffedExplosionSprite.animation_finished
		$Timer.start()
		fade_out_sound()
		$BuffedExplosionSprite.hide()
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)
		$BuffedExplosionParticles.emitting = false
	else:
		$Timer.start()
		$ExplosionParticles/Explosion.emitting = true
		$ExplosionParticles/Explosion/Shards.emitting = true
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)

func destroy():
	$BuffedExplosionSprite.playing = false
	destroyed = true
	await get_tree().create_timer(1.0).timeout
	if is_instance_valid(self):
		queue_free()

func fade_out_sound():
	tween.tween_property(sound_effects2, "volume_db", -80, 1.0)

func _on_Hitbox_body_entered(body):
	projectile_collided()

func _on_Timer_timeout():
	if is_instance_valid(self):
		queue_free()
