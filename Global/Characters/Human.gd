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
		1 : preload("res://Characters/Human/male/SWORD SWING/assets/down/shoes/shoes.png")
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
	
	body_holding_idle_down = {
		0 : preload("res://Characters/Human/male/HOLDING IDLE/body/down/body.png")
	},
	body_holding_idle_up = {
		0 : preload("res://Characters/Human/male/HOLDING IDLE/body/up/body.png")
	},
	body_holding_idle_right = {
		0 : preload("res://Characters/Human/male/HOLDING IDLE/body/right/body.png")
	},
	body_holding_idle_left = {
		0 : preload("res://Characters/Human/male/HOLDING IDLE/body/left/body.png")
	},
	arms_holding_idle_down = {
		0 : preload("res://Characters/Human/male/HOLDING IDLE/body/down/arms.png")
	},
	arms_holding_idle_up = {
		0 : preload("res://Characters/Human/male/HOLDING IDLE/body/up/arms.png")
	},
	arms_holding_idle_right = {
		0 : preload("res://Characters/Human/male/HOLDING IDLE/body/right/arms.png")
	},
	arms_holding_idle_left = {
		0 : preload("res://Characters/Human/male/HOLDING IDLE/body/left/arms.png")
	},
	acc_holding_idle_down = {
		0 : null,
	},
	acc_holding_idle_up = {
		0 : null,
	},
	acc_holding_idle_right = {
		0 : null,
	},
	acc_holding_idle_left = {
		0 : null,
	},
	head_attribute_holding_idle_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING IDLE/assets/down/head_attribute/hair.png")
	},
	head_attribute_holding_idle_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING IDLE/assets/up/head_attribute/hair.png")
	},
	head_attribute_holding_idle_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING IDLE/assets/right/head_attribute/hair.png")
	},
	head_attribute_holding_idle_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING IDLE/assets/left/head_attribute/hair.png")
	},
	shirts_holding_idle_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING IDLE/assets/down/shirts/shirt.png")
	},
	shirts_holding_idle_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING IDLE/assets/up/shirts/shirt.png")
	},
	shirts_holding_idle_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING IDLE/assets/right/shirts/shirt.png")
	},
	shirts_holding_idle_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING IDLE/assets/left/shirts/shirt.png")
	},
	pants_holding_idle_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING IDLE/assets/down/pants/pants.png")
	},
	pants_holding_idle_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING IDLE/assets/up/pants/pants.png")
	},
	pants_holding_idle_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING IDLE/assets/right/pants/pants.png")
	},
	pants_holding_idle_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING IDLE/assets/left/pants/pants.png")
	},
	shoes_holding_idle_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING IDLE/assets/down/shoes/shoes.png")
	},
	shoes_holding_idle_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING IDLE/assets/up/shoes/shoes.png")
	},
	shoes_holding_idle_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING IDLE/assets/right/shoes/shoes.png")
	},
	shoes_holding_idle_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING IDLE/assets/left/shoes/shoes.png")
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
	head_attribute_holding_walk_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/down/head_attribute/hair.png"),
	},
	head_attribute_holding_walk_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/up/head_attribute/hair.png"),
	},
	head_attribute_holding_walk_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/right/head_attribute/hair.png"),
	},
	head_attribute_holding_walk_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/left/head_attribute/hair.png"),
	},
	pants_holding_walk_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/down/pants/pants.png")
	},
	pants_holding_walk_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/up/pants/pants.png")
	},
	pants_holding_walk_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/right/pants/pants.png")
	},
	pants_holding_walk_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/left/pants/pants.png")
	},
	shirts_holding_walk_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/down/shirts/shirt.png")
	},
	shirts_holding_walk_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/up/shirts/shirt.png")
	},
	shirts_holding_walk_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/right/shirts/shirt.png")
	},
	shirts_holding_walk_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/left/shirts/shirt.png")
	},
	shoes_holding_walk_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/down/shoes/shoes.png")
	},
	shoes_holding_walk_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/up/shoes/shoes.png")
	},
	shoes_holding_walk_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/right/shoes/shoes.png")
	},
	shoes_holding_walk_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/HOLDING WALK/assets/left/shoes/shoes.png")
	},
	
	
	body_eat = {
		0 : preload("res://Characters/Human/male/EATING/body/down/body.png")
	},
	arms_eat = {
		0 : preload("res://Characters/Human/male/EATING/body/down/arms.png")
	},
	acc_eat = {
		0 : null,
	},
	head_attribute_eat = {
		0 : null,
		1 : preload("res://Characters/Human/male/EATING/assets/down/head_attribute/hair.png")
	},
	shirts_eat = {
		0 : null,
		1 : preload("res://Characters/Human/male/EATING/assets/down/shirts/shirt.png")
	},
	pants_eat = {
		0 : null,
		1 : preload("res://Characters/Human/male/EATING/assets/down/pants/pants.png")
	},
	shoes_eat = {
		0 : null,
		1 : preload("res://Characters/Human/male/EATING/assets/down/shoes/shoes.png")
	},
	
	body_swim_down = {
		0 : preload("res://Characters/Human/male/SWIMMING/body/down/body.png")
	},
	body_swim_up = {
		0 : preload("res://Characters/Human/male/SWIMMING/body/up/body.png")
	},
	body_swim_right = {
		0 : preload("res://Characters/Human/male/SWIMMING/body/right/body.png")
	},
	body_swim_left = {
		0 : preload("res://Characters/Human/male/SWIMMING/body/left/body.png")
	},

	arms_swim_down = {
		0 : preload("res://Characters/Human/male/SWIMMING/body/down/arms.png")
	},
	arms_swim_up = {
		0 : preload("res://Characters/Human/male/SWIMMING/body/up/arms.png")
	},
	arms_swim_right = {
		0 : preload("res://Characters/Human/male/SWIMMING/body/right/arms.png")
	},
	arms_swim_left = {
		0 : preload("res://Characters/Human/male/SWIMMING/body/left/arms.png")
	},

	acc_swim_down = {
		0 : null,
	},
	acc_swim_up = {
		0 : null,
	},
	acc_swim_right = {
		0 : null,
	},
	acc_swim_left = {
		0 : null,
	},

	head_attribute_swim_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWIMMING/assets/down/head_attribute/hair.png")
	},
	head_attribute_swim_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWIMMING/assets/up/head_attribute/hair.png")
	},
	head_attribute_swim_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWIMMING/assets/right/head_attribute/hair.png")
	},
	head_attribute_swim_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWIMMING/assets/left/head_attribute/hair.png")
	},

	shirts_swim_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWIMMING/assets/down/shirts/shirt.png")
	},
	shirts_swim_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWIMMING/assets/up/shirts/shirt.png")
	},
	shirts_swim_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWIMMING/assets/right/shirts/shirt.png")
	},
	shirts_swim_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/SWIMMING/assets/left/shirts/shirt.png")
	},

	pants_swim_down = {
		0 : null,
		1 : null
	},
	pants_swim_up = {
		0 : null,
		1 : null
	},
	pants_swim_right = {
		0 : null,
		1 : null
	},
	pants_swim_left = {
		0 : null,
		1 : null
	},

	shoes_swim_down = {
		0 : null,
		1 : null
	},
	shoes_swim_up = {
		0 : null,
		1 : null
	},
	shoes_swim_right = {
		0 : null,
		1 : null
	},
	shoes_swim_left = {
		0 : null,
		1 : null
	},
	
	body_cast_down = {
		0 : preload("res://Characters/Human/male/CAST FISHING/body/down/body.png")
	},
	body_cast_up = {
		0 : preload("res://Characters/Human/male/CAST FISHING/body/up/body.png")
	},
	body_cast_right = {
		0 : preload("res://Characters/Human/male/CAST FISHING/body/right/body.png")
	},
	body_cast_left = {
		0 : preload("res://Characters/Human/male/CAST FISHING/body/left/body.png")
	},

	arms_cast_down = {
		0 : preload("res://Characters/Human/male/CAST FISHING/body/down/arms.png")
	},
	arms_cast_up = {
		0 : preload("res://Characters/Human/male/CAST FISHING/body/up/arms.png")
	},
	arms_cast_right = {
		0 : preload("res://Characters/Human/male/CAST FISHING/body/right/arms.png")
	},
	arms_cast_left = {
		0 : preload("res://Characters/Human/male/CAST FISHING/body/left/arms.png")
	},

	acc_cast_down = {
		0 : null,
	},
	acc_cast_up = {
		0 : null,
	},
	acc_cast_right = {
		0 : null,
	},
	acc_cast_left = {
		0 : null,
	},

	head_attribute_cast_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/CAST FISHING/assets/down/head_attribute/hair.png")
	},
	head_attribute_cast_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/CAST FISHING/assets/up/head_attribute/hair.png")
	},
	head_attribute_cast_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/CAST FISHING/assets/right/head_attribute/hair.png")
	},
	head_attribute_cast_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/CAST FISHING/assets/left/head_attribute/hair.png")
	},

	shirts_cast_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/CAST FISHING/assets/down/shirts/shirt.png")
	},
	shirts_cast_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/CAST FISHING/assets/up/shirts/shirt.png")
	},
	shirts_cast_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/CAST FISHING/assets/right/shirts/shirt.png")
	},
	shirts_cast_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/CAST FISHING/assets/left/shirts/shirt.png")
	},

	pants_cast_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/CAST FISHING/assets/down/pants/pants.png")
	},
	pants_cast_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/CAST FISHING/assets/up/pants/pants.png")
	},
	pants_cast_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/CAST FISHING/assets/right/pants/pants.png")
	},
	pants_cast_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/CAST FISHING/assets/left/pants/pants.png")
	},

	shoes_cast_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/CAST FISHING/assets/down/shoes/shoes.png")
	},
	shoes_cast_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/CAST FISHING/assets/up/shoes/shoes.png")
	},
	shoes_cast_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/CAST FISHING/assets/right/shoes/shoes.png")
	},
	shoes_cast_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/CAST FISHING/assets/left/shoes/shoes.png")
	},
	
	body_retract_down = {
		0 : preload("res://Characters/Human/male/RETRACT FISHING/body/down/body.png")
	},
	body_retract_up = {
		0 : preload("res://Characters/Human/male/RETRACT FISHING/body/up/body.png")
	},
	body_retract_right = {
		0 : preload("res://Characters/Human/male/RETRACT FISHING/body/right/body.png")
	},
	body_retract_left = {
		0 : preload("res://Characters/Human/male/RETRACT FISHING/body/left/body.png")
	},

	arms_retract_down = {
		0 : preload("res://Characters/Human/male/RETRACT FISHING/body/down/arms.png")
	},
	arms_retract_up = {
		0 : preload("res://Characters/Human/male/RETRACT FISHING/body/up/arms.png")
	},
	arms_retract_right = {
		0 : preload("res://Characters/Human/male/RETRACT FISHING/body/right/arms.png")
	},
	arms_retract_left = {
		0 : preload("res://Characters/Human/male/RETRACT FISHING/body/left/arms.png")
	},

	acc_retract_down = {
		0 : null,
	},
	acc_retract_up = {
		0 : null,
	},
	acc_retract_right = {
		0 : null,
	},
	acc_retract_left = {
		0 : null,
	},

	head_attribute_retract_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/RETRACT FISHING/assets/down/head_attribute/hair.png")
	},
	head_attribute_retract_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/RETRACT FISHING/assets/up/head_attribute/hair.png")
	},
	head_attribute_retract_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/RETRACT FISHING/assets/right/head_attribute/hair.png")
	},
	head_attribute_retract_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/RETRACT FISHING/assets/left/head_attribute/hair.png")
	},

	shirts_retract_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/RETRACT FISHING/assets/down/shirts/shirt.png")
	},
	shirts_retract_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/RETRACT FISHING/assets/up/shirts/shirt.png")
	},
	shirts_retract_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/RETRACT FISHING/assets/right/shirts/shirt.png")
	},
	shirts_retract_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/RETRACT FISHING/assets/left/shirts/shirt.png")
	},

	pants_retract_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/RETRACT FISHING/assets/down/pants/pants.png")
	},
	pants_retract_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/RETRACT FISHING/assets/up/pants/pants.png")
	},
	pants_retract_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/RETRACT FISHING/assets/right/pants/pants.png")
	},
	pants_retract_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/RETRACT FISHING/assets/left/pants/pants.png")
	},

	shoes_retract_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/RETRACT FISHING/assets/down/shoes/shoes.png")
	},
	shoes_retract_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/RETRACT FISHING/assets/up/shoes/shoes.png")
	},
	shoes_retract_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/RETRACT FISHING/assets/right/shoes/shoes.png")
	},
	shoes_retract_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/RETRACT FISHING/assets/left/shoes/shoes.png")
	},
	
	body_struggle_down = {
		0 : preload("res://Characters/Human/male/STRUGGLE FISHING/body/down/body.png")
	},
	body_struggle_up = {
		0 : preload("res://Characters/Human/male/STRUGGLE FISHING/body/up/body.png")
	},
	body_struggle_right = {
		0 : preload("res://Characters/Human/male/STRUGGLE FISHING/body/right/body.png")
	},
	body_struggle_left = {
		0 : preload("res://Characters/Human/male/STRUGGLE FISHING/body/left/body.png")
	},

	arms_struggle_down = {
		0 : preload("res://Characters/Human/male/STRUGGLE FISHING/body/down/arms.png")
	},
	arms_struggle_up = {
		0 : preload("res://Characters/Human/male/STRUGGLE FISHING/body/up/arms.png")
	},
	arms_struggle_right = {
		0 : preload("res://Characters/Human/male/STRUGGLE FISHING/body/right/arms.png")
	},
	arms_struggle_left = {
		0 : preload("res://Characters/Human/male/STRUGGLE FISHING/body/left/arms.png")
	},

	acc_struggle_down = {
		0 : null,
	},
	acc_struggle_up = {
		0 : null,
	},
	acc_struggle_right = {
		0 : null,
	},
	acc_struggle_left = {
		0 : null,
	},

	head_attribute_struggle_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/STRUGGLE FISHING/assets/down/head_attribute/hair.png")
	},
	head_attribute_struggle_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/STRUGGLE FISHING/assets/up/head_attribute/hair.png")
	},
	head_attribute_struggle_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/STRUGGLE FISHING/assets/right/head_attribute/hair.png")
	},
	head_attribute_struggle_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/STRUGGLE FISHING/assets/left/head_attribute/hair.png")
	},

	shirts_struggle_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/STRUGGLE FISHING/assets/down/shirts/shirt.png")
	},
	shirts_struggle_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/STRUGGLE FISHING/assets/up/shirts/shirt.png")
	},
	shirts_struggle_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/STRUGGLE FISHING/assets/right/shirts/shirt.png")
	},
	shirts_struggle_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/STRUGGLE FISHING/assets/left/shirts/shirt.png")
	},

	pants_struggle_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/STRUGGLE FISHING/assets/down/pants/pants.png")
	},
	pants_struggle_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/STRUGGLE FISHING/assets/up/pants/pants.png")
	},
	pants_struggle_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/STRUGGLE FISHING/assets/right/pants/pants.png")
	},
	pants_struggle_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/STRUGGLE FISHING/assets/left/pants/pants.png")
	},

	shoes_struggle_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/STRUGGLE FISHING/assets/down/shoes/shoes.png")
	},
	shoes_struggle_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/STRUGGLE FISHING/assets/up/shoes/shoes.png")
	},
	shoes_struggle_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/STRUGGLE FISHING/assets/right/shoes/shoes.png")
	},
	shoes_struggle_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/STRUGGLE FISHING/assets/left/shoes/shoes.png")
	},
	
	body_harvest_down = {
		0 : preload("res://Characters/Human/male/HARVESTING/body/down/body.png")
	},
	body_harvest_up = {
		0 : preload("res://Characters/Human/male/HARVESTING/body/up/body.png")
	},
	body_harvest_right = {
		0 : preload("res://Characters/Human/male/HARVESTING/body/right/body.png")
	},
	body_harvest_left = {
		0 : preload("res://Characters/Human/male/HARVESTING/body/left/body.png")
	},

	arms_harvest_down = {
		0 : preload("res://Characters/Human/male/HARVESTING/body/down/arms.png")
	},
	arms_harvest_up = {
		0 : preload("res://Characters/Human/male/HARVESTING/body/up/arms.png")
	},
	arms_harvest_right = {
		0 : preload("res://Characters/Human/male/HARVESTING/body/right/arms.png")
	},
	arms_harvest_left = {
		0 : preload("res://Characters/Human/male/HARVESTING/body/left/arms.png")
	},

	acc_harvest_down = {
		0 : null,
	},
	acc_harvest_up = {
		0 : null,
	},
	acc_harvest_right = {
		0 : null,
	},
	acc_harvest_left = {
		0 : null,
	},

	head_attribute_harvest_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/HARVESTING/assets/down/head_attribute/hair.png")
	},
	head_attribute_harvest_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/HARVESTING/assets/up/head_attribute/hair.png")
	},
	head_attribute_harvest_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/HARVESTING/assets/right/head_attribute/hair.png")
	},
	head_attribute_harvest_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/HARVESTING/assets/left/head_attribute/hair.png")
	},

	shirts_harvest_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/HARVESTING/assets/down/shirts/shirt.png")
	},
	shirts_harvest_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/HARVESTING/assets/up/shirts/shirt.png")
	},
	shirts_harvest_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/HARVESTING/assets/right/shirts/shirt.png")
	},
	shirts_harvest_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/HARVESTING/assets/left/shirts/shirt.png")
	},

	pants_harvest_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/HARVESTING/assets/down/pants/pants.png")
	},
	pants_harvest_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/HARVESTING/assets/up/pants/pants.png")
	},
	pants_harvest_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/HARVESTING/assets/right/pants/pants.png")
	},
	pants_harvest_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/HARVESTING/assets/left/pants/pants.png")
	},

	shoes_harvest_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/HARVESTING/assets/down/shoes/shoes.png")
	},
	shoes_harvest_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/HARVESTING/assets/up/shoes/shoes.png")
	},
	shoes_harvest_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/HARVESTING/assets/right/shoes/shoes.png")
	},
	shoes_harvest_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/HARVESTING/assets/left/shoes/shoes.png")
	},
	body_punch_down = {
		0 : preload("res://Characters/Human/male/PUNCH/body/down/body.png")
	},
	body_punch_up = {
		0 : preload("res://Characters/Human/male/PUNCH/body/up/body.png")
	},
	body_punch_right = {
		0 : preload("res://Characters/Human/male/PUNCH/body/right/body.png")
	},
	body_punch_left = {
		0 : preload("res://Characters/Human/male/PUNCH/body/left/body.png")
	},

	arms_punch_down = {
		0 : preload("res://Characters/Human/male/PUNCH/body/down/arms.png")
	},
	arms_punch_up = {
		0 : preload("res://Characters/Human/male/PUNCH/body/up/arms.png")
	},
	arms_punch_right = {
		0 : preload("res://Characters/Human/male/PUNCH/body/right/arms.png")
	},
	arms_punch_left = {
		0 : preload("res://Characters/Human/male/PUNCH/body/left/arms.png")
	},

	acc_punch_down = {
		0 : null,
	},
	acc_punch_up = {
		0 : null,
	},
	acc_punch_right = {
		0 : null,
	},
	acc_punch_left = {
		0 : null,
	},

	head_attribute_punch_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/PUNCH/assests/down/head_attribute/hair.png")
	},
	head_attribute_punch_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/PUNCH/assests/up/head_attribute/hair.png")
	},
	head_attribute_punch_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/PUNCH/assests/right/head_attribute/Hair.png")
	},
	head_attribute_punch_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/PUNCH/assests/left/head_attribute/hair.png")
	},

	shirts_punch_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/PUNCH/assests/down/shirts/shirts.png")
	},
	shirts_punch_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/PUNCH/assests/up/shirts/shirts.png")
	},
	shirts_punch_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/PUNCH/assests/right/shirts/shirts.png")
	},
	shirts_punch_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/PUNCH/assests/left/shirts/shirts.png")
	},

	pants_punch_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/PUNCH/assests/down/pants/pants.png")
	},
	pants_punch_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/PUNCH/assests/up/pants/pants.png")
	},
	pants_punch_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/PUNCH/assests/right/pants/pants.png")
	},
	pants_punch_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/PUNCH/assests/left/pants/pants.png")
	},

	shoes_punch_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/PUNCH/assests/down/shoes/shoes.png")
	},
	shoes_punch_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/PUNCH/assests/up/shoes/shoes.png")
	},
	shoes_punch_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/PUNCH/assests/right/shoes/shoes.png")
	},
	shoes_punch_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/PUNCH/assests/left/shoes/shoes.png")
	},
	body_draw_down = {
		0 : preload("res://Characters/Human/male/DRAW/body/down/body.png")
	},
	body_draw_up = {
		0 : preload("res://Characters/Human/male/DRAW/body/up/body.png")
	},
	body_draw_right = {
		0 : preload("res://Characters/Human/male/DRAW/body/right/body.png")
	},
	body_draw_left = {
		0 : preload("res://Characters/Human/male/DRAW/body/left/body.png")
	},

	arms_draw_down = {
		0 : preload("res://Characters/Human/male/DRAW/body/down/arms.png")
	},
	arms_draw_up = {
		0 : preload("res://Characters/Human/male/DRAW/body/up/arms.png")
	},
	arms_draw_right = {
		0 : preload("res://Characters/Human/male/DRAW/body/right/arms.png")
	},
	arms_draw_left = {
		0 : preload("res://Characters/Human/male/DRAW/body/left/arms.png")
	},

	acc_draw_down = {
		0 : null,
	},
	acc_draw_up = {
		0 : null,
	},
	acc_draw_right = {
		0 : null,
	},
	acc_draw_left = {
		0 : null,
	},

	head_attribute_draw_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/DRAW/assets/down/head_attribute/hair.png")
	},
	head_attribute_draw_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/DRAW/assets/up/head_attribute/hair.png")
	},
	head_attribute_draw_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/DRAW/assets/right/head_attribute/hair.png")
	},
	head_attribute_draw_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/DRAW/assets/left/head_attribute/hair.png")
	},

	shirts_draw_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/DRAW/assets/down/shirts/shirt.png")
	},
	shirts_draw_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/DRAW/assets/up/shirts/shirt.png")
	},
	shirts_draw_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/DRAW/assets/right/shirts/shirt.png")
	},
	shirts_draw_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/DRAW/assets/left/shirts/shirts.png")
	},

	pants_draw_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/DRAW/assets/down/pants/pants.png")
	},
	pants_draw_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/DRAW/assets/up/pants/pants.png")
	},
	pants_draw_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/DRAW/assets/right/pants/pants.png")
	},
	pants_draw_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/DRAW/assets/left/pants/pants.png")
	},

	shoes_draw_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/DRAW/assets/down/shoes/shoes.png")
	},
	shoes_draw_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/DRAW/assets/up/shoes/shoes.png")
	},
	shoes_draw_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/DRAW/assets/right/shoes/shoes.png")
	},
	shoes_draw_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/DRAW/assets/left/shoes/shoes.png")
	},
	
	body_release_down = {
		0 : preload("res://Characters/Human/male/RELEASE/body/down/body.png")
	},
	body_release_up = {
		0 : preload("res://Characters/Human/male/RELEASE/body/up/body.png")
	},
	body_release_right = {
		0 : preload("res://Characters/Human/male/RELEASE/body/right/body.png")
	},
	body_release_left = {
		0 : preload("res://Characters/Human/male/RELEASE/body/left/body.png")
	},

	arms_release_down = {
		0 : preload("res://Characters/Human/male/RELEASE/body/down/arms.png")
	},
	arms_release_up = {
		0 : preload("res://Characters/Human/male/RELEASE/body/up/arms.png")
	},
	arms_release_right = {
		0 : preload("res://Characters/Human/male/RELEASE/body/right/arms.png")
	},
	arms_release_left = {
		0 : preload("res://Characters/Human/male/RELEASE/body/left/arms.png")
	},

	acc_release_down = {
		0 : null,
	},
	acc_release_up = {
		0 : null,
	},
	acc_release_right = {
		0 : null,
	},
	acc_release_left = {
		0 : null,
	},

	head_attribute_release_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/RELEASE/assets/down/head_attribute/hair.png")
	},
	head_attribute_release_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/RELEASE/assets/up/head_attribute/hair.png")
	},
	head_attribute_release_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/RELEASE/assets/right/head_attribute/hair.png")
	},
	head_attribute_release_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/RELEASE/assets/left/head_attribute/hair.png")
	},

	shirts_release_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/RELEASE/assets/down/shirts/shirt.png")
	},
	shirts_release_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/RELEASE/assets/up/shirts/shirt.png")
	},
	shirts_release_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/RELEASE/assets/right/shirts/shirt.png")
	},
	shirts_release_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/RELEASE/assets/left/shirts/shirt.png")
	},

	pants_release_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/RELEASE/assets/down/pants/pants.png")
	},
	pants_release_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/RELEASE/assets/up/pants/pants.png")
	},
	pants_release_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/RELEASE/assets/right/pants/pants.png")
	},
	pants_release_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/RELEASE/assets/left/pants/pants.png")
	},

	shoes_release_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/RELEASE/assets/down/shoes/shoes.png")
	},
	shoes_release_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/RELEASE/assets/up/shoes/shoes.png")
	},
	shoes_release_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/RELEASE/assets/right/shoes/shoes.png")
	},
	shoes_release_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/RELEASE/assets/left/shoes/shoes.png")
	},
	
	body_run_down = {
		0 : preload("res://Characters/Human/male/RUN/body/down/body.png")
	},
	body_run_up = {
		0 : preload("res://Characters/Human/male/RUN/body/up/body.png")
	},
	body_run_right = {
		0 : preload("res://Characters/Human/male/RUN/body/right/body.png")
	},
	body_run_left = {
		0 : preload("res://Characters/Human/male/RUN/body/left/body.png")
	},

	arms_run_down = {
		0 : preload("res://Characters/Human/male/RUN/body/down/arms.png")
	},
	arms_run_up = {
		0 : preload("res://Characters/Human/male/RUN/body/up/arms.png")
	},
	arms_run_right = {
		0 : preload("res://Characters/Human/male/RUN/body/right/arms.png")
	},
	arms_run_left = {
		0 : preload("res://Characters/Human/male/RUN/body/left/arms.png")
	},

	acc_run_down = {
		0 : null,
	},
	acc_run_up = {
		0 : null,
	},
	acc_run_right = {
		0 : null,
	},
	acc_run_left = {
		0 : null,
	},

	head_attribute_run_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/RUN/assets/down/head_attribute/hair.png")
	},
	head_attribute_run_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/RUN/assets/up/head_attribute/hair.png")
	},
	head_attribute_run_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/RUN/assets/right/head_attribute/hair.png")
	},
	head_attribute_run_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/RUN/assets/left/head_attribute/hair.png")
	},

	shirts_run_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/RUN/assets/down/shirts/shirt.png")
	},
	shirts_run_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/RUN/assets/up/shirts/shirt.png")
	},
	shirts_run_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/RUN/assets/right/shirts/shirt.png")
	},
	shirts_run_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/RUN/assets/left/shirts/shirt.png")
	},

	pants_run_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/RUN/assets/down/pants/pants.png")
	},
	pants_run_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/RUN/assets/up/pants/pants.png")
	},
	pants_run_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/RUN/assets/right/pants/pants.png")
	},
	pants_run_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/RUN/assets/left/pants/pants.png")
	},

	shoes_run_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/RUN/assets/down/shoes/shoes.png")
	},
	shoes_run_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/RUN/assets/up/shoes/shoes.png")
	},
	shoes_run_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/RUN/assets/right/shoes/shoes.png")
	},
	shoes_run_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/RUN/assets/left/shoes/shoes.png")
	},
	
	body_magic_cast_down = {
		0 : preload("res://Characters/Human/male/MAGIC CAST/body/down/body.png")
	},
	body_magic_cast_up = {
		0 : preload("res://Characters/Human/male/MAGIC CAST/body/up/body.png")
	},
	body_magic_cast_right = {
		0 : preload("res://Characters/Human/male/MAGIC CAST/body/right/body.png")
	},
	body_magic_cast_left = {
		0 : preload("res://Characters/Human/male/MAGIC CAST/body/left/body.png")
	},

	arms_magic_cast_down = {
		0 : preload("res://Characters/Human/male/MAGIC CAST/body/down/arms.png")
	},
	arms_magic_cast_up = {
		0 : preload("res://Characters/Human/male/MAGIC CAST/body/up/arms.png")
	},
	arms_magic_cast_right = {
		0 : preload("res://Characters/Human/male/MAGIC CAST/body/right/arms.png")
	},
	arms_magic_cast_left = {
		0 : preload("res://Characters/Human/male/MAGIC CAST/body/left/arms.png")
	},

	acc_magic_cast_down = {
		0 : null,
	},
	acc_magic_cast_up = {
		0 : null,
	},
	acc_magic_cast_right = {
		0 : null,
	},
	acc_magic_cast_left = {
		0 : null,
	},

	head_attribute_magic_cast_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/MAGIC CAST/assets/down/head_attribute/hair.png")
	},
	head_attribute_magic_cast_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/MAGIC CAST/assets/up/head_attribute/hair.png")
	},
	head_attribute_magic_cast_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/MAGIC CAST/assets/right/head_attribute/hair.png")
	},
	head_attribute_magic_cast_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/MAGIC CAST/assets/left/head_attribute/hair.png")
	},

	shirts_magic_cast_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/MAGIC CAST/assets/down/shirt/shirt.png")
	},
	shirts_magic_cast_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/MAGIC CAST/assets/up/shirt/shirt.png")
	},
	shirts_magic_cast_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/MAGIC CAST/assets/right/shirt/shirt.png")
	},
	shirts_magic_cast_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/MAGIC CAST/assets/left/shirt/shirt.png")
	},

	pants_magic_cast_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/MAGIC CAST/assets/down/pants/pants.png")
	},
	pants_magic_cast_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/MAGIC CAST/assets/up/pants/pants.png")
	},
	pants_magic_cast_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/MAGIC CAST/assets/right/pants/pants.png")
	},
	pants_magic_cast_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/MAGIC CAST/assets/left/pants/pants.png")
	},

	shoes_magic_cast_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/MAGIC CAST/assets/down/shoes/shoes.png")
	},
	shoes_magic_cast_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/MAGIC CAST/assets/up/shoes/shoes.png")
	},
	shoes_magic_cast_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/MAGIC CAST/assets/right/shoes/shoes.png")
	},
	shoes_magic_cast_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/MAGIC CAST/assets/left/shoes/shoes.png")
	},
	
	body_sit_down = {
		0 : preload("res://Characters/Human/male/SITTING/body/down/body.png")
	},
	body_sit_up = {
		0 : preload("res://Characters/Human/male/SITTING/body/up/body.png")
	},
	body_sit_right = {
		0 : preload("res://Characters/Human/male/SITTING/body/right/body.png")
	},
	body_sit_left = {
		0 : preload("res://Characters/Human/male/SITTING/body/left/body.png")
	},

	arms_sit_down = {
		0 : preload("res://Characters/Human/male/SITTING/body/down/arms.png")
	},
	arms_sit_up = {
		0 : preload("res://Characters/Human/male/SITTING/body/up/arms.png")
	},
	arms_sit_right = {
		0 : preload("res://Characters/Human/male/SITTING/body/right/arms.png")
	},
	arms_sit_left = {
		0 : preload("res://Characters/Human/male/SITTING/body/left/arms.png")
	},

	acc_sit_down = {
		0 : null,
	},
	acc_sit_up = {
		0 : null,
	},
	acc_sit_right = {
		0 : null,
	},
	acc_sit_left = {
		0 : null,
	},

	head_attribute_sit_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/SITTING/assets/down/head_attribute/hair.png")
	},
	head_attribute_sit_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/SITTING/assets/up/head_attribute/hair.png")
	},
	head_attribute_sit_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/SITTING/assets/right/head_attribute/hair.png")
	},
	head_attribute_sit_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/SITTING/assets/left/head_attribute/hair.png")
	},

	shirts_sit_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/SITTING/assets/down/shirt/shirt.png")
	},
	shirts_sit_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/SITTING/assets/up/shirt/shirt.png")
	},
	shirts_sit_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/SITTING/assets/right/shirt/shirt.png")
	},
	shirts_sit_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/SITTING/assets/left/shirt/shirt.png")
	},

	pants_sit_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/SITTING/assets/down/pants/pants.png")
	},
	pants_sit_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/SITTING/assets/up/pants/pants.png")
	},
	pants_sit_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/SITTING/assets/right/pants/pants.png")
	},
	pants_sit_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/SITTING/assets/left/pants/pants.png")
	},

	shoes_sit_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/SITTING/assets/down/shoes/shoes.png")
	},
	shoes_sit_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/SITTING/assets/up/shoes/shoes.png")
	},
	shoes_sit_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/SITTING/assets/right/shoes/shoes.png")
	},
	shoes_sit_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/SITTING/assets/left/shoes/shoes.png")
	},
	
	body_throw_down = {
		0 : preload("res://Characters/Human/male/THROWING/body/down/body.png")
	},
	body_throw_up = {
		0 : preload("res://Characters/Human/male/THROWING/body/up/body.png")
	},
	body_throw_right = {
		0 : preload("res://Characters/Human/male/THROWING/body/right/body.png")
	},
	body_throw_left = {
		0 : preload("res://Characters/Human/male/THROWING/body/left/body.png")
	},

	arms_throw_down = {
		0 : preload("res://Characters/Human/male/THROWING/body/down/arms.png")
	},
	arms_throw_up = {
		0 : preload("res://Characters/Human/male/THROWING/body/up/arms.png")
	},
	arms_throw_right = {
		0 : preload("res://Characters/Human/male/THROWING/body/right/arms.png")
	},
	arms_throw_left = {
		0 : preload("res://Characters/Human/male/THROWING/body/left/arms.png")
	},

	acc_throw_down = {
		0 : null,
	},
	acc_throw_up = {
		0 : null,
	},
	acc_throw_right = {
		0 : null,
	},
	acc_throw_left = {
		0 : null,
	},

	head_attribute_throw_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/THROWING/assets/down/head_attribute/hair.png")
	},
	head_attribute_throw_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/THROWING/assets/up/head_attribute/hair.png")
	},
	head_attribute_throw_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/THROWING/assets/right/head_attribute/hair.png")
	},
	head_attribute_throw_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/THROWING/assets/left/head_attribute/hair.png")
	},

	shirts_throw_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/THROWING/assets/down/shirt/shirt.png")
	},
	shirts_throw_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/THROWING/assets/up/shirt/shirt.png")
	},
	shirts_throw_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/THROWING/assets/right/shirt/shirt.png")
	},
	shirts_throw_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/THROWING/assets/left/shirt/shirt.png")
	},

	pants_throw_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/THROWING/assets/down/pants/pants.png")
	},
	pants_throw_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/THROWING/assets/up/pants/pants.png")
	},
	pants_throw_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/THROWING/assets/right/pants/pants.png")
	},
	pants_throw_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/THROWING/assets/left/pants/pants.png")
	},

	shoes_throw_down = {
		0 : null,
		1 : preload("res://Characters/Human/male/THROWING/assets/down/shoes/shoes.png")
	},
	shoes_throw_up = {
		0 : null,
		1 : preload("res://Characters/Human/male/THROWING/assets/up/shoes/shoes.png")
	},
	shoes_throw_right = {
		0 : null,
		1 : preload("res://Characters/Human/male/THROWING/assets/right/shoes/shoes.png")
	},
	shoes_throw_left = {
		0 : null,
		1 : preload("res://Characters/Human/male/THROWING/assets/left/shoes/shoes.png")
	},
	
}
#var female = {
#	body_idle_down = {
#		0 : preload("res://Characters/Human/female/IDLE/body/down/body.png")
#	},
#	body_idle_up = {
#		0 : preload("res://Characters/Human/female/IDLE/body/up/body.png")
#	},
#	body_idle_left = {
#		0 : preload("res://Characters/Human/female/IDLE/body/left/body.png")
#	},
#	body_idle_right = {
#		0 : preload("res://Characters/Human/female/IDLE/body/right/body.png")
#	},
#
#	body_walk_down = {
#		0 : preload("res://Characters/Human/female/WALK/body/down/body.png")
#	},
#	body_walk_up = {
#		0 : preload("res://Characters/Human/female/WALK/body/up/body.png")
#	},
#	body_walk_right = {
#		0 : preload("res://Characters/Human/female/WALK/body/right/body.png")
#	},
#	body_walk_left = {
#		0 : preload("res://Characters/Human/female/WALK/body/left/body.png")
#	},
#
#
#	arms_idle_down = {
#		0 : preload("res://Characters/Human/female/IDLE/body/down/arms.png")
#	},
#	arms_idle_up = {
#		0 : preload("res://Characters/Human/female/IDLE/body/up/arms.png")
#	},
#	arms_idle_left = {
#		0 : preload("res://Characters/Human/female/IDLE/body/left/arms.png")
#	},
#	arms_idle_right = {
#		0 : preload("res://Characters/Human/female/IDLE/body/right/arms.png")
#	},
#
#	arms_walk_down = {
#		0 : preload("res://Characters/Human/female/WALK/body/down/arms.png")
#	},
#	arms_walk_up = {
#		0 : preload("res://Characters/Human/female/WALK/body/up/arms.png")
#	},
#	arms_walk_right = {
#		0 : preload("res://Characters/Human/female/WALK/body/right/arms.png")
#	},
#	arms_walk_left = {
#		0 : preload("res://Characters/Human/female/WALK/body/left/arms.png")
#	},
#
#
#	acc_idle_down = {
#		0 : null,
#	},
#	acc_idle_up = {
#		0 : null,
#	},
#	acc_idle_left = {
#		0 : null,
#	},
#	acc_idle_right = {
#		0 : null,
#	},
#
#	acc_walk_down = {
#		0 : null,
#	},
#	acc_walk_up = {
#		0 : null,
#	},
#	acc_walk_right = {
#		0 : null,
#	},
#	acc_walk_left = {
#		0 : null,
#	},
#
#	acc_swing_down = {
#		0 : null,
#	},
#	acc_swing_up = {
#		0 : null,
#	},
#	acc_swing_right = {
#		0 : null,
#	},
#	acc_swing_left = {
#		0 : null,
#	},
#
#
#	head_attribute_idle_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/IDLE/assets/down/head_attribute/hair.png"),
#	},
#	head_attribute_idle_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/IDLE/assets/up/head_attribute/hair.png"),
#	},
#	head_attribute_idle_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/IDLE/assets/left/head_attribute/hair.png"),
#	},
#	head_attribute_idle_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/IDLE/assets/right/head_attribute/hair.png"),
#	},
#
#	head_attribute_walk_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WALK/assets/down/head_attribute/hair.png"),
#	},
#	head_attribute_walk_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WALK/assets/up/head_attribute/hair.png"),
#	},
#	head_attribute_walk_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WALK/assets/right/head_attribute/hair.png"),
#	},
#	head_attribute_walk_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WALK/assets/left/head_attribute/hair.png"),
#	},
#
#	body_swing_down = {
#		0 : preload("res://Characters/Human/female/SWING/body/down/body.png")
#	},
#	body_swing_up = {
#		0 : preload("res://Characters/Human/female/SWING/body/up/body.png")
#	},
#	body_swing_right = {
#		0 : preload("res://Characters/Human/female/SWING/body/right/body.png")
#	},
#	body_swing_left = {
#		0 : preload("res://Characters/Human/female/SWING/body/left/body.png")
#	},
#	arms_swing_down = {
#		0 : preload("res://Characters/Human/female/SWING/body/down/arms.png")
#	},
#	arms_swing_up = {
#		0 : preload("res://Characters/Human/female/SWING/body/up/arms.png")
#	},
#	arms_swing_right = {
#		0 : preload("res://Characters/Human/female/SWING/body/right/arms.png")
#	},
#	arms_swing_left = {
#		0 : preload("res://Characters/Human/female/SWING/body/left/arms.png")
#	},
#	head_attribute_swing_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWING/assets/down/head_attribute/hair.png"),
#	},
#	head_attribute_swing_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWING/assets/up/head_attribute/hair.png"),
#	},
#	head_attribute_swing_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWING/assets/right/head_attribute/hair.png"),
#	},
#	head_attribute_swing_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWING/assets/left/head_attribute/hair.png"),
#	},
#
#
#	pants_idle_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/IDLE/assets/down/pants/skirt.png")
#	},
#	pants_idle_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/IDLE/assets/up/pants/skirt.png")
#	},
#	pants_idle_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/IDLE/assets/right/pants/skirt.png")
#	},
#	pants_idle_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/IDLE/assets/left/pants/skirt.png")
#	},
#
#	pants_walk_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WALK/assets/down/pants/skirt.png")
#	},
#	pants_walk_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WALK/assets/up/pants/skirt.png")
#	},
#	pants_walk_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WALK/assets/right/pants/skirt.png")
#	},
#	pants_walk_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WALK/assets/left/pants/skirt.png")
#	},
#
#	pants_swing_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWING/assets/down/pants/skirt.png")
#	},
#	pants_swing_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWING/assets/up/pants/skirt.png")
#	},
#	pants_swing_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWING/assets/right/pants/skirt.png")
#	},
#	pants_swing_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWING/assets/left/pants/skirt.png")
#	},
#
#
#	shirts_idle_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/IDLE/assets/down/shirts/shirt.png")
#	},
#	shirts_idle_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/IDLE/assets/up/shirts/shirt.png")
#	},
#	shirts_idle_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/IDLE/assets/right/shirts/shirt.png")
#	},
#	shirts_idle_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/IDLE/assets/left/shirts/shirt.png")
#	},
#
#	shirts_walk_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WALK/assets/down/shirts/shirt.png")
#	},
#	shirts_walk_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WALK/assets/up/shirts/shirt.png")
#	},
#	shirts_walk_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WALK/assets/right/shirts/shirt.png")
#	},
#	shirts_walk_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WALK/assets/left/shirts/shirt.png")
#	},
#
#	shirts_swing_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWING/assets/down/shirts/shirt.png")
#	},
#	shirts_swing_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWING/assets/up/shirts/shirt.png")
#	},
#	shirts_swing_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWING/assets/right/shirts/shirt.png")
#	},
#	shirts_swing_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWING/assets/left/shirts/shirt.png")
#	},
#
#	shoes_idle_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/IDLE/assets/down/shoes/shoes.png")
#	},
#	shoes_idle_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/IDLE/assets/up/shoes/shoes.png")
#	},
#	shoes_idle_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/IDLE/assets/left/shoes/shoes.png")
#	},
#	shoes_idle_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/IDLE/assets/right/shoes/shoes.png")
#	},
#
#	shoes_walk_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WALK/assets/down/shoes/shoes.png")
#	},
#	shoes_walk_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WALK/assets/up/shoes/shoes.png")
#	},
#	shoes_walk_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WALK/assets/right/shoes/shoes.png")
#	},
#	shoes_walk_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WALK/assets/left/shoes/shoes.png")
#	},
#
#	shoes_swing_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWING/assets/down/shoes/shoes.png")
#	},
#	shoes_swing_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWING/assets/up/shoes/shoes.png")
#	},
#	shoes_swing_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWING/assets/right/shoes/shoes.png")
#	},
#	shoes_swing_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWING/assets/left/shoes/shoes.png")		
#	},
#	body_death_down = {
#		0 : preload("res://Characters/Human/female/DEATH/body/down/body.png")
#	},
#	body_death_up = {
#		0 : preload("res://Characters/Human/female/DEATH/body/up/body.png")
#	},
#	body_death_right = {
#		0 : preload("res://Characters/Human/female/DEATH/body/right/body.png")
#	},
#	body_death_left = {
#		0 : preload("res://Characters/Human/female/DEATH/body/left/body.png")
#	},
#
#	arms_death_down = {
#		0 : preload("res://Characters/Human/female/DEATH/body/down/arms.png")
#	},
#	arms_death_up = {
#		0 : preload("res://Characters/Human/female/DEATH/body/up/arms.png")
#	},
#	arms_death_right = {
#		0 : preload("res://Characters/Human/female/DEATH/body/right/arms.png")
#	},
#	arms_death_left = {
#		0 : preload("res://Characters/Human/female/DEATH/body/left/arms.png")
#	},
#
#	acc_death_down = {
#		0 : null,
#	},
#	acc_death_up = {
#		0 : null,
#	},
#	acc_death_right = {
#		0 : null,
#	},
#	acc_death_left = {
#		0 : null,
#	},
#
#	head_attribute_death_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/DEATH/assets/down/head_attribute/hair.png")
#	},
#	head_attribute_death_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/DEATH/assets/up/head_attribute/hair.png")
#	},
#	head_attribute_death_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/DEATH/assets/right/head_attribute/hair.png")
#	},
#	head_attribute_death_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/DEATH/assets/left/head_attribute/hair.png")
#	},
#
#	shirts_death_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/DEATH/assets/down/shirts/shirt.png")
#	},
#	shirts_death_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/DEATH/assets/up/shirts/shirt.png")
#	},
#	shirts_death_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/DEATH/assets/right/shirts/shirt.png")
#	},
#	shirts_death_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/DEATH/assets/left/shirts/shirt.png")
#	},
#
#	pants_death_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/DEATH/assets/down/pants/skirt.png")
#	},
#	pants_death_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/DEATH/assets/up/pants/skirt.png")
#	},
#	pants_death_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/DEATH/assets/right/pants/skirt.png")
#	},
#	pants_death_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/DEATH/assets/left/shirts/shirt.png")
#	},
#
#	shoes_death_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/DEATH/assets/down/shoes/shoes.png")
#	},
#	shoes_death_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/DEATH/assets/up/shoes/shoes.png")
#	},
#	shoes_death_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/DEATH/assets/right/shoes/shoes.png")
#	},
#	shoes_death_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/DEATH/assets/left/shoes/shoes.png")
#	},
#
#	body_watering_down = {
#		0 : preload("res://Characters/Human/female/WATERING CAN/body/down/body.png")
#	},
#	body_watering_up = {
#		0 : preload("res://Characters/Human/female/WATERING CAN/body/up/body.png")
#	},
#	body_watering_right = {
#		0 : preload("res://Characters/Human/female/WATERING CAN/body/right/body.png")
#	},
#	body_watering_left = {
#		0 : preload("res://Characters/Human/female/WATERING CAN/body/left/body.png")
#	},
#
#	arms_watering_down = {
#		0 : preload("res://Characters/Human/female/WATERING CAN/body/down/arms.png")
#	},
#	arms_watering_up = {
#		0 : preload("res://Characters/Human/female/WATERING CAN/body/up/arms.png")
#	},
#	arms_watering_right = {
#		0 : preload("res://Characters/Human/female/WATERING CAN/body/right/arms.png")
#	},
#	arms_watering_left = {
#		0 : preload("res://Characters/Human/female/WATERING CAN/body/left/arms.png")
#	},
#
#	acc_watering_down = {
#		0 : null,
#	},
#	acc_watering_up = {
#		0 : null,
#	},
#	acc_watering_right = {
#		0 : null,
#	},
#	acc_watering_left = {
#		0 : null,
#	},
#
#	head_attribute_watering_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WATERING CAN/assets/down/head_attribute/hair.png")
#	},
#	head_attribute_watering_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WATERING CAN/assets/up/head_attribute/hair.png")
#	},
#	head_attribute_watering_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WATERING CAN/assets/right/head_attribute/hair.png")
#	},
#	head_attribute_watering_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WATERING CAN/assets/left/head_attribute/hair.png")
#	},
#
#	shirts_watering_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WATERING CAN/assets/down/shirts/shirt.png")
#	},
#	shirts_watering_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WATERING CAN/assets/up/shirts/shirt.png")
#	},
#	shirts_watering_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WATERING CAN/assets/right/shirts/shirt.png")
#	},
#	shirts_watering_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WATERING CAN/assets/left/shirts/shirt.png")
#	},
#
#	pants_watering_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WATERING CAN/assets/down/pants/skirt.png")
#	},
#	pants_watering_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WATERING CAN/assets/up/pants/skirt.png")
#	},
#	pants_watering_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WATERING CAN/assets/right/pants/skirt.png")
#	},
#	pants_watering_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WATERING CAN/assets/left/pants/skirt.png")
#	},
#
#	shoes_watering_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WATERING CAN/assets/down/shoes/shoes.png")
#	},
#	shoes_watering_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WATERING CAN/assets/up/shoes/shoes.png")
#	},
#	shoes_watering_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WATERING CAN/assets/right/shoes/shoes.png")
#	},
#	shoes_watering_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/WATERING CAN/assets/left/shoes/shoes.png")
#	},
#	body_sleep_down = {
#		0 : preload("res://Characters/Human/female/SLEEP/body/down/body.png")
#	},
#	body_sleep_up = {
#		0 : preload("res://Characters/Human/female/SLEEP/body/up/body.png")
#	},
#	body_sleep_right = {
#		0 : preload("res://Characters/Human/female/SLEEP/body/right/body.png")
#	},
#	body_sleep_left = {
#		0 : preload("res://Characters/Human/female/SLEEP/body/left/body.png")
#	},
#
#	arms_sleep_down = {
#		0 : preload("res://Characters/Human/female/SLEEP/body/down/arms.png")
#	},
#	arms_sleep_up = {
#		0 : preload("res://Characters/Human/female/SLEEP/body/up/arms.png")
#	},
#	arms_sleep_right = {
#		0 : preload("res://Characters/Human/female/SLEEP/body/right/arms.png")
#	},
#	arms_sleep_left = {
#		0 : preload("res://Characters/Human/female/SLEEP/body/left/arms.png")
#	},
#
#	acc_sleep_down = {
#		0 : null,
#	},
#	acc_sleep_up = {
#		0 : null,
#	},
#	acc_sleep_right = {
#		0 : null,
#	},
#	acc_sleep_left = {
#		0 : null,
#	},
#
#	head_attribute_sleep_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SLEEP/assets/down/head_attribute/hair.png")
#	},
#	head_attribute_sleep_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SLEEP/assets/up/head_attribute/hair.png")
#	},
#	head_attribute_sleep_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SLEEP/assets/right/head_attribute/hair.png")
#	},
#	head_attribute_sleep_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SLEEP/assets/left/head_attribute/hair.png")
#	},
#
#	shirts_sleep_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SLEEP/assets/down/shirts/shirt.png")
#	},
#	shirts_sleep_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SLEEP/assets/up/shirts/shirt.png")
#	},
#	shirts_sleep_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SLEEP/assets/right/shirts/shirt.png")
#	},
#	shirts_sleep_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SLEEP/assets/left/shirts/shirt.png")
#	},
#
#	pants_sleep_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SLEEP/assets/down/pants/skirt.png")
#	},
#	pants_sleep_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SLEEP/assets/up/pants/skirt.png")
#	},
#	pants_sleep_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SLEEP/assets/right/pants/skirt.png")
#	},
#	pants_sleep_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SLEEP/assets/left/pants/skirt.png")
#	},
#
#	shoes_sleep_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SLEEP/assets/down/shoes/shoes.png")
#	},
#	shoes_sleep_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SLEEP/assets/up/shoes/shoes.png")
#	},
#	shoes_sleep_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SLEEP/assets/right/shoes/shoes.png")
#	},
#	shoes_sleep_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SLEEP/assets/left/shoes/shoes.png")
#	},
#
#	body_sword_swing_down = {
#		0 : preload("res://Characters/Human/female/SWORD SWING/body/down/body.png")
#	},
#	body_sword_swing_up = {
#		0 : preload("res://Characters/Human/female/SWORD SWING/body/up/body.png")
#	},
#	body_sword_swing_right = {
#		0 : preload("res://Characters/Human/female/SWORD SWING/body/right/body.png")
#	},
#	body_sword_swing_left = {
#		0 : preload("res://Characters/Human/female/SWORD SWING/body/left/body.png")
#	},
#
#	arms_sword_swing_down = {
#		0 : preload("res://Characters/Human/female/SWORD SWING/body/down/arms.png")
#	},
#	arms_sword_swing_up = {
#		0 : preload("res://Characters/Human/female/SWORD SWING/body/up/arms.png")
#	},
#	arms_sword_swing_right = {
#		0 : preload("res://Characters/Human/female/SWORD SWING/body/right/arms.png")
#	},
#	arms_sword_swing_left = {
#		0 : preload("res://Characters/Human/female/SWORD SWING/body/left/arms.png")
#	},
#
#	acc_sword_swing_down = {
#		0 : null,
#	},
#	acc_sword_swing_up = {
#		0 : null,
#	},
#	acc_sword_swing_right = {
#		0 : null,
#	},
#	acc_sword_swing_left = {
#		0 : null,
#	},
#
#	head_attribute_sword_swing_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWORD SWING/assets/down/head_attribute/hair.png")
#	},
#	head_attribute_sword_swing_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWORD SWING/assets/up/head_attribute/hair.png")
#	},
#	head_attribute_sword_swing_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWORD SWING/assets/right/head_attribute/hair.png")
#	},
#	head_attribute_sword_swing_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWORD SWING/assets/left/head_attribute/hair.png")
#	},
#
#	shirts_sword_swing_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWORD SWING/assets/down/shirts/shirt.png")
#	},
#	shirts_sword_swing_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWORD SWING/assets/up/shirts/shirt.png")
#	},
#	shirts_sword_swing_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWORD SWING/assets/right/shirts/shirt.png")
#	},
#	shirts_sword_swing_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWORD SWING/assets/left/shirts/shirt.png")
#	},
#
#	pants_sword_swing_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWORD SWING/assets/down/pants/skirt.png")
#	},
#	pants_sword_swing_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWORD SWING/assets/up/pants/skirt.png")
#	},
#	pants_sword_swing_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWORD SWING/assets/right/pants/skirt.png")
#	},
#	pants_sword_swing_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWORD SWING/assets/left/pants/skirt.png")
#	},
#
#	shoes_sword_swing_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWORD SWING/assets/down/shoes/shoes.png")
#	},
#	shoes_sword_swing_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWORD SWING/assets/up/shoes/shoes.png")
#	},
#	shoes_sword_swing_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWORD SWING/assets/right/shoes/shoes.png")
#	},
#	shoes_sword_swing_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/SWORD SWING/assets/left/shoes/shoes.png")
#	},
#
#
#	body_holding_idle_down = {
#		0 : preload("res://Characters/Human/female/HOLDING IDLE/body/down/body.png")
#	},
#	body_holding_idle_up = {
#		0 : preload("res://Characters/Human/female/HOLDING IDLE/body/up/body.png")
#	},
#	body_holding_idle_right = {
#		0 : preload("res://Characters/Human/female/HOLDING IDLE/body/right/body.png")
#	},
#	body_holding_idle_left = {
#		0 : preload("res://Characters/Human/female/HOLDING IDLE/body/left/body.png")
#	},
#	arms_holding_idle_down = {
#		0 : preload("res://Characters/Human/female/HOLDING IDLE/body/down/arms.png")
#	},
#	arms_holding_idle_up = {
#		0 : preload("res://Characters/Human/female/HOLDING IDLE/body/up/arms.png")
#	},
#	arms_holding_idle_right = {
#		0 : preload("res://Characters/Human/female/HOLDING IDLE/body/right/arms.png")
#	},
#	arms_holding_idle_left = {
#		0 : preload("res://Characters/Human/female/HOLDING IDLE/body/left/arms.png")
#	},
#	acc_holding_idle_down = {
#		0 : null,
#	},
#	acc_holding_idle_up = {
#		0 : null,
#	},
#	acc_holding_idle_right = {
#		0 : null,
#	},
#	acc_holding_idle_left = {
#		0 : null,
#	},
#	head_attribute_holding_idle_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING IDLE/assets/down/head_attribute/hair.png")
#	},
#	head_attribute_holding_idle_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING IDLE/assets/up/head_attribute/hair.png")
#	},
#	head_attribute_holding_idle_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING IDLE/assets/right/head_attribute/hair.png")
#	},
#	head_attribute_holding_idle_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING IDLE/assets/left/head_attribute/hair.png")
#	},
#	shirts_holding_idle_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING IDLE/assets/down/shirts/shirt.png")
#	},
#	shirts_holding_idle_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING IDLE/assets/up/shirts/shirt.png")
#	},
#	shirts_holding_idle_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING IDLE/assets/right/shirts/shirt.png")
#	},
#	shirts_holding_idle_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING IDLE/assets/left/shirts/shirt.png")
#	},
#	pants_holding_idle_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING IDLE/assets/down/pants/skirt.png")
#	},
#	pants_holding_idle_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING IDLE/assets/up/pants/skirt.png")
#	},
#	pants_holding_idle_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING IDLE/assets/right/pants/skirt.png")
#	},
#	pants_holding_idle_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING IDLE/assets/left/pants/skirt.png")
#	},
#	shoes_holding_idle_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING IDLE/assets/down/shoes/shoes.png")
#	},
#	shoes_holding_idle_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING IDLE/assets/up/shoes/shoes.png")
#	},
#	shoes_holding_idle_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING IDLE/assets/right/shoes/shoes.png")
#	},
#	shoes_holding_idle_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING IDLE/assets/left/shoes/shoes.png")
#	},
#
#
#	body_holding_walk_down = {
#		0 : preload("res://Characters/Human/female/HOLDING WALK/body/down/body.png")
#	},
#	body_holding_walk_up = {
#		0 : preload("res://Characters/Human/female/HOLDING WALK/body/up/body.png")
#	},
#	body_holding_walk_right = {
#		0 : preload("res://Characters/Human/female/HOLDING WALK/body/right/body.png")
#	},
#	body_holding_walk_left = {
#		0 : preload("res://Characters/Human/female/HOLDING WALK/body/left/body.png")
#	},
#	arms_holding_walk_down = {
#		0 : preload("res://Characters/Human/female/HOLDING WALK/body/down/arms.png")
#	},
#	arms_holding_walk_up = {
#		0 : preload("res://Characters/Human/female/HOLDING WALK/body/up/arms.png")
#	},
#	arms_holding_walk_right = {
#		0 : preload("res://Characters/Human/female/HOLDING WALK/body/right/arms.png")
#	},
#	arms_holding_walk_left = {
#		0 : preload("res://Characters/Human/female/HOLDING WALK/body/left/arms.png")
#	},
#	acc_holding_walk_down = {
#		0 : null,
#	},
#	acc_holding_walk_up = {
#		0 : null,
#	},
#	acc_holding_walk_right = {
#		0 : null,
#	},
#	acc_holding_walk_left = {
#		0 : null,
#	},
#	head_attribute_holding_walk_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING WALK/assets/down/head_attribute/hair.png"),
#	},
#	head_attribute_holding_walk_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING WALK/assets/up/head_attribute/hair.png"),
#	},
#	head_attribute_holding_walk_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING WALK/assets/right/head_attribute/hair.png"),
#	},
#	head_attribute_holding_walk_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING WALK/assets/left/head_attribute/hair.png"),
#	},
#	pants_holding_walk_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING WALK/assets/down/pants/skirt.png")
#	},
#	pants_holding_walk_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING WALK/assets/up/pants/skirt.png")
#	},
#	pants_holding_walk_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING WALK/assets/right/pants/skirt.png")
#	},
#	pants_holding_walk_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING WALK/assets/left/pants/skirt.png")
#	},
#	shirts_holding_walk_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING WALK/assets/down/shirts/shirt.png")
#	},
#	shirts_holding_walk_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING WALK/assets/up/shirts/shirt.png")
#	},
#	shirts_holding_walk_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING WALK/assets/right/shirts/shirt.png")
#	},
#	shirts_holding_walk_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING WALK/assets/left/shirts/shirt.png")
#	},
#	shoes_holding_walk_down = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING WALK/assets/down/shoes/shoes.png")
#	},
#	shoes_holding_walk_up = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING WALK/assets/up/shoes/shoes.png")
#	},
#	shoes_holding_walk_right = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING WALK/assets/right/shoes/shoes.png")
#	},
#	shoes_holding_walk_left = {
#		0 : null,
#		1 : preload("res://Characters/Human/female/HOLDING WALK/assets/left/shoes/shoes.png")
#	},
#}

