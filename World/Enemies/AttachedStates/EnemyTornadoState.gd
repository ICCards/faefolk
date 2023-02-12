extends Node

var d := 0.0
var orbit_speed 
var orbit_radius = 0
var MAX_ORBIT_RADIUS

func _ready():
	randomize()
	orbit_speed = randf_range(3.0,4.5)
	MAX_ORBIT_RADIUS = randf_range(60.0,75.0)

func _physics_process(delta):
	if get_parent().destroyed: return
	if get_parent().tornado_node:
		if is_instance_valid(get_parent().tornado_node):
			if orbit_radius < MAX_ORBIT_RADIUS:
				orbit_radius += 0.75
			d += delta
			get_parent().position = Vector2(sin(d * orbit_speed) * orbit_radius, cos(d * orbit_speed) * orbit_radius) + get_parent().tornado_node.global_position
		else: 
			get_parent().tornado_node = null
