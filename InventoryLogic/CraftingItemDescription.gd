extends Node2D

var width
var height
var item_name
var amount_ingredients

#func _ready():
#	item_name = "gold fishing rod"
#	initialize()

func _physics_process(delta):
	position = return_adjusted_position()

func return_adjusted_position():
	var y
	var x
	var pos = get_global_mouse_position() + Vector2(20,25)
	var height = 3*$GridContainer.size.y
	var width = 3*$GridContainer.size.x
	if height+pos.y > 720:
		y = 720-height
	else:
		y = pos.y
	if width+pos.x > 1080:
		x = 1080-width
	else:
		x = pos.x
	return Vector2(x,y)


func initialize():
	show()
	set_description_text(item_name)
	set_ingredients(item_name)
	await get_tree().process_frame
	set_size_of_description($Body/ItemName.size.x)
	$GridContainer.size = Vector2( width , height )

func set_ingredients(item_name):
	amount_ingredients = JsonData.item_data[item_name]["Ingredients"].size()
	var ingredient1 = str(JsonData.item_data[item_name]["Ingredients"][0][0])
	var amount1 = JsonData.item_data[item_name]["Ingredients"][0][1]
	$Body/Ingredient1/Icon.texture = load("res://Assets/Images/inventory_icons/" + JsonData.item_data[ingredient1]["ItemCategory"] + "/" + ingredient1 + ".png") 
	$Body/Ingredient1/Name.text = ingredient1[0].to_upper() + ingredient1.substr(1, -1)
	$Body/Ingredient1/Amount.text = str(amount1)
	$Body/Ingredient1/Name.modulate = returnIfValidMaterial(ingredient1, amount1)
	if amount_ingredients == 1:
		$Body/Ingredient2.hide()
		$Body/Ingredient3.hide()
	elif amount_ingredients == 2:
		$Body/Ingredient2.show()
		$Body/Ingredient3.hide()
		var ingredient2 = str(JsonData.item_data[item_name]["Ingredients"][1][0])
		var amount2 = JsonData.item_data[item_name]["Ingredients"][1][1]
		$Body/Ingredient2/Icon.texture = load("res://Assets/Images/inventory_icons/" + JsonData.item_data[ingredient2]["ItemCategory"] + "/" + ingredient2 + ".png") 
		$Body/Ingredient2/Name.text = ingredient2[0].to_upper() + ingredient2.substr(1, -1)
		$Body/Ingredient2/Amount.text = str(amount2)
		$Body/Ingredient2/Name.modulate = returnIfValidMaterial(ingredient2, amount2)
	elif amount_ingredients == 3:
		$Body/Ingredient2.show()
		$Body/Ingredient3.show()
		var ingredient2 = str(JsonData.item_data[item_name]["Ingredients"][1][0])
		var amount2 = JsonData.item_data[item_name]["Ingredients"][1][1]
		$Body/Ingredient2/Icon.texture = load("res://Assets/Images/inventory_icons/" + JsonData.item_data[ingredient2]["ItemCategory"] + "/" + ingredient2 + ".png") 
		$Body/Ingredient2/Name.text = ingredient2[0].to_upper() + ingredient2.substr(1, -1)
		$Body/Ingredient2/Amount.text = str(amount2)
		$Body/Ingredient2/Name.modulate = returnIfValidMaterial(ingredient2, amount2)
		var ingredient3 = str(JsonData.item_data[item_name]["Ingredients"][2][0])
		var amount3 = JsonData.item_data[item_name]["Ingredients"][2][1]
		$Body/Ingredient3/Icon.texture = load("res://Assets/Images/inventory_icons/" + JsonData.item_data[ingredient3]["ItemCategory"] + "/" + ingredient3 + ".png") 
		$Body/Ingredient3/Name.text = ingredient3[0].to_upper() + ingredient3.substr(1, -1)
		$Body/Ingredient3/Amount.text = str(amount3)
		$Body/Ingredient3/Name.modulate = returnIfValidMaterial(ingredient3, amount3)


func returnIfValidMaterial(item, amount):
	if PlayerData.returnSufficentCraftingMaterial(item, amount):
		return Color("ffffff") 
	else:
		return Color("ff0000") 


func set_description_text(item):
	if item:
		var category = JsonData.item_data[item]["ItemCategory"]
		var description = JsonData.item_data[item]["Description"]
		$Body/ItemName.set_text(Util.capitalizeFirstLetter(item))
		$Body/ItemDescription.set_text(description)


func set_size_of_description(x):
	if x <= 726:
		width = 39
	else:
		width = 39 + ((x - 726) / 22)
	var lines = $Body/ItemDescription.get_line_count()
	$Body/ItemDescription.custom_minimum_size.y = 124*lines
	height = 36 + ((lines - 1) * 4.5)
	height += (10*JsonData.item_data[item_name]["Ingredients"].size())
