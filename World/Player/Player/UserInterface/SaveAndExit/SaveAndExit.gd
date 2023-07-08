extends Control



func _input(event):
	if event.is_action_pressed("exit") and not PlayerData.interactive_screen_mode and not visible and not PlayerData.viewInventoryMode:
		initialize()
	elif event.is_action_pressed("exit") and visible:
		destroy()


func initialize():
	get_tree().paused = true
	Server.player_node.actions.destroy_placeable_object()
	PlayerData.interactive_screen_mode = true
	get_parent().close_hotbar_clock_and_stats()
	show()

func destroy():
	get_tree().paused = false
	Sounds.play_deselect_sound()
	PlayerData.interactive_screen_mode = false
	get_parent().add_hotbar_clock_and_stats()
	hide()


func _on_ExitBtn_pressed():
	destroy()

func _on_SaveAndCtn_pressed():
	Sounds.play_small_select_sound()
	get_parent().save_player_data(false)
	hide()


func _on_SaveAndExit_pressed():
	Sounds.play_small_select_sound()
	Server.world.is_changing_scene = true
	get_parent().save_player_data(true)
	hide()


func _on_Exit_pressed():
	Sounds.play_small_select_sound()
	Server.world.is_changing_scene = true
	destroy()
	await get_tree().create_timer(1.0).timeout
	SceneChanger.goto_scene("res://MainMenu/MainMenu.tscn")
