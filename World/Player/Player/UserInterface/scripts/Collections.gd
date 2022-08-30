extends Control

var page = "Crops"

func initialize():
	page = "Crops"
	$Crops.show()
	get_node("../Background").texture = preload("res://Assets/Images/Inventory UI/menus/collections1.png")

func _on_Crops_pressed():
	page = "Crops"
	$Crops.show()
	get_node("../Background").texture = preload("res://Assets/Images/Inventory UI/menus/collections1.png")
	
func _on_Fish_pressed():
	$Crops.hide()
	get_node("../Background").texture = preload("res://Assets/Images/Inventory UI/menus/collections2.png")

func _on_Forage_pressed():
	$Crops.hide()
	get_node("../Background").texture = preload("res://Assets/Images/Inventory UI/menus/collections3.png")

func _on_Minerals_pressed():
	$Crops.hide()
	get_node("../Background").texture = preload("res://Assets/Images/Inventory UI/menus/collections4.png")

func _on_Foods_pressed():
	$Crops.hide()
	get_node("../Background").texture = preload("res://Assets/Images/Inventory UI/menus/collections5.png")


func entered_item_area(item_name):
	$Tween.interpolate_property(get_node(page + "/" + item_name), "rect_scale",
		get_node(page + "/" + item_name).rect_scale, Vector2(1.05, 1.05), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func exited_item_area(item_name):
	if has_node(page + "/" + item_name):
		$Tween.interpolate_property(get_node(page + "/" + item_name), "rect_scale",
		get_node(page + "/" + item_name).rect_scale, Vector2(1.0, 1.0), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_garlic_mouse_entered():
	entered_item_area("garlic")
func _on_garlic_mouse_exited():
	exited_item_area("garlic")

func _on_corn_mouse_entered():
	entered_item_area("corn")
func _on_corn_mouse_exited():
	exited_item_area("corn")

func _on_blueberry_mouse_entered():
	entered_item_area("blueberry")
func _on_blueberry_mouse_exited():
	exited_item_area("blueberry")
	
func _on_asparagus_mouse_entered():
	entered_item_area("asparagus")
func _on_asparagus_mouse_exited():
	exited_item_area("asparagus")

func _on_cabbage_mouse_entered():
	entered_item_area("cabbage")
func _on_cabbage_mouse_exited():
	exited_item_area("cabbage")

func _on_carrot_mouse_entered():
	entered_item_area("carrot")
func _on_carrot_mouse_exited():
	exited_item_area("carrot")

func _on_cauliflower_mouse_entered():
	entered_item_area("cauliflower")
func _on_cauliflower_mouse_exited():
	exited_item_area("cauliflower")

func _on_grape_mouse_entered():
	entered_item_area("grape")
func _on_grape_mouse_exited():
	exited_item_area("grape")

func _on_green_bean_mouse_entered():
	entered_item_area("green bean")
func _on_green_bean_mouse_exited():
	exited_item_area("green bean")
	
func _on_green_melon_mouse_entered():
	entered_item_area("green melon")
func _on_green_melon_mouse_exited():
	exited_item_area("green melon")

func _on_green_pepper_mouse_entered():
	entered_item_area("green pepper")
func _on_green_pepper_mouse_exited():
	exited_item_area("green pepper")
	
func _on_jalapeno_mouse_entered():
	entered_item_area("jalapeno")
func _on_jalapeno_mouse_exited():
	exited_item_area("jalapeno")
	
func _on_potato_mouse_entered():
	entered_item_area("potato")
func _on_potato_mouse_exited():
	exited_item_area("potato")

func _on_radish_mouse_entered():
	entered_item_area("radish")
func _on_radish_mouse_exited():
	exited_item_area("radish")

func _on_red_pepper_mouse_entered():
	entered_item_area("red pepper")
func _on_red_pepper_mouse_exited():
	exited_item_area("red pepper")
	
func _on_strawberry_mouse_entered():
	entered_item_area("strawberry")
func _on_strawberry_mouse_exited():
	exited_item_area("strawberry")

func _on_sugar_cane_mouse_entered():
	entered_item_area("sugar cane")
func _on_sugar_cane_mouse_exited():
	exited_item_area("sugar cane")
	
func _on_tomato_mouse_entered():
	entered_item_area("tomato")
func _on_tomato_mouse_exited():
	exited_item_area("tomato")

func _on_wheat_mouse_entered():
	entered_item_area("wheat")
func _on_wheat_mouse_exited():
	exited_item_area("wheat")

func _on_yellow_onion_mouse_entered():
	entered_item_area("yellow onion")
func _on_yellow_onion_mouse_exited():
	exited_item_area("yellow onion")

func _on_yellow_pepper_mouse_entered():
	entered_item_area("yellow pepper")
func _on_yellow_pepper_mouse_exited():
	exited_item_area("yellow pepper")

func _on_zucchinni_mouse_entered():
	entered_item_area("zucchinni")
func _on_zucchinni_mouse_exited():
	exited_item_area("zucchinni")

