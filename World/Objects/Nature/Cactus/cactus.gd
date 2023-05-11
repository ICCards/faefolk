extends Node2D


var variety

func _ready():
	$Hitbox.tool_name = "cactus"
	$AnimatedSprite2D.play(str(variety))
