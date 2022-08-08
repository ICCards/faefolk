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
	body_holding_walk_down = {
		0 : preload("res://Characters/Human/male/HOLDING WALK/body/down/body.png")
	},
	body_holding_walk_up = {
		0 : preload("res://Characters/Human/male/HOLDING WALK/body/up/body.png")
	},
	body_holding_walk_right = {
		0 : preload("res://Characters/Human/male/HOLDING WALK/body/right/body.png")
	},
	body_holding_walk_left = {
		0 : preload("res://Characters/Human/male/HOLDING WALK/body/left/body.png")
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
	
	arms_holding_walk_down = {
		0 : preload("res://Characters/Human/male/HOLDING WALK/body/down/arms.png")
	},
	arms_holding_walk_up = {
		0 : preload("res://Characters/Human/male/HOLDING WALK/body/up/arms.png")
	},
	arms_holding_walk_right = {
		0 : preload("res://Characters/Human/male/HOLDING WALK/body/right/arms.png")
	},
	arms_holding_walk_left = {
		0 : preload("res://Characters/Human/male/HOLDING WALK/body/left/arms.png")
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
	
	acc_holding_walk_down = {
		0 : null,
	},
	acc_holding_walk_up = {
		0 : null,
	},
	acc_holding_walk_right = {
		0 : null,
	},
	acc_holding_walk_left = {
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
	
	head_attribute_holding_walk_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/down/hair.png"),
	},
	head_attribute_holding_walk_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/up/hair.png"),
	},
	head_attribute_holding_walk_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/right/hair.png"),
	},
	head_attribute_holding_walk_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/left/hair.png"),
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
	
	pants_holding_walk_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/down/pants.png")
	},
	pants_holding_walk_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/up/pants.png")
	},
	pants_holding_walk_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/right/pants.png")
	},
	pants_holding_walk_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/left/pants.png")
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

	shirts_holding_walk_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/down/shirt.png")
	},
	shirts_holding_walk_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/up/shirt.png")
	},
	shirts_holding_walk_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/right/shirt.png")
	},
	shirts_holding_walk_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/left/shirt.png")
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
	
	shoes_holding_walk_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/down/shoes.png")
	},
	shoes_holding_walk_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/up/shoes.png")
	},
	shoes_holding_walk_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/right/shoes.png")
	},
	shoes_holding_walk_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/left/shoes.png")
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
	body_sleep_down = {
		0 : preload("res://Characters/Human/male/SLEEP/body/down/body.png")
	},
	body_sleep_up = {
		0 : preload("res://Characters/Human/male/SLEEP/body/up/body.png")
	},
	body_sleep_right = {
		0 : preload("res://Characters/Human/male/SLEEP/body/right/body.png")
	},
	body_sleep_left = {
		0 : preload("res://Characters/Human/male/SLEEP/body/left/body.png")
	},

	arms_sleep_down = {
		0 : preload("res://Characters/Human/male/SLEEP/body/down/arms.png")
	},
	arms_sleep_up = {
		0 : preload("res://Characters/Human/male/SLEEP/body/up/arms.png")
	},
	arms_sleep_right = {
		0 : preload("res://Characters/Human/male/SLEEP/body/right/arms.png")
	},
	arms_sleep_left = {
		0 : preload("res://Characters/Human/male/SLEEP/body/left/arms.png")
	},

	acc_sleep_down = {
		0 : null,
	},
	acc_sleep_up = {
		0 : null,
	},
	acc_sleep_right = {
		0 : null,
	},
	acc_sleep_left = {
		0 : null,
	},

	head_attribute_sleep_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/SLEEP/assets/down/head_attribute/hair.png")
	},
	head_attribute_sleep_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/SLEEP/assets/up/head_attribute/hair.png")
	},
	head_attribute_sleep_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/SLEEP/assets/right/head_attribute/hair.png")
	},
	head_attribute_sleep_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/SLEEP/assets/left/head_attribute/hair.png")
	},

	shirts_sleep_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/SLEEP/assets/down/shirts/shirt.png")
	},
	shirts_sleep_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/SLEEP/assets/up/shirts/shirt.png")
	},
	shirts_sleep_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/SLEEP/assets/right/shirts/shirt.png")
	},
	shirts_sleep_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/SLEEP/assets/left/shirts/shirt.png")
	},

	pants_sleep_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/SLEEP/assets/down/pants/pants.png")
	},
	pants_sleep_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/SLEEP/assets/up/pants/pants.png")
	},
	pants_sleep_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/SLEEP/assets/right/pants/pants.png")
	},
	pants_sleep_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/SLEEP/assets/left/pants/pants.png")
	},

	shoes_sleep_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/SLEEP/assets/down/shoes/shoes.png")
	},
	shoes_sleep_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/SLEEP/assets/up/shoes/shoes.png")
	},
	shoes_sleep_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/SLEEP/assets/right/shoes/shoes.png")
	},
	shoes_sleep_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/SLEEP/assets/left/shoes/shoes.png")
	},
	
	body_sword_swing_down = {
		0 : preload("res://Characters/Human/male/SWORD SWING/body/down/body.png")
	},
	body_sword_swing_up = {
		0 : preload("res://Characters/Human/male/SWORD SWING/body/up/body.png")
	},
	body_sword_swing_right = {
		0 : preload("res://Characters/Human/male/SWORD SWING/body/right/body.png")
	},
	body_sword_swing_left = {
		0 : preload("res://Characters/Human/male/SWORD SWING/body/left/body.png")
	},

	arms_sword_swing_down = {
		0 : preload("res://Characters/Human/male/SWORD SWING/body/down/arms.png")
	},
	arms_sword_swing_up = {
		0 : preload("res://Characters/Human/male/SWORD SWING/body/up/arms.png")
	},
	arms_sword_swing_right = {
		0 : preload("res://Characters/Human/male/SWORD SWING/body/right/arms.png")
	},
	arms_sword_swing_left = {
		0 : preload("res://Characters/Human/male/SWORD SWING/body/left/arms.png")
	},

	acc_sword_swing_down = {
		0 : null,
	},
	acc_sword_swing_up = {
		0 : null,
	},
	acc_sword_swing_right = {
		0 : null,
	},
	acc_sword_swing_left = {
		0 : null,
	},

	head_attribute_sword_swing_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWORD SWING/assets/down/head_attribute/hair.png")
	},
	head_attribute_sword_swing_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWORD SWING/assets/up/head_attribute/hair.png")
	},
	head_attribute_sword_swing_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWORD SWING/assets/right/head_attribute/hair.png")
	},
	head_attribute_sword_swing_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWORD SWING/assets/left/head_attribute/hair.png")
	},

	shirts_sword_swing_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWORD SWING/assets/down/shirts/shirt.png")
	},
	shirts_sword_swing_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWORD SWING/assets/up/shirts/shirt.png")
	},
	shirts_sword_swing_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWORD SWING/assets/right/shirts/shirt.png")
	},
	shirts_sword_swing_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWORD SWING/assets/left/shirts/shirt.png")
	},

	pants_sword_swing_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWORD SWING/assets/down/pants/pants.png")
	},
	pants_sword_swing_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWORD SWING/assets/up/pants/pants.png")
	},
	pants_sword_swing_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWORD SWING/assets/right/pants/pants.png")
	},
	pants_sword_swing_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWORD SWING/assets/left/pants/pants.png")
	},

	shoes_sword_swing_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWORD SWING/assets/down/shoes/shoe.png")
	},
	shoes_sword_swing_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWORD SWING/assets/up/shoes/shoes.png")
	},
	shoes_sword_swing_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWORD SWING/assets/right/shoes/shoes.png")
	},
	shoes_sword_swing_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWORD SWING/assets/left/shoes/shoes.png")
	},
}
var female = {
	body_idle_down = {
		0 : preload("res://Characters/Human/female/IDLE/body/down/body.png")
	},
	body_idle_up = {
		0 : preload("res://Characters/Human/female/IDLE/body/up/body.png")
	},
	body_idle_left = {
		0 : preload("res://Characters/Human/female/IDLE/body/left/body.png")
	},
	body_idle_right = {
		0 : preload("res://Characters/Human/female/IDLE/body/right/body.png")
	},

	body_walk_down = {
		0 : preload("res://Characters/Human/female/WALK/body/down/body.png")
	},
	body_walk_up = {
		0 : preload("res://Characters/Human/female/WALK/body/up/body.png")
	},
	body_walk_right = {
		0 : preload("res://Characters/Human/female/WALK/body/right/body.png")
	},
	body_walk_left = {
		0 : preload("res://Characters/Human/female/WALK/body/left/body.png")
	},

	body_swing_down = {
		0 : preload("res://Characters/Human/female/SWING/body/down/body.png")
	},
	body_swing_up = {
		0 : preload("res://Characters/Human/female/SWING/body/up/body.png")
	},
	body_swing_right = {
		0 : preload("res://Characters/Human/female/SWING/body/right/body.png")
	},
	body_swing_left = {
		0 : preload("res://Characters/Human/female/SWING/body/left/body.png")
	},


	arms_idle_down = {
		0 : preload("res://Characters/Human/female/IDLE/body/down/arms.png")
	},
	arms_idle_up = {
		0 : preload("res://Characters/Human/female/IDLE/body/up/arms.png")
	},
	arms_idle_left = {
		0 : preload("res://Characters/Human/female/IDLE/body/left/arms.png")
	},
	arms_idle_right = {
		0 : preload("res://Characters/Human/female/IDLE/body/right/arms.png")
	},

	arms_walk_down = {
		0 : preload("res://Characters/Human/female/WALK/body/down/arms.png")
	},
	arms_walk_up = {
		0 : preload("res://Characters/Human/female/WALK/body/up/arms.png")
	},
	arms_walk_right = {
		0 : preload("res://Characters/Human/female/WALK/body/right/arms.png")
	},
	arms_walk_left = {
		0 : preload("res://Characters/Human/female/WALK/body/left/arms.png")
	},

	arms_swing_down = {
		0 : preload("res://Characters/Human/female/SWING/body/down/arms.png")
	},
	arms_swing_up = {
		0 : preload("res://Characters/Human/female/SWING/body/up/arms.png")
	},
	arms_swing_right = {
		0 : preload("res://Characters/Human/female/SWING/body/right/arms.png")
	},
	arms_swing_left = {
		0 : preload("res://Characters/Human/female/SWING/body/left/arms.png")
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


	head_attribute_idle_down = {
		0 : null,
		1 : preload("res://Characters/Human/female/IDLE/assets/down/head_attribute/hair.png"),
	},
	head_attribute_idle_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/IDLE/assets/up/head_attribute/hair.png"),
	},
	head_attribute_idle_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/IDLE/assets/left/head_attribute/hair.png"),
	},
	head_attribute_idle_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/IDLE/assets/right/head_attribute/hair.png"),
	},

	head_attribute_walk_down = {
		0 : null,
		1 : preload("res://Characters/Human/female/WALK/assets/down/head_attribute/hair.png"),
	},
	head_attribute_walk_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/WALK/assets/up/head_attribute/hair.png"),
	},
	head_attribute_walk_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/WALK/assets/right/head_attribute/hair.png"),
	},
	head_attribute_walk_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/WALK/assets/left/head_attribute/hair.png"),
	},

	head_attribute_swing_down = {
		0 : null,
		1 : preload("res://Characters/Human/female/SWING/assets/down/head_attribute/hair.png"),
	},
	head_attribute_swing_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/SWING/assets/up/head_attribute/hair.png"),
	},
	head_attribute_swing_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/SWING/assets/right/head_attribute/hair.png"),
	},
	head_attribute_swing_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/SWING/assets/left/head_attribute/hair.png"),
	},


	pants_idle_down = {
		0 : null,
		1 : preload("res://Characters/Human/female/IDLE/assets/down/pants/skirt.png")
	},
	pants_idle_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/IDLE/assets/up/pants/skirt.png")
	},
	pants_idle_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/IDLE/assets/right/pants/skirt.png")
	},
	pants_idle_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/IDLE/assets/left/pants/skirt.png")
	},

	pants_walk_down = {
		0 : null,
		1 : preload("res://Characters/Human/female/WALK/assets/down/pants/skirt.png")
	},
	pants_walk_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/WALK/assets/up/pants/skirt.png")
	},
	pants_walk_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/WALK/assets/right/pants/skirt.png")
	},
	pants_walk_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/WALK/assets/left/pants/skirt.png")
	},

	pants_swing_down = {
		0 : null,
		1 : preload("res://Characters/Human/female/SWING/assets/down/pants/skirt.png")
	},
	pants_swing_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/SWING/assets/up/pants/skirt.png")
	},
	pants_swing_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/SWING/assets/right/pants/skirt.png")
	},
	pants_swing_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/SWING/assets/left/pants/skirt.png")
	},


	shirts_idle_down = {
		0 : null,
		1 : preload("res://Characters/Human/female/IDLE/assets/down/shirts/shirt.png")
	},
	shirts_idle_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/IDLE/assets/up/shirts/shirt.png")
	},
	shirts_idle_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/IDLE/assets/right/shirts/shirt.png")
	},
	shirts_idle_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/IDLE/assets/left/shirts/shirt.png")
	},

	shirts_walk_down = {
		0 : null,
		1 : preload("res://Characters/Human/female/WALK/assets/down/shirts/shirt.png")
	},
	shirts_walk_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/WALK/assets/up/shirts/shirt.png")
	},
	shirts_walk_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/WALK/assets/right/shirts/shirt.png")
	},
	shirts_walk_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/WALK/assets/left/shirts/shirt.png")
	},

	shirts_swing_down = {
		0 : null,
		1 : preload("res://Characters/Human/female/SWING/assets/down/shirts/shirt.png")
	},
	shirts_swing_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/SWING/assets/up/shirts/shirt.png")
	},
	shirts_swing_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/SWING/assets/right/shirts/shirt.png")
	},
	shirts_swing_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/SWING/assets/left/shirts/shirt.png")
	},

	shoes_idle_down = {
		0 : null,
		1 : preload("res://Characters/Human/female/IDLE/assets/down/shoes/shoes.png")
	},
	shoes_idle_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/IDLE/assets/up/shoes/shoes.png")
	},
	shoes_idle_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/IDLE/assets/left/shoes/shoes.png")
	},
	shoes_idle_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/IDLE/assets/right/shoes/shoes.png")
	},

	shoes_walk_down = {
		0 : null,
		1 : preload("res://Characters/Human/female/WALK/assets/down/shoes/shoes.png")
	},
	shoes_walk_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/WALK/assets/up/shoes/shoes.png")
	},
	shoes_walk_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/WALK/assets/right/shoes/shoes.png")
	},
	shoes_walk_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/WALK/assets/left/shoes/shoes.png")
	},

	shoes_swing_down = {
		0 : null,
		1 : preload("res://Characters/Human/female/SWING/assets/down/shoes/shoes.png")
	},
	shoes_swing_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/SWING/assets/up/shoes/shoes.png")
	},
	shoes_swing_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/SWING/assets/right/shoes/shoes.png")
	},
	shoes_swing_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/SWING/assets/left/shoes/shoes.png")		
	},
	body_death_down = {
		0 : preload("res://Characters/Human/female/DEATH/body/down/body.png")
	},
	body_death_up = {
		0 : preload("res://Characters/Human/female/DEATH/body/up/body.png")
	},
	body_death_right = {
		0 : preload("res://Characters/Human/female/DEATH/body/right/body.png")
	},
	body_death_left = {
		0 : preload("res://Characters/Human/female/DEATH/body/left/body.png")
	},

	arms_death_down = {
		0 : preload("res://Characters/Human/female/DEATH/body/down/arms.png")
	},
	arms_death_up = {
		0 : preload("res://Characters/Human/female/DEATH/body/up/arms.png")
	},
	arms_death_right = {
		0 : preload("res://Characters/Human/female/DEATH/body/right/arms.png")
	},
	arms_death_left = {
		0 : preload("res://Characters/Human/female/DEATH/body/left/arms.png")
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
		1 : preload("res://Characters/Human/female/DEATH/assets/down/head_attribute/hair.png")
	},
	head_attribute_death_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/DEATH/assets/up/head_attribute/hair.png")
	},
	head_attribute_death_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/DEATH/assets/right/head_attribute/hair.png")
	},
	head_attribute_death_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/DEATH/assets/left/head_attribute/hair.png")
	},

	shirts_death_down = {
		0 : null,
		1 : preload("res://Characters/Human/female/DEATH/assets/down/shirts/shirt.png")
	},
	shirts_death_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/DEATH/assets/up/shirts/shirt.png")
	},
	shirts_death_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/DEATH/assets/right/shirts/shirt.png")
	},
	shirts_death_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/DEATH/assets/left/shirts/shirt.png")
	},

	pants_death_down = {
		0 : null,
		1 : preload("res://Characters/Human/female/DEATH/assets/down/pants/skirt.png")
	},
	pants_death_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/DEATH/assets/up/pants/skirt.png")
	},
	pants_death_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/DEATH/assets/right/pants/skirt.png")
	},
	pants_death_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/DEATH/assets/left/shirts/shirt.png")
	},

	shoes_death_down = {
		0 : null,
		1 : preload("res://Characters/Human/female/DEATH/assets/down/shoes/shoes.png")
	},
	shoes_death_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/DEATH/assets/up/shoes/shoes.png")
	},
	shoes_death_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/DEATH/assets/right/shoes/shoes.png")
	},
	shoes_death_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/DEATH/assets/left/shoes/shoes.png")
	},

	body_watering_down = {
		0 : preload("res://Characters/Human/female/WATERING CAN/body/down/body.png")
	},
	body_watering_up = {
		0 : preload("res://Characters/Human/female/WATERING CAN/body/up/body.png")
	},
	body_watering_right = {
		0 : preload("res://Characters/Human/female/WATERING CAN/body/right/body.png")
	},
	body_watering_left = {
		0 : preload("res://Characters/Human/female/WATERING CAN/body/left/body.png")
	},

	arms_watering_down = {
		0 : preload("res://Characters/Human/female/WATERING CAN/body/down/arms.png")
	},
	arms_watering_up = {
		0 : preload("res://Characters/Human/female/WATERING CAN/body/up/arms.png")
	},
	arms_watering_right = {
		0 : preload("res://Characters/Human/female/WATERING CAN/body/right/arms.png")
	},
	arms_watering_left = {
		0 : preload("res://Characters/Human/female/WATERING CAN/body/left/arms.png")
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
		1 : preload("res://Characters/Human/female/WATERING CAN/assets/down/head_attribute/hair.png")
	},
	head_attribute_watering_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/WATERING CAN/assets/up/head_attribute/hair.png")
	},
	head_attribute_watering_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/WATERING CAN/assets/right/head_attribute/hair.png")
	},
	head_attribute_watering_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/WATERING CAN/assets/left/head_attribute/hair.png")
	},

	shirts_watering_down = {
		0 : null,
		1 : preload("res://Characters/Human/female/WATERING CAN/assets/down/shirts/shirt.png")
	},
	shirts_watering_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/WATERING CAN/assets/up/shirts/shirt.png")
	},
	shirts_watering_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/WATERING CAN/assets/right/shirts/shirt.png")
	},
	shirts_watering_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/WATERING CAN/assets/left/shirts/shirt.png")
	},

	pants_watering_down = {
		0 : null,
		1 : preload("res://Characters/Human/female/WATERING CAN/assets/down/pants/skirt.png")
	},
	pants_watering_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/WATERING CAN/assets/up/pants/skirt.png")
	},
	pants_watering_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/WATERING CAN/assets/right/pants/skirt.png")
	},
	pants_watering_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/WATERING CAN/assets/left/pants/skirt.png")
	},

	shoes_watering_down = {
		0 : null,
		1 : preload("res://Characters/Human/female/WATERING CAN/assets/down/shoes/shoes.png")
	},
	shoes_watering_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/WATERING CAN/assets/up/shoes/shoes.png")
	},
	shoes_watering_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/WATERING CAN/assets/right/shoes/shoes.png")
	},
	shoes_watering_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/WATERING CAN/assets/left/shoes/shoes.png")
	},
	body_sleep_down = {
		0 : preload("res://Characters/Human/female/SLEEP/body/down/body.png")
	},
	body_sleep_up = {
		0 : preload("res://Characters/Human/female/SLEEP/body/up/body.png")
	},
	body_sleep_right = {
		0 : preload("res://Characters/Human/female/SLEEP/body/right/body.png")
	},
	body_sleep_left = {
		0 : preload("res://Characters/Human/female/SLEEP/body/left/body.png")
	},

	arms_sleep_down = {
		0 : preload("res://Characters/Human/female/SLEEP/body/down/arms.png")
	},
	arms_sleep_up = {
		0 : preload("res://Characters/Human/female/SLEEP/body/up/arms.png")
	},
	arms_sleep_right = {
		0 : preload("res://Characters/Human/female/SLEEP/body/right/arms.png")
	},
	arms_sleep_left = {
		0 : preload("res://Characters/Human/female/SLEEP/body/left/arms.png")
	},

	acc_sleep_down = {
		0 : null,
	},
	acc_sleep_up = {
		0 : null,
	},
	acc_sleep_right = {
		0 : null,
	},
	acc_sleep_left = {
		0 : null,
	},

	head_attribute_sleep_down = {
		0 : null,
		1 : preload("res://Characters/Human/female/SLEEP/assets/down/head_attribute/hair.png")
	},
	head_attribute_sleep_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/SLEEP/assets/up/head_attribute/hair.png")
	},
	head_attribute_sleep_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/SLEEP/assets/right/head_attribute/hair.png")
	},
	head_attribute_sleep_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/SLEEP/assets/left/head_attribute/hair.png")
	},

	shirts_sleep_down = {
		0 : null,
		1 : preload("res://Characters/Human/female/SLEEP/assets/down/shirts/shirt.png")
	},
	shirts_sleep_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/SLEEP/assets/up/shirts/shirt.png")
	},
	shirts_sleep_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/SLEEP/assets/right/shirts/shirt.png")
	},
	shirts_sleep_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/SLEEP/assets/left/shirts/shirt.png")
	},

	pants_sleep_down = {
		0 : null,
		1 : preload("res://Characters/Human/female/SLEEP/assets/down/pants/skirt.png")
	},
	pants_sleep_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/SLEEP/assets/up/pants/skirt.png")
	},
	pants_sleep_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/SLEEP/assets/right/pants/skirt.png")
	},
	pants_sleep_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/SLEEP/assets/left/pants/skirt.png")
	},

	shoes_sleep_down = {
		0 : null,
		1 : preload("res://Characters/Human/female/SLEEP/assets/down/shoes/shoes.png")
	},
	shoes_sleep_up = {
		0 : null,
		1 : preload("res://Characters/Human/female/SLEEP/assets/up/shoes/shoes.png")
	},
	shoes_sleep_right = {
		0 : null,
		1 : preload("res://Characters/Human/female/SLEEP/assets/right/shoes/shoes.png")
	},
	shoes_sleep_left = {
		0 : null,
		1 : preload("res://Characters/Human/female/SLEEP/assets/left/shoes/shoes.png")
	},
}
