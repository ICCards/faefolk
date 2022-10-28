extends KinematicBody2D

onready var animation_player: AnimationPlayer = $AnimationPlayer
var velocity = Vector2(0,0)
var speed = 500
var collided = false
var path

func _physics_process(delta):
	if not collided:
		var collision_info = move_and_collide(velocity.normalized() * delta * speed)

func _ready():
	$Hitbox.tool_name = "explosion spell"
	$ExplosionHitbox.tool_name = "explosion"


func _on_Area2D_area_entered(area):
	$Fireball.hide()
	$Explosion.show()
	$Explosion.frame = 1
	$Explosion.play("explode")
	animation_player.play("explode")
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	collided = true
	yield($Explosion, "animation_finished")
	queue_free()


func _on_Timer_timeout():
	queue_free()
