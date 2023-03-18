extends Node2D


var width
var height = 0
var item_name: String
var item_category: String


#func _ready():
#	item_name = "sunflower"
#	item_category = JsonData.item_data[item_name]["ItemCategory"]
#	initialize()


func initialize():
	if not Server.world.is_changing_scene:
		item_category = JsonData.item_data[item_name]["ItemCategory"]
		set_description_text(item_name)
		await get_tree().process_frame
		set_health_and_energy()
		set_size_of_description($Body/ItemName.size.x)
		$GridContainer.size = Vector2( width , height )
		#$Body.size.x = (width*5.7) 
		#$Body/ItemDescription.size.x = (width*5.7) 
		#$ItemName.size.x = width


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
		var description = JsonData.item_data[item]["Description"]
		$Body/ItemCategory.modulate = Util.returnCategoryColor(item_category)
		$Body/ItemName.set_text(item.left(1).to_upper() + item.right(item.length()-1))
		$Body/ItemCategory.set_text(item_category.left(1).to_upper() + item_category.right(item_category.length()-1))
		$Body/ItemDescription.set_text(description)


func set_size_of_description(x):
	if x <= 726:
		width = 39
	else:
		width = 39 + ((x - 726) / 22)
	var lines = $Body/ItemDescription.get_line_count()
	$Body/ItemDescription.custom_minimum_size.y = 124*lines
	height = 36 + ((lines - 1) * 4.5)
	if item_category == "Food" or item_category == "Fish" or item_category == "Crop":
		height += 12
		

 

