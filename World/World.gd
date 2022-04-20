extends Node2D

onready var TreeObject = preload("res://World/Objects/TreeObject.tscn")
onready var world = get_tree().current_scene
var rng = RandomNumberGenerator.new()

func _ready():
	for i in range(0):
		var treeObject = TreeObject.instance()
		world.add_child(treeObject)
		treeObject.global_position = Vector2(rng.randi_range(600, 1600), rng.randi_range(600, 1600))



