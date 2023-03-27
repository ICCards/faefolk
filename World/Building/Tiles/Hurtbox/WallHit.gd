extends Sprite2D


func initialize():
	call_deferred("show")
	var x = Tiles.wall_tiles.get_cell_atlas_coords(0,get_parent().location).x + 1
	if x == 1 or x == 4 or x == 15 or x == 16 or x == 17:
		self.set_deferred("texture", load("res://Assets/Tilesets/walls/hit effects/"+ get_parent().tier +"/1.png"))
	else:
		self.set_deferred("texture", load("res://Assets/Tilesets/walls/hit effects/"+ get_parent().tier +"/"+ str(x) +".png"))
	$AnimationPlayer.call_deferred("stop")
	$AnimationPlayer.call_deferred("play","hit")
	await $AnimationPlayer.animation_finished
	call_deferred("hide")
