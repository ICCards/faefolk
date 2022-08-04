extends Node2D


var width
var height
var item_name

func _ready():
	set_description_text(item_name)
	yield(get_tree(), "idle_frame")
	set_size_of_description($ItemName.rect_size.x)
	$VBoxContainer.rect_size.x = width
	$VBoxContainer/TopRow.rect_size.x = width
	$VBoxContainer/MiddleRow.rect_size.x = width
	$VBoxContainer/BottomRow.rect_size.x = width
	$ItemDescription.rect_size.x = (width + 80) * 2
	$ItemName.rect_size.x = width


func initialize():
	set_description_text(item_name)
	yield(get_tree(), "idle_frame")
	set_size_of_description($ItemName.rect_size.x)
	$VBoxContainer.rect_size = Vector2( width , height )
	$VBoxContainer/TopRow.rect_size.x = width
	$VBoxContainer/MiddleRow.rect_size.x = width
	$VBoxContainer/BottomRow.rect_size.x = width
	$ItemDescription.rect_size.x = (width * 7) 
	$ItemName.rect_size.x = width

func set_description_text(item):
	if item:
		var category = JsonData.item_data[item]["ItemCategory"]
		var description = JsonData.item_data[item]["Description"]
		$ItemName.set_text(item[0].to_upper() + item.substr(1,-1))
		$ItemCategory.set_text(category[0].to_upper() + category.substr(1,-1))
		$ItemDescription.set_text(description)



func set_size_of_description(x):
	if x <= 210:
		width = 58	
	else:
		width = 58 + ((x - 210) / 4)
	var lines = $ItemDescription.get_line_count()
	print(lines)
	if lines > 2:
		height = (50 + (lines - 2) * 14)
	else:
		height = 50
	print("height " + str(height))
	 
	
