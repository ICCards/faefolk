extends Node2D

var destroyed: bool = false
var variety

func _ready():
	$Hitbox.tool_name = "cactus"
	$AnimatedSprite2D.play(str(variety))
