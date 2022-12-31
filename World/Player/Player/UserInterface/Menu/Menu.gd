extends Control

var item
var hovered_button

onready var sound_effects: AudioStreamPlayer = $SoundEffects

func initialize():
	show()
	Server.player_node.actions.destroy_placable_object()
	hovered_button = null
	$Trash.initialize()
	$Inventory.initialize()
	$Crafting.hide()
	$Collections.hide()
	$Options.hide()
	$Skills.hide()
	$Exit.hide()
	$Background.texture = load("res://Assets/Images/User interface/inventory/inventory/inventory-tab.png")
	set_name_plate("inventory")


func _physics_process(delta):
	if not visible:
		return
	$ItemDescription.position = get_local_mouse_position() + Vector2(28 , 40)
	if hovered_button:
		$ItemNameBox.item_name = hovered_button
		$ItemNameBox.initialize()
		$ItemNameBox.position = get_local_mouse_position() + Vector2(28 , 40)
	else:
		$ItemNameBox.hide()


func set_name_plate(selected_tab):
	for node in $NamePlates.get_children():
		if node.name != selected_tab:
			node.texture = load("res://Assets/Images/User interface/buttons-icons/nameplate.png")
		else:
			node.texture = load("res://Assets/Images/User interface/buttons-icons/nameplate-selected.png")


func _on_Inventory_pressed():
	if not find_parent("UserInterface").holding_item:
		sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/Menu/smallSelect.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects.play()
		initialize()

func _on_Skills_pressed():
	if not find_parent("UserInterface").holding_item:
		sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/Menu/smallSelect.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects.play()
		$Trash.hide()
		$Inventory.hide()
		$Collections.hide()
		$Options.hide()
		$Crafting.hide()
		$Skills.initialize()
		$Exit.hide()
		set_name_plate("skills")


func _on_Crafting_pressed():
	if not find_parent("UserInterface").holding_item:
		sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/Menu/smallSelect.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects.play()
		$Trash.show()
		$Skills.hide()
		$Inventory.hide()
		$Crafting.initialize()
		$Collections.hide()
		$Options.hide()
		$Exit.hide()
		$Background.texture = load("res://Assets/Images/User interface/inventory/crafting/crafting-tab.png")
		set_name_plate("crafting")

func _on_Collections_pressed():
	if not find_parent("UserInterface").holding_item:
		sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/Menu/smallSelect.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects.play()
		$Trash.hide()
		$Inventory.hide()
		$Crafting.hide()
		$Options.hide()
		$Skills.hide()
		$Exit.hide()
		$Collections.initialize()
		set_name_plate("collections")

func _on_Options_pressed():
	if not find_parent("UserInterface").holding_item:
		sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/Menu/smallSelect.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects.play()
		$Trash.hide()
		$Inventory.hide()
		$Crafting.hide()
		$Options.show()
		$Collections.hide()
		$Skills.hide()
		$Exit.hide()
		$Background.texture = load("res://Assets/Images/User interface/inventory/options/options-tab.png")
		set_name_plate("options")


func _on_Inventory_mouse_entered():
	hovered_button = "Inventory"
func _on_Inventory_mouse_exited():
	hovered_button = null

func _on_Skills_mouse_entered():
	hovered_button = "Skills"
func _on_Skills_mouse_exited():
	hovered_button = null

func _on_Crafting_mouse_entered():
	hovered_button = "Crafting"
func _on_Crafting_mouse_exited():
	hovered_button = null

func _on_Collections_mouse_entered():
	hovered_button = "Collections"
func _on_Collections_mouse_exited():
	hovered_button = null

func _on_Options_mouse_entered():
	hovered_button = "Options"
func _on_Options_mouse_exited():
	hovered_button = null

#func _on_Exit_mouse_entered():
#	hovered_button = "Exit"
#func _on_Exit_mouse_exited():
#	hovered_button = null


func _on_ExitBtn_pressed():
	if not get_parent().holding_item:
		get_parent().toggle_menu()
