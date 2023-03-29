extends Control


func _ready():
	Server.player_node.actions.destroy_placeable_object()

func _on_ExitBtn_pressed():
	Sounds.play_deselect_sound()
	get_parent().toggle_save_and_exit()


func _on_SaveAndCtn_pressed():
	Sounds.play_small_select_sound()
	get_parent().save_player_data(false)
	get_parent().toggle_save_and_exit()


func _on_SaveAndExit_pressed():
	Sounds.play_small_select_sound()
	Server.world.is_changing_scene = true
	get_parent().save_player_data(true)
	get_parent().toggle_save_and_exit()


func _on_Exit_pressed():
	Sounds.play_small_select_sound()
	Server.world.is_changing_scene = true
	await get_tree().create_timer(1.0).timeout
	SceneChanger.goto_scene("res://MainMenu/MainMenu.tscn")
	get_parent().toggle_save_and_exit()
