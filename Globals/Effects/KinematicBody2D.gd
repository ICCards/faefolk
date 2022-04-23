extends KinematicBody2D


const GRAVITY = 300.0
var velocity = Vector2()

func _physics_process(delta):
	velocity.y += delta * GRAVITY
