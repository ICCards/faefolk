extends KinematicBody2D

onready var background = $CompositeSprites/background
onready var body = $CompositeSprites/body
onready var ears = $CompositeSprites/ears
onready var face = $CompositeSprites/face
onready var eyes = $CompositeSprites/eyes
onready var mouth = $CompositeSprites/mouth
onready var hat = $CompositeSprites/hat
onready var prop = $CompositeSprites/prop
onready var unique = $CompositeSprites/unique

var test_ghost = [
		  {
			"k": "background",
			"v": "Flesh-color"
		  },
		  {
			"k": "body",
			"v": "Dfinity3"
		  },
		  {
			"k": "ears",
			"v": "vertical-red"
		  },
		  {
			"k": "face",
			"v": "none"
		  },
		  {
			"k": "eyes",
			"v": "Sunglasses-blue"
		  },
		  {
			"k": "mouth",
			"v": "none"
		  },
		  {
			"k": "hat",
			"v": "witch-red"
		  },
		  {
			"k": "prop",
			"v": "ship-pink"
		  },
		  {
			"k": "uniques",
			"v": "none"
		  }
]

var velocity = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var knockback = Vector2.ZERO
export var MAX_SPEED = 160
export var ACCELERATION = 200
export var FRICTION = 80
export var KNOCKBACK_AMOUNT = 550

func _ready():
	background.texture = Images.returnICGhostBackground(test_ghost[0]["v"])
	body.texture = Images.returnICGhostBody(test_ghost[1]["v"])
	ears.texture = Images.returnICGhostEars(test_ghost[2]["v"])
	face.texture = Images.returnICGhostFace(test_ghost[3]["v"])
	eyes.texture = Images.returnICGhostEyes(test_ghost[4]["v"])
	mouth.texture = Images.returnICGhostMouth(test_ghost[5]["v"])
	hat.texture = Images.returnICGhostHat(test_ghost[6]["v"])
	prop.texture = Images.returnICGhostProp(test_ghost[7]["v"])
	unique.texture = Images.returnICGhostUnique(test_ghost[8]["v"])
	

func _physics_process(delta):
	rng.randomize()
	if knockback != Vector2.ZERO:
		knockback = knockback.move_toward(Vector2.ZERO, KNOCKBACK_AMOUNT * delta)
		knockback = move_and_slide(knockback)
	else:
		var direction = (Server.player_node.global_position - global_position).normalized()
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		velocity = move_and_slide(velocity)
		if velocity.x > 0:
			flip_horizontal_false()
		else:
			flip_horizontal_true()
	#set_direction()



func set_direction():
	if abs(velocity.y) > abs(velocity.x):
		if velocity.y > 0:
			$AnimatedSprite.animation = "down"
		else: 
			$AnimatedSprite.animation = "up"
	else: 
		if velocity.x > 0:
			$AnimatedSprite.animation = "right"
		else: 
			$AnimatedSprite.animation = "left"



func flip_horizontal_true():
	background.flip_h = true
	body.flip_h = true
	ears.flip_h = true
	face.flip_h = true
	eyes.flip_h = true
	mouth.flip_h = true
	hat.flip_h = true
	prop.flip_h = true
	unique.flip_h = true
	
	
func flip_horizontal_false():
	background.flip_h = false
	body.flip_h = false
	ears.flip_h = false
	face.flip_h = false
	eyes.flip_h = false
	mouth.flip_h = false
	hat.flip_h = false
	prop.flip_h = false
	unique.flip_h = false
	


func _on_Area2D_area_entered(area):
	$HurtBox/AnimationPlayer.play("hit")
	if area.knockback_vector != null:
		knockback = area.knockback_vector * 400
