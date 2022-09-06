extends Node2D


var width
var height
var item_name
var item_category


func initialize():
	set_description_text(item_name)
	yield(get_tree(), "idle_frame")
	set_health_and_energy()
	set_size_of_description($ItemName.rect_size.x)
	$GridContainer.rect_size = Vector2( width , height )
#	$GridContainer/TopRow.rect_size.x = width
#	$GridContainer/MiddleRow.rect_size.x = width
#	$GridContainer/BottomRow.rect_size.x = width
	$Body.rect_size.x = (width*5.7) 
	$Body/ItemDescription.rect_size.x = (width*5.7) 
	$ItemName.rect_size.x = width

func set_health_and_energy():
	if item_category == "Food" or item_category == "Fish":
		show_health_and_energy()
	else:
		hide_health_and_energy()

func show_health_and_energy():
	$Body/Energy.show()
	$Body/Health.show()
	$Body/Energy/EnergyAmount.text = "+" + str(JsonData.food_data[item_name]["Energy"]) + " Energy"
	$Body/Health/HealthAmount.text = "+" + str(JsonData.food_data[item_name]["Health"]) + " Health"

func hide_health_and_energy():
	$Body/Energy.hide()
	$Body/Health.hide()

func set_description_text(item):
	if item:
		var category = JsonData.item_data[item]["ItemCategory"]
		var description = JsonData.item_data[item]["Description"]
		$Body/ItemCategory.modulate = Util.returnCategoryColor(category)
		$ItemName.set_text(item[0].to_upper() + item.substr(1,-1))
		$Body/ItemCategory.set_text(category[0].to_upper() + category.substr(1,-1))
		$Body/ItemDescription.set_text(description)


func set_size_of_description(x):
	if x <= 210:
		width = 58	
	else:
		width = 58 + ((x - 210) / 5)
	var lines = $Body/ItemDescription.get_line_count()
	if lines > 2:
		height = (50 + (lines - 2) * 20)
	else:
		height = 50
	if item_category == "Food" or item_category == "Fish":
		height += 46
		
		 
	 
	
