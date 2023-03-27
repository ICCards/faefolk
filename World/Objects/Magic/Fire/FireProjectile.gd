extends CharacterBody2D

@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects


var speed = 250
var collided = false
var debuff
var is_hostile_projectile: bool = false

func _physics_process(delta):
	if not collided:
		var collision_info = move_and_collide(velocity.normalized() * delta * speed)

func _ready():
	$Projectile.play("loop")
	if is_hostile_projectile:
		$Hitbox.set_collision_mask(2+8+16+128)
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Magic/Fire/cast.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -8)
	sound_effects.play()
	$Hitbox.tool_name = "fire projectile"
	$TrailParticles/Particles1.direction = -velocity
	$TrailParticles/Particles2.direction = -velocity 
	$TrailParticles/Particles3.direction = -velocity 
	await get_tree().create_timer(0.2).timeout
	if not collided:
		$TrailParticles/Particles1.emitting = true
		$TrailParticles/Particles2.emitting = true
		$TrailParticles/Particles3.emitting = true

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
		$TrailParticles/Particles1.set_deferred("emitting", false)
		$TrailParticles/Particles2.set_deferred("emitting", false)
		$TrailParticles/Particles3.set_deferred("emitting", false)
		if debuff:
			$Hitbox.set_collision_mask(264192) # scythe layer break
			sound_effects.stream = load("res://Assets/Sound/Sound effects/Magic/Fire/explosion.mp3")
			sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -18)
			sound_effects.play()
			$Explosion.show()
			$Explosion.frame = 1
			$Explosion.play("explode")
			$Hitbox/CollisionShape2D.shape.set_deferred("radius", 80)
			await get_tree().create_timer(0.5).timeout
			var tween = get_tree().create_tween()
			tween.tween_property($PointLight2D, "color", Color("00ffffff"), 0.5)
			$Hitbox/CollisionShape2D.set_deferred("disabled", true)
			await $Explosion.animation_finished
			$Explosion.hide()
		else:
			sound_effects.stream = load("res://Assets/Sound/Sound effects/Magic/Fire/fireball.mp3")
			sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -8)
			sound_effects.play()
			InstancedScenes.initiateExplosionParticles(position)
			$Hitbox/CollisionShape2D.set_deferred("disabled", true)
			var tween = get_tree().create_tween()
			tween.tween_property($PointLight2D, "color", Color("00ffffff"), 0.5)
			await get_tree().create_timer(0.25).timeout
		await get_tree().create_timer(1.5).timeout
		destroy()

func _on_Hitbox_body_entered(body):
	projectile_collided()
