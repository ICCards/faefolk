extends Node2D

func _ready():
	if not get_node("../").is_multiplayer_authority(): queue_free()
