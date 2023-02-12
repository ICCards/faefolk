extends Node2D

var width
var height
var item_name
var amount_ingredients
@onready var Ingredient = load("res://InventoryLogic/Ingredient.tscn")

func initialize():
	set_description_text(item_name)
	set_ingredients(item_name)
	await get_tree().idle_frame
	set_size_of_description($ItemName.size.x)
	$Divider1.size.x = width - 12
	$Divider2.size.x = width - 12
	$GridContainer.size = Vector2( width , height )
	$GridContainer/TopRow.size.x = width
	$GridContainer/MiddleRow.size.x = width
	$GridContainer/BottomRow.size.x = width
	$ItemDescription.size.x = (width * 7) 
	$ItemName.size.x = width

func set_ingredients(item_name):
	amount_ingredients = JsonData.item_data[item_name]["Ingredients"].size()
	var ingredient1 = str(JsonData.item_data[item_name]["Ingredients"][0][0])
	var amount1 = JsonData.item_data[item_name]["Ingredients"][0][1]
	$Ingredient1/Icon.texture = load("res://Assets/Images/inventory_icons/" + JsonData.item_data[ingredient1]["ItemCategory"] + "/" + ingredient1 + ".png") 
	$Ingredient1/Name.text = ingredient1[0].to_upper() + ingredient1.substr(1, -1)
	$Ingredient1/Amount.text = str(amount1)
	$Ingredient1/Name.modulate = returnIfValidMaterial(ingredient1, amount1)
	$Ingredient1.position = Vector2(6,28)
	$Ingredient2.position = Vector2(6,41)
	$Ingredient3.position = Vector2(6,54)
	
	if amount_ingredients == 1:
		$Divider2.position = Vector2(6, 43)
		$ItemDescription.position = Vector2(6, 45)
		$Ingredient2.hide()
		$Ingredient3.hide()
	elif amount_ingredients == 2:
		$Divider2.position = Vector2(6, 56)
		$ItemDescription.position = Vector2(6, 58)
		$Ingredient2.show()
		$Ingredient3.hide()
		var ingredient2 = str(JsonData.item_data[item_name]["Ingredients"][1][0])
		var amount2 = JsonData.item_data[item_name]["Ingredients"][1][1]
		$Ingredient2/Icon.texture = load("res://Assets/Images/inventory_icons/" + JsonData.item_data[ingredient2]["ItemCategory"] + "/" + ingredient2 + ".png") 
		$Ingredient2/Name.text = ingredient2[0].to_upper() + ingredient2.substr(1, -1)
		$Ingredient2/Amount.text = str(amount2)
		$Ingredient2/Name.modulate = returnIfValidMaterial(ingredient2, amount2)
	elif amount_ingredients == 3:
		$Divider2.position = Vector2(6, 69)
		$ItemDescription.position = Vector2(6, 71)
		$Ingredient2.show()
		$Ingredient3.show()
		var ingredient2 = str(JsonData.item_data[item_name]["Ingredients"][1][0])
		var amount2 = JsonData.item_data[item_name]["Ingredients"][1][1]
		$Ingredient2/Icon.texture = load("res://Assets/Images/inventory_icons/" + JsonData.item_data[ingredient2]["ItemCategory"] + "/" + ingredient2 + ".png") 
		$Ingredient2/Name.text = ingredient2[0].to_upper() + ingredient2.substr(1, -1)
		$Ingredient2/Amount.text = str(amount2)
		$Ingredient2/Name.modulate = returnIfValidMaterial(ingredient2, amount2)
		var ingredient3 = str(JsonData.item_data[item_name]["Ingredients"][2][0])
		var amount3 = JsonData.item_data[item_name]["Ingredients"][2][1]
		$Ingredient3/Icon.texture = load("res://Assets/Images/inventory_icons/" + JsonData.item_data[ingredient3]["ItemCategory"] + "/" + ingredient3 + ".png") 
		$Ingredient3/Name.text = ingredient3[0].to_upper() + ingredient3.substr(1, -1)
		$Ingredient3/Amount.text = str(amount3)
		$Ingredient3/Name.modulate = returnIfValidMaterial(ingredient3, amount3)
		


func returnIfValidMaterial(item, amount):
	if PlayerData.returnSufficentCraftingMaterial(item, amount):
		return Color("ffffff") 
	else:
		return Color("ff0000") 


func set_description_text(item):
	if item:
		var category = JsonData.item_data[item]["ItemCategory"]
		var description = JsonData.item_data[item]["Description"]
		$ItemName.set_text(item[0].to_upper() + item.substr(1,-1))
		$ItemDescription.set_text(description)


func set_size_of_description(x):
	if x <= 210:
		width = 58	
	else:
		width = 58 + ((x - 210) / 5)
	var lines = $ItemDescription.get_line_count()
	if amount_ingredients == 1:
		height = (40 + (lines * 14) + (amount_ingredients * 10))
	elif amount_ingredients == 2:
		height = (40 + (lines * 14) + (amount_ingredients * 18))
	elif amount_ingredients == 3:
		height = (40 + (lines * 14) + (amount_ingredients * 20.5))
