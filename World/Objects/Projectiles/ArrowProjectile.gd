extends KinematicBody2D


var velocity = Vector2(-1,0)
var speed = 500
var collided = false
var is_on_fire: bool = true

func _physics_process(delta):
	if not collided:
		var collision_info = move_and_collide(velocity.normalized() * delta * speed)

func _ready():
	$Hitbox.tool_name = "arrow"
	$Hitbox.knockback_vector = velocity / 150
	if is_on_fire:
		$Hitbox.special_ability = "fire"
		$Sprite.modulate = Color("ff0000")
		$TrailParticles/Particles.emitting = true
		$TrailParticles/Particles2.emitting = true
		$TrailParticles/Particles3.emitting = true
	yield(get_tree().create_timer(1.0), "timeout")
	fade_out()
	$TrailParticles/Particles.emitting = false
	$TrailParticles/Particles2.emitting = false
	$TrailParticles/Particles3.emitting = false
	yield(get_tree().create_timer(2.0), "timeout")
	queue_free()

func fade_out():
	$Tween.interpolate_property($Sprite, "modulate:a", 1.0, 0.0, 0.5, 3, 1)
	$Tween.start()

func _on_Area2D_area_entered(area):
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	collided = true
	if is_on_fire:
		$Sprite.hide()
		InstancedScenes.initiateExplosionParticles(position+Vector2(12,0))
