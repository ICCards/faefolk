extends KinematicBody2D


var velocity = Vector2(-1,-1)
var speed = 525
var collided = false
var is_on_fire: bool = false
var is_hostile: bool = false

func _physics_process(delta):
	if not collided:
		var collision_info = move_and_collide(velocity.normalized() * delta * speed)

func _ready():
	if is_hostile:
		$Hitbox.set_collision_mask(128+2)
	rotation_degrees = rad2deg(Vector2(1,0).angle_to(velocity))
	$Hitbox.tool_name = "arrow"
	$Hitbox.knockback_vector = velocity / 150
	if is_on_fire:
		$Hitbox.special_ability = "fire"
		$ArrowBreak.modulate = Color("ff0000")
		$TrailParticles/Particles.emitting = true
		$TrailParticles/Particles2.emitting = true
		$TrailParticles/Particles3.emitting = true


func fade_out():
	$Tween.interpolate_property($Sprite, "modulate:a", 1.0, 0.0, 0.5, 3, 1)
	$Tween.start()

func _on_Area2D_area_entered(area):
	destroy()

func _on_Hitbox_body_entered(body):
	destroy()

func destroy():
	if not collided:
		$TrailParticles/Particles.emitting = false
		$TrailParticles/Particles2.emitting = false
		$TrailParticles/Particles3.emitting = false
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)
		$CollisionShape2D.set_deferred("disabled", true)
		collided = true
		$ArrowBreak.playing = true
		yield($ArrowBreak, "animation_finished")
		$ArrowBreak.hide()

func _on_Timer_timeout():
	hide()
	destroy()
