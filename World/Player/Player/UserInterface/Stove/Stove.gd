extends Control

@onready var sound_effects: AudioStreamPlayer = $SoundEffects

var id
var level

var hovered_item
var ingredients = []


@onready var fuel_slot = $StoveSlots/FuelSlot
@onready var ingredient_slot1 = $StoveSlots/Ingredient1
@onready var ingredient_slot2 = $StoveSlots/Ingredient2
@onready var ingredient_slot3 = $StoveSlots/Ingredient3
@onready var yield_slot1 = $StoveSlots/YieldSlot1
@onready var yield_slot2 = $StoveSlots/YieldSlot2
@onready var coal_yield_slot = $StoveSlots/CoalYieldSlot
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
	Server.player_node.actions.destroy_placable_object()
	$MenuTitle.text = "Stove #" + str(level)
	$InventorySlots.initialize_slots()
	$HotbarInventorySlots.initialize_slots()


func check_valid_recipe():
	var new_ingredients = []
	if ingredient_slot1.item:
		new_ingredients.append([ingredient_slot1.item.item_name, ingredient_slot1.item.item_quantity])
	if ingredient_slot2.item:
		new_ingredients.append([ingredient_slot2.item.item_name, ingredient_slot2.item.item_quantity])
	if ingredient_slot3.item:
		new_ingredients.append([ingredient_slot3.item.item_name, ingredient_slot3.item.item_quantity])
	if ingredients != new_ingredients:
		ingredients = new_ingredients
		if ingredients.size() == 1:
			if check_1_ingredient_recipe():
				cooking_active()
			else:
				cooking_inactive()
		elif ingredients.size() == 2:
			if check_2_ingredient_recipe():
				cooking_active()
			else:
				cooking_inactive()
		elif ingredients.size() == 3:
			if check_3_ingredient_recipe():
				cooking_active()
			else:
				cooking_inactive()
		else:
			cooking_inactive()
	elif not valid_fuel():
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
	if current_cooking_item and PlayerData.player_data["stoves"].has(id):
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
			PlayerData.player_data["stoves"][id]["6"] = ["coal", 3, null]
	elif fuel_slot.item.item_name == "coal":
		fuel_slot.item.decrease_item_quantity(1)
		PlayerData.decrease_item_quantity(fuel_slot, 1, id)
		if fuel_slot.item.item_quantity == 0:
			fuel_slot.removeFromSlot()
			PlayerData.remove_item(fuel_slot, id)

func remove_ingredients():
	for ingredient in JsonData.item_data[current_cooking_item]["Ingredients"]:
		if ingredient_slot1.item:
			if ingredient[0] == ingredient_slot1.item.item_name:
				PlayerData.decrease_item_quantity(ingredient_slot1, ingredient[1], id)
				ingredient_slot1.item.decrease_item_quantity(ingredient[1])
				if ingredient_slot1.item.item_quantity == 0:
					ingredient_slot1.removeFromSlot()
					PlayerData.remove_item(ingredient_slot1, id)
		if ingredient_slot2.item:
			if ingredient[0] == ingredient_slot2.item.item_name:
				PlayerData.decrease_item_quantity(ingredient_slot2, ingredient[1], id)
				ingredient_slot2.item.decrease_item_quantity(ingredient[1])
				if ingredient_slot2.item.item_quantity == 0:
					ingredient_slot2.removeFromSlot()
					PlayerData.remove_item(ingredient_slot2, id)
		if ingredient_slot3.item:
			if ingredient[0] == ingredient_slot3.item.item_name:
				PlayerData.decrease_item_quantity(ingredient_slot3, ingredient[1], id)
				ingredient_slot3.item.decrease_item_quantity(ingredient[1])
				if ingredient_slot3.item.item_quantity == 0:
					ingredient_slot3.removeFromSlot()
					PlayerData.remove_item(ingredient_slot3, id)

func add_to_yield_slot():
	PlayerData.player_data["collections"]["food"][current_cooking_item] += 1
	if not yield_slot1.item:
		yield_slot1.initialize_item(current_cooking_item, 1, null)
		PlayerData.player_data["stoves"][id]["4"] = [current_cooking_item, 1, null]
	elif not yield_slot1.item.item_quantity == 999 and yield_slot1.item.item_name == current_cooking_item:
		PlayerData.add_item_quantity(yield_slot1, 1, id)
		yield_slot1.item.add_item_quantity(1)
	elif not yield_slot2.item:
		yield_slot2.initialize_item(current_cooking_item, 1, null)
		PlayerData.player_data["stoves"][id]["5"] = [current_cooking_item, 1, null]
	else:
		PlayerData.add_item_quantity(yield_slot2, 1, id)
		yield_slot2.item.add_item_quantity(1)


