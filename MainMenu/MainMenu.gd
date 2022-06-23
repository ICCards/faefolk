extends Node2D

onready var PlayerMenuState = preload("res://MainMenu/PlayerMenuState.tscn")

var is_menu_open = false
func _ready():
	$TitleMusic.volume_db = Sounds.return_adjusted_sound_db("music", -32)
	$TitleMusic.play()
	Sounds.connect("volume_change", self, "change_title_volume")
	
	
func spawn_player_in_menu(player):
	if not player.empty():
		var playerMenuState = PlayerMenuState.instance()
		playerMenuState.initialize(player)
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
	$Menu.visible = true
	is_menu_open = true
	$CloseMenuArea/CollisionPolygon2D.disabled = false
	
func close_options_menu():
	$Menu.visible = false
	is_menu_open = false
	$CloseMenuArea/CollisionPolygon2D.disabled = true

func _on_CloseMenuArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if is_menu_open:
			close_options_menu()



