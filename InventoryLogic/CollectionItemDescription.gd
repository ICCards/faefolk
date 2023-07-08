extends Node2D


var width
var height
var lines


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
	if width+pos.x > 1280:
		x = 1280-width
	else:
		x = pos.x
	return Vector2(x,y)


func initialize(item_name):
	show()
	set_description_text(item_name)
	await get_tree().process_frame
	set_size_of_description($Body/ItemName.size.x)
	$GridContainer.size = Vector2( width , height )


func set_description_text(item):
	if item:
		var description = JsonData.item_data[item]["Description"]
		$Body/ItemName.set_text(Util.capitalizeFirstLetter(item))
		$Body/ItemDescription.set_text(description)
		var category = JsonData.item_data[item]["ItemCategory"]
		$Body/ItemAmount.modulate = Util.returnCategoryColor(category)
		if category == "Crop":
			$Body/ItemAmount.set_text("Harvested: " + str(PlayerData.player_data["collections"]["crops"][item]))
		elif category == "Fish":
			$Body/ItemAmount.set_text("Caught: " + str(PlayerData.player_data["collections"]["fish"][item]))
		elif category == "Food":
			$Body/ItemAmount.set_text("Cooked: " + str(PlayerData.player_data["collections"]["food"][item]))
		elif category == "Forage":
			$Body/ItemAmount.set_text("Foraged: " + str(PlayerData.player_data["collections"]["forage"][item]))
		elif category == "Resource":
			$Body/ItemAmount.set_text("Total: " + str(PlayerData.player_data["collections"]["resources"][item]))
		elif category == "Mob":
			$Body/ItemAmount.set_text("Killed: " + str(PlayerData.player_data["collections"]["mobs"][item]))
	else: 
		hide()


func set_size_of_description(x):
	if x <= 726:
		width = 39
	else:
		width = 39 + ((x - 726) / 22)
	var lines = $Body/ItemDescription.get_line_count()
	$Body/ItemDescription.custom_minimum_size.y = 124*lines
	height = 36 + ((lines - 1) * 4.75)
