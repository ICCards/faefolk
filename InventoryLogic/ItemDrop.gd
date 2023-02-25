extends CharacterBody2D

#var velo = Vector2.ZERO
const MAX_SPEED = 425
const ACCELERATION = 460
@onready var itemSprite = $Sprite2D/Image
@onready var itemQuantity = $Sprite2D/Label
@onready var animationPlayer = $AnimationPlayer

var rng = RandomNumberGenerator.new()

var player = null
var being_picked_up = false
var being_added_to_inventory = false
var item_name
var randomInt
var item_quantity
var item_health
var adjustedPosition
var is_tree_harvest: bool = false


func initItemDropType(_item_name, _quantity = 1, _health = null):
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
	randomInt = 1 #rng.randi_range(1, 5)
	animationPlayer.call_deferred("play", "Animate " + str(randomInt))


func adjustPosition(animation):
	if animation == 1:
		adjustedPosition = global_position + Vector2(32, 0)
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
				$Sprite2D.set_deferred("visible", false)
				$CollisionShape2D.set_deferred("disabled", true)
				PlayerData.pick_up_item(item_name, item_quantity, item_health)
				$SoundEffects.set_deferred("volume_db",  Sounds.return_adjusted_sound_db("sound", 0))
				$SoundEffects.call_deferred("play")
				await $SoundEffects.finished
				Server.player_node.user_interface.get_node("ItemPickUpDialogue").item_picked_up(item_name, item_quantity)
				call_deferred("queue_free")
	velocity.normalized()
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity

func pick_up_item(body):
	player = body
	being_picked_up = true
