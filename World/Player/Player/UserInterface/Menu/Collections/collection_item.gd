extends TextureRect



func _ready():
	texture = load("res://Assets/Images/inventory_icons/"+ JsonData.item_data[name]["ItemCategory"] + "/"  + name + ".png")
	set_locked()


func set_locked():
	pass


func _on_collection_item_mouse_entered():
	get_node("../").entered_item_area(name)

func _on_collection_item_mouse_exited():
	get_node("../").exited_item_area(name)
