extends Node2D


var door_open = false

func _on_Area2D_area_entered(area):
	if door_open:
		$AnimationPlayer.play("close")
		#$AnimatedSprite.play("close")
	else:
		$AnimationPlayer.play("open")
		#$AnimatedSprite.play("open")
	door_open = !door_open
