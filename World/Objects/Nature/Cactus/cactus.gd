extends Node2D

var variety
var destroyed: bool = false

func _ready():
	$Hitbox.tool_name = "cactus"
	if variety == 5:
		$AnimatedSprite2D.position = Vector2(0,-14)
	else:
		$AnimatedSprite2D.position = Vector2(0,-22)
	$AnimatedSprite2D.play(str(variety))
