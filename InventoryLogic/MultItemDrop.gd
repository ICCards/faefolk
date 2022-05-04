extends KinematicBody2D

var player = null
var being_picked_up = false
var velocity = Vector2.ZERO
const MAX_SPEED = 425
const ACCELERATION = 460

onready var api = Api
var thread = Thread.new()

func _whoAmI(_value):
	print("THREAD FUNC!")
	var result = api.mint("wood", "j26ec-ix7zw-kiwcx-ixw6w-72irq-zsbyr-4t7fk-alils-u33an-kh6rk-7qe")
	call_deferred("loadDone")
	return result

func loadDone():
	var value = thread.wait_to_finish()
	print(value)	
	queue_free()

func _physics_process(_delta):
	if !being_picked_up:
		velocity = Vector2.ZERO
	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)
		var distance = global_position.distance_to(player.global_position)
		if distance < 6: 
			$Sprite.visible = false
			$CollisionShape2D.disabled = true
			if (thread.is_active()):
				# Already working
				return
			print("START THREAD!")
			thread.start(self,"_whoAmI",null)
			PlayerInventory.add_item_to_hotbar("Wood", 1)
			$SoundEffects.play()
			queue_free()
			yield($SoundEffects, "finished")
			$SoundEffects.stop()

	velocity.normalized()
	velocity = move_and_slide(velocity, Vector2.UP)
	
func pick_up_item(body):
	if PlayerInventory.hotbar.size() == 10 and PlayerInventory.inventory.size() == 16:
		pass
	else: 
		player = body
		being_picked_up = true
