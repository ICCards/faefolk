extends KinematicBody2D

onready var projectile_sprite: AnimatedSprite = $AnimatedSprite

var velocity = Vector2(0,0)
var speed = 500
var collided = false
var path
var debuff 
var type

func _physics_process(delta):
	if not collided:
		var collision_info = move_and_collide(velocity.normalized() * delta * speed)

func _ready():
	if debuff:
		type = "lightning spell debuff"
	else:
		type = "lightning spell"
	$Hitbox.tool_name = type
	projectile_sprite.play("default")
	
func _on_Area2D_area_entered(area):
	chain_effect(area.name)

func chain_effect(start_name):
	var nodes = []
	for node in get_node("/root/World/NatureObjects").get_children():
		if not node.destroyed and self.position.distance_to(node.position) < 250 and node.name != start_name:
			node.hit(type)
			nodes.append(Vector3(node.position.x, node.position.y, 0))
	for node in get_node("/root/World/Animals").get_children():
		if not node.destroyed and self.position.distance_to(node.position) < 250 and node.name != start_name:
			node.hit(type)
			nodes.append(Vector3(node.position.x, node.position.y, 0))
	yield(get_tree(), 'idle_frame')
	Server.world.draw_mst(find_mst(nodes))
	queue_free()

func find_mst(nodes):
	var path = AStar.new()
	if not nodes.empty():
		path.add_point(path.get_available_point_id(), nodes.pop_front())
		
		while nodes:
			var min_dist = INF
			var min_p = null 
			var p = null  
			for p1 in path.get_points():
				p1 = path.get_point_position(p1)
				for p2 in nodes:
					if p1.distance_to(p2) < min_dist:
						min_dist = p1.distance_to(p2)
						min_p = p2
						p = p1
			var n = path.get_available_point_id()
			path.add_point(n, min_p)
			path.connect_points(path.get_closest_point(p), n)
			nodes.erase(min_p)
		return path


func _on_Timer_timeout():
	queue_free()
