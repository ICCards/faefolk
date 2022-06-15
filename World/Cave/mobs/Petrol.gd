extends ActionLeaf

func tick(actor, blackboard):
	randomize()
	var petrol_range = 200
	var rand_x = rand_range(-petrol_range, petrol_range)
	var rand_y = rand_range(-petrol_range, petrol_range)
	#actor.petrolTimer.start()
	print(Vector2(rand_x, rand_y))
	var next_stop = Vector2(rand_x, rand_y) + actor.spawn_location
	actor.move_towards_position(next_stop, blackboard.get("delta"))
	#print("moving to", next_stop)
	return SUCCESS
