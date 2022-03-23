extends KinematicBody2D

var velocity = Vector2.ZERO
const MAX_SPEED = 425
const ACCELERATION = 460
onready var itemSprite = $ItemSprite

var player = null
var being_picked_up = false
var item_name

func _ready():
	item_name = "Wood"
	
func _physics_process(delta):
	if !being_picked_up:
		velocity = Vector2.ZERO
	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)
			
		var distance = global_position.distance_to(player.global_position)
		if distance < 6: 
			PlayerInventory.add_item(item_name, 1)
			queue_free()
	velocity = move_and_slide(velocity, Vector2.UP)
	
func pick_up_item(body):
	player = body
	being_picked_up = true


