extends Node

var d := 0.0
var orbit_speed 
var orbit_radius = 0
var MAX_ORBIT_RADIUS
var tornado_node = null

func _ready():
	randomize()
	orbit_speed = randf_range(2.0,3.5)
	MAX_ORBIT_RADIUS = randf_range(10.0,20.0)

func _physics_process(delta):
	if get_parent().destroyed: return
	if tornado_node:
		if is_instance_valid(tornado_node):
			if orbit_radius < MAX_ORBIT_RADIUS:
				orbit_radius += 0.75
			d += delta
			get_parent().position = Vector2(sin(d * orbit_speed) * orbit_radius, cos(d * orbit_speed) * orbit_radius) + tornado_node.global_position
		else: 
			tornado_node = null
