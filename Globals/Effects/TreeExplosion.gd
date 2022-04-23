extends Particles2D



func initialize(sprite: Texture, side_direction):
	if side_direction == "right":
		rotation_degrees += 90
	else:
		rotation_degrees -= 90
	process_material.set_shader_param("emisssion_box_extents",
		Vector3(sprite.get_width() / 2.0, sprite.get_height() / 2.0 , 1))
		
	process_material.set_shader_param("sprite", sprite)
	
	amount = (sprite.get_width() * sprite.get_height() / 8)
	
	emitting = true
