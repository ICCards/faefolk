extends Control

var is_kitty_visible = true

func _ready():
	$AnimatedSprite.frames = Images.randomKitty
	$AnimatedSprite.play("idle right")

func _on_HideShowButton_pressed():
	var kitty = get_node("/root/World/Players/kittyNode")
	is_kitty_visible = !is_kitty_visible
	if is_kitty_visible:
		$HideShowButton.text = "Hide"
		kitty.visible = true
	else: 
		$HideShowButton.text = "Show"
		kitty.visible = false
