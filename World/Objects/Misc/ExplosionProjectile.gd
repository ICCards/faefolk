extends KinematicBody2D

onready var projectile_sprite: AnimatedSprite = $AnimatedSprite
onready var animation_player: AnimationPlayer = $AnimationPlayer
var velocity = Vector2(0,0)
var speed = 500
var collided = false
var path

func _physics_process(delta):
	if not collided:
		var collision_info = move_and_collide(velocity.normalized() * delta * speed)

func _ready():
	$Area2D.tool_name = "explosion spell"
	$ExplosionArea.tool_name = "explosion"


func _on_Area2D_area_entered(area):
	projectile_sprite.frame = 1
	projectile_sprite.play("explode")
	animation_player.play("explode")
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	collided = true
	yield(projectile_sprite, "animation_finished")
	queue_free()



