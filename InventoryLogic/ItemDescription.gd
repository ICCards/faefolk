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
	$Body.rect_size.x = (width*5.7) 
	$Body/ItemDescription.rect_size.x = (width*5.7) 
	$ItemName.rect_size.x = width

func _physics_process(delta):
	if not visible:
		return
	adjusted_description_position()

func adjusted_description_position():
	yield(get_tree(), "idle_frame")
	position = Vector2(get_local_mouse_position().x - 110, -42)
#	adjusted_pos = Vector2(get_local_mouse_position().x + 45, -height)
#	var lines = $ItemDescription/Body/ItemDescription.get_line_count()
#	if lines == 8:
#		position = Vector2(get_local_mouse_position().x + 45, -194)
#	elif lines == 7:
#		position = Vector2(get_local_mouse_position().x + 45, -168)
#	elif lines == 6:
#		position = Vector2(get_local_mouse_position().x + 45, -144)
#	elif lines == 5:
#		position = Vector2(get_local_mouse_position().x + 45, -118)
#	elif lines == 4:
#		position = Vector2(get_local_mouse_position().x + 45, -93)
#	elif lines == 3:
#		position = Vector2(get_local_mouse_position().x + 45, -66)
#	else:
#		position = Vector2(get_local_mouse_position().x + 45, -42)



func set_health_and_energy():
	if item_category == "Food" or item_category == "Fish" or item_category == "Crop":
		show_health_and_energy()
	else:
		hide_health_and_energy()

func show_health_and_energy():
	$Body/Energy.show()
	$Body/Health.show()
	$Body/Energy/EnergyAmount.text = "+" + str(JsonData.item_data[item_name]["EnergyHealth"][0]) + " Energy"
	$Body/Health/HealthAmount.text = "+" + str(JsonData.item_data[item_name]["EnergyHealth"][1]) + " Health"

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
		height = (50 + (lines - 2) * 9.5)
	else:
		height = 50
	if item_category == "Food" or item_category == "Fish" or item_category == "Crop":
		height += 24
		

 

