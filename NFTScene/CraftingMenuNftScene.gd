extends Node2D

var item = null

func _physics_process(delta):
	if item != null:
		$CraftingItemDescription.visible = true
		$CraftingItemDescription.item_name = item
		$CraftingItemDescription.position = get_local_mouse_position() + Vector2(15 , 20)
		$CraftingItemDescription.initialize()
	else:
		$CraftingItemDescription.visible = false


func _on_CampfireArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if sufficientMaterialToCraft("campfire"):
			play_craft_sound()
			PlayerInventoryNftScene.craft_item("campfire")
			initialize_crafting()
		else:
			play_error_sound()

func initialize_crafting():
		if sufficientMaterialToCraft("campfire"):
			$campfire.modulate = Color(1, 1, 1, 1)
		else:
			$campfire.modulate = Color(1, 1, 1, 0.4)


func _on_CampfireArea_mouse_entered():
	yield(get_tree(), "idle_frame")
	item = "campfire"
	$Tween.interpolate_property($campfire, "scale",
		$campfire.scale, Vector2(3.35, 3.35), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_CampfireArea_mouse_exited():
	item = null
	if has_node("campfire"):
		$Tween.interpolate_property($campfire, "scale",
			$campfire.scale, Vector2(3, 3), 0.15,
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
	

func sufficientMaterialToCraft(item):
	var ingredients = JsonData.crafting_data[item]["ingredients"]
	for i in range(ingredients.size()):
		if PlayerInventoryNftScene.returnSufficentCraftingMaterial(ingredients[i][0], ingredients[i][1]):
			continue
		else:
			return false
	return true
