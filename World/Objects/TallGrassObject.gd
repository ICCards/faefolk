extends Node2D


onready var rng = RandomNumberGenerator.new()
var variety

func initialize(varietyInput):
	variety = varietyInput

func _ready():
	rng.randomize()
	var randomNum = rng.randi_range(1, 2)
	$Sprite.texture = load("res://Assets/tall grass sets/" + variety + ".png")


