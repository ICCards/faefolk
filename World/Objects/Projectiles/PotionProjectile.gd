extends KinematicBody2D

var speed = 500
var destroyed: bool = false
var target
var particles_transform

func _physics_process(delta):
	position = position.move_toward(target, delta * speed)
	if position == target:
		if not destroyed:
			destroy()
		return

func _ready():
	$PotionHitbox.tool_name = "health potion"
	$TrailParticles.transform = particles_transform
	$TrailParticles.position += Vector2(0,32)
	yield(get_tree().create_timer(0.025), "timeout")
	if not destroyed:
		$Sprite.show()

func destroy():
	destroyed = true
	$Sprite.hide()
	$TrailParticles/P1.emitting = false
	$TrailParticles/P2.emitting = false
	$TrailParticles/P3.emitting = false
	$ExplosionParticles/Explosion.emitting = true
	$ExplosionParticles/Explosion/Shards.emitting = true
	$PotionHitbox/CollisionShape2D.set_deferred("disabled", false)
	yield(get_tree().create_timer(0.2), "timeout")
	$PotionHitbox/CollisionShape2D.set_deferred("disabled", true)
	yield(get_tree().create_timer(1.8), "timeout")
	queue_free()
