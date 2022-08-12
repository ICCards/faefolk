extends Node2D


var width
var height
var item_name

#func _ready():
#	set_description_text(item_name)
#	yield(get_tree(), "idle_frame")
#	set_size_of_description($ItemName.rect_size.x)
#	$GridContainer.rect_size.x = width
#	$GridContainer/TopRow.rect_size.x = width
#	$GridContainer/MiddleRow.rect_size.x = width
#	$GridContainer/BottomRow.rect_size.x = width
#	$ItemDescription.rect_size.x = (width + 80) * 2
#	$ItemName.rect_size.x = width


func initialize():
	set_description_text(item_name)
	yield(get_tree(), "idle_frame")
	set_size_of_description($ItemName.rect_size.x)
	$GridContainer.rect_size = Vector2( width , height )
	$GridContainer/TopRow.rect_size.x = width
	$GridContainer/MiddleRow.rect_size.x = width
	$GridContainer/BottomRow.rect_size.x = width
	$ItemDescription.rect_size.x = (width * 7) 
	$ItemName.rect_size.x = width

func set_description_text(item):
	if item:
		var category = JsonData.item_data[item]["ItemCategory"]
		var description = JsonData.item_data[item]["Description"]
		$ItemCategory.modulate = returnCategoryColor(category)
		$ItemName.set_text(item[0].to_upper() + item.substr(1,-1))
		$ItemCategory.set_text(category[0].to_upper() + category.substr(1,-1))
		#$ItemDescription.set_text(description)
		$ItemDescription.set_text("descriptionodsjfk jdf jslkj sdlfkjdd  dasdas  asd sa a sads sa a spjsa ;lzm aslknm lksadfnlkn fsdlkn sdnflsn dns dlkns dnn")
		




func returnCategoryColor(category):
	match category:
		"Tool":
			return Color("ff2525")
		"Resource":
			return Color("00ffc3")
		"Placable object":
			return Color("fffb00")
		"Seed":
			return Color("26ff00")
		"Food":
			return Color("eb00ff")
		"Placable path":
			return Color("3c1aff")
		"Construction":
			return Color("ff25f1")

func set_size_of_description(x):
	if x <= 210:
		width = 58	
	else:
		width = 58 + ((x - 210) / 5)
	var lines = $ItemDescription.get_line_count()
	if lines > 2:
		height = (50 + (lines - 2) * 14)
	else:
		height = 50
	 
	
