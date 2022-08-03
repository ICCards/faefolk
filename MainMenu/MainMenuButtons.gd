extends Control

var changing_scene_active = false
var hovered_button = ""
var connect_callback = JavaScript.create_callback(self, "_connect_plug")
var login_callback = JavaScript.create_callback(self, "_login")

func _ready():
	if not Server.player.empty():
		get_parent().spawn_player_in_menu()

func _connect_plug(args):
	IC.login(login_callback)
	
func _login(args):
	var value = Util.toMessage("LOGIN",{"d":{}})
	print("logging in")
	Server._client.get_peer(1).put_packet(value)
	get_parent().spawn_player_in_menu()
	
func _play_hover_effect(button_name):
	if hovered_button != button_name and not changing_scene_active:
		$SoundEffects.stream = Sounds.button_hover
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
		$SoundEffects.play()

func _on_PlayArea_mouse_entered():
	_play_hover_effect("play")
	$Tween.interpolate_property($PlayShopQuit/Play, "scale",
		$PlayShopQuit/Play.get_scale(), Vector2(1.035, 1.035), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($PlayShopQuit/Play, "position",
		$PlayShopQuit/Play.get_position(), Vector2(0, -5),  0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_QuitArea_mouse_entered():
	_play_hover_effect("quit")
	$Tween.interpolate_property($PlayShopQuit/Quit, "scale",
		$PlayShopQuit/Quit.get_scale(), Vector2(1.035, 1.035), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($PlayShopQuit/Quit, "position",
		$PlayShopQuit/Quit.get_position(), Vector2(0, -15),  0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
func _on_ShopArea_mouse_entered():
	_play_hover_effect("options")
	$Tween.interpolate_property($PlayShopQuit/Shop, "scale",
		$PlayShopQuit/Shop.get_scale(), Vector2(1.035, 1.035), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($PlayShopQuit/Shop, "position",
		$PlayShopQuit/Shop.get_position(), Vector2(0, -10),  0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_ShopArea_mouse_exited():
	hovered_button = ""
	$Tween.interpolate_property($PlayShopQuit/Shop, "scale",
		$PlayShopQuit/Shop.get_scale(), Vector2(1, 1), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($PlayShopQuit/Shop, "position",
		$PlayShopQuit/Shop.get_position(), Vector2(0, 0), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_PlayArea_mouse_exited():
	hovered_button = ""
	$Tween.interpolate_property($PlayShopQuit/Play, "scale",
		$PlayShopQuit/Play.get_scale(), Vector2(1, 1), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($PlayShopQuit/Play, "position",
		$PlayShopQuit/Play.get_position(), Vector2(0, 0), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_QuitArea_mouse_exited():
	hovered_button = ""
	$Tween.interpolate_property($PlayShopQuit/Quit, "scale",
		$PlayShopQuit/Quit.get_scale(), Vector2(1, 1), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($PlayShopQuit/Quit, "position",
		$PlayShopQuit/Quit.get_position(), Vector2(0, 0), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_PlayArea_input_event(viewport, event, shape_idx):
	
	if event.is_action_pressed("mouse_click") and not changing_scene_active:
		changing_scene_active = true
		get_parent().get_node("TitleMusic").stop()
		$SoundEffects.stream = Sounds.button_select
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
		$SoundEffects.play()
		SceneChanger.goto_scene("res://World/World/World.tscn")


func _on_QuitArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click") and not changing_scene_active:
		$SoundEffects.stream = Sounds.button_select
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
		$SoundEffects.play()
		#get_tree().quit()


func _on_ShopArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click") and not changing_scene_active:
		$SoundEffects.stream = Sounds.button_select
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
		$SoundEffects.play()

func _on_ConnectToPlugButton_pressed():
	$SoundEffects.stream = Sounds.button_select
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -28)
	$SoundEffects.play()
	_login_test()
	#IC.connect_plug(connect_callback)
	$ConnectToPlug.visible = false
	$LoadingIndicator.visible = true	

func _login_test():
	print("logging in")
	Server.rpc_id(1, "login_test")
	get_parent().spawn_player_in_menu()


func _on_ConnectToPlugButton_mouse_entered():
	_play_hover_effect("connect to plug")
	$Tween.interpolate_property($ConnectToPlug, "rect_scale",
		$ConnectToPlug.get_scale(), Vector2(1.015, 1.015), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($ConnectToPlug, "rect_position",
		$ConnectToPlug.get_position(), Vector2(-28, 12),  0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_ConnectToPlugButton_mouse_exited():
	hovered_button = ""
	$Tween.interpolate_property($ConnectToPlug, "rect_scale",
		$ConnectToPlug.get_scale(), Vector2(1, 1), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($ConnectToPlug, "rect_position",
		$ConnectToPlug.get_position(), Vector2(0, 0), 0.15,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


