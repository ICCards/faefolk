extends Node2D


var autotile_cord
var tier
var location

func _ready():
	Tiles.wall_tiles.set_cellv(location, -1)
	$Wall.texture = load("res://Assets/Tilesets/walls/hit effects/" + tier + "/" + str(autotile_cord.x+1)  + ".png")
	$AnimationPlayer.play("hit")
	yield($AnimationPlayer, "animation_finished")
	Tiles.wall_tiles.set_cell(location.x, location.y, 0, false, false, false, autotile_cord )
	queue_free()
