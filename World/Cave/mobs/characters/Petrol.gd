extends ActionLeaf

func tick(actor, blackboard):
	if not actor.next_petrol_reached:
		actor.petrol_next_point()
	
	

	#actor.petrolTimer.start()
	#print(Vector2(rand_x, rand_y))
	#var next_stop = Vector2(rand_x, rand_y) + actor.spawn_location
	#actor.move_towards_position(next_stop, blackboard.get("delta"))
	#print("moving to", next_stop)
	#return RUNNING
