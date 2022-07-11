extends Control

var is_kitty_visible = true

func _ready():
	$AnimatedSprite.frames = Images.randomKitty
	$AnimatedSprite.play("idle right")

func _on_HideShowButton_pressed():
	is_kitty_visible = !is_kitty_visible
	if is_kitty_visible:
		$HideShowButton.text = "Hide"
		get_node("/root/World").spawn_IC_kitty()
	else: 
		$HideShowButton.text = "Show"
		get_node("/root/World/Players/kittyNode").queue_free()
