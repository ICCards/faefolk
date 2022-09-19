extends TextureButton



func _ready():
	texture_normal = load("res://Assets/Images/inventory_icons/Dish/" + name + ".png")


func _on_mouse_entered() -> void:
	print(name)
