extends Control

var item
var hovered_button

onready var sound_effects: AudioStreamPlayer = $SoundEffects

func initialize():
	show()
	Server.player_node.destroy_placable_object()
	hovered_button = null
	$Trash/Top.rotation_degrees = 0
	$Trash.show()
	$Inventory.initialize()
	$Crafting.hide()
	$Collections.hide()
	$OptionsMenu.hide()
	$Skills.hide()
	$Tab.texture = preload("res://Assets/Images/Inventory UI/tabs/inventory.png")
	$Background.texture = preload("res://Assets/Images/Inventory UI/menus/inventory.png")


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


func _on_Inventory_pressed():
	if not find_parent("UserInterface").holding_item:
		initialize()

func _on_Skills_pressed():
	if not find_parent("UserInterface").holding_item:
		$Trash.hide()
		$Inventory.hide()
		$Collections.hide()
		$OptionsMenu.hide()
		$Crafting.hide()
		$Skills.initialize()
		$Tab.texture = preload("res://Assets/Images/Inventory UI/tabs/skills.png")
		$Background.texture = preload("res://Assets/Images/Inventory UI/menus/empty.png")


func _on_Crafting_pressed():
	if not find_parent("UserInterface").holding_item:
		$Trash.show()
		$Skills.hide()
		$Inventory.hide()
		$Crafting.initialize()
		$Collections.hide()
		$OptionsMenu.hide()
		$Tab.texture = preload("res://Assets/Images/Inventory UI/tabs/crafting.png")
		$Background.texture = preload("res://Assets/Images/Inventory UI/menus/crafting.png")

func _on_Collections_pressed():
	if not find_parent("UserInterface").holding_item:
		$Trash.hide()
		$Inventory.hide()
		$Crafting.hide()
		$OptionsMenu.hide()
		$Skills.hide()
		$Collections.initialize()
		$Tab.texture = preload("res://Assets/Images/Inventory UI/tabs/collections.png")
		$Background.texture = preload("res://Assets/Images/Inventory UI/menus/collections1.png")

func _on_Options_pressed():
	if not find_parent("UserInterface").holding_item:
		$Trash.hide()
		$Inventory.hide()
		$Crafting.hide()
		$OptionsMenu.show()
		$Collections.hide()
		$Skills.hide()
		$Tab.texture = preload("res://Assets/Images/Inventory UI/tabs/options.png")
		$Background.texture = preload("res://Assets/Images/Inventory UI/menus/empty.png")


func _on_Exit_pressed():
	pass
#	if not find_parent("UserInterface").holding_item:
#		$Inventory.hide()
#		$Crafting.hide()
#		$OptionsMenu.hide()
#		$Tab.texture = preload("res://Assets/Images/Inventory UI/tabs/exit.png")
#		#$Background.texture = preload("res://Assets/Images/Inventory UI/menus/exit.png")


func _on_BackgroundButton_pressed():
	if find_parent("UserInterface").holding_item:
		sound_effects.stream = preload("res://Assets/Sound/Sound effects/UI/throwDownITem.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects.play()
		find_parent("UserInterface").items_to_drop.append([find_parent("UserInterface").holding_item.item_name, find_parent("UserInterface").holding_item.item_quantity, find_parent("UserInterface").holding_item.item_health])
		find_parent("UserInterface").holding_item.queue_free()
		find_parent("UserInterface").holding_item = null


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

func _on_Exit_mouse_entered():
	hovered_button = "Exit"
func _on_Exit_mouse_exited():
	hovered_button = null


func _on_ExitButton_pressed():
	if not get_parent().holding_item:
		get_parent().toggle_menu()
