extends Sprite2D


func initialize():
	call_deferred("show")
	if get_parent().direction == "left" or get_parent().direction == "right":
		if get_parent().door_opened:
			position = Vector2(1,-24)
			texture = load("res://Assets/Tilesets/doors/hit effects/"+ get_parent().item_name +"/side/open.png")
		else:
			position = Vector2(-7,-24)
			texture = load("res://Assets/Tilesets/doors/hit effects/"+ get_parent().item_name +"/side/closed.png")
	else:
		if get_parent().door_opened:
			position = Vector2(8,-19)
			texture = load("res://Assets/Tilesets/doors/hit effects/"+ get_parent().item_name +"/front/open.png")
		else:
			position = Vector2(8,-15)
			texture = load("res://Assets/Tilesets/doors/hit effects/"+ get_parent().item_name +"/front/closed.png")
	$AnimationPlayer.call_deferred("stop")
	$AnimationPlayer.call_deferred("play","hit")
	await $AnimationPlayer.animation_finished
	call_deferred("hide")
