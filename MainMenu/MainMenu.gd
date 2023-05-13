extends Control

@onready var PlayerMenuState = load("res://World/Player/PlayerInMenu/PlayerMenuState.tscn")
var playerMenuState

var game_state: GameState


func _ready():
	#get_tree().get_root().set_min_size(Vector2(1280, 720))
	if GameState.save_exists(): # Load world
		game_state = GameState.new()
		game_state.load_state()
		PlayerData.player_data = game_state.player_state
		#PlayerData.player_data = PlayerData.starting_player_data
		MapData.world = game_state.world_state
	else: # Initial launch
		game_state = GameState.new()
		game_state.player_state = PlayerData.starting_player_data 
		game_state.world_state = MapData.world
		game_state.save_state()
	$TitleMusic.stream = Sounds.title_music
	$TitleMusic.volume_db = Sounds.return_adjusted_sound_db("music", -32)
	$TitleMusic.play()
	Sounds.connect("volume_change",Callable(self,"change_title_volume"))
	$Background/Water1.play("loop")
	$Background/Water2.play("loop")
	spawn_player_in_menu()  


func spawn_player_in_menu():
#	$MainMenuButtons/LoadingIndicator.visible = false
#	$MainMenuButtons/PlayShopQuit.visible = true
	playerMenuState = PlayerMenuState.instantiate()
	playerMenuState.name = "PLAYER"
	call_deferred("add_child",playerMenuState)
	playerMenuState.global_position = Vector2(735, 585 )



func change_title_volume():
	$TitleMusic.volume_db = Sounds.return_adjusted_sound_db("music", -32)


func toggle_menu_open():
	if $OptionsMenuLayer/Options.visible:
		close_options_menu()
	else:
		open_options_menu()


func open_options_menu():
	$OptionsMenuLayer/Options.show()
	$MainMenuButtons.hide()
	get_node("PLAYER").hide()

func close_options_menu():
	$OptionsMenuLayer/Options.hide()
	$MainMenuButtons.show()
	get_node("PLAYER").show()

func _on_OptionsIconButton_pressed():
	$SoundEffects.stream = Sounds.button_select
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	$SoundEffects.play()
	toggle_menu_open()

func _on_ExitBtn_pressed():
	$SoundEffects.stream = Sounds.button_select
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	$SoundEffects.play()
	close_options_menu()
