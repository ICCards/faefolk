extends KinematicBody2D

var velocity = Vector2.ZERO
const MAX_SPEED = 425
const ACCELERATION = 460
onready var itemSprite = $Sprite/TextureRect
onready var itemQuantity = $Sprite/Label
onready var animationPlayer = $AnimationPlayer

var rng = RandomNumberGenerator.new()

var player = null
var being_picked_up = false
var being_added_to_inventory = false
var item_name
var randomInt
var item_quantity
var item_health
var adjustedPosition


func initItemDropType(_item_name, var _quantity = 1, var _health = null):
	item_name = _item_name
	item_quantity = _quantity
	item_health = _health


func _ready():
	rng.randomize()
	itemSprite.set_deferred("texture", load("res://Assets/Images/inventory_icons/" + JsonData.item_data[item_name]["ItemCategory"] + "/" + item_name + ".png"))
	if item_quantity == 1:
		itemQuantity.call_deferred("hide")
	else:
		itemQuantity.set_deferred("text", str(item_quantity))
	randomInt = rng.randi_range(1, 5)
	animationPlayer.call_deferred("play", "Animate " + String(randomInt))


func adjustPosition(animation):
	if animation == 1:
		adjustedPosition = global_position + Vector2(48, 0)
	elif animation == 2:
		adjustedPosition = global_position + Vector2(-48, 0)
	elif animation == 3:
		adjustedPosition = global_position + Vector2(24, -25)
	elif animation == 4:
		adjustedPosition = global_position + Vector2(-24, -25)
	elif animation == 5:
		adjustedPosition = global_position + Vector2(0, -6)


func _physics_process(_delta):
	if !being_picked_up:
		velocity = Vector2.ZERO
	else:
		adjustPosition(randomInt)
		var direction = adjustedPosition.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)
		var distance = adjustedPosition.distance_to(player.global_position)
		if distance < 4: 
			if being_added_to_inventory:
				return
			else:
				being_added_to_inventory = true
				$Sprite.set_deferred("visible", false)
				$CollisionShape2D.set_deferred("disabled", true)
				PlayerData.pick_up_item(item_name, item_quantity, item_health)
				$SoundEffects.set_deferred("volume_db",  Sounds.return_adjusted_sound_db("sound", 0))
				$SoundEffects.call_deferred("play")
				yield($SoundEffects, "finished")
				queue_free()
	velocity.normalized()
	velocity = move_and_slide(velocity, Vector2.UP)

func pick_up_item(body):
	player = body
	being_picked_up = true
