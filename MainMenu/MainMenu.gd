extends Control

onready var PlayerMenuState = load("res://World/Player/PlayerInMenu/PlayerMenuState.tscn")
var playerMenuState

var game_state: GameState

func _ready():
	if GameState.save_exists(): # Load world
		game_state = GameState.new()
		game_state.load_state()
		#PlayerData.player_data = game_state.player_state
		PlayerData.player_data = PlayerData.starting_player_data
		MapData.world = game_state.world_state
		MapData.caves = game_state.cave_state
	else: # Initial launch
		game_state = GameState.new()
		game_state.player_state = PlayerData.starting_player_data 
		game_state.world_state = MapData.world
		game_state.cave_state = MapData.starting_caves_data
		game_state.save_state()
	$TitleMusic.stream = Sounds.title_music
	$TitleMusic.volume_db = Sounds.return_adjusted_sound_db("music", -32)
	$TitleMusic.play()
	Sounds.connect("volume_change", self, "change_title_volume")
	$Background/Water1.playing = true
	$Background/Water2.playing = true
	spawn_player_in_menu()
	Server.isLoaded = false

func spawn_player_in_menu():
	$MainMenuButtons/LoadingIndicator.visible = false
	$MainMenuButtons/PlayShopQuit.visible = true
	playerMenuState = PlayerMenuState.instance()
	playerMenuState.name = "Player"
	add_child(playerMenuState)
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
	Server.player_node.hide()

func close_options_menu():
	$OptionsMenuLayer/Options.hide()
	$MainMenuButtons.show()
	Server.player_node.show()

func _on_OptionsIconButton_pressed():
	$SoundEffects.stream = Sounds.button_select
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	$SoundEffects.play()
	toggle_menu_open()

func _on_ExitBtn_pressed():
	$SoundEffects.stream = Sounds.button_select
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	$SoundEffects.play()
	$OptionsMenuLayer.hide()
	$MainMenuButtons.show()
	Server.player_node.show()
