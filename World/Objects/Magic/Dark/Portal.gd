extends Node2D



func _ready():
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play("open")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("idle")

func _on_Area2D_area_entered(area):
	Server.player_node.teleport(position)
