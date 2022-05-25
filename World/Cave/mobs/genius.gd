extends KinematicBody2D

onready var _animated_sprite = $AnimatedSprite

const GRAVITY = 10
const SPEED = 60
const FLOOR = Vector2(0, -1)

var velocity = Vector2()

var direction = 1

func _ready():
	pass

func physicsprocess(delta):
	velocity.x = SPEED * direction

func _process(_delta):
	_animated_sprite.play("idle")
	
	if direction == 1:
		_animated_sprite.flip_h = true
	else:
		_animated_sprite.flip_h = false
		_animated_sprite.play("walk")
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)

	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1

	if $RayCast2D.is_colliding() == false:
		direction = direction * -1
		$RayCast2D.position.x *= -1
