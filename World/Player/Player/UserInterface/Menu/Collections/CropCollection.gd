extends GridContainer




func initialize():
	show()
	for crop in CollectionsData.crops.keys():
		if CollectionsData.crops[crop] > 0:
			get_node(crop).modulate = Color("ffffff") # unlocked
			get_node(crop).material.set_shader_param("flash_modifier", 0)
		else:
			get_node(crop).modulate = Color("50ffffff") # locked
			get_node(crop).material.set_shader_param("flash_modifier", 1)

func entered_item_area(item_name):
	get_parent().item = item_name
	$Tween.interpolate_property(get_node(item_name), "rect_scale",
		get_node(item_name).rect_scale, Vector2(1.1, 1.1), 0.075,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func exited_item_area(item_name):
	get_parent().item = null
	if has_node(item_name):
		$Tween.interpolate_property(get_node(item_name), "rect_scale",
		get_node(item_name).rect_scale, Vector2(1.0, 1.0), 0.075,
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
