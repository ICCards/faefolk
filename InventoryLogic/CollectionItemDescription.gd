extends Node2D


var width
var height
var lines


func initialize(item_name):
	show()
	set_description_text(item_name)
	yield(get_tree(), "idle_frame")
	set_size_of_description($ItemName.rect_size.x)
	$GridContainer.rect_size = Vector2( width , height )
	$GridContainer/TopRow.rect_size.x = width
	$GridContainer/MiddleRow.rect_size.x = width
	$GridContainer/BottomRow.rect_size.x = width
	$Body.rect_size.x = width*5.7
	$Body/ItemDescription.rect_size.x = width * 5.7
	$ItemName.rect_size.x = width



func set_description_text(item):
	if item:
		var description = JsonData.item_data[item]["Description"]
		$ItemName.set_text(item[0].to_upper() + item.substr(1,-1))
		$Body/ItemDescription.set_text(description)
		var category = JsonData.item_data[item]["ItemCategory"]
		$Body/ItemAmount.modulate = Util.returnCategoryColor(category)
		if category == "Crop":
			$Body/ItemAmount.set_text("Total: " + str(PlayerData.player_data["collections"]["crops"][item]))
		elif category == "Fish":
			$Body/ItemAmount.set_text("Total: " + str(PlayerData.player_data["collections"]["fish"][item]))
		elif category == "Food":
			$Body/ItemAmount.set_text("Total: " + str(PlayerData.player_data["collections"]["food"][item]))
		elif category == "Forage":
			$Body/ItemAmount.set_text("Total: " + str(PlayerData.player_data["collections"]["forage"][item]))
		elif category == "Resource":
			$Body/ItemAmount.set_text("Total: " + str(PlayerData.player_data["collections"]["resources"][item]))
	else: 
		hide()


func set_size_of_description(x):
	if x <= 210:
		width = 58	
	else:
		width = 58 + ((x - 210) / 5)
	lines = $Body/ItemDescription.get_line_count()
	if lines > 2:
		height = (50 + (lines - 2) * 10)
	else:
		height = 50

