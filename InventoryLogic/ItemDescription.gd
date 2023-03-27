extends Node2D


var width
var height = 0
var item_name: String
var item_category: String


#func _ready():
#	item_name = "bronze ore"
#	item_category = JsonData.item_data[item_name]["ItemCategory"]
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
	if not Server.world.is_changing_scene:
		show()
		item_category = JsonData.item_data[item_name]["ItemCategory"]
		set_description_text(item_name)
		await get_tree().process_frame
		set_health_and_energy()
		set_size_of_description($Body/ItemName.size.x)
		$GridContainer.size = Vector2( width , height )


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
		$Body/ItemName.set_text(Util.capitalizeFirstLetter(item))
		$Body/ItemCategory.set_text(Util.capitalizeFirstLetter(item_category))
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
		

 

