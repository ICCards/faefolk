extends Node2D

onready var seed_type

func init(seedType):
	seed_type = seedType
	
onready var Seeds = $Seeds

func _ready():
	Seeds.texture = load("res://Assets/crop_sets/" + str(seed_type) + "/hay1.png")
