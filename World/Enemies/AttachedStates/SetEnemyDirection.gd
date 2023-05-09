extends Node

var changed_direction_delay: bool = false

func _physics_process(delta):
	if get_parent().destroyed or get_parent().stunned:
		return
	if get_parent().chasing:
		set_direction_chase_state()
	else:
		set_direction_idle_state()


func set_direction_chase_state():
	if not get_parent().attacking:
		get_parent().hit_box.look_at(Server.player_node.position)
	if changed_direction_delay:
		return
	var degrees = int(get_parent().hit_box.rotation_degrees) % 360
	if get_parent().hit_box.rotation_degrees >= 0:
		if degrees <= 45 or degrees >= 315:
			if get_parent().direction != "right":
				get_parent().direction = "right"
				set_change_direction_delay()
		elif degrees <= 135:
			if get_parent().direction != "down":
				get_parent().direction = "down"
				set_change_direction_delay()
		elif degrees <= 225:
			if get_parent().direction != "left":
				get_parent().direction = "left"
				set_change_direction_delay()
		else:
			if get_parent().direction != "up":
				get_parent().direction = "up"
				set_change_direction_delay()
	else:
		if degrees >= -45 or degrees <= -315:
			if get_parent().direction != "right":
				get_parent().direction = "right"
				set_change_direction_delay()
		elif degrees >= -135:
			if get_parent().direction != "up":
				get_parent().direction = "up"
				set_change_direction_delay()
		elif degrees >= -225:
			if get_parent().direction != "left":
				get_parent().direction = "left"
				set_change_direction_delay()
		else:
			if get_parent().direction != "down":
				get_parent().direction = "down"
				set_change_direction_delay()
			
			
func set_direction_idle_state():
	return
	if not changed_direction_delay and get_parent().state != 0:
		if abs(get_parent().velocity.x) >= abs(get_parent().velocity.y):
			if get_parent().velocity.x >= 0:
				if get_parent().direction != "right":
					get_parent().direction = "right"
					set_change_direction_delay()
			else:
				if get_parent().direction != "left":
					get_parent().direction = "left"
					set_change_direction_delay()
		else:
			if get_parent().velocity.y >= 0:
				if get_parent().direction != "down":
					get_parent().direction = "down"
					set_change_direction_delay()
			else:
				if get_parent().direction != "up":
					get_parent().direction = "up"
					set_change_direction_delay()
					
					
func set_change_direction_delay():
	changed_direction_delay = true
	await get_tree().create_timer(0.25).timeout
	changed_direction_delay = false
