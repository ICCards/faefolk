extends Control

var init_text = "Welcome to the world of FaeFolk! Gather resources to craft tools and build a base. Be vigilant, surviving on this island is not an easy feat. Good luck!"

func _ready():
	show()


func _on_texture_button_pressed():
	Sounds.play_small_select_sound()
	hide()wi
