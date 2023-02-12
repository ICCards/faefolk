extends Node2D


var width
var height
var lines


func initialize(item_name):
	show()
	set_description_text(item_name)
	await get_tree().idle_frame
	set_size_of_description($ItemName.size.x)
	$GridContainer.size = Vector2( width , height )
	$GridContainer/TopRow.size.x = width
	$GridContainer/MiddleRow.size.x = width
	$GridContainer/BottomRow.size.x = width
	$Body.size.x = width*5.7
	$Body/ItemDescription.size.x = width * 5.7
	$ItemName.size.x = width



func set_description_text(item):
	if item:
		var description = JsonData.item_data[item]["Description"]
		$ItemName.set_text(item[0].to_upper() + item.substr(1,-1))
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
	if x <= 210:
		width = 58	
	else:
		width = 58 + ((x - 210) / 5)
	lines = $Body/ItemDescription.get_line_count()
	if lines > 2:
		height = (50 + (lines - 2) * 10)
	else:
		height = 50

