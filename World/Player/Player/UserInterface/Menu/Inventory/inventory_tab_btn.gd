extends TextureButton




func _ready():
	$Label.text = name[0].to_upper() + name.substr(1,-1)


func _on_inventory_tab_btn_pressed():
	get_node("../../").change_inventory_tab(name)
