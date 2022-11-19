extends TextureRect



func _ready():
	material = material.duplicate()
	texture = load("res://Assets/Images/inventory_icons/"+ JsonData.item_data[name]["ItemCategory"] + "/"  + name + ".png")


func _on_collection_item_mouse_entered():
	get_node("../").entered_item_area(name)

func _on_collection_item_mouse_exited():
	get_node("../").exited_item_area(name)
