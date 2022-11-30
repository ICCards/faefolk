extends Node

var d := 0.0
var orbit_speed := 5.0
var orbit_radius = 0


func _physics_process(delta):
	if get_parent().destroyed: return
	if get_parent().tornado_node:
		if is_instance_valid(get_parent().tornado_node):
			orbit_radius += 1
			d += delta
			get_parent().position = Vector2(sin(d * orbit_speed) * orbit_radius, cos(d * orbit_speed) * orbit_radius) + get_parent().tornado_node.global_position
		else: 
			get_parent().tornado_node = null
