extends KinematicBody2D

var velocity = Vector2.ZERO
const MAX_SPEED = 425
const ACCELERATION = 460
onready var itemSprite = $Sprite/TextureRect
onready var itemQuantity = $Sprite/Label
onready var animationPlayer = $AnimationPlayer


var player = null
var being_picked_up = false
var being_added_to_inventory = false
var item_name
var randomInt
var rng = RandomNumberGenerator.new()
var quantity


func initItemDropType(_item_name, var _quantity = 1):
	item_name = _item_name
	quantity = _quantity
	if item_name == "wood path1" or item_name == "wood path2":
		item_name = "wood path"
	elif item_name == "stone path1" or item_name == "stone path2" or  item_name == "stone path3" or item_name == "stone path4": 
		item_name = "stone path"
#	if item_name == "Cobblestone":
#		item_name = "Stone"
#	api_call_name = item_name
#	if item_name == "Stone":
#		api_call_name = "stone ore"

func _ready():
	itemSprite.texture = load("res://Assets/Images/dropped_item_icon/" + item_name + ".png")
	if quantity == 1:
		itemQuantity.visible = false
	else:
		itemQuantity.text = str(quantity)
	rng.randomize()
	randomInt = rng.randi_range(1, 5)
	animationPlayer.play("Animate " + String(randomInt))
	$SoundEffects.stream = Sounds.pick_up_item


var adjustedPosition
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
				$Sprite.visible = false
				$CollisionShape2D.disabled = true
				if item_name == "wood" or item_name == "stone ore":
					pass
					#RustCalls.mint_object(item_name)
				PlayerInventory.add_item_to_hotbar(item_name, quantity)
				$SoundEffects.play()
				yield($SoundEffects, "finished")
				queue_free()

	velocity.normalized()
	velocity = move_and_slide(velocity, Vector2.UP)
	

func pick_up_item(body):
	if PlayerInventory.hotbar.size() == 10 and PlayerInventory.inventory.size() == 16:
		pass
	else: 
		player = body
		being_picked_up = true


