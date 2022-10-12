extends Control


func _ready():
	$btn.texture_normal = load("res://Assets/Images/craftable object preview/" + name + ".png")

func _on_btn_pressed():
	get_node("../../").craftable_item_pressed(name)
	
func _on_btn_mouse_entered():
	get_node("../../").entered_crafting_area(name)
	
func _on_btn_mouse_exited():
	get_node("../../").exited_crafting_area(name)
	

