extends Control

var item

@onready var sound_effects: AudioStreamPlayer = $SoundEffects


func initialize():
	show()
	Server.player_node.actions.destroy_placable_object()
	change_inventory_tab("inventory")

func _physics_process(delta):
	if not visible:
		return
	$ItemDescription.position = get_local_mouse_position() + Vector2(20,25)
	$ItemNameBox.position = get_local_mouse_position() + Vector2(20,25)

func _input(_event):
	if find_parent("UserInterface").holding_item:
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()

func set_name_plate(selected_tab):
	for node in $NamePlates.get_children():
		if node.name != "save":
			if node.name != selected_tab:
				node.set_deferred("texture_normal", load("res://Assets/Images/User interface/buttons-icons/nameplate.png"))
			else:
				node.set_deferred("texture_normal", load("res://Assets/Images/User interface/buttons-icons/nameplate-selected.png"))

func change_inventory_tab(new_tab):
	if not find_parent("UserInterface").holding_item:
		if new_tab == "save":
			find_parent("UserInterface").hide_menu()
			find_parent("UserInterface").toggle_save_and_exit()
		Sounds.play_small_select_sound()
		set_tab(new_tab)
		set_name_plate(new_tab)
		
func set_tab(new_tab):
	for page in $Pages.get_children():
		if page.name == new_tab:
			page.initialize()
		else:
			page.hide()

func _on_ExitBtn_pressed():
	if not get_parent().holding_item:
		get_parent().toggle_menu()


