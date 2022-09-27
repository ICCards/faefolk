extends Node2D


export(float) var min_x = -300.0
export(float) var min_y = -300.0
export(float) var max_x = 300.0
export(float) var max_y = 300.0

onready var bunny:Bunny = get_parent()

#func _ready():
#	yield(get_tree().create_timer(2.0), "timeout")
#	randomize()
#	bunny.connect("target_reached", self, "_compute_new_target")
#	_compute_new_target()
#
#func _compute_new_target():
#	var target_position_x = rand_range(min_x, max_x) + get_parent().position.x
#	var target_position_y = rand_range(min_y, max_y) + get_parent().position.y
#	bunny.set_target_location(Vector2(target_position_x, target_position_y))
