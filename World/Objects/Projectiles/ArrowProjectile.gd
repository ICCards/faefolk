extends KinematicBody2D


var velocity = Vector2(-1,-1)
var speed = 525
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
onready var uuid = _uuid.new()

func _physics_process(delta):
	if not collided:
		var collision_info = move_and_collide(velocity * delta * speed)

func _ready():
	if is_hostile:
		$Hitbox.set_collision_mask(128+2)
	rotation_degrees = rad2deg(Vector2(1,0).angle_to(velocity))
	$Hitbox.id = uuid.v4()
	$Hitbox.tool_name = "arrow"
	$Hitbox.knockback_vector = velocity
	if is_fire_arrow:
		$Hitbox.special_ability = "fire"
		$ArrowBreak.modulate = Color("ff0000")
		$FireTrailParticles/P1.emitting = true
		$FireTrailParticles/P2.emitting = true
		$FireTrailParticles/P3.emitting = true
	elif is_ice_arrow:
		$Hitbox.special_ability = "ice"
		$ArrowBreak.modulate = Color("009bff")
		$IceTrailParticles/P1.emitting = true
		$IceTrailParticles/P2.emitting = true
		$IceTrailParticles/P3.emitting = true
	elif is_poison_arrow:
		$Hitbox.special_ability = "poison"
		$ArrowBreak.modulate = Color("00ee18")
		$PoisonTrailParticles/P1.emitting = true
		$PoisonTrailParticles/P2.emitting = true
		$PoisonTrailParticles/P3.emitting = true


func fade_out():
	$Tween.interpolate_property($Sprite, "modulate:a", 1.0, 0.0, 0.5, 3, 1)
	$Tween.start()

func _on_Area2D_area_entered(area):
	if is_ricochet_shot:
		ricochet_enemies.append(area.get_parent().name)
		find_next_player()
	else:
		destroy()
		
		
func find_next_player():
	var temp = null
	for new_body in $DetectEnemyBox.get_overlapping_bodies():
		if not ricochet_enemies.has(new_body.name):
			if temp == null:
				temp = new_body
			elif self.position.distance_to(new_body.position) < self.position.distance_to(temp.position):
				temp = new_body
	if temp == null:
		destroy()
		return
	ricochet_enemies.append(temp.name)
	velocity = (temp.position - self.position).normalized()
	rotation_degrees = rad2deg(Vector2(1,0).angle_to(velocity))
	$Hitbox.knockback_vector = velocity
#		elif self.position.distance_to(new_body.position) < self.position.distance_to(enemy_node.position):
#			temp = new_body

func _on_Hitbox_body_entered(body):
	destroy()

func destroy():
	if not collided:
		$FireTrailParticles/P1.emitting = false
		$FireTrailParticles/P2.emitting = false
		$FireTrailParticles/P3.emitting = false
		$IceTrailParticles/P1.emitting = false
		$IceTrailParticles/P2.emitting = false
		$IceTrailParticles/P3.emitting = false
		$PoisonTrailParticles/P1.emitting = false
		$PoisonTrailParticles/P2.emitting = false
		$PoisonTrailParticles/P3.emitting = false
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)
		$CollisionShape2D.set_deferred("disabled", true)
		collided = true
		$ArrowBreak.playing = true
		yield($ArrowBreak, "animation_finished")
		$ArrowBreak.hide()

func _on_Timer_timeout():
	hide()
	destroy()
