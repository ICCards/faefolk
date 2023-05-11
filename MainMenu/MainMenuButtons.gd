extends Control

var changing_scene_active = false
var hovered_button = ""


func _on_PlayBtn_mouse_entered():
	var tween = get_tree().create_tween()
	tween.tween_property($PlayShopQuit/Play, "scale", Vector2(1.03, 1.03), 0.15)


func _on_PlayBtn_mouse_exited():
	var tween = get_tree().create_tween()
	tween.tween_property($PlayShopQuit/Play, "scale", Vector2(1, 1), 0.15)


func _on_PlayBtn_pressed():
	if not changing_scene_active:
		changing_scene_active = true
		get_parent().get_node("TitleMusic").stop()
		$SoundEffects.stream = load("res://Assets/Sound/Sound effects/UI/Buttons/select.mp3")
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		$SoundEffects.play()
		PlayerData.spawn_at_last_saved_location = true
		if has_node("../PLAYER"):
			get_node("../PLAYER").destroy()
		SceneChanger.goto_scene("res://World/World/main.tscn")


func _on_host_btn_mouse_entered():
	var tween = get_tree().create_tween()
	tween.tween_property($PlayShopQuit/Host, "scale", Vector2(1.03, 1.03), 0.15)


func _on_host_btn_mouse_exited():
	var tween = get_tree().create_tween()
	tween.tween_property($PlayShopQuit/Host, "scale", Vector2(1, 1), 0.15)
