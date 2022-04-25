extends Node2D


onready var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	var randomNum = rng.randi_range(1, 10)
	$Sprite.texture = load("res://Assets/grass_sets/tall grass " + str(randomNum) + ".png")


