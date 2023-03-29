extends Control

var hovered_item
var id


@onready var sound_effects: AudioStreamPlayer = $SoundEffects
@onready var ore_slot1 = $FurnaceSlots/OreSlot1
@onready var ore_slot2 = $FurnaceSlots/OreSlot2
@onready var fuel_slot = $FurnaceSlots/FuelSlot
@onready var yield_slot1 = $FurnaceSlots/YieldSlot1
@onready var yield_slot2 = $FurnaceSlots/YieldSlot2
@onready var coal_yield_slot = $FurnaceSlots/CoalYieldSlot

func _ready():
	initialize()

func initialize():
	Server.player_node.actions.destroy_placeable_object()
	hovered_item = null
	show()
	$InventorySlots.initialize_slots()
	$HotbarInventorySlots.initialize_slots()

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
		$TimerProgress.value = (10-$CookTimer.time_left)*10


func _on_CookTimer_timeout():
	if PlayerData.player_data["furnaces"].has(id):
		smelt()
		check_if_furnace_active()

func smelt():
	if ore_slot1.item:
		if ore_slot1.item.item_quantity >= 5 and valid_yield_slot(ore_slot1.item.item_name):
			remove_fuel()
			ore_slot1.item.decrease_item_quantity(5)
			PlayerData.decrease_item_quantity(ore_slot1, 5, id)
			add_to_yield_slot(ore_slot1.item.item_name)
			if ore_slot1.item.item_quantity == 0:
				ore_slot1.removeFromSlot()
				PlayerData.remove_item(ore_slot1, id)
			return
	if ore_slot2.item:
		if ore_slot2.item.item_quantity >= 5 and valid_yield_slot(ore_slot2.item.item_name):
			remove_fuel()
			ore_slot2.item.decrease_item_quantity(5)
			PlayerData.decrease_item_quantity(ore_slot2, 5, id)
			add_to_yield_slot(ore_slot2.item.item_name)
			if ore_slot2.item.item_quantity == 0:
				ore_slot2.removeFromSlot()
				PlayerData.remove_item(ore_slot2, id)
			return
			
func remove_fuel():
	if fuel_slot.item.item_name == "wood":
		fuel_slot.item.decrease_item_quantity(3)
		PlayerData.decrease_item_quantity(fuel_slot, 3, id)
		if fuel_slot.item.item_quantity == 0:
			fuel_slot.removeFromSlot()
			PlayerData.remove_item(fuel_slot, id)
		if coal_yield_slot.item:
			PlayerData.add_item_quantity(coal_yield_slot, 3, id)
			coal_yield_slot.item.add_item_quantity(3)
		else:
			coal_yield_slot.initialize_item("coal", 3, null)
			PlayerData.player_data["furnaces"][id]["5"] = ["coal", 3, null]
	elif fuel_slot.item.item_name == "coal":
		fuel_slot.item.decrease_item_quantity(1)
		PlayerData.decrease_item_quantity(fuel_slot, 1, id)
		if fuel_slot.item.item_quantity == 0:
			fuel_slot.removeFromSlot()
			PlayerData.remove_item(fuel_slot, id)

func add_to_yield_slot(ore_name):
	var ingot_name
	match ore_name:
		"bronze ore":
			ingot_name = "bronze ingot"
		"iron ore":
			ingot_name = "iron ingot"
		"gold ore":
			ingot_name = "gold ingot"
	if yield_slot1.item:
		if yield_slot1.item.item_name == ingot_name and yield_slot1.item.item_quantity != 999:
			yield_slot1.item.add_item_quantity(1)
			PlayerData.add_item_quantity(yield_slot1, 1, id)
			return
	if yield_slot2.item:
		if yield_slot2.item.item_name == ingot_name and yield_slot2.item.item_quantity != 999:
			yield_slot2.item.add_item_quantity(1)
			PlayerData.add_item_quantity(yield_slot2, 1, id)
			return
	if not yield_slot1.item:
		yield_slot1.initialize_item(ingot_name, 1, null)
		PlayerData.player_data["furnaces"][id]["3"] = [ingot_name, 1, null]
		return
	if not yield_slot2.item:
		yield_slot2.initialize_item(ingot_name, 1, null)
		PlayerData.player_data["furnaces"][id]["4"] = [ingot_name, 1, null]
		return


func check_if_furnace_active():
	if valid_recipe():
		cooking_active()
	else:
		cooking_inactive()


func valid_recipe():
	if valid_fuel():
		if ore_slot1.item:
			if ore_slot1.item.item_quantity >= 5:
				if valid_yield_slot(ore_slot1.item.item_name):
					return true
		if ore_slot2.item:
			if ore_slot2.item.item_quantity >= 5:
				if valid_yield_slot(ore_slot2.item.item_name):
					return true
	return false

func valid_yield_slot(ore_name):
	var ingot_name
	match ore_name:
		"bronze ore":
			ingot_name = "bronze ingot"
		"iron ore":
			ingot_name = "iron ingot"
		"gold ore":
			ingot_name = "gold ingot"
	if yield_slot1.item:
		if yield_slot1.item.item_name == ingot_name and yield_slot1.item.item_quantity != 999:
			return true
	if yield_slot2.item:
		if yield_slot2.item.item_name == ingot_name and yield_slot2.item.item_quantity != 999:
			return true
	if not yield_slot1.item:
		return true
	if not yield_slot2.item:
		return true
	return false

func cooking_active():
	$CookTimer.start()
	$FireAnimatedSprite.show()
	if Server.world.name == "Overworld":
		Server.world.get_node("PlaceableObjects/"+id).interactives.toggle_furnace_smoke(true)
	if self.visible and Server.isLoaded:
		sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/furnace/furnace.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects.play()

func cooking_inactive():
	$CookTimer.stop()
	$TimerProgress.value = 0
	$FireAnimatedSprite.hide()
	if Server.world.name == "Overworld":
		Server.world.get_node("PlaceableObjects/"+id).interactives.toggle_furnace_smoke(false)

func valid_fuel():
	if fuel_slot.item:
		if fuel_slot.item.item_name == "wood" and fuel_slot.item.item_quantity >= 3:
			return true
		elif fuel_slot.item.item_name == "coal" and fuel_slot.item.item_quantity >= 1:
			return true
	return false


func _on_ExitBtn_pressed():
	get_parent().close_furnace(id)