func check_valid_yield_slot_and_fuel(new_item):
	if valid_fuel():
		if not yield_slot1.item: # empty yield slot
			current_cooking_item = new_item
			return true
		elif yield_slot1.item.item_name == new_item: # yield slot same as recipe
			current_cooking_item = new_item
			return true
		elif not yield_slot2.item:
			current_cooking_item = new_item
			return true
		elif yield_slot2.item.item_name == new_item: # yield slot same as recipe
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

func check_2_ingredient_recipe():
	for item in JsonData.item_data:
		if JsonData.item_data[item]["ItemCategory"] == "Food" and JsonData.item_data[item]["Ingredients"]:
			if JsonData.item_data[item]["Ingredients"].size() == 2:
				var recipe = JsonData.item_data[item]["Ingredients"]
				if ingredients[0][0] == recipe[0][0] and ingredients[1][0] == recipe[1][0]:
					if ingredients[0][1] >= recipe[0][1] and ingredients[1][1] >= recipe[1][1]: 
						return check_valid_yield_slot_and_fuel(item)
				elif ingredients[0][0] == recipe[1][0] and ingredients[1][0] == recipe[0][0]:
					if ingredients[0][1] >= recipe[1][1] and ingredients[1][1] >= recipe[0][1]:
						return check_valid_yield_slot_and_fuel(item)
	return false

func check_3_ingredient_recipe():
	for item in JsonData.item_data:
		if JsonData.item_data[item]["ItemCategory"] == "Food" and JsonData.item_data[item]["Ingredients"]:
			if JsonData.item_data[item]["Ingredients"].size() == 3:
				var recipe = JsonData.item_data[item]["Ingredients"]
				if ingredients[0][0] == recipe[0][0] and ingredients[1][0] == recipe[1][0] and ingredients[2][0] == recipe[2][0]:
					if ingredients[0][1] >= recipe[0][1] and ingredients[1][1] >= recipe[1][1] and ingredients[2][1] >= recipe[2][1]: 
						return check_valid_yield_slot_and_fuel(item)
				elif ingredients[0][0] == recipe[0][0] and ingredients[1][0] == recipe[2][0] and ingredients[2][0] == recipe[1][0]:
					if ingredients[0][1] >= recipe[0][1] and ingredients[1][1] >= recipe[2][1] and ingredients[2][1] >= recipe[1][1]: 
						return check_valid_yield_slot_and_fuel(item)
				elif ingredients[0][0] == recipe[1][0] and ingredients[1][0] == recipe[0][0] and ingredients[2][0] == recipe[2][0]:
					if ingredients[0][1] >= recipe[1][1] and ingredients[1][1] >= recipe[0][1] and ingredients[2][1] >= recipe[2][1]: 
						return check_valid_yield_slot_and_fuel(item)
				elif ingredients[0][0] == recipe[1][0] and ingredients[1][0] == recipe[2][0] and ingredients[2][0] == recipe[0][0]:
					if ingredients[0][1] >= recipe[1][1] and ingredients[1][1] >= recipe[2][1] and ingredients[2][1] >= recipe[0][1]: 
						return check_valid_yield_slot_and_fuel(item)
				elif ingredients[0][0] == recipe[2][0] and ingredients[1][0] == recipe[1][0] and ingredients[2][0] == recipe[0][0]:
					if ingredients[0][1] >= recipe[2][1] and ingredients[1][1] >= recipe[1][1] and ingredients[2][1] >= recipe[0][1]: 
						return check_valid_yield_slot_and_fuel(item)
				elif ingredients[0][0] == recipe[2][0] and ingredients[1][0] == recipe[0][0] and ingredients[2][0] == recipe[1][0]:
					if ingredients[0][1] >= recipe[2][1] and ingredients[1][1] >= recipe[0][1] and ingredients[2][1] >= recipe[1][1]: 
						return check_valid_yield_slot_and_fuel(item)
	return false


func _on_ExitBtn_pressed():
	get_parent().close_stove(id)
