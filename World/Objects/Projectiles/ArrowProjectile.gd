extends Node2D


var speed = 250
var collided = false
var is_fire_arrow: bool = false
var is_ice_arrow: bool = false
var is_poison_arrow: bool = false
var is_hostile: bool = false
var is_ricochet_shot: bool = false
var is_multishot1: bool = false
var is_multishot2: bool = false
var ricochet_enemies = []

var _uuid = load("res://helpers/UUID.gd")
@onready var uuid = _uuid.new()

@export var sync_velocity: Vector2
@export var destroyed: bool

#func _physics_process(delta):
#	if not collided:
#		var collision_info = move_and_collide(velocity * delta * speed)
#	if $Hitbox.get_overlapping_areas().size() > 0:
#		destroy()

func _ready():
	rotation_degrees = rad_to_deg(Vector2(1,0).angle_to(sync_velocity))
#	if is_hostile:
#		$Hitbox.set_collision_layer(128+2+32)
#	rotation_degrees = rad_to_deg(Vector2(1,0).angle_to(velocity))
#	$Hitbox.id = uuid.v4()
#	$Hitbox.tool_name = "arrow"
#	$Hitbox.knockback_vector = velocity
#	if is_fire_arrow:
#		$PointLight2D.enabled = true
#		$Hitbox.special_ability = "fire"
#		$ArrowBreak.modulate = Color("ff0000")
#		$FireTrailParticles/Particles1.emitting = true
#		$FireTrailParticles/Particles2.emitting = true
#		$FireTrailParticles/Particles3.emitting = true
#	elif is_ice_arrow:
#		$Hitbox.special_ability = "ice"
#		$ArrowBreak.modulate = Color("009bff")
#		$IceTrailParticles/Particles1.emitting = true
#		$IceTrailParticles/Particles2.emitting = true
#		$IceTrailParticles/Particles3.emitting = true
#	elif is_poison_arrow:
#		$Hitbox.special_ability = "poison"
#		$ArrowBreak.modulate = Color("00ee18")
#		$PoisonTrailParticles/Particles1.emitting = true
#		$PoisonTrailParticles/Particles2.emitting = true
#		$PoisonTrailParticles/Particles3.emitting = true


func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate:a", 0.0, 0.5)

#func _on_Area2D_area_entered(area):
#	if is_ricochet_shot:
#		ricochet_enemies.append(area.get_parent().name)
#		find_next_player()
#	else:
#		destroy()

#func find_next_player():
#	var temp = null
#	for new_body in $DetectEnemyBox.get_overlapping_bodies():
#		if not ricochet_enemies.has(new_body.name):
#			if temp == null:
#				temp = new_body
#			elif self.position.distance_to(new_body.position) < self.position.distance_to(temp.position):
#				temp = new_body
#	if temp == null:
#		destroy()
#		return
#	ricochet_enemies.append(temp.name)
#	velocity = (temp.position - self.position).normalized()
#	rotation_degrees = rad_to_deg(Vector2(1,0).angle_to(velocity))
#	$Hitbox.knockback_vector = velocity

#func _on_Hitbox_body_entered(body):
#	destroy()


func _physics_process(delta):
	if destroyed == true:
		destroy()

func destroy():
	if not collided:
		collided = true
		$ArrowBreak.play("break")
		$FireTrailParticles/Particles1.emitting = false
		$FireTrailParticles/Particles2.emitting = false
		$FireTrailParticles/Particles3.emitting = false
		$IceTrailParticles/Particles1.emitting = false
		$IceTrailParticles/Particles2.emitting = false
		$IceTrailParticles/Particles3.emitting = false
		$PoisonTrailParticles/Particles1.emitting = false
		$PoisonTrailParticles/Particles2.emitting = false
		$PoisonTrailParticles/Particles3.emitting = false
	#	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	#	$CollisionShape2D.set_deferred("disabled", true)
		var tween = get_tree().create_tween()
		tween.tween_property($PointLight2D, "color", Color("00ffffff"), 0.5)
		await $ArrowBreak.animation_finished
		$ArrowBreak.hide()

func _on_Timer_timeout():
	pass
#	hide()
#	destroy()
