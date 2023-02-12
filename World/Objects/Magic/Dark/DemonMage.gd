extends CharacterBody2D

@onready var LightningProjectile = load("res://World3D/Objects/Magic/Lightning/LightningProjectile.tscn")
@onready var TornadoProjectile = load("res://World3D/Objects/Magic/Wind/TornadoProjectile.tscn")
@onready var FireProjectile = load("res://World3D/Objects/Magic/Fire/FireProjectile.tscn")
@onready var IceProjectile = load("res://World3D/Objects/Magic/Ice/IceProjectile.tscn")

@onready var demon_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
var state = IDLE

enum {
	IDLE,
	MOVE
}

#var velocity = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var knockback = Vector2.ZERO
@export var MAX_SPEED = 400
@export var ACCELERATION = 375
@export var FRICTION = 20
@export var KNOCKBACK_AMOUNT = 550

var enemy_node
var attacking: bool = false
var destroyed: bool = false
var debuff: bool = false

var random_movement_position = null

func _ready():
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Magic/Dark/demon mage spawn.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -4)
	sound_effects.play()
	randomize()
	$HitBox.tool_name = "wood sword"
	if Util.chance(50):
		demon_sprite.flip_h = true

func _physics_process(delta):
	set_trail_particles_direction()
	if enemy_node:
		if not enemy_node.destroyed:
			if not debuff:
				state = MOVE
				var direction = (enemy_node.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				set_velocity(velocity)
				move_and_slide()
				velocity = velocity
				demon_sprite.flip_h = velocity.x < 0
				if not attacking and self.position.distance_to(enemy_node.position) < 150:
					swing()
				return
			else:
				state = MOVE
				if self.position.distance_to(enemy_node.position) > 400:
					random_movement_position = null
					var direction = (enemy_node.global_position - global_position).normalized()
					velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
					set_velocity(velocity)
					move_and_slide()
					velocity = velocity
				else:
					if not random_movement_position:
						var random1 = randf_range(75, 100)
						var random2 = randf_range(75, 100)
						if Util.chance(50):
							random1 *= -1
						if Util.chance(50):
							random2 *= -1
						random_movement_position = Vector2(random1, random2)
					var direction = ((enemy_node.global_position+random_movement_position) - global_position).normalized()
					velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
					set_velocity(velocity)
					move_and_slide()
					velocity = velocity
				if attacking:
					$ShootDirection.look_at(enemy_node.position)
					var degrees = int($ShootDirection.rotation_degrees) % 360
					if $ShootDirection.rotation_degrees >= 0:
						if degrees <= 90 or degrees >= 270:
							demon_sprite.flip_h = false
						else:
							demon_sprite.flip_h = true
					else:
						if degrees >= -90 or degrees <= -270:
							demon_sprite.flip_h = true
						else:
							demon_sprite.flip_h = false
				else:
					if velocity.x > 0:
						demon_sprite.flip_h = true
					else:
						demon_sprite.flip_h = false
				if not attacking and self.position.distance_to(enemy_node.position) < 400:
					shoot(enemy_node.position)
				return
	state = IDLE
	enemy_node = null
	demon_sprite.play("idle")
	if $DetectEnemyBox.get_overlapping_bodies().size() >= 1 and not enemy_node:
		var temp
		for new_body in $DetectEnemyBox.get_overlapping_bodies():
			if not enemy_node:
				temp = new_body
			elif self.position.distance_to(new_body.position) < self.position.distance_to(enemy_node.position):
				temp = new_body
		enemy_node = temp


func shoot(_pos):
	attacking = true
	demon_sprite.frame = 0
	demon_sprite.play("shoot")
	await get_tree().create_timer(1.0).timeout
	if enemy_node:
		if not enemy_node.destroyed and not destroyed:
			shoot_random_projectile()
			await get_tree().create_timer(1.0).timeout
	attacking = false


func shoot_random_projectile():
	randomize()
	var rand = randf_range(0,100)
	if rand < 25:
		var spell = FireProjectile.instantiate()
		spell.position = $ShootDirection/Marker2D.global_position
		spell.velocity = enemy_node.position - spell.position
		get_node("../").add_child(spell)
	elif rand < 50:
		var spell = IceProjectile.instantiate()
		spell.projectile_transform = $ShootDirection.transform
		spell.position = $ShootDirection/Marker2D.global_position
		spell.velocity = enemy_node.position - spell.position
		get_node("../").add_child(spell)
	elif rand < 75:
		var spell = TornadoProjectile.instantiate()
		spell.position = $ShootDirection/Marker2D.global_position
		spell.velocity = enemy_node.position - spell.position
		get_node("../").add_child(spell)
	else:
		var spell = LightningProjectile.instantiate()
		spell.transform = $ShootDirection.transform
		spell.position = $ShootDirection/Marker2D.global_position
		spell.velocity = enemy_node.position - spell.position
		get_node("../").add_child(spell)


func swing():
	attacking = true
	demon_sprite.frame = 0
	demon_sprite.play("swing")
	await get_tree().create_timer(0.5).timeout
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Magic/Dark/swoosh.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -8)
	sound_effects.play()
	$HitBox/CollisionShape2D.set_deferred('disabled', false)
	await get_tree().create_timer(0.5).timeout
	$HitBox/CollisionShape2D.set_deferred('disabled', true)
	attacking = false


func set_trail_particles_direction():
	if velocity == Vector2.ZERO or state == IDLE:
		$TrailParticles.emitting = false 
		$TrailParticles2.emitting = false
		$TrailParticles3.emitting = false 
	else:
		$TrailParticles.emitting = true 
		$TrailParticles2.emitting = true 
		$TrailParticles3.emitting = true 
		$TrailParticles.direction = -velocity
		$TrailParticles2.direction = -velocity
		$TrailParticles3.direction = -velocity
		$TrailParticles.initial_velocity = 75
		$TrailParticles2.initial_velocity = 75 
		$TrailParticles3.initial_velocity = 75 

func _on_Timer_timeout():
	destroy()

func destroy(): 
	$Shadow.hide()
	destroyed = true
	set_physics_process(false)
	await get_tree().idle_frame
	state = IDLE
	$TrailParticles.emitting = false
	$TrailParticles2.emitting = false
	$TrailParticles3.emitting = false
	demon_sprite.frame = 0
	demon_sprite.play("die")
	await demon_sprite.animation_finished
	queue_free()
