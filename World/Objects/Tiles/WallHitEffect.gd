extends Node2D


var autotile_cord
var tier
var location
var tiers = ["twig", "wood", "stone", "metal", "armored"]

func _ready():
	Tiles.wall_tiles.set_cellv(location, -1)
	$Wall.texture = load("res://Assets/Tilesets/walls/hit effects/" + tier + "/" + str(autotile_cord.x+1)  + ".png")
	$AnimationPlayer.play("hit")
	yield($AnimationPlayer, "animation_finished")
	Tiles.wall_tiles.set_cell(location.x, location.y, tiers.find(tier), false, false, false, autotile_cord )
	queue_free()


func restart():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("hit")
	yield($AnimationPlayer, "animation_finished")
	Tiles.wall_tiles.set_cell(location.x, location.y, tiers.find(tier), false, false, false, autotile_cord )
	queue_free()
