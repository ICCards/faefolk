extends CharacterBody2D

#const MAX_SPEED = 425
#const ACCELERATION = 46#0
@onready var itemSprite = $Sprite2D/Image
@onready var itemQuantity = $Sprite2D/Label
@onready var animationPlayer = $AnimationPlayer

var rng = RandomNumberGenerator.new()

@export var item_name: String = "wood"
@export var item_quantity: int = 5
@export var item_health: int

var player = null
var being_picked_up = false
var being_added_to_inventory = false
var randomInt
var adjustedPosition = global_position
var is_tree_harvest: bool = false



func _ready():
#	rng.randomize()
	itemSprite.texture = load("res://Assets/Images/inventory_icons/" + JsonData.item_data[item_name]["ItemCategory"] + "/" + item_name + ".png")
	if item_quantity == 1:
		itemQuantity.hide()
	else:
		itemQuantity.text = str(item_quantity)
#	randomInt = rng.randi_range(1, 6)
#	animationPlayer.play("Animate " + str(randomInt))


#func adjustPosition(animation):
#	if animation == 1:
#		adjustedPosition = global_position + Vector2(24,0)
#	elif animation == 2:
#		adjustedPosition = global_position + Vector2(-24,0)
#	elif animation == 3:
#		adjustedPosition = global_position + Vector2(12,-8)
#	elif animation == 4:
#		adjustedPosition = global_position + Vector2(-12,-8)
#	elif animation == 5:
#		adjustedPosition = global_position + Vector2(4, -8)
#	elif animation == 6:
#		adjustedPosition = global_position + Vector2(-8, 4)


#func _physics_process(_delta):
#	if is_multiplayer_authority(): 
#		if not being_picked_up:
#			velocity = Vector2.ZERO
#		else:
#			#adjustPosition(randomInt)
#			var direction = self.position.direction_to(player.global_position)
#			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)
#			var distance = self.position.distance_to(player.global_position)
#			if distance < 4: 
#				if being_added_to_inventory:
#					return
#				else:
#					being_added_to_inventory = true
#					$Sprite2D.set_deferred("visible", false)
#					$CollisionShape2D.set_deferred("disabled", true)
#					PlayerData.pick_up_item(item_name, item_quantity, item_health)
#					$SoundEffects.set_deferred("volume_db",  Sounds.return_adjusted_sound_db("sound", 0))
#					$SoundEffects.call_deferred("play")
#					await $SoundEffects.finished
#					Server.player_node.user_interface.get_node("ItemPickUpDialogue").item_picked_up(item_name, item_quantity)
#					call_deferred("queue_free")
#		velocity.normalized()
#		set_velocity(velocity)
#		set_up_direction(Vector2.UP)
#		move_and_slide()

func pick_up_item(body):
	get_parent().rpc_id(1,"player_picked_up_item",{"id": name, "player_id":body.name})
#	player = body
#	being_picked_up = true
