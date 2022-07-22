extends Area2D


func _on_HurtBox_area_entered(area):
	PlayerStats.decrease_health()
	$AnimationPlayer.play("hit")
	print('PLAYER HIT')
