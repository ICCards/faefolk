extends Node2D


func initialize():
	$Wood/Name.modulate = returnIfValidMaterial("wood", 200)
	$Stone/Name.modulate = returnIfValidMaterial("stone", 300)
	$Metal/Name.modulate = returnIfValidMaterial("metal", 300)
	$Armored/Name.modulate = returnIfValidMaterial("armored", 25)


func returnIfValidMaterial(item, amount):
	if PlayerInventory.returnSufficentCraftingMaterial(item, amount):
		return Color("ffffff") 
	else:
		return Color("ff0000")

func entered_ingredient_area(item): 
	$SoundEffects.stream = Sounds.button_hover
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
	$SoundEffects.play()
	$Tween.interpolate_property(get_node(item), "rect_scale",
		get_node(item).rect_scale, Vector2(0.13, 0.13), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
func exited_ingredient_area(item):
	$Tween.interpolate_property(get_node(item), "rect_scale",
		get_node(item).rect_scale, Vector2(0.12, 0.12), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
	
func play_craft_sound():
	$SoundEffects.stream = Sounds.button_select
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
	$SoundEffects.play()
	
func play_error_sound():
	$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/Farming/ES_Error Tone Chime 6 - SFX Producer.mp3")
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
	$SoundEffects.play()

func _on_WoodArea_mouse_entered():
	entered_ingredient_area("Wood")

func _on_StoneArea_mouse_entered():
	entered_ingredient_area("Stone")

func _on_ArmoredArea_mouse_entered():
	entered_ingredient_area("Armored")

func _on_MetalArea_mouse_entered():
	entered_ingredient_area("Metal")
	
func _on_WoodArea_mouse_exited():
	exited_ingredient_area("Wood")

func _on_StoneArea_mouse_exited():
	exited_ingredient_area("Stone")

func _on_MetalArea_mouse_exited():
	exited_ingredient_area("Metal")

func _on_ArmoredArea_mouse_exited():
	exited_ingredient_area("Armored")



func _on_WoodArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if PlayerInventory.returnSufficentCraftingMaterial("wood", 200):
			PlayerInventory.remove_material("wood", 200)
			get_parent().tier = "wood"
			get_parent().set_type()
			play_craft_sound()
			hide()
		else:
			play_error_sound()

func _on_StoneArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if PlayerInventory.returnSufficentCraftingMaterial("stone", 300):
			PlayerInventory.remove_material("stone", 300)
			get_parent().tier = "stone"
			get_parent().set_type()
			play_craft_sound()
			hide()
		else:
			play_error_sound()


func _on_MetalArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if PlayerInventory.returnSufficentCraftingMaterial("metal", 300):
			PlayerInventory.remove_material("metal", 300)
			get_parent().tier = "metal"
			get_parent().set_type()
			play_craft_sound()
			hide()
		else:
			play_error_sound()

func _on_ArmoredArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if PlayerInventory.returnSufficentCraftingMaterial("armor", 25):
			PlayerInventory.remove_material("armor", 25)
			get_parent().tier = "armor"
			get_parent().set_type()
			play_craft_sound()
			hide()
		else:
			play_error_sound()

