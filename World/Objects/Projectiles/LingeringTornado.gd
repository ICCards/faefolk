extends KinematicBody2D


var velocity = Vector2(0,0)
var speed = 350
var collided = false
var target 

func _physics_process(delta):
	position = position.move_toward(target, delta * speed)

func _ready():
	$Hitbox.tool_name = "lingering tornado"
	$AnimationPlayer.play("play")
	$AnimatedSprite.play("start")
	$Trail.emitting = true
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("middle")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("middle")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("middle")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("middle")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("middle")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("end")
	$Trail.emitting = false
	yield($AnimatedSprite, "animation_finished")
	queue_free()

