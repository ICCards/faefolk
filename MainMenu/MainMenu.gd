extends Control

onready var PlayerMenuState = preload("res://World/Player/PlayerInMenu/PlayerMenuState.tscn")


var is_menu_open = false
func _ready():
	$TitleMusic.stream = Sounds.title_music
	$TitleMusic.volume_db = Sounds.return_adjusted_sound_db("music", -32)
	$TitleMusic.play()
	Sounds.connect("volume_change", self, "change_title_volume")
	$Background/Water1.playing = true
	$Background/Water2.playing = true


func spawn_player_in_menu(var player = ""):
	var playerMenuState = PlayerMenuState.instance()
	#playerMenuState.initialize(player)
	add_child(playerMenuState)
	playerMenuState.global_position = Vector2(600, 472 )


func change_title_volume():
	$TitleMusic.volume_db = Sounds.return_adjusted_sound_db("music", -32)


func toggle_menu_open():
	if is_menu_open:
		close_options_menu()
	else:
		open_options_menu()


func open_options_menu():
	$Options/OptionsMenu.initialize()
	$Options.visible = true
	is_menu_open = true


func close_options_menu():
	$Options.visible = false
	is_menu_open = false


func _on_OptionsIconButton_pressed():
	$SoundEffects.stream = Sounds.button_select
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
	$SoundEffects.play()
	toggle_menu_open()


func _on_ExitOptionsArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if is_menu_open:
			close_options_menu()
