extends KinematicBody2D

var velocity = Vector2.ZERO
const MAX_SPEED = 425
const ACCELERATION = 460
onready var itemSprite = $Sprite
onready var animationPlayer = $AnimationPlayer


var player = null
var being_picked_up = false
var item_name
var randomInt
var rng = RandomNumberGenerator.new()
var api_call_name

#onready var api = Api
#var thread = Thread.new()
#func _whoAmI(_value):
#	print("THREAD FUNC!")
#	var result = api.mint(api_call_name.to_lower(), "jkfup-u5fms-2eumr-7z7ub-5ssv2-dpuxn-pmnrx-vwr4h-cqghb-xhki5-aae")
#	call_deferred("loadDone")
#	return result
#
#func loadDone():
#	var value = thread.wait_to_finish()
#	print(value)	
#	queue_free()

func initItemDropType(item_name_input):
	item_name = item_name_input
	if item_name == "Cobblestone":
		item_name = "Stone"
	api_call_name = item_name
	if item_name == "Stone":
		api_call_name = "stone ore"

func _ready():
	itemSprite.texture = load("res://Assets/dropped_item_icon/" + item_name + ".png")
	rng.randomize()
	randomInt = rng.randi_range(1, 5)
	animationPlayer.play("Animate " + String(randomInt))
	

	
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
			if $SoundEffects.playing == true:
				return
			else: 
				$Sprite.visible = false
				$CollisionShape2D.disabled = true
	#			if (thread.is_active()):
	#				# Already working
	#				return
	#			print("START THREAD!")
	#			thread.start(self,"_whoAmI",null)
				PlayerInventory.add_item_to_hotbar(item_name, 1)
				queue_free()
				$SoundEffects.play()
				yield($SoundEffects, "finished")
				$SoundEffects.stop()
				#queue_free()
			

	velocity.normalized()
	velocity = move_and_slide(velocity, Vector2.UP)
	
func pick_up_item(body):
	if PlayerInventory.hotbar.size() == 10 and PlayerInventory.inventory.size() == 16:
		pass
	else: 
		player = body
		being_picked_up = true


