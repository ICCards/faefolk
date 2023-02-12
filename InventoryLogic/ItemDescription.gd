extends Node2D


var width
var height = 0
var item_name
var item_category


func initialize():
	if not Server.world.is_changing_scene:
		set_description_text(item_name)
		await get_tree().idle_frame
		set_health_and_energy()
		set_size_of_description($ItemName.size.x)
		$GridContainer.size = Vector2( width , height )
		$Body.size.x = (width*5.7) 
		$Body/ItemDescription.size.x = (width*5.7) 
		$ItemName.size.x = width


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
		#$Body/ItemDescription.set_text("description fds dsf sdf sdfddasd asd asdsa das fdsf f dsf fsdfdsdfsfds dasdsa a sdd asads das s")


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
		

 

