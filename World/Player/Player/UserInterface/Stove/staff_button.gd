extends Control

func _ready():
	$button.texture_normal = load("res://Assets/Images/inventory_icons/"+ JsonData.item_data[name]["ItemCategory"] + "/"  + name + ".png")
	set_locked()

func set_locked():
	if name == "wind staff":
		if PlayerData.player_data["skill_experience"]["wind"] > 0:
			$button.modulate = Color("ffffff") # unlocked
			$button.material.set_shader_parameter("flash_modifier", 0)
		else:
			$button.disabled = true
			$button.modulate = Color("50ffffff") # locked
			$button.material.set_shader_parameter("flash_modifier", 1)
	elif name == "fire staff":
		if PlayerData.player_data["skill_experience"]["fire"] > 0:
			$button.modulate = Color("ffffff") # unlocked
			$button.material.set_shader_parameter("flash_modifier", 0)
		else:
			$button.disabled = true
			$button.modulate = Color("50ffffff") # locked
			$button.material.set_shader_parameter("flash_modifier", 1)
	else:
		$button.disabled = true
		$button.modulate = Color("50ffffff") # locked
		$button.material.set_shader_parameter("flash_modifier", 1)


func _on_button_pressed():
	get_node("../../../").craft(name)

func _on_button_mouse_entered():
	get_node("../../../").entered_crafting_area(name)

func _on_button_mouse_exited():
	get_node("../../../").exited_crafting_area(name)
