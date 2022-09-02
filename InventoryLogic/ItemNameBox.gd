extends Node2D

var item_name = "?????"
var width


func initialize():
	show()
	$ItemName.text = item_name
	yield(get_tree(), "idle_frame")
	set_size_of_description($ItemName.rect_size.x)
	$GridContainer.rect_size.x = width

func set_size_of_description(x):
	if x <= 112:
		width = 32
	else:
		width = 32 + ((x - 112) / 5)
