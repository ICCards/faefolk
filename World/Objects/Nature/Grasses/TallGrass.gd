extends Node2D

func _on_1Area_body_entered(body):
	$AnimationPlayer1.play("play")

func _on_3Area_body_entered(body):
	$AnimationPlayer3.play("play")

func _on_2Area_body_entered(body):
	$AnimationPlayer2.play("play")

func _on_4Area_body_entered(body):
	$AnimationPlayer4.play("play")
