extends Node2D

var item_name = ""
var width


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
	show()
	$Body/ItemName.text = item_name
	await get_tree().process_frame
	set_size_of_description($Body/ItemName.size.x)
	$GridContainer.size.x = width

func set_size_of_description(x):
	if x <= 561:
		width = 28
	else:
		width = 28 + ((x - 561) / 19)
