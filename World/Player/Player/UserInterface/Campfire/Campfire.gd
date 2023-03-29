extends Control

@onready var sound_effects: AudioStreamPlayer = $SoundEffects

var id
var level

var hovered_item
var ingredients = []

@onready var fuel_slot = $CampfireSlots/FuelSlot
@onready var ingredient_slot = $CampfireSlots/Ingredient
@onready var yield_slot = $CampfireSlots/YieldSlot
@onready var coal_yield_slot = $CampfireSlots/CoalYieldSlot

var current_cooking_item


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
		$TimerProgress.value = (10-$CookTimer.time_left)*10

func initialize():
	show()
	Server.player_node.actions.destroy_placeable_object()
	$InventorySlots.initialize_slots()
	$HotbarInventorySlots.initialize_slots()


func check_valid_recipe():
	var new_ingredients = []
	if ingredient_slot.item:
		new_ingredients.append([ingredient_slot.item.item_name, ingredient_slot.item.item_quantity])
	ingredients = new_ingredients
	if ingredients.size() == 1:
		if check_1_ingredient_recipe() and valid_fuel():
			cooking_active()
			return
	cooking_inactive()


func cooking_active():
	$CookTimer.start()
	$FireAnimatedSprite.show()
	if self.visible and Server.isLoaded:
		sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/furnace/furnace.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects.play()


func cooking_inactive():
	ingredients = []
	$CookTimer.stop()
	$TimerProgress.value = 0
	current_cooking_item = null
	$FireAnimatedSprite.hide()



func _on_CookTimer_timeout():
	if current_cooking_item and PlayerData.player_data["campfires"].has(id):
		add_to_yield_slot()
		remove_ingredients()
		remove_fuel()
		check_valid_recipe()


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
			PlayerData.player_data["campfires"][id]["3"] = ["coal", 3, null]
	elif fuel_slot.item.item_name == "coal":
		fuel_slot.item.decrease_item_quantity(1)
		PlayerData.decrease_item_quantity(fuel_slot, 1, id)
		if fuel_slot.item.item_quantity == 0:
			fuel_slot.removeFromSlot()
			PlayerData.remove_item(fuel_slot, id)

func remove_ingredients():
	for ingredient in JsonData.item_data[current_cooking_item]["Ingredients"]:
		if ingredient_slot.item:
			if ingredient[0] == ingredient_slot.item.item_name:
				PlayerData.decrease_item_quantity(ingredient_slot, ingredient[1], id)
				ingredient_slot.item.decrease_item_quantity(ingredient[1])
				if ingredient_slot.item.item_quantity == 0:
					ingredient_slot.removeFromSlot()
					PlayerData.remove_item(ingredient_slot, id)

func add_to_yield_slot():
	PlayerData.player_data["collections"]["food"][current_cooking_item] += 1
	if not yield_slot.item:
		yield_slot.initialize_item(current_cooking_item, 1, null)
		PlayerData.player_data["campfires"][id]["2"] = [current_cooking_item, 1, null]
	else:
		PlayerData.add_item_quantity(yield_slot, 1, id)
		yield_slot.item.add_item_quantity(1)


func check_valid_yield_slot_and_fuel(new_item):
	if valid_fuel():
		if not yield_slot.item: # empty yield slot
			current_cooking_item = new_item
			return true
		elif yield_slot.item.item_name == new_item and yield_slot.item.item_quantity != 999: # yield slot same as recipe and not 999
			current_cooking_item = new_item
			return true
	return false


func valid_fuel():
	if fuel_slot.item:
		if fuel_slot.item.item_name == "wood" and fuel_slot.item.item_quantity >= 3:
			return true
		elif fuel_slot.item.item_name == "coal" and fuel_slot.item.item_quantity >= 1:
			return true
	return false

func check_1_ingredient_recipe():
	for item in JsonData.item_data:
		if JsonData.item_data[item]["ItemCategory"] == "Food" and JsonData.item_data[item]["Ingredients"]:
			if JsonData.item_data[item]["Ingredients"].size() == 1:
				if ingredients[0][0] == JsonData.item_data[item]["Ingredients"][0][0] and ingredients[0][1] >= JsonData.item_data[item]["Ingredients"][0][1]: # checks name and sufficient ingredients
					return check_valid_yield_slot_and_fuel(item)
	return false



func _on_ExitBtn_pressed():
	get_parent().close_campfire(id)
