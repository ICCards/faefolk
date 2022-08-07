extends Node2D


var door_open = false

func _on_Area2D_area_entered(area):
	if door_open:
		$AnimatedSprite.play("close")
	else:
		$AnimatedSprite.play("open")
	door_open = !door_open
