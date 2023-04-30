extends Control

var id
var hovered_item
var location
var time_last_opened
var time_remaining

@onready var yield_slot = $BarrelSlots/Yield
@onready var ingredient_slot = $BarrelSlots/Ingredient
var is_cooking_active: bool

const TIME_TO_COOK = 100

func _ready():
	initialize()

func destroy():
	set_physics_process(false)
	$ItemDescription.queue_free()
	queue_free()

func _physics_process(delta):
	if hovered_item and not find_parent("UserInterface").holding_item:
		$ItemDescription.show()
		$ItemDescription.item_category = JsonData.item_data[hovered_item]["ItemCategory"]
		$ItemDescription.item_name = hovered_item
		$ItemDescription.position = get_local_mouse_position() + Vector2(20 , 25)
		$ItemDescription.initialize()
	else:
		$ItemDescription.hide()
	if $CookTimer.time_left == 0:
		return 
	else:
		$TimerProgress.value = (TIME_TO_COOK-$CookTimer.time_left)


func initialize():
	Server.player_node.actions.destroy_placeable_object()
	var last_opened = Server.world.server_data["ui_slots"][id]["lo"]
	if last_opened == null:
		print("FIRST OPEN")
	else:
		print("SECS SINCE LAST OPEN = " + str(int(Time.get_unix_time_from_system()) - last_opened))


func check_valid_recipe():
	if ingredient_slot.item:
		if ingredient_slot.item.item_quantity >= 5:
			if yield_slot.item:
				if not yield_slot.item.item_quantity == 999:
					if not is_cooking_active:
						start_cooking()
					return
			elif not is_cooking_active:
				start_cooking()
			return
	if is_cooking_active:
		stop_cooking()


func start_cooking():
	is_cooking_active = true
	$CookTimer.start(TIME_TO_COOK)

func stop_cooking():
	is_cooking_active = false
	$CookTimer.stop()
	$TimerProgress.value = 0


func _on_cook_timer_timeout():
	if ingredient_slot.item.item_quantity >= 5 and Server.world.server_data["ui_slots"].has(id):
		add_to_yield_slot()
		remove_ingredients()
		check_valid_recipe()


func add_to_yield_slot():
	PlayerData.player_data["collections"]["food"]["wine"] += 1
	if not yield_slot.item:
		yield_slot.initialize_item("wine", 1, null)
		Server.world.server_data["ui_slots"][id]["1"] = ["wine",1,null]
	else:
		PlayerData.add_item_quantity(yield_slot,1,id)
		yield_slot.item.add_item_quantity(1)


func remove_ingredients():
	PlayerData.decrease_item_quantity(ingredient_slot, 5, id)
	ingredient_slot.item.decrease_item_quantity(5)
	if ingredient_slot.item.item_quantity == 0:
		ingredient_slot.removeFromSlot()
		PlayerData.remove_item(ingredient_slot, id)


func _input(event):
	if event.is_action_pressed("action"):
		get_parent().close_barrel(id,location,$CookTimer.time_left)

func _on_exit_btn_pressed():
	get_parent().close_barrel(id,location,$CookTimer.time_left)
