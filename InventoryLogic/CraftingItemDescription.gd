extends Node2D

var width
var height
var item_name
var amount_ingredients
onready var Ingredient = preload("res://InventoryLogic/Ingredient.tscn")

func initialize():
	set_description_text(item_name)
	set_ingredients(item_name)
	yield(get_tree(), "idle_frame")
	set_size_of_description($ItemName.rect_size.x)
	$GridContainer.rect_size = Vector2( width , height )
	$GridContainer/TopRow.rect_size.x = width
	$GridContainer/MiddleRow.rect_size.x = width
	$GridContainer/BottomRow.rect_size.x = width
	$ItemDescription.rect_size.x = (width * 7) 
	$ItemName.rect_size.x = width

func set_ingredients(item_name):
	amount_ingredients = JsonData.crafting_data[item_name]["ingredients"].size()
	var ingredient1 = str(JsonData.crafting_data[item_name]["ingredients"][0][0])
	var amount1 = JsonData.crafting_data[item_name]["ingredients"][0][1]
	$Ingredient1/Icon.texture = load("res://Assets/Images/inventory_icons/" + JsonData.item_data[ingredient1]["ItemCategory"] + "/" + ingredient1 + ".png") 
	$Ingredient1/Name.text = ingredient1[0].to_upper() + ingredient1.substr(1, -1)
	$Ingredient1/Amount.text = str(amount1)
	$Ingredient1/Name.modulate = returnIfValidMaterial(ingredient1, amount1)
	if amount_ingredients == 1:
		$Divider2.rect_position = Vector2(6, 42)
		$ItemDescription.rect_position = Vector2(6, 44)
		$Ingredient2.visible = false
	elif amount_ingredients == 2:
		$Divider2.rect_position = Vector2(6, 50)
		$ItemDescription.rect_position = Vector2(6, 52)
		$Ingredient2.visible = true
		var ingredient2 = str(JsonData.crafting_data[item_name]["ingredients"][1][0])
		var amount2 = JsonData.crafting_data[item_name]["ingredients"][1][1]
		$Ingredient2/Icon.texture = load("res://Assets/Images/inventory_icons/" + JsonData.item_data[ingredient2]["ItemCategory"] + "/" + ingredient2 + ".png") 
		$Ingredient2/Name.text = ingredient2[0].to_upper() + ingredient2.substr(1, -1)
		$Ingredient2/Amount.text = str(amount2)
		$Ingredient2/Name.modulate = returnIfValidMaterial(ingredient2, amount2)


func returnIfValidMaterial(item, amount):
	if PlayerInventory.returnSufficentCraftingMaterial(item, amount):
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
	height = (40 + (lines * 14) + (amount_ingredients * 12))
