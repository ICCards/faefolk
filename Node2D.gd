extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var cords = "(1324, 1654)"
	var some_vector = str_to_var("Vector2i" + cords) 
	print(some_vector)
	print(some_vector is Vector2i)
