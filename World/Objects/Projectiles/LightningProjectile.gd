extends KinematicBody2D

onready var projectile_sprite: AnimatedSprite = $AnimatedSprite

var velocity = Vector2(0,0)
var speed = 500
var collided = false
var path

func _physics_process(delta):
	if not collided:
		var collision_info = move_and_collide(velocity.normalized() * delta * speed)

func _ready():
	$Area2D.tool_name = "lightning spell"
	$Area2D.knockback_vector = Vector2.ZERO
	projectile_sprite.play("cast")
	yield(projectile_sprite, "animation_finished")
	projectile_sprite.play("movement")
	yield(projectile_sprite, "animation_finished")


func _on_Area2D_area_entered(area):
	chain_effect(area.name)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	collided = true
	projectile_sprite.play("hit")
	yield(projectile_sprite, "animation_finished")
	queue_free()

func chain_effect(start_name):
	var nodes = []
	for node in get_node("/root/World/NatureObjects").get_children():
		if not node.destroyed and self.position.distance_to(node.position) < 250 and node.name != start_name:
			node.hit("lightning spell")
			nodes.append(Vector3(node.position.x, node.position.y, 0))
	for node in get_node("/root/World/Animals").get_children():
		if not node.destroyed and self.position.distance_to(node.position) < 250 and node.name != start_name:
			node.hit("lightning spell")
			nodes.append(Vector3(node.position.x, node.position.y, 0))
	yield(get_tree(), 'idle_frame')
	Server.world.draw_mst(find_mst(nodes))

func find_mst(nodes):
	# Prim's algorithm
	# Given an array of positions (nodes), generates a minimum
	# spanning tree
	# Returns an AStar object

	# Initialize the AStar and add the first point
	var path = AStar.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())

	# Repeat until no more nodes remain
	while nodes:
		var min_dist = INF  # Minimum distance found so far
		var min_p = null  # Position of that node
		var p = null  # Current position
		# Loop through the points in the path
		for p1 in path.get_points():
			p1 = path.get_point_position(p1)
			# Loop through the remaining nodes in the given array
			for p2 in nodes:
				# If the node is closer, make it the closest
				if p1.distance_to(p2) < min_dist:
					min_dist = p1.distance_to(p2)
					min_p = p2
					p = p1
		# Insert the resulting node into the path and add
		# its connection
		var n = path.get_available_point_id()
		path.add_point(n, min_p)
		path.connect_points(path.get_closest_point(p), n)
		# Remove the node from the array so it isn't visited again
		nodes.erase(min_p)
	return path


func _on_Timer_timeout():
	queue_free()
