extends Node

var male = {
	body_idle_down = {
		0 : preload("res://Characters/Human/male/IDLE/body/down/body.png")
	},
	body_idle_up = {
		0 : preload("res://Characters/Human/male/IDLE/body/up/body.png")
	},
	body_idle_left = {
		0 : preload("res://Characters/Human/male/IDLE/body/left/body.png")
	},
	body_idle_right = {
		0 : preload("res://Characters/Human/male/IDLE/body/right/body.png")
	},

	body_walk_down = {
		0 : preload("res://Characters/Human/male/WALK/body/down/body.png")
	},
	body_walk_up = {
		0 : preload("res://Characters/Human/male/WALK/body/up/body.png")
	},
	body_walk_right = {
		0 : preload("res://Characters/Human/male/WALK/body/right/body.png")
	},
	body_walk_left = {
		0 : preload("res://Characters/Human/male/WALK/body/left/body.png")
	},
	

	body_swing_down = {
		0 : preload("res://Characters/Human/male/SWING/body/down/body.png")
	},
	body_swing_up = {
		0 : preload("res://Characters/Human/male/SWING/body/up/body.png")
	},
	body_swing_right = {
		0 : preload("res://Characters/Human/male/SWING/body/right/body.png")
	},
	body_swing_left = {
		0 : preload("res://Characters/Human/male/SWING/body/left/body.png")
	},
	body_holding_down = {
		0 : preload("res://Characters/Human/male/HOLDING/body/down/body.png")
	},
	body_holding_up = {
		0 : preload("res://Characters/Human/male/HOLDING/body/up/body.png")
	},
	body_holding_right = {
		0 : preload("res://Characters/Human/male/HOLDING/body/right/body.png")
	},
	body_holding_left = {
		0 : preload("res://Characters/Human/male/HOLDING/body/left/body.png")
	},


	arms_idle_down = {
		0 : preload("res://Characters/Human/male/IDLE/body/down/arms.png")
	},
	arms_idle_up = {
		0 : preload("res://Characters/Human/male/IDLE/body/up/arms.png")
	},
	arms_idle_left = {
		0 : preload("res://Characters/Human/male/IDLE/body/left/arms.png")
	},
	arms_idle_right = {
		0 : preload("res://Characters/Human/male/IDLE/body/right/arms.png")
	},

	arms_walk_down = {
		0 : preload("res://Characters/Human/male/WALK/body/down/arms.png")
	},
	arms_walk_up = {
		0 : preload("res://Characters/Human/male/WALK/body/up/arms.png")
	},
	arms_walk_right = {
		0 : preload("res://Characters/Human/male/WALK/body/right/arms.png")
	},
	arms_walk_left = {
		0 : preload("res://Characters/Human/male/WALK/body/left/arms.png")
	},

	arms_swing_down = {
		0 : preload("res://Characters/Human/male/SWING/body/down/arms.png")
	},
	arms_swing_up = {
		0 : preload("res://Characters/Human/male/SWING/body/up/arms.png")
	},
	arms_swing_right = {
		0 : preload("res://Characters/Human/male/SWING/body/right/arms.png")
	},
	arms_swing_left = {
		0 : preload("res://Characters/Human/male/SWING/body/left/arms.png")
	},
	
	arms_holding_down = {
		0 : preload("res://Characters/Human/male/HOLDING/body/down/arms.png")
	},
	arms_holding_up = {
		0 : preload("res://Characters/Human/male/HOLDING/body/up/arms.png")
	},
	arms_holding_right = {
		0 : preload("res://Characters/Human/male/HOLDING/body/right/arms.png")
	},
	arms_holding_left = {
		0 : preload("res://Characters/Human/male/HOLDING/body/left/arms.png")
	},



	acc_idle_down = {
		0 : null,
	},
	acc_idle_up = {
		0 : null,
	},
	acc_idle_left = {
		0 : null,
	},
	acc_idle_right = {
		0 : null,
	},

	acc_walk_down = {
		0 : null,
	},
	acc_walk_up = {
		0 : null,
	},
	acc_walk_right = {
		0 : null,
	},
	acc_walk_left = {
		0 : null,
	},

	acc_swing_down = {
		0 : null,
	},
	acc_swing_up = {
		0 : null,
	},
	acc_swing_right = {
		0 : null,
	},
	acc_swing_left = {
		0 : null,
	},
	
	acc_holding_down = {
		0 : null,
	},
	acc_holding_up = {
		0 : null,
	},
	acc_holding_right = {
		0 : null,
	},
	acc_holding_left = {
		0 : null,
	},


	head_attribute_idle_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/IDLE/assets/down/head_attribute/hair.png"),
	},
	head_attribute_idle_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/IDLE/assets/up/head_attribute/hair.png"),
	},
	head_attribute_idle_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/IDLE/assets/left/head_attribute/hair.png"),
	},
	head_attribute_idle_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/IDLE/assets/right/head_attribute/hair.png"),
	},

	head_attribute_walk_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/WALK/assets/down/head_attribute/hair.png"),
	},
	head_attribute_walk_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/WALK/assets/up/head_attribute/hair.png"),
	},
	head_attribute_walk_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/WALK/assets/right/head_attribute/hair.png"),
	},
	head_attribute_walk_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/WALK/assets/left/head_attribute/hair.png"),
	},

	head_attribute_swing_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWING/assets/down/head_attribute/hair.png"),
	},
	head_attribute_swing_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWING/assets/up/head_attribute/hair.png"),
	},
	head_attribute_swing_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWING/assets/right/head_attribute/hair.png"),
	},
	head_attribute_swing_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWING/assets/left/head_attribute/hair.png"),
	},
	
	head_attribute_holding_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING/assets/down/hair.png"),
	},
	head_attribute_holding_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING/assets/up/hair.png"),
	},
	head_attribute_holding_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING/assets/right/hair.png"),
	},
	head_attribute_holding_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING/assets/left/hair.png"),
	},


	pants_idle_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/IDLE/assets/down/pants/pants.png")
	},
	pants_idle_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/IDLE/assets/up/pants/pants.png")
	},
	pants_idle_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/IDLE/assets/right/pants/pants.png")
	},
	pants_idle_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/IDLE/assets/left/pants/pants.png")
	},

	pants_walk_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/WALK/assets/down/pants/pants.png")
	},
	pants_walk_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/WALK/assets/up/pants/pants.png")
	},
	pants_walk_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/WALK/assets/right/pants/pants.png")
	},
	pants_walk_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/WALK/assets/left/pants/pants.png")
	},

	pants_swing_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWING/assets/down/pants/pants.png")
	},
	pants_swing_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWING/assets/up/pants/pants.png")
	},
	pants_swing_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWING/assets/right/pants/pants.png")
	},
	pants_swing_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWING/assets/left/pants/pants.png")
	},
	
	pants_holding_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING/assets/down/pants.png")
	},
	pants_holding_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING/assets/up/pants.png")
	},
	pants_holding_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING/assets/right/pants.png")
	},
	pants_holding_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING/assets/left/pants.png")
	},


	shirts_idle_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/IDLE/assets/down/shirts/shirt.png")
	},
	shirts_idle_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/IDLE/assets/up/shirts/shirt.png")
	},
	shirts_idle_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/IDLE/assets/right/shirts/shirt.png")
	},
	shirts_idle_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/IDLE/assets/left/shirts/shirt.png")
	},

	shirts_walk_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/WALK/assets/down/shirts/shirt.png")
	},
	shirts_walk_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/WALK/assets/up/shirts/shirt.png")
	},
	shirts_walk_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/WALK/assets/right/shirts/shirt.png")
	},
	shirts_walk_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/WALK/assets/left/shirts/shirt.png")
	},

	shirts_swing_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWING/assets/down/shirts/shirt.png")
	},
	shirts_swing_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWING/assets/up/shirts/shirt.png")
	},
	shirts_swing_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWING/assets/right/shirts/shirt.png")
	},
	shirts_swing_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWING/assets/left/shirts/shirt.png")
	},

	shirts_holding_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING/assets/down/shirt.png")
	},
	shirts_holding_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING/assets/up/shirt.png")
	},
	shirts_holding_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING/assets/right/shirt.png")
	},
	shirts_holding_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING/assets/left/shirt.png")
	},
	
	
	shoes_idle_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/IDLE/assets/down/shoes/shoes.png")
	},
	shoes_idle_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/IDLE/assets/up/shoes/shoes.png")
	},
	shoes_idle_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/IDLE/assets/left/shoes/shoes.png")
	},
	shoes_idle_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/IDLE/assets/right/shoes/shoes.png")
	},

	shoes_walk_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/WALK/assets/down/shoes/shoes.png")
	},
	shoes_walk_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/WALK/assets/up/shoes/shoes.png")
	},
	shoes_walk_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/WALK/assets/right/shoes/shoes.png")
	},
	shoes_walk_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/WALK/assets/left/shoes/shoes.png")
	},

	shoes_swing_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWING/assets/down/shoes/shoes.png")
	},
	shoes_swing_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWING/assets/up/shoes/shoes.png")
	},
	shoes_swing_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWING/assets/right/shoes/shoes.png")
	},
	shoes_swing_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWING/assets/left/shoes/shoes.png")
	},
	
	shoes_holding_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING/assets/down/shoes.png")
	},
	shoes_holding_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING/assets/up/shoes.png")
	},
	shoes_holding_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING/assets/right/shoes.png")
	},
	shoes_holding_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING/assets/left/shoes.png")
	},
	
	body_death_down = {
		0 : preload("res://Characters/Human/male/DEATH/body/down/body.png")
	},
	body_death_up = {
		0 : preload("res://Characters/Human/male/DEATH/body/up/body.png")
	},
	body_death_right = {
		0 : preload("res://Characters/Human/male/DEATH/body/right/body.png")
	},
	body_death_left = {
		0 : preload("res://Characters/Human/male/DEATH/body/left/body.png")
	},
	
	arms_death_down = {
		0 : preload("res://Characters/Human/male/DEATH/body/down/arms.png")
	},
	arms_death_up = {
		0 : preload("res://Characters/Human/male/DEATH/body/up/arms.png")
	},
	arms_death_right = {
		0 : preload("res://Characters/Human/male/DEATH/body/right/arms.png")
	},
	arms_death_left = {
		0 : preload("res://Characters/Human/male/DEATH/body/left/arms.png")
	},
	
	acc_death_down = {
		0 : null,
	},
	acc_death_up = {
		0 : null,
	},
	acc_death_right = {
		0 : null,
	},
	acc_death_left = {
		0 : null,
	},
	
	head_attribute_death_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/DEATH/assets/down/head_attribute/hair.png"),
	},
	head_attribute_death_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/DEATH/assets/up/head_attribute/hair.png"),
	},
	head_attribute_death_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/DEATH/assets/right/head_attribute/hair.png"),
	},
	head_attribute_death_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/DEATH/assets/left/head_attribute/hair.png"),
	},
	
	shirts_death_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/DEATH/assets/down/shirts/shirt.png"),
	},
	shirts_death_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/DEATH/assets/up/shirts/shirt.png"),
	},
	shirts_death_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/DEATH/assets/right/shirts/shirt.png"),
	},
	shirts_death_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/DEATH/assets/left/shirts/shirt.png"),
	},
	
	pants_death_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/DEATH/assets/down/pants/pants.png"),
	},
	pants_death_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/DEATH/assets/up/pants/pants.png"),
	},
	pants_death_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/DEATH/assets/right/pants/pants.png"),
	},
	pants_death_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/DEATH/assets/left/pants/pants.png"),
	},
	
	shoes_death_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/DEATH/assets/down/shoes/shoes.png"),
	},
	shoes_death_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/DEATH/assets/up/shoes/shoes.png"),
	},
	shoes_death_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/DEATH/assets/right/shoes/shoes.png"),
	},
	shoes_death_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/DEATH/assets/left/shoes/shoes.png"),
	},
	
	body_watering_down = {
		0 : preload("res://Characters/Human/male/WATERING CAN/body/down/body.png")
	},
	body_watering_up = {
		0 : preload("res://Characters/Human/male/WATERING CAN/body/up/body.png")
	},
	body_watering_right = {
		0 : preload("res://Characters/Human/male/WATERING CAN/body/right/body.png")
	},
	body_watering_left = {
		0 : preload("res://Characters/Human/male/WATERING CAN/body/left/body.png")
	},

	arms_watering_down = {
		0 : preload("res://Characters/Human/male/WATERING CAN/body/down/arms.png")
	},
	arms_watering_up = {
		0 : preload("res://Characters/Human/male/WATERING CAN/body/up/arms.png")
	},
	arms_watering_right = {
		0 : preload("res://Characters/Human/male/WATERING CAN/body/right/arms.png")
	},
	arms_watering_left = {
		0 : preload("res://Characters/Human/male/WATERING CAN/body/left/arms.png")
	},

	acc_watering_down = {
		0 : null,
	},
	acc_watering_up = {
		0 : null,
	},
	acc_watering_right = {
		0 : null,
	},
	acc_watering_left = {
		0 : null,
	},

	head_attribute_watering_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/WATERING CAN/assets/down/head_attribute/hair.png")
	},
	head_attribute_watering_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/WATERING CAN/assets/up/head_attribute/hair.png")
	},
	head_attribute_watering_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/WATERING CAN/assets/right/head_attribute/hair.png")
	},
	head_attribute_watering_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/WATERING CAN/assets/left/head_attribute/hair.png")
	},

	shirts_watering_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/WATERING CAN/assets/down/shirts/shirt.png")
	},
	shirts_watering_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/WATERING CAN/assets/up/shirts/shirt.png")
	},
	shirts_watering_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/WATERING CAN/assets/right/shirts/shirt.png")
	},
	shirts_watering_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/WATERING CAN/assets/left/shirts/shirt.png")
	},

	pants_watering_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/WATERING CAN/assets/down/pants/pants.png")
	},
	pants_watering_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/WATERING CAN/assets/up/pants/pants.png")
	},
	pants_watering_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/WATERING CAN/assets/right/pants/pants.png")
	},
	pants_watering_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/WATERING CAN/assets/left/pants/pants.png")
	},

	shoes_watering_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/WATERING CAN/assets/down/shoes/shoes.png")
	},
	shoes_watering_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/WATERING CAN/assets/up/shoes/shoes.png")
	},
	shoes_watering_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/WATERING CAN/assets/right/shoes/shoes.png")
	},
	shoes_watering_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/WATERING CAN/assets/left/shoes/shoes.png")
	},
}


