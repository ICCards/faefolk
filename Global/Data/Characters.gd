extends Node




#	body_death_down = {},
#	body_death_up = {},
#	body_death_right = {},
#	body_death_left = {},
#
#	arms_death_down = {},
#	arms_death_up = {},
#	arms_death_right = {},
#	arms_death_left = {},
#
#	acc_death_down = {},
#	acc_death_up = {},
#	acc_death_right = {},
#	acc_death_left = {},
#
#	head_attribute_death_down = {},
#	head_attribute_death_up = {},
#	head_attribute_death_right = {},
#	head_attribute_death_left = {},
#
#	shirt_death_down = {},
#	shirt_death_up = {},
#	shirt_death_right = {},
#	shirt_death_left = {},
#
#	pants_death_down = {},
#	pants_death_up = {},
#	pants_death_right = {},
#	pants_death_left = {},
#
#	shoes_death_down = {},
#	shoes_death_up = {},
#	shoes_death_right = {},
#	shoes_death_left = {},

#	body_watering_down = {
#		0 : preload()
#	},
#	body_watering_up = {
#		0 : preload()
#	},
#	body_watering_right = {
#		0 : preload()
#	},
#	body_watering_left = {
#		0 : preload()
#	},
#
#	arms_watering_down = {
#		0 : preload()
#	},
#	arms_watering_up = {
#		0 : preload()
#	},
#	arms_watering_right = {
#		0 : preload()
#	},
#	arms_watering_left = {
#		0 : preload()
#	},
#
#	acc_watering_down = {
#		0 : null,
#		1 : preload()
#	},
#	acc_watering_up = {
#		0 : null,
#		1 : preload()
#	},
#	acc_watering_right = {
#		0 : null,
#		1 : preload()
#	},
#	acc_watering_left = {
#		0 : null,
#		1 : preload()
#	},
#
#	head_attribute_watering_down = {
#		0 : null,
#		1 : preload()
#	},
#	head_attribute_watering_up = {
#		0 : null,
#		1 : preload()
#	},
#	head_attribute_watering_right = {
#		0 : null,
#		1 : preload()
#	},
#	head_attribute_watering_left = {
#		0 : null,
#		1 : preload()
#	},
#
#	shirts_watering_down = {
#		0 : null,
#		1 : preload()
#	},
#	shirts_watering_up = {
#		0 : null,
#		1 : preload()
#	},
#	shirts_watering_right = {
#		0 : null,
#		1 : preload()
#	},
#	shirts_watering_left = {
#		0 : null,
#		1 : preload()
#	},
#
#	pants_watering_down = {
#		0 : null,
#		1 : preload()
#	},
#	pants_watering_up = {
#		0 : null,
#		1 : preload()
#	},
#	pants_watering_right = {
#		0 : null,
#		1 : preload()
#	},
#	pants_watering_left = {
#		0 : null,
#		1 : preload()
#	},
#
#	shoes_watering_down = {
#		0 : null,
#		1 : preload()
#	},
#	shoes_watering_up = {
#		0 : null,
#		1 : preload()
#	},
#	shoes_watering_right = {
#		0 : null,
#		1 : preload()
#	},
#	shoes_watering_left = {
#		0 : null,
#		1 : preload()
#	},



### Characters ###
var goblin_male = {
	body_idle_down = {
		0 : preload("res://Characters/Goblin/male/idle/body/down/body.png")
	},
	body_idle_up = {
		0 : preload("res://Characters/Goblin/male/idle/body/up/body.png")
	},
	body_idle_left = {
		0 : preload("res://Characters/Goblin/male/idle/body/left/body.png")
	},
	body_idle_right = {
		0 : preload("res://Characters/Goblin/male/idle/body/right/body.png")
	},

	body_walk_down = {
		0 : preload("res://Characters/Goblin/male/walk/body/down/body.png")
	},
	body_walk_up = {
		0 : preload("res://Characters/Goblin/male/walk/body/up/body.png")
	},
	body_walk_right = {
		0 : preload("res://Characters/Goblin/male/walk/body/right/body.png")
	},
	body_walk_left = {
		0 : preload("res://Characters/Goblin/male/walk/body/left/body.png")
	},

	body_swing_down = {
		0 : preload("res://Characters/Goblin/male/swing/body/down/body.png")
	},
	body_swing_up = {
		0 : preload("res://Characters/Goblin/male/swing/body/up/body.png")
	},
	body_swing_right = {
		0 : preload("res://Characters/Goblin/male/swing/body/right/body.png")
	},
	body_swing_left = {
		0 : preload("res://Characters/Goblin/male/swing/body/left/body.png")
	},


	arms_idle_down = {
		0 : preload("res://Characters/Goblin/male/idle/body/down/arms.png")
	},
	arms_idle_up = {
		0 : preload("res://Characters/Goblin/male/idle/body/up/arms.png")
	},
	arms_idle_left = {
		0 : preload("res://Characters/Goblin/male/idle/body/left/arms.png")
	},
	arms_idle_right = {
		0 : preload("res://Characters/Goblin/male/idle/body/right/arms.png")
	},

	arms_walk_up = {
		0 : preload("res://Characters/Goblin/male/walk/body/up/arms.png")
	},
	arms_walk_down = {
		0 : preload("res://Characters/Goblin/male/walk/body/down/arms.png")
	},
	arms_walk_right = {
		0 : preload("res://Characters/Goblin/male/walk/body/right/arms.png")
	},
	arms_walk_left = {
		0 : preload("res://Characters/Goblin/male/walk/body/left/arms.png")
	},

	arms_swing_down = {
		0 : preload("res://Characters/Goblin/male/swing/body/down/arms.png")
	},
	arms_swing_up = {
		0 : preload("res://Characters/Goblin/male/swing/body/up/arms.png")
	},
	arms_swing_right = {
		0 : preload("res://Characters/Goblin/male/swing/body/right/arms.png")
	},
	arms_swing_left = {
		0 : preload("res://Characters/Goblin/male/swing/body/left/arms.png")
	},



	acc_idle_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/idle/assets/down/accessory/armlet_1.png")
	},
	acc_idle_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/idle/assets/up/accessory/armlet_1.png")
	},
	acc_idle_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/idle/assets/left/accessory/armlet_1.png")
	},
	acc_idle_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/idle/assets/right/accessory/armlet_1.png")
	},

	acc_walk_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/walk/assets/down/accessory/armlet_1.png")
	},
	acc_walk_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/walk/assets/up/accessory/armlet_1.png")
	},
	acc_walk_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/walk/assets/right/accessory/armlet_1.png")
	},
	acc_walk_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/walk/assets/left/accessory/armlet_1.png")
	},

	acc_swing_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/swing/assets/down/accessory/armlet_1.png")
	},
	acc_swing_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/swing/assets/up/accessory/armlet_1.png")
	},
	acc_swing_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/swing/assets/right/accessory/armlet_1.png")
	},
	acc_swing_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/swing/assets/left/accessory/armlet_1.png")
	},


	head_attribute_idle_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/idle/assets/down/head_attribute/hair_red_1.png"),
		2 : preload("res://Characters/Goblin/male/idle/assets/down/head_attribute/hood_black_1.png")
	},
	head_attribute_idle_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/idle/assets/up/head_attribute/hair_red_1.png"),
		2 : preload("res://Characters/Goblin/male/idle/assets/up/head_attribute/hood_black_1.png")
	},
	head_attribute_idle_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/idle/assets/left/head_attribute/hair_red_1.png"),
		2 : preload("res://Characters/Goblin/male/idle/assets/left/head_attribute/hood_black_1.png")
	},
	head_attribute_idle_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/idle/assets/right/head_attribute/hair_red_1.png"),
		2 : preload("res://Characters/Goblin/male/idle/assets/right/head_attribute/hood_black_1.png")
	},

	head_attribute_walk_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/walk/assets/down/head_attribute/hair_red_1.png"),
		2 : preload("res://Characters/Goblin/male/walk/assets/down/head_attribute/hood_black_1.png")
	},
	head_attribute_walk_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/walk/assets/up/head_attribute/hair_red_1.png"),
		2 : preload("res://Characters/Goblin/male/walk/assets/up/head_attribute/hood_black_1.png")
	},
	head_attribute_walk_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/walk/assets/right/head_attribute/hair_red_1.png"),
		2 : preload("res://Characters/Goblin/male/walk/assets/right/head_attribute/hood_black_1.png")
	},
	head_attribute_walk_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/walk/assets/left/head_attribute/hair_red_1.png"),
		2 : preload("res://Characters/Goblin/male/walk/assets/left/head_attribute/hood_black_1.png")
	},

	head_attribute_swing_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/swing/assets/down/head_attribute/hair_red_1.png"),
		2 : preload("res://Characters/Goblin/male/swing/assets/down/head_attribute/hood_black_1.png")
	},
	head_attribute_swing_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/swing/assets/up/head_attribute/hair_red_1.png"),
		2 : preload("res://Characters/Goblin/male/swing/assets/up/head_attribute/hood_black_1.png")
	},
	head_attribute_swing_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/swing/assets/right/head_attribute/hair_red_1.png"),
		2 : preload("res://Characters/Goblin/male/swing/assets/right/head_attribute/hood_black_1.png")
	},
	head_attribute_swing_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/swing/assets/left/head_attribute/hair_red_1.png"),
		2 : preload("res://Characters/Goblin/male/swing/assets/left/head_attribute/hood_black_1.png")
	},


	pants_idle_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/idle/assets/down/pants/pants_black_1.png")
	},
	pants_idle_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/idle/assets/up/pants/pants_black_1.png")
	},
	pants_idle_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/idle/assets/right/pants/pants_black_1.png")
	},
	pants_idle_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/idle/assets/left/pants/pants_black_1.png")
	},

	pants_walk_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/walk/assets/down/pants/pants_black_1.png")
	},
	pants_walk_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/walk/assets/up/pants/pants_black_1.png")
	},
	pants_walk_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/walk/assets/right/pants/pants_black_1.png")
	},
	pants_walk_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/walk/assets/left/pants/pants_black_1.png")
	},

	pants_swing_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/swing/assets/down/pants/pants_black_1.png")
	},
	pants_swing_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/swing/assets/up/pants/pants_black_1.png")
	},
	pants_swing_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/swing/assets/right/pants/pants_black_1.png")
	},
	pants_swing_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/swing/assets/left/pants/pants_black_1.png")
	},


	shirts_idle_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/idle/assets/down/shirts/shirt_white_1.png")
	},
	shirts_idle_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/idle/assets/up/shirts/shirt_white_1.png")
	},
	shirts_idle_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/idle/assets/right/shirts/shirt_white_1.png")
	},
	shirts_idle_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/idle/assets/left/shirts/shirt_white_1.png")
	},

	shirts_walk_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/walk/assets/down/shirts/shirt_white_1.png")
	},
	shirts_walk_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/walk/assets/up/shirts/shirt_white_1.png")
	},
	shirts_walk_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/walk/assets/right/shirts/shirt_white_1.png")
	},
	shirts_walk_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/walk/assets/left/shirts/shirt_white_1.png")
	},

	shirts_swing_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/swing/assets/down/shirts/shirt_white_1.png")
	},
	shirts_swing_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/swing/assets/up/shirts/shirt_white_1.png")
	},
	shirts_swing_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/swing/assets/right/shirts/shirt_white_1.png")
	},
	shirts_swing_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/swing/assets/left/shirts/shirt_white_1.png")
	},

	shoes_idle_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/idle/assets/down/shoes/shoes_brown_1.png")
	},
	shoes_idle_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/idle/assets/up/shoes/shoes_brown_1.png")
	},
	shoes_idle_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/idle/assets/left/shoes/shoes_brown_1.png")
	},
	shoes_idle_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/idle/assets/right/shoes/shoes_brown_1.png")
	},

	shoes_walk_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/walk/assets/down/shoes/shoes_brown_1.png")
	},
	shoes_walk_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/walk/assets/up/shoes/shoes_brown_1.png")
	},
	shoes_walk_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/walk/assets/right/shoes/shoes_brown_1.png")
	},
	shoes_walk_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/walk/assets/left/shoes/shoes_brown_1.png")
	},

	shoes_swing_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/swing/assets/down/shoes/shoes_brown_1.png")
	},
	shoes_swing_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/swing/assets/up/shoes/shoes_brown_1.png")
	},
	shoes_swing_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/swing/assets/right/shoes/shoes_brown_1.png")
	},
	shoes_swing_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/male/swing/assets/left/shoes/shoes_brown_1.png")
	}
}

var demi_wolf_male = {
	body_idle_down = {
		0 : preload("res://Characters/demi human/demi wolf/male/IDLE/body/down/body.png")
	},
	body_idle_up = {
		0 : preload("res://Characters/demi human/demi wolf/male/IDLE/body/up/body.png")
	},
	body_idle_left = {
		0 : preload("res://Characters/demi human/demi wolf/male/IDLE/body/left/body.png")
	},
	body_idle_right = {
		0 : preload("res://Characters/demi human/demi wolf/male/IDLE/body/right/body.png")
	},

	body_walk_down = {
		0 : preload("res://Characters/demi human/demi wolf/male/WALK/body/down/body.png")
	},
	body_walk_up = {
		0 : preload("res://Characters/demi human/demi wolf/male/WALK/body/up/body.png")
	},
	body_walk_right = {
		0 : preload("res://Characters/demi human/demi wolf/male/WALK/body/right/body.png")
	},
	body_walk_left = {
		0 : preload("res://Characters/demi human/demi wolf/male/WALK/body/left/body.png")
	},

	body_swing_down = {
		0 : preload("res://Characters/demi human/demi wolf/male/SWING/body/down/body.png")
	},
	body_swing_up = {
		0 : preload("res://Characters/demi human/demi wolf/male/SWING/body/up/body.png")
	},
	body_swing_right = {
		0 : preload("res://Characters/demi human/demi wolf/male/SWING/body/right/body.png")
	},
	body_swing_left = {
		0 : preload("res://Characters/demi human/demi wolf/male/SWING/body/left/body.png")
	},


	arms_idle_down = {
		0 : preload("res://Characters/demi human/demi wolf/male/IDLE/body/down/arms.png")
	},
	arms_idle_up = {
		0 : preload("res://Characters/demi human/demi wolf/male/IDLE/body/up/arms.png")
	},
	arms_idle_left = {
		0 : preload("res://Characters/demi human/demi wolf/male/IDLE/body/left/arms.png")
	},
	arms_idle_right = {
		0 : preload("res://Characters/demi human/demi wolf/male/IDLE/body/right/arms.png")
	},

	arms_walk_up = {
		0 : preload("res://Characters/demi human/demi wolf/male/WALK/body/up/arms.png")
	},
	arms_walk_down = {
		0 : preload("res://Characters/demi human/demi wolf/male/WALK/body/down/arms.png")
	},
	arms_walk_right = {
		0 : preload("res://Characters/demi human/demi wolf/male/WALK/body/right/arms.png")
	},
	arms_walk_left = {
		0 : preload("res://Characters/demi human/demi wolf/male/WALK/body/left/arms.png")
	},

	arms_swing_down = {
		0 : preload("res://Characters/demi human/demi wolf/male/SWING/body/down/arms.png")
	},
	arms_swing_up = {
		0 : preload("res://Characters/demi human/demi wolf/male/SWING/body/up/arms.png")
	},
	arms_swing_right = {
		0 : preload("res://Characters/demi human/demi wolf/male/SWING/body/right/arms.png")
	},
	arms_swing_left = {
		0 : preload("res://Characters/demi human/demi wolf/male/SWING/body/left/arms.png")
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
		1 : preload("res://Characters/demi human/demi wolf/male/IDLE/assets/down/head_attribute/hair.png"),
	},
	head_attribute_idle_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/IDLE/assets/up/head_attribute/hair.png"),
	},
	head_attribute_idle_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/IDLE/assets/left/head_attribute/hair.png"),
	},
	head_attribute_idle_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/IDLE/assets/right/head_attribute/hair.png"),
	},

	head_attribute_walk_down = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/WALK/assets/down/head_attribute/hair.png"),
	},
	head_attribute_walk_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/WALK/assets/up/head_attribute/hair.png"),
	},
	head_attribute_walk_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/WALK/assets/right/head_attribute/hair.png"),
	},
	head_attribute_walk_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/WALK/assets/left/head_attribute/hair.png"),
	},

	head_attribute_swing_down = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/SWING/assets/down/head_attribute/hair.png"),
	},
	head_attribute_swing_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/SWING/assets/up/head_attribute/hair.png"),
	},
	head_attribute_swing_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/SWING/assets/right/head_attribute/hair.png"),
	},
	head_attribute_swing_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/SWING/assets/left/head_attribute/hair.png"),
	},


	pants_idle_down = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/IDLE/assets/down/pants/pants.png")
	},
	pants_idle_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/IDLE/assets/up/pants/pants.png")
	},
	pants_idle_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/IDLE/assets/right/pants/pants.png")
	},
	pants_idle_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/IDLE/assets/left/pants/pants.png")
	},

	pants_walk_down = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/WALK/assets/down/pants/pants.png")
	},
	pants_walk_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/WALK/assets/up/pants/pants.png")
	},
	pants_walk_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/WALK/assets/right/pants/pants.png")
	},
	pants_walk_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/WALK/assets/left/pants/pants.png")
	},

	pants_swing_down = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/SWING/assets/down/pants/pants.png")
	},
	pants_swing_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/SWING/assets/up/pants/pants.png")
	},
	pants_swing_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/SWING/assets/right/pants/pants.png")
	},
	pants_swing_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/SWING/assets/left/pants/pants.png")
	},


	shirts_idle_down = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/IDLE/assets/down/shirts/shirt.png")
	},
	shirts_idle_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/IDLE/assets/up/shirts/shirt.png")
	},
	shirts_idle_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/IDLE/assets/right/shirts/shirt.png")
	},
	shirts_idle_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/IDLE/assets/left/shirts/shirt.png")
	},

	shirts_walk_down = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/IDLE/assets/down/shirts/shirt.png")
	},
	shirts_walk_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/IDLE/assets/up/shirts/shirt.png")
	},
	shirts_walk_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/IDLE/assets/right/shirts/shirt.png")
	},
	shirts_walk_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/IDLE/assets/left/shirts/shirt.png")
	},

	shirts_swing_down = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/SWING/assets/down/shirts/shirt.png")
	},
	shirts_swing_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/SWING/assets/up/shirts/shirt.png")
	},
	shirts_swing_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/SWING/assets/right/shirts/shirt.png")
	},
	shirts_swing_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/SWING/assets/left/shirts/shirt.png")
	},

	shoes_idle_down = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/IDLE/assets/down/shoes/shoes.png")
	},
	shoes_idle_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/IDLE/assets/up/shoes/shoes.png")
	},
	shoes_idle_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/IDLE/assets/left/shoes/shoes.png")
	},
	shoes_idle_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/IDLE/assets/right/shoes/shoes.png")
	},

	shoes_walk_down = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/WALK/assets/down/shoes/shoes.png")
	},
	shoes_walk_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/WALK/assets/up/shoes/shoes.png")
	},
	shoes_walk_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/WALK/assets/right/shoes/shoes.png")
	},
	shoes_walk_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/WALK/assets/left/shoes/shoes.png")
	},

	shoes_swing_down = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/SWING/assets/down/shoes/shoes.png")
	},
	shoes_swing_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/SWING/assets/up/shoes/shoes.png")
	},
	shoes_swing_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/SWING/assets/right/shoes/shoes.png")
	},
	shoes_swing_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/male/SWING/assets/left/shoes/shoes.png")
	}
}
var demi_wolf_female = {
	body_idle_down = {
		0 : preload("res://Characters/demi human/demi wolf/female/IDLE/body/down/body.png")
	},
	body_idle_up = {
		0 : preload("res://Characters/demi human/demi wolf/female/IDLE/body/up/body.png")
	},
	body_idle_left = {
		0 : preload("res://Characters/demi human/demi wolf/female/IDLE/body/left/body.png")
	},
	body_idle_right = {
		0 : preload("res://Characters/demi human/demi wolf/female/IDLE/body/right/body.png")
	},

	body_walk_down = {
		0 : preload("res://Characters/demi human/demi wolf/female/WALK/body/down/body.png")
	},
	body_walk_up = {
		0 : preload("res://Characters/demi human/demi wolf/female/WALK/body/up/body.png")
	},
	body_walk_right = {
		0 : preload("res://Characters/demi human/demi wolf/female/WALK/body/right/body.png")
	},
	body_walk_left = {
		0 : preload("res://Characters/demi human/demi wolf/female/WALK/body/left/body.png")
	},

	body_swing_down = {
		0 : preload("res://Characters/demi human/demi wolf/female/SWING/body/down/body.png")
	},
	body_swing_up = {
		0 : preload("res://Characters/demi human/demi wolf/female/SWING/body/up/body.png")
	},
	body_swing_right = {
		0 : preload("res://Characters/demi human/demi wolf/female/SWING/body/right/body.png")
	},
	body_swing_left = {
		0 : preload("res://Characters/demi human/demi wolf/female/SWING/body/left/body.png")
	},


	arms_idle_down = {
		0 : preload("res://Characters/demi human/demi wolf/female/IDLE/body/down/arms.png")
	},
	arms_idle_up = {
		0 : preload("res://Characters/demi human/demi wolf/female/IDLE/body/up/arms.png")
	},
	arms_idle_left = {
		0 : preload("res://Characters/demi human/demi wolf/female/IDLE/body/left/arms.png")
	},
	arms_idle_right = {
		0 : preload("res://Characters/demi human/demi wolf/female/IDLE/body/right/arms.png")
	},

	arms_walk_up = {
		0 : preload("res://Characters/demi human/demi wolf/female/WALK/body/up/arms.png")
	},
	arms_walk_down = {
		0 : preload("res://Characters/demi human/demi wolf/female/WALK/body/down/arms.png")
	},
	arms_walk_right = {
		0 : preload("res://Characters/demi human/demi wolf/female/WALK/body/right/arms.png")
	},
	arms_walk_left = {
		0 : preload("res://Characters/demi human/demi wolf/female/WALK/body/left/arms.png")
	},

	arms_swing_down = {
		0 : preload("res://Characters/demi human/demi wolf/female/SWING/body/down/arms.png")
	},
	arms_swing_up = {
		0 : preload("res://Characters/demi human/demi wolf/female/SWING/body/up/arms.png")
	},
	arms_swing_right = {
		0 : preload("res://Characters/demi human/demi wolf/female/SWING/body/right/arms.png")
	},
	arms_swing_left = {
		0 : preload("res://Characters/demi human/demi wolf/female/SWING/body/left/arms.png")
	},



	acc_idle_down = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/IDLE/assets/down/accesory/earrings.png")
	},
	acc_idle_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/IDLE/assets/up/accesory/earrings.png")
		
	},
	acc_idle_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/IDLE/assets/left/accesory/earrings.png")
	},
	acc_idle_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/IDLE/assets/right/accesory/earrings.png")
	},

	acc_walk_down = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/WALK/assets/down/accesory/earrings.png")
	},
	acc_walk_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/WALK/assets/up/accesory/earrings.png")
	},
	acc_walk_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/WALK/assets/right/accesory/earrings.png")
	},
	acc_walk_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/WALK/assets/left/accesory/earrings.png")
	},

	acc_swing_down = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/SWING/assets/down/accesory/earrings.png")
	},
	acc_swing_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/SWING/assets/up/accesory/earrings.png")
	},
	acc_swing_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/SWING/assets/right/accesory/earrings.png")
	},
	acc_swing_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/SWING/assets/left/accesory/earrings.png")
	},


	head_attribute_idle_down = {
		0 : null,
	},
	head_attribute_idle_up = {
		0 : null,
	},
	head_attribute_idle_left = {
		0 : null,
	},
	head_attribute_idle_right = {
		0 : null,
	},

	head_attribute_walk_down = {
		0 : null,
	},
	head_attribute_walk_up = {
		0 : null,
	},
	head_attribute_walk_right = {
		0 : null,
	},
	head_attribute_walk_left = {
		0 : null,
	},

	head_attribute_swing_down = {
		0 : null,
	},
	head_attribute_swing_up = {
		0 : null,
	},
	head_attribute_swing_right = {
		0 : null,
	},
	head_attribute_swing_left = {
		0 : null,
	},


	pants_idle_down = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/IDLE/assets/down/pants/pants.png")
	},
	pants_idle_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/IDLE/assets/up/pants/pants.png")
	},
	pants_idle_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/IDLE/assets/right/pants/pants.png")
	},
	pants_idle_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/IDLE/assets/left/pants/pants.png")
	},

	pants_walk_down = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/WALK/assets/down/pants/pants.png")
	},
	pants_walk_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/WALK/assets/up/pants/pants.png")
	},
	pants_walk_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/WALK/assets/right/pants/pants.png")
	},
	pants_walk_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/WALK/assets/left/pants/pants.png")
	},

	pants_swing_down = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/SWING/assets/down/pants/pants.png")
	},
	pants_swing_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/SWING/assets/up/pants/pants.png")
	},
	pants_swing_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/SWING/assets/right/pants/pants.png")
	},
	pants_swing_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/SWING/assets/left/pants/pants.png")
	},


	shirts_idle_down = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/IDLE/assets/down/shirts/shirt.png")
	},
	shirts_idle_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/IDLE/assets/up/shirts/shirt.png")
	},
	shirts_idle_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/IDLE/assets/right/shirts/shirt.png")
	},
	shirts_idle_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/IDLE/assets/left/shirts/shirt.png")
	},

	shirts_walk_down = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/WALK/assets/down/shirts/shirt.png")
	},
	shirts_walk_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/WALK/assets/up/shirts/shirt.png")
	},
	shirts_walk_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/WALK/assets/right/shirts/shirt.png")
	},
	shirts_walk_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/WALK/assets/left/shirts/shirt.png")
	},

	shirts_swing_down = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/SWING/assets/down/shirts/shirt.png")
	},
	shirts_swing_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/SWING/assets/up/shirts/shirt.png")
	},
	shirts_swing_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/SWING/assets/right/shirts/shirt.png")
	},
	shirts_swing_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/SWING/assets/left/shirts/shirt.png")
	},

	shoes_idle_down = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/IDLE/assets/down/shoes/shoes.png")
	},
	shoes_idle_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/IDLE/assets/up/shoes/shoes.png")
	},
	shoes_idle_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/IDLE/assets/left/shoes/shoes.png")
	},
	shoes_idle_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/IDLE/assets/right/shoes/shoes.png")
	},

	shoes_walk_down = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/WALK/assets/down/shoes/shoes.png")
	},
	shoes_walk_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/WALK/assets/up/shoes/shoes.png")
	},
	shoes_walk_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/WALK/assets/right/shoes/shoes.png")
	},
	shoes_walk_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/WALK/assets/left/shoes/shoes.png")
	},

	shoes_swing_down = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/SWING/assets/down/shoes/shoes.png")
	},
	shoes_swing_up = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/SWING/assets/up/shoes/shoes.png")
	},
	shoes_swing_right = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/SWING/assets/right/shoes/shoes.png")
	},
	shoes_swing_left = {
		0 : null,
		1 : preload("res://Characters/demi human/demi wolf/female/SWING/assets/left/shoes/shoes.png")
	}
}

var human_female = {
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
	}
}

var lesser_demon_male = {
	body_idle_down = {
		0 : preload("res://Characters/lesser demon/male/IDLE/body/down/body.png")
	},
	body_idle_up = {
		0 : preload("res://Characters/lesser demon/male/IDLE/body/up/body.png")
	},
	body_idle_left = {
		0 : preload("res://Characters/lesser demon/male/IDLE/body/left/body.png")
	},
	body_idle_right = {
		0 : preload("res://Characters/lesser demon/male/IDLE/body/right/body.png")
	},

	body_walk_down = {
		0 : preload("res://Characters/lesser demon/male/WALK/body/down/body.png")
	},
	body_walk_up = {
		0 : preload("res://Characters/lesser demon/male/WALK/body/up/body.png")
	},
	body_walk_right = {
		0 : preload("res://Characters/lesser demon/male/WALK/body/right/body.png")
	},
	body_walk_left = {
		0 : preload("res://Characters/lesser demon/male/WALK/body/left/body.png")
	},

	body_swing_down = {
		0 : preload("res://Characters/lesser demon/male/SWING/body/down/body.png")
	},
	body_swing_up = {
		0 : preload("res://Characters/lesser demon/male/SWING/body/up/body.png")
	},
	body_swing_right = {
		0 : preload("res://Characters/lesser demon/male/SWING/body/right/body.png")
	},
	body_swing_left = {
		0 : preload("res://Characters/lesser demon/male/SWING/body/left/body.png")
	},


	arms_idle_down = {
		0 : preload("res://Characters/lesser demon/male/IDLE/body/down/arms.png")
	},
	arms_idle_up = {
		0 : preload("res://Characters/lesser demon/male/IDLE/body/up/arms.png")
	},
	arms_idle_left = {
		0 : preload("res://Characters/lesser demon/male/IDLE/body/left/arms.png")
	},
	arms_idle_right = {
		0 : preload("res://Characters/lesser demon/male/IDLE/body/right/arms.png")
	},

	arms_walk_down = {
		0 : preload("res://Characters/lesser demon/male/WALK/body/down/arms.png")
	},
	arms_walk_up = {
		0 : preload("res://Characters/lesser demon/male/WALK/body/up/arms.png")
	},
	arms_walk_right = {
		0 : preload("res://Characters/lesser demon/male/WALK/body/right/arms.png")
	},
	arms_walk_left = {
		0 : preload("res://Characters/lesser demon/male/WALK/body/left/arms.png")
	},

	arms_swing_down = {
		0 : preload("res://Characters/lesser demon/male/SWING/body/down/arms.png")
	},
	arms_swing_up = {
		0 : preload("res://Characters/lesser demon/male/SWING/body/up/arms.png")
	},
	arms_swing_right = {
		0 : preload("res://Characters/lesser demon/male/SWING/body/right/arms.png")
	},
	arms_swing_left = {
		0 : preload("res://Characters/lesser demon/male/SWING/body/left/arms.png")
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
		1 : preload("res://Characters/lesser demon/male/IDLE/assets/down/head_attribute/hair.png"),
	},
	head_attribute_idle_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/IDLE/assets/up/head_attribute/hair.png"),
	},
	head_attribute_idle_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/IDLE/assets/left/head_attribute/hair.png"),
	},
	head_attribute_idle_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/IDLE/assets/right/head_attribute/hair.png"),
	},

	head_attribute_walk_down = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/WALK/assets/down/head_attribute/hair.png"),
	},
	head_attribute_walk_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/WALK/assets/up/head_attribute/hair.png"),
	},
	head_attribute_walk_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/WALK/assets/right/head_attribute/hair.png"),
	},
	head_attribute_walk_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/WALK/assets/left/head_attribute/hair.png"),
	},

	head_attribute_swing_down = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/SWING/assets/down/head_attribute/hair.png"),
	},
	head_attribute_swing_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/SWING/assets/up/head_attribute/hair.png"),
	},
	head_attribute_swing_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/SWING/assets/right/head_attribute/hair.png"),
	},
	head_attribute_swing_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/SWING/assets/left/head_attribute/hair.png"),
	},


	pants_idle_down = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/IDLE/assets/down/pants/bottom.png")
	},
	pants_idle_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/IDLE/assets/up/pants/bottom.png")
	},
	pants_idle_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/IDLE/assets/right/pants/bottom.png")
	},
	pants_idle_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/IDLE/assets/left/pants/bottom.png")
	},

	pants_walk_down = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/WALK/assets/down/pants/bottom.png")
	},
	pants_walk_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/WALK/assets/up/pants/bottom.png")
	},
	pants_walk_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/WALK/assets/right/pants/bottom.png")
	},
	pants_walk_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/WALK/assets/left/pants/bottom.png")
	},

	pants_swing_down = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/SWING/assets/down/pants/bottom.png")
	},
	pants_swing_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/SWING/assets/up/pants/bottom.png")
	},
	pants_swing_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/SWING/assets/right/pants/bottom.png")
	},
	pants_swing_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/SWING/assets/left/pants/bottom.png")
	},


	shirts_idle_down = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/IDLE/assets/down/shirts/breastplate.png")
	},
	shirts_idle_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/IDLE/assets/up/shirts/breastplate.png")
	},
	shirts_idle_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/IDLE/assets/right/shirts/breastplate.png")
	},
	shirts_idle_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/IDLE/assets/left/shirts/breastplate.png")
	},

	shirts_walk_down = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/WALK/assets/down/shirts/breastplate.png")
	},
	shirts_walk_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/WALK/assets/up/shirts/breastplate.png")
	},
	shirts_walk_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/WALK/assets/right/shirts/breastplate.png")
	},
	shirts_walk_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/WALK/assets/left/shirts/breastplate.png")
	},

	shirts_swing_down = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/SWING/assets/down/shirts/breastplate.png")
	},
	shirts_swing_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/SWING/assets/up/shirts/breastplate.png")
	},
	shirts_swing_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/SWING/assets/right/shirts/breastplate.png")
	},
	shirts_swing_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/SWING/assets/left/shirts/breastplate.png")
	},

	shoes_idle_down = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/IDLE/assets/down/shoes/boots.png")
	},
	shoes_idle_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/IDLE/assets/up/shoes/boots.png")
	},
	shoes_idle_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/IDLE/assets/left/shoes/boots.png")
	},
	shoes_idle_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/IDLE/assets/right/shoes/boots.png")
	},

	shoes_walk_down = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/WALK/assets/down/shoes/boots.png")
	},
	shoes_walk_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/WALK/assets/up/shoes/boots.png")
	},
	shoes_walk_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/WALK/assets/right/shoes/boots.png")
	},
	shoes_walk_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/WALK/assets/left/shoes/boots.png")
	},

	shoes_swing_down = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/SWING/assets/down/shoes/boots.png")
	},
	shoes_swing_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/SWING/assets/up/shoes/boots.png")
	},
	shoes_swing_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/SWING/assets/right/shoes/boots.png")
	},
	shoes_swing_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/male/SWING/assets/left/shoes/boots.png")
	}
}
var lesser_demon_female = {
	body_idle_down = {
		0 : preload("res://Characters/lesser demon/female/IDLE/body/down/body.png")
	},
	body_idle_up = {
		0 : preload("res://Characters/lesser demon/female/IDLE/body/up/body.png")
	},
	body_idle_left = {
		0 : preload("res://Characters/lesser demon/female/IDLE/body/left/body.png")
	},
	body_idle_right = {
		0 : preload("res://Characters/lesser demon/female/IDLE/body/right/body.png")
	},

	body_walk_down = {
		0 : preload("res://Characters/lesser demon/female/WALK/body/down/body.png")
	},
	body_walk_up = {
		0 : preload("res://Characters/lesser demon/female/WALK/body/up/body.png")
	},
	body_walk_right = {
		0 : preload("res://Characters/lesser demon/female/WALK/body/right/body.png")
	},
	body_walk_left = {
		0 : preload("res://Characters/lesser demon/female/WALK/body/left/body.png")
	},

	body_swing_down = {
		0 : preload("res://Characters/lesser demon/female/SWING/body/down/body.png")
	},
	body_swing_up = {
		0 : preload("res://Characters/lesser demon/female/SWING/body/up/body.png")
	},
	body_swing_right = {
		0 : preload("res://Characters/lesser demon/female/SWING/body/right/body.png")
	},
	body_swing_left = {
		0 : preload("res://Characters/lesser demon/female/SWING/body/left/body.png")
	},


	arms_idle_down = {
		0 : preload("res://Characters/lesser demon/female/IDLE/body/down/arms.png")
	},
	arms_idle_up = {
		0 : preload("res://Characters/lesser demon/female/IDLE/body/up/arms.png")
	},
	arms_idle_left = {
		0 : preload("res://Characters/lesser demon/female/IDLE/body/left/arms.png")
	},
	arms_idle_right = {
		0 : preload("res://Characters/lesser demon/female/IDLE/body/right/arms.png")
	},

	arms_walk_down = {
		0 : preload("res://Characters/lesser demon/female/WALK/body/down/arms.png")
	},
	arms_walk_up = {
		0 : preload("res://Characters/lesser demon/female/WALK/body/up/arms.png")
	},
	arms_walk_right = {
		0 : preload("res://Characters/lesser demon/female/WALK/body/right/arms.png")
	},
	arms_walk_left = {
		0 : preload("res://Characters/lesser demon/female/WALK/body/left/arms.png")
	},

	arms_swing_down = {
		0 : preload("res://Characters/lesser demon/female/SWING/body/down/arms.png")
	},
	arms_swing_up = {
		0 : preload("res://Characters/lesser demon/female/SWING/body/up/arms.png")
	},
	arms_swing_right = {
		0 : preload("res://Characters/lesser demon/female/SWING/body/right/arms.png")
	},
	arms_swing_left = {
		0 : preload("res://Characters/lesser demon/female/SWING/body/left/arms.png")
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
	},
	head_attribute_idle_up = {
		0 : null,
	},
	head_attribute_idle_left = {
		0 : null,
	},
	head_attribute_idle_right = {
		0 : null,

	},

	head_attribute_walk_down = {
		0 : null,
	},
	head_attribute_walk_up = {
		0 : null,
	},
	head_attribute_walk_right = {
		0 : null,
	},
	head_attribute_walk_left = {
		0 : null,
	},

	head_attribute_swing_down = {
		0 : null,
	},
	head_attribute_swing_up = {
		0 : null,
	},
	head_attribute_swing_right = {
		0 : null,
	},
	head_attribute_swing_left = {
		0 : null,
	},


	pants_idle_down = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/IDLE/assets/down/pants/pants.png")
	},
	
	pants_idle_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/IDLE/assets/up/pants/pants.png")
	},
	pants_idle_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/IDLE/assets/right/pants/pants.png")
	},
	pants_idle_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/IDLE/assets/left/pants/pants.png")
	},

	pants_walk_down = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/WALK/assets/down/pants/pants.png")
	},
	pants_walk_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/WALK/assets/up/pants/pants.png")
	},
	pants_walk_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/WALK/assets/right/pants/pants.png")
	},
	pants_walk_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/WALK/assets/left/pants/pants.png")
	},

	pants_swing_down = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/SWING/assets/down/pants/pants.png")
	},
	pants_swing_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/SWING/assets/up/pants/pants.png")
	},
	pants_swing_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/SWING/assets/right/pants/pants.png")
	},
	pants_swing_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/SWING/assets/left/pants/pants.png")
	},


	shirts_idle_down = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/IDLE/assets/down/shirts/shirt.png")
	},
	shirts_idle_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/IDLE/assets/up/shirts/shirt.png")
	},
	shirts_idle_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/IDLE/assets/right/shirts/shirt.png")
	},
	shirts_idle_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/IDLE/assets/left/shirts/shirt.png")
	},

	shirts_walk_down = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/WALK/assets/down/shirts/shirt.png")
	},
	shirts_walk_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/WALK/assets/up/shirts/shirt.png")
	},
	shirts_walk_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/WALK/assets/right/shirts/shirt.png")
	},
	shirts_walk_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/WALK/assets/left/shirts/shirt.png")
	},

	shirts_swing_down = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/SWING/assets/down/shirts/shirt.png")
	},
	shirts_swing_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/SWING/assets/up/shirts/shirt.png")
	},
	shirts_swing_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/SWING/assets/right/shirts/shirt.png")
	},
	shirts_swing_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/SWING/assets/left/shirts/shirt.png")
	},

	shoes_idle_down = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/IDLE/assets/down/shoes/shoes.png")
	},
	shoes_idle_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/IDLE/assets/up/shoes/shoes.png")
	},
	shoes_idle_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/IDLE/assets/left/shoes/shoes.png")
	},
	shoes_idle_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/IDLE/assets/right/shoes/shoes.png")
	},

	shoes_walk_down = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/WALK/assets/down/shoes/shoes.png")
	},
	shoes_walk_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/WALK/assets/up/shoes/shoes.png")
	},
	shoes_walk_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/WALK/assets/right/shoes/shoes.png")
	},
	shoes_walk_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/WALK/assets/left/shoes/shoes.png")
	},

	shoes_swing_down = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/SWING/assets/down/shoes/shoes.png")
	},
	shoes_swing_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/SWING/assets/up/shoes/shoes.png")
	},
	shoes_swing_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/SWING/assets/right/shoes/shoes.png")
	},
	shoes_swing_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/SWING/assets/left/shoes/shoes.png")
	}
}

var lesser_spirit = {
	body_idle_down = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/IDLE/body/down/body.png")
	},
	body_idle_up = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/IDLE/body/up/body.png")
	},
	body_idle_left = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/IDLE/body/left/body.png")
	},
	body_idle_right = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/IDLE/body/right/body.png")
	},

	body_walk_down = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/WALK/body/down/body.png")
	},
	body_walk_up = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/WALK/body/up/body.png")
	},
	body_walk_right = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/WALK/body/right/body.png")
	},
	body_walk_left = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/WALK/body/left/body.png")
	},

	body_swing_down = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/SWING/body/down/body.png")
	},
	body_swing_up = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/SWING/body/up/body.png")
	},
	body_swing_right = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/SWING/body/right/body.png")
	},
	body_swing_left = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/SWING/body/left/body.png")
	},


	arms_idle_down = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/IDLE/body/down/arms.png")
	},
	arms_idle_up = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/IDLE/body/up/arms.png")
	},
	arms_idle_left = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/IDLE/body/left/arms.png")
	},
	arms_idle_right = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/IDLE/body/right/arms.png")
	},

	arms_walk_down = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/WALK/body/down/arms.png")
	},
	arms_walk_up = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/WALK/body/up/arms.png")
	},
	arms_walk_right = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/WALK/body/right/arms.png")
	},
	arms_walk_left = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/WALK/body/left/arms.png")
	},

	arms_swing_down = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/SWING/body/down/arms.png")
	},
	arms_swing_up = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/SWING/body/up/arms.png")
	},
	arms_swing_right = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/SWING/body/right/arms.png")
	},
	arms_swing_left = {
		0 : preload("res://Characters/Spirits/LESSER SPIRIT/SWING/body/left/arms.png")
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
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/IDLE/assets/down/head_attribute/hair.png")
	},
	head_attribute_idle_up = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/IDLE/assets/up/head_attribute/hair.png"),
	},
	head_attribute_idle_left = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/IDLE/assets/left/head_attribute/hair.png"),
	},
	head_attribute_idle_right = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/IDLE/assets/right/head_attribute/hair.png"),

	},

	head_attribute_walk_down = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/WALK/assets/down/head_attribute/hair.png"),
	},
	head_attribute_walk_up = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/WALK/assets/up/head_attribute/hair.png"),
	},
	head_attribute_walk_right = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/WALK/assets/right/head_attribute/hair.png"),
	},
	head_attribute_walk_left = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/WALK/assets/left/head_attribute/hair.png"),
	},

	head_attribute_swing_down = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/SWING/assets/down/head_attribute/hair.png"),
	},
	head_attribute_swing_up = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/SWING/assets/up/head_attribute/hair.png"),
	},
	head_attribute_swing_right = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/SWING/assets/right/head_attribute/hair.png"),
	},
	head_attribute_swing_left = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/SWING/assets/left/head_attribute/hair.png"),
	},


	pants_idle_down = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/IDLE/assets/down/pants/green_pants.png")
	},

	pants_idle_up = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/IDLE/assets/up/pants/green_pants.png")
	},
	pants_idle_right = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/IDLE/assets/right/pants/green_pants.png")
	},
	pants_idle_left = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/IDLE/assets/left/pants/green_pants.png")
	},

	pants_walk_down = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/WALK/assets/down/pants/green_pants.png")
	},
	pants_walk_up = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/WALK/assets/up/pants/green_pants.png")
	},
	pants_walk_right = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/WALK/assets/right/pants/green_pants.png")
	},
	pants_walk_left = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/WALK/assets/left/pants/green_pants.png")
	},

	pants_swing_down = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/SWING/assets/down/pants/green_pants.png")
	},
	pants_swing_up = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/SWING/assets/up/pants/green_pants.png")
	},
	pants_swing_right = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/SWING/assets/right/pants/green_pants.png")
	},
	pants_swing_left = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/SWING/assets/left/pants/green_pants.png")
	},


	shirts_idle_down = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/IDLE/assets/down/shirts/shirt.png")
	},
	shirts_idle_up = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/IDLE/assets/up/shirts/shirt.png")
	},
	shirts_idle_right = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/IDLE/assets/right/shirts/shirt.png")
	},
	shirts_idle_left = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/IDLE/assets/left/shirts/shirt.png")
	},

	shirts_walk_down = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/WALK/assets/down/shirts/shirt.png")
	},
	shirts_walk_up = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/WALK/assets/up/shirts/shirt.png")
	},
	shirts_walk_right = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/WALK/assets/right/shirts/shirt.png")
	},
	shirts_walk_left = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/WALK/assets/left/shirts/shirt.png")
	},

	shirts_swing_down = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/SWING/assets/down/shirts/shirt.png")
	},
	shirts_swing_up = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/SWING/assets/up/shirts/shirt.png")
	},
	shirts_swing_right = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/SWING/assets/right/shirts/shirt.png")
	},
	shirts_swing_left = {
		0 : null,
		1 : preload("res://Characters/Spirits/LESSER SPIRIT/SWING/assets/left/shirts/shirt.png")
	},

	shoes_idle_down = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/IDLE/assets/down/shoes/shoes.png")
	},
	shoes_idle_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/IDLE/assets/up/shoes/shoes.png")
	},
	shoes_idle_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/IDLE/assets/left/shoes/shoes.png")
	},
	shoes_idle_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/IDLE/assets/right/shoes/shoes.png")
	},

	shoes_walk_down = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/WALK/assets/down/shoes/shoes.png")
	},
	shoes_walk_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/WALK/assets/up/shoes/shoes.png")
	},
	shoes_walk_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/WALK/assets/right/shoes/shoes.png")
	},
	shoes_walk_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/WALK/assets/left/shoes/shoes.png")
	},

	shoes_swing_down = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/SWING/assets/down/shoes/shoes.png")
	},
	shoes_swing_up = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/SWING/assets/up/shoes/shoes.png")
	},
	shoes_swing_right = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/SWING/assets/right/shoes/shoes.png")
	},
	shoes_swing_left = {
		0 : null,
		1 : preload("res://Characters/lesser demon/female/SWING/assets/left/shoes/shoes.png")
	}	
}

var succubus = {
	body_idle_down = {
		0 : preload("res://Characters/Vampires/Succubus/IDLE/body/down/body.png")
	},
	body_idle_up = {
		0 : preload("res://Characters/Vampires/Succubus/IDLE/body/up/body.png")
	},
	body_idle_left = {
		0 : preload("res://Characters/Vampires/Succubus/IDLE/body/left/body.png")
	},
	body_idle_right = {
		0 : preload("res://Characters/Vampires/Succubus/IDLE/body/right/body.png")
	},

	body_walk_down = {
		0 : preload("res://Characters/Vampires/Succubus/WALK/body/down/body.png")
	},
	body_walk_up = {
		0 : preload("res://Characters/Vampires/Succubus/WALK/body/up/body.png")
	},
	body_walk_right = {
		0 : preload("res://Characters/Vampires/Succubus/WALK/body/right/body.png")
	},
	body_walk_left = {
		0 : preload("res://Characters/Vampires/Succubus/WALK/body/left/body.png")
	},

	body_swing_down = {
		0 : preload("res://Characters/Vampires/Succubus/SWING/body/down/body.png")
	},
	body_swing_up = {
		0 : preload("res://Characters/Vampires/Succubus/SWING/body/up/body.png")
	},
	body_swing_right = {
		0 : preload("res://Characters/Vampires/Succubus/SWING/body/right/body.png")
	},
	body_swing_left = {
		0 : preload("res://Characters/Vampires/Succubus/SWING/body/left/body.png")
	},


	arms_idle_down = {
		0 : preload("res://Characters/Vampires/Succubus/IDLE/body/down/arms.png")
	},
	arms_idle_up = {
		0 : preload("res://Characters/Vampires/Succubus/IDLE/body/up/arms.png")
	},
	arms_idle_left = {
		0 : preload("res://Characters/Vampires/Succubus/IDLE/body/left/arms.png")
	},
	arms_idle_right = {
		0 : preload("res://Characters/Vampires/Succubus/IDLE/body/right/arms.png")
	},

	arms_walk_down = {
		0 : preload("res://Characters/Vampires/Succubus/WALK/body/down/arms.png")
	},
	arms_walk_up = {
		0 : preload("res://Characters/Vampires/Succubus/WALK/body/up/arms.png")
	},
	arms_walk_right = {
		0 : preload("res://Characters/Vampires/Succubus/WALK/body/right/arms.png")
	},
	arms_walk_left = {
		0 : preload("res://Characters/Vampires/Succubus/WALK/body/left/arms.png")
	},

	arms_swing_down = {
		0 : preload("res://Characters/Vampires/Succubus/SWING/body/down/arms.png")
	},
	arms_swing_up = {
		0 : preload("res://Characters/Vampires/Succubus/SWING/body/up/arms.png")
	},
	arms_swing_right = {
		0 : preload("res://Characters/Vampires/Succubus/SWING/body/right/arms.png")
	},
	arms_swing_left = {
		0 : preload("res://Characters/Vampires/Succubus/SWING/body/left/arms.png")
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
		1 : preload("res://Characters/Vampires/Succubus/IDLE/assets/down/head_attribute/brown_hair.png")
	},
	head_attribute_idle_up = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/IDLE/assets/up/head_attribute/brown_hair.png"),
	},
	head_attribute_idle_left = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/IDLE/assets/left/head_attribute/brown_hair.png"),
	},
	head_attribute_idle_right = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/IDLE/assets/right/head_attribute/brown_hair.png"),

	},

	head_attribute_walk_down = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/WALK/assets/down/head_attribute/brown_hair.png"),
	},
	head_attribute_walk_up = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/WALK/assets/up/head_attribute/brown_hair.png"),
	},
	head_attribute_walk_right = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/WALK/assets/right/head_attribute/brown_hair.png"),
	},
	head_attribute_walk_left = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/WALK/assets/left/head_attribute/brown_hair.png"),
	},

	head_attribute_swing_down = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/SWING/assets/down/head_attribute/brown_hair.png"),
	},
	head_attribute_swing_up = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/SWING/assets/up/head_attribute/brown_hair.png"),
	},
	head_attribute_swing_right = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/SWING/assets/right/head_attribute/brown_hair.png"),
	},
	head_attribute_swing_left = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/SWING/assets/left/head_attribute/brown_hair.png"),
	},


	pants_idle_down = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/IDLE/assets/down/pants/light_skirt.png")
	},

	pants_idle_up = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/IDLE/assets/up/pants/light_skirt.png")
	},
	pants_idle_right = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/IDLE/assets/right/pants/light_skirt.png")
	},
	pants_idle_left = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/IDLE/assets/left/pants/light_skirt.png")
	},

	pants_walk_down = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/WALK/assets/down/pants/light_skirt.png")
	},
	pants_walk_up = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/WALK/assets/up/pants/light_skirt.png")
	},
	pants_walk_right = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/WALK/assets/right/pants/light_skirt.png")
	},
	pants_walk_left = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/WALK/assets/left/pants/light_skirt.png")
	},

	pants_swing_down = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/SWING/assets/down/pants/light_skirt.png")
	},
	pants_swing_up = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/SWING/assets/up/pants/light_skirt.png")
	},
	pants_swing_right = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/SWING/assets/right/pants/light_skirt.png")
	},
	pants_swing_left = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/SWING/assets/left/pants/light_skirt.png")
	},


	shirts_idle_down = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/IDLE/assets/down/shirts/gold_shirt.png")
	},
	shirts_idle_up = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/IDLE/assets/up/shirts/gold_shirt.png")
	},
	shirts_idle_right = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/IDLE/assets/right/shirts/gold_shirt.png")
	},
	shirts_idle_left = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/IDLE/assets/left/shirts/gold_shirt.png")
	},

	shirts_walk_down = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/WALK/assets/down/shirts/gold_shirt.png")
	},
	shirts_walk_up = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/WALK/assets/up/shirts/gold_shirt.png")
	},
	shirts_walk_right = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/WALK/assets/right/shirts/gold_shirt.png")
	},
	shirts_walk_left = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/WALK/assets/left/shirts/gold_shirt.png")
	},

	shirts_swing_down = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/SWING/assets/down/shirts/gold_shirt.png")
	},
	shirts_swing_up = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/SWING/assets/up/shirts/gold_shirt.png")
	},
	shirts_swing_right = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/SWING/assets/right/shirts/gold_shirt.png")
	},
	shirts_swing_left = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/SWING/assets/left/shirts/gold_shirt.png")
	},

	shoes_idle_down = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/IDLE/assets/down/shoes/black_heels.png")
	},
	shoes_idle_up = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/IDLE/assets/up/shoes/black_heels.png")
	},
	shoes_idle_left = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/IDLE/assets/left/shoes/black_heels.png")
	},
	shoes_idle_right = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/IDLE/assets/right/shoes/black_heels.png")
	},

	shoes_walk_down = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/WALK/assets/down/shoes/black_heels.png")
	},
	shoes_walk_up = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/WALK/assets/up/shoes/black_heels.png")
	},
	shoes_walk_right = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/WALK/assets/right/shoes/black_heels.png")
	},
	shoes_walk_left = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/WALK/assets/left/shoes/black_heels.png")
	},

	shoes_swing_down = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/SWING/assets/down/shoes/black_heels.png")
	},
	shoes_swing_up = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/SWING/assets/up/shoes/black_heels.png")
	},
	shoes_swing_right = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/SWING/assets/right/shoes/black_heels.png")
	},
	shoes_swing_left = {
		0 : null,
		1 : preload("res://Characters/Vampires/Succubus/SWING/assets/left/shoes/black_heels.png")
	}	
}

var seraphim_male = {
	body_idle_down = {
		0 : preload("res://Characters/Angels/seraphim/male/idle/body/down/body.png")
	},
	body_idle_up = {
		0 : preload("res://Characters/Angels/seraphim/male/idle/body/up/body.png")
	},
	body_idle_left = {
		0 : preload("res://Characters/Angels/seraphim/male/idle/body/left/body.png")
	},
	body_idle_right = {
		0 : preload("res://Characters/Angels/seraphim/male/idle/body/right/body.png")
	},

	body_walk_down = {
		0 : preload("res://Characters/Angels/seraphim/male/walk/body/down/body.png")
	},
	body_walk_up = {
		0 : preload("res://Characters/Angels/seraphim/male/walk/body/up/body.png")
	},
	body_walk_right = {
		0 : preload("res://Characters/Angels/seraphim/male/walk/body/right/body.png")
	},
	body_walk_left = {
		0 : preload("res://Characters/Angels/seraphim/male/walk/body/left/body.png")
	},

	body_swing_down = {
		0 : preload("res://Characters/Angels/seraphim/male/swing/body/down/body.png")
	},
	body_swing_up = {
		0 : preload("res://Characters/Angels/seraphim/male/swing/body/up/body.png")
	},
	body_swing_right = {
		0 : preload("res://Characters/Angels/seraphim/male/swing/body/right/body.png")
	},
	body_swing_left = {
		0 : preload("res://Characters/Angels/seraphim/male/swing/body/left/body.png")
	},


	arms_idle_down = {
		0 : preload("res://Characters/Angels/seraphim/male/idle/body/down/arms.png")
	},
	arms_idle_up = {
		0 : preload("res://Characters/Angels/seraphim/male/idle/body/up/arms.png")
	},
	arms_idle_left = {
		0 : preload("res://Characters/Angels/seraphim/male/idle/body/left/arms.png")
	},
	arms_idle_right = {
		0 : preload("res://Characters/Angels/seraphim/male/idle/body/right/arms.png")
	},

	arms_walk_down = {
		0 : preload("res://Characters/Angels/seraphim/male/walk/body/down/arms.png")
	},
	arms_walk_up = {
		0 : preload("res://Characters/Angels/seraphim/male/walk/body/up/arms.png")
	},
	arms_walk_right = {
		0 : preload("res://Characters/Angels/seraphim/male/walk/body/right/arms.png")
	},
	arms_walk_left = {
		0 : preload("res://Characters/Angels/seraphim/male/walk/body/left/arms.png")
	},

	arms_swing_down = {
		0 : preload("res://Characters/Angels/seraphim/male/swing/body/down/arms.png")
	},
	arms_swing_up = {
		0 : preload("res://Characters/Angels/seraphim/male/swing/body/up/arms.png")
	},
	arms_swing_right = {
		0 : preload("res://Characters/Angels/seraphim/male/swing/body/right/arms.png")
	},
	arms_swing_left = {
		0 : preload("res://Characters/Angels/seraphim/male/swing/body/left/arms.png")
	},



	acc_idle_down = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/idle/assets/down/accesory/cloak.png")
	},
	acc_idle_up = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/idle/assets/up/accesory/cloak.png")
	},
	acc_idle_left = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/idle/assets/left/accesory/cloak.png")
	},
	acc_idle_right = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/idle/assets/right/accesory/cloak.png")
	},

	acc_walk_down = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/walk/assets/down/accesory/cloak.png")
	},
	acc_walk_up = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/walk/assets/up/accesory/cloak.png")
	},
	acc_walk_right = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/walk/assets/right/accesory/cloak.png")
	},
	acc_walk_left = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/walk/assets/left/accesory/cloak.png")
	},

	acc_swing_down = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/swing/assets/down/accesory/cloak.png")
	},
	acc_swing_up = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/swing/assets/up/accesory/cloak.png")
	},
	acc_swing_right = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/swing/assets/right/accesory/cloak.png")
	},
	acc_swing_left = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/swing/assets/left/accesory/cloak.png")
	},


	head_attribute_idle_down = {
		0 : null,
	},
	head_attribute_idle_up = {
		0 : null,
	},
	head_attribute_idle_left = {
		0 : null,
	},
	head_attribute_idle_right = {
		0 : null,
	},

	head_attribute_walk_down = {
		0 : null,
	},
	head_attribute_walk_up = {
		0 : null,
	},
	head_attribute_walk_right = {
		0 : null,
	},
	head_attribute_walk_left = {
		0 : null,
	},

	head_attribute_swing_down = {
		0 : null,
	},
	head_attribute_swing_up = {
		0 : null,
	},
	head_attribute_swing_right = {
		0 : null,
	},
	head_attribute_swing_left = {
		0 : null,
	},


	pants_idle_down = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/idle/assets/down/pants/pants.png")
	},

	pants_idle_up = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/idle/assets/up/pants/pants.png")
	},
	pants_idle_right = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/idle/assets/right/pants/pants.png")
	},
	pants_idle_left = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/idle/assets/left/pants/pants.png")
	},

	pants_walk_down = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/walk/assets/down/pants/pants.png")
	},
	pants_walk_up = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/walk/assets/up/pants/pants.png")
	},
	pants_walk_right = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/walk/assets/right/pants/pants.png")
	},
	pants_walk_left = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/walk/assets/left/pants/pants.png")
	},

	pants_swing_down = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/swing/assets/down/pants/pants.png")
	},
	pants_swing_up = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/swing/assets/up/pants/pants.png")
	},
	pants_swing_right = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/swing/assets/right/pants/pants.png")
	},
	pants_swing_left = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/swing/assets/left/pants/pants.png")
	},


	shirts_idle_down = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/idle/assets/down/shirts/robe.png")
	},
	shirts_idle_up = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/idle/assets/up/shirts/robe.png")
	},
	shirts_idle_right = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/idle/assets/right/shirts/robe.png")
	},
	shirts_idle_left = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/idle/assets/left/shirts/robe.png")
	},

	shirts_walk_down = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/walk/assets/down/shirts/robe.png")
	},
	shirts_walk_up = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/walk/assets/up/shirts/robe.png")
	},
	shirts_walk_right = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/walk/assets/right/shirts/robe.png")
	},
	shirts_walk_left = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/walk/assets/left/shirts/robe.png")
	},

	shirts_swing_down = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/swing/assets/down/shirts/robe.png")
	},
	shirts_swing_up = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/swing/assets/up/shirts/robe.png")
	},
	shirts_swing_right = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/swing/assets/right/shirts/robe.png")
	},
	shirts_swing_left = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/swing/assets/left/shirts/robe.png")
	},

	shoes_idle_down = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/idle/assets/down/shoes/shoes.png")
	},
	shoes_idle_up = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/idle/assets/up/shoes/shoes.png")
	},
	shoes_idle_left = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/idle/assets/left/shoes/shoes.png")
	},
	shoes_idle_right = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/idle/assets/right/shoes/shoes.png")
	},

	shoes_walk_down = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/walk/assets/down/shoes/shoes.png")
	},
	shoes_walk_up = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/walk/assets/up/shoes/shoes.png")
	},
	shoes_walk_right = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/walk/assets/right/shoes/shoes.png")
	},
	shoes_walk_left = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/walk/assets/left/shoes/shoes.png")
	},

	shoes_swing_down = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/swing/assets/down/shoes/shoes.png")
	},
	shoes_swing_up = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/swing/assets/up/shoes/shoes.png")
	},
	shoes_swing_right = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/swing/assets/right/shoes/shoes.png")
	},
	shoes_swing_left = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/male/swing/assets/left/shoes/shoes.png")
	}	
}
var seraphim_female = {
	body_idle_down = {
		0 : preload("res://Characters/Angels/seraphim/female/idle/body/down/body.png")
	},
	body_idle_up = {
		0 : preload("res://Characters/Angels/seraphim/female/idle/body/up/body.png")
	},
	body_idle_left = {
		0 : preload("res://Characters/Angels/seraphim/female/idle/body/left/body.png")
	},
	body_idle_right = {
		0 : preload("res://Characters/Angels/seraphim/female/idle/body/right/body.png")
	},

	body_walk_down = {
		0 : preload("res://Characters/Angels/seraphim/female/walk/body/down/body.png")
	},
	body_walk_up = {
		0 : preload("res://Characters/Angels/seraphim/female/walk/body/up/body.png")
	},
	body_walk_right = {
		0 : preload("res://Characters/Angels/seraphim/female/walk/body/right/body.png")
	},
	body_walk_left = {
		0 : preload("res://Characters/Angels/seraphim/female/walk/body/left/body.png")
	},

	body_swing_down = {
		0 : preload("res://Characters/Angels/seraphim/female/swing/body/down/body.png")
	},
	body_swing_up = {
		0 : preload("res://Characters/Angels/seraphim/female/swing/body/up/body.png")
	},
	body_swing_right = {
		0 : preload("res://Characters/Angels/seraphim/female/swing/body/right/body.png")
	},
	body_swing_left = {
		0 : preload("res://Characters/Angels/seraphim/female/swing/body/left/body.png")
	},


	arms_idle_down = {
		0 : preload("res://Characters/Angels/seraphim/female/idle/body/down/arms.png")
	},
	arms_idle_up = {
		0 : preload("res://Characters/Angels/seraphim/female/idle/body/up/arms.png")
	},
	arms_idle_left = {
		0 : preload("res://Characters/Angels/seraphim/female/idle/body/left/arms.png")
	},
	arms_idle_right = {
		0 : preload("res://Characters/Angels/seraphim/female/idle/body/right/arms.png")
	},

	arms_walk_down = {
		0 : preload("res://Characters/Angels/seraphim/female/walk/body/down/arms.png")
	},
	arms_walk_up = {
		0 : preload("res://Characters/Angels/seraphim/female/walk/body/up/arms.png")
	},
	arms_walk_right = {
		0 : preload("res://Characters/Angels/seraphim/female/walk/body/right/arms.png")
	},
	arms_walk_left = {
		0 : preload("res://Characters/Angels/seraphim/female/walk/body/left/arms.png")
	},

	arms_swing_down = {
		0 : preload("res://Characters/Angels/seraphim/female/swing/body/down/arms.png")
	},
	arms_swing_up = {
		0 : preload("res://Characters/Angels/seraphim/female/swing/body/up/arms.png")
	},
	arms_swing_right = {
		0 : preload("res://Characters/Angels/seraphim/female/swing/body/right/arms.png")
	},
	arms_swing_left = {
		0 : preload("res://Characters/Angels/seraphim/female/swing/body/left/arms.png")
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
		1 : preload("res://Characters/Angels/seraphim/female/idle/assets/down/head_attribute/hair.png")
	},
	head_attribute_idle_up = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/idle/assets/up/head_attribute/hair.png")
	},
	head_attribute_idle_left = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/idle/assets/left/head_attribute/hair.png")
	},
	head_attribute_idle_right = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/idle/assets/right/head_attribute/hair.png")
	},

	head_attribute_walk_down = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/walk/assets/down/head_attribute/hair.png")
	},
	head_attribute_walk_up = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/walk/assets/up/head_attribute/hair.png")
	},
	head_attribute_walk_right = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/walk/assets/right/head_attribute/hair.png")
	},
	head_attribute_walk_left = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/walk/assets/left/head_attribute/hair.png")
	},

	head_attribute_swing_down = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/swing/assets/down/head_attribute/hair.png")
	},
	head_attribute_swing_up = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/swing/assets/up/head_attribute/hair.png")
	},
	head_attribute_swing_right = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/swing/assets/right/head_attribute/hair.png")
	},
	head_attribute_swing_left = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/swing/assets/left/head_attribute/hair.png")
	},


	pants_idle_down = {
		0 : null,
	},
	pants_idle_up = {
		0 : null,
	},
	pants_idle_right = {
		0 : null,
	},
	pants_idle_left = {
		0 : null,
	},

	pants_walk_down = {
		0 : null,
	},
	pants_walk_up = {
		0 : null,
	},
	pants_walk_right = {
		0 : null,
	},
	pants_walk_left = {
		0 : null,
	},

	pants_swing_down = {
		0 : null,
	},
	pants_swing_up = {
		0 : null,
	},
	pants_swing_right = {
		0 : null,
	},
	pants_swing_left = {
		0 : null,
	},


	shirts_idle_down = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/idle/assets/down/shirts/breastplate.png")
	},
	shirts_idle_up = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/idle/assets/up/shirts/breastplate.png")
	},
	shirts_idle_right = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/idle/assets/right/shirts/breastplate.png")
	},
	shirts_idle_left = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/idle/assets/left/shirts/breastplate.png")
	},

	shirts_walk_down = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/walk/assets/down/shirts/breastplate.png")
	},
	shirts_walk_up = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/walk/assets/up/shirts/breastplate.png")
	},
	shirts_walk_right = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/walk/assets/right/shirts/breastplate.png")
	},
	shirts_walk_left = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/walk/assets/left/shirts/breastplate.png")
	},

	shirts_swing_down = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/swing/assets/down/shirts/breastplate.png")
	},
	shirts_swing_up = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/swing/assets/up/shirts/breastplate.png")
	},
	shirts_swing_right = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/swing/assets/right/shirts/breastplate.png")
	},
	shirts_swing_left = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/swing/assets/left/shirts/breastplate.png")
	},

	shoes_idle_down = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/idle/assets/down/shoes/shoes.png")
	},
	shoes_idle_up = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/idle/assets/up/shoes/shoes.png")
	},
	shoes_idle_left = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/idle/assets/left/shoes/shoes.png")
	},
	shoes_idle_right = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/idle/assets/right/shoes/shoes.png")
	},

	shoes_walk_down = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/walk/assets/down/shoes/shoes.png")
	},
	shoes_walk_up = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/walk/assets/up/shoes/shoes.png")
	},
	shoes_walk_right = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/walk/assets/right/shoes/shoes.png")
	},
	shoes_walk_left = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/walk/assets/left/shoes/shoes.png")
	},

	shoes_swing_down = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/swing/assets/down/shoes/shoes.png")
	},
	shoes_swing_up = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/swing/assets/up/shoes/shoes.png")
	},
	shoes_swing_right = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/swing/assets/right/shoes/shoes.png")
	},
	shoes_swing_left = {
		0 : null,
		1 : preload("res://Characters/Angels/seraphim/female/swing/assets/left/shoes/shoes.png")
	}	
}

var water_draganoid_male = {
	body_idle_down = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/body/down/body.png")
	},
	body_idle_up = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/body/up/body.png")
	},
	body_idle_left = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/body/left/body.png")
	},
	body_idle_right = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/body/right/body.png")
	},

	body_walk_down = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/body/down/body.png")
	},
	body_walk_up = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/body/up/body.png")
	},
	body_walk_right = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/body/right/body.png")
	},
	body_walk_left = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/body/left/body.png")
	},

	body_swing_down = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/body/down/body.png")
	},
	body_swing_up = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/body/up/body.png")
	},
	body_swing_right = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/body/right/body.png")
	},
	body_swing_left = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/body/left/body.png")
	},


	arms_idle_down = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/body/down/arms.png")
	},
	arms_idle_up = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/body/up/arms.png")
	},
	arms_idle_left = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/body/left/arms.png")
	},
	arms_idle_right = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/body/right/arms.png")
	},

	arms_walk_down = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/body/down/arms.png")
	},
	arms_walk_up = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/body/up/arms.png")
	},
	arms_walk_right = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/body/right/arms.png")
	},
	arms_walk_left = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/body/left/arms.png")
	},

	arms_swing_down = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/body/down/arms.png")
	},
	arms_swing_up = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/body/up/arms.png")
	},
	arms_swing_right = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/body/right/arms.png")
	},
	arms_swing_left = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/body/left/arms.png")
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
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/assets/down/head_attribute/spikes.png")
	},
	head_attribute_idle_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/assets/up/head_attribute/spikes.png")
	},
	head_attribute_idle_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/assets/left/head_attribute/spikes.png")
	},
	head_attribute_idle_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/assets/right/head_attribute/spikes.png")
	},

	head_attribute_walk_down = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/assets/down/head_attribute/spikes.png")
	},
	head_attribute_walk_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/assets/up/head_attribute/spikes.png")
	},
	head_attribute_walk_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/assets/right/head_attribute/spikes.png")
	},
	head_attribute_walk_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/assets/left/head_attribute/spikes.png")
	},

	head_attribute_swing_down = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/assets/down/head_attribute/spikes.png")
	},
	head_attribute_swing_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/assets/up/head_attribute/spikes.png")
	},
	head_attribute_swing_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/assets/right/head_attribute/spikes.png")
	},
	head_attribute_swing_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/assets/left/head_attribute/spikes.png")
	},


	pants_idle_down = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/assets/down/pants/pants.png")
	},

	pants_idle_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/assets/up/pants/pants.png")
	},
	pants_idle_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/assets/right/pants/pants.png")
	},
	pants_idle_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/assets/left/pants/pants.png")
	},

	pants_walk_down = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/assets/down/pants/pants.png")
	},
	pants_walk_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/assets/up/pants/pants.png")
	},
	pants_walk_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/assets/right/pants/pants.png")
	},
	pants_walk_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/assets/left/pants/pants.png")
	},

	pants_swing_down = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/assets/down/pants/pants.png")
	},
	pants_swing_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/assets/up/pants/pants.png")
	},
	pants_swing_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/assets/right/pants/pants.png")
	},
	pants_swing_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/assets/left/pants/pants.png")
	},


	shirts_idle_down = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/assets/down/shirts/shirt.png")
	},
	shirts_idle_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/assets/up/shirts/shirt.png")
	},
	shirts_idle_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/assets/right/shirts/shirt.png")
	},
	shirts_idle_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/assets/left/shirts/shirt.png")
	},

	shirts_walk_down = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/assets/down/shirts/shirt.png")
	},
	shirts_walk_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/assets/up/shirts/shirt.png")
	},
	shirts_walk_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/assets/right/shirts/shirt.png")
	},
	shirts_walk_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/assets/left/shirts/shirt.png")
	},

	shirts_swing_down = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/assets/down/shirts/shirt.png")
	},
	shirts_swing_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/assets/up/shirts/shirt.png")
	},
	shirts_swing_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/assets/right/shirts/shirt.png")
	},
	shirts_swing_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/assets/left/shirts/shirt.png")
	},

	shoes_idle_down = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/assets/down/shoes/shoes.png")
	},
	shoes_idle_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/assets/up/shoes/shoes.png")
	},
	shoes_idle_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/assets/left/shoes/shoes.png")
	},
	shoes_idle_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/idle/assets/right/shoes/shoes.png")
	},

	shoes_walk_down = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/assets/down/shoes/shoes.png")
	},
	shoes_walk_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/assets/up/shoes/shoes.png")
	},
	shoes_walk_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/assets/right/shoes/shoes.png")
	},
	shoes_walk_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/walk/assets/left/shoes/shoes.png")
	},

	shoes_swing_down = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/assets/down/shoes/shoes.png")
	},
	shoes_swing_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/assets/up/shoes/shoes.png")
	},
	shoes_swing_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/assets/right/shoes/shoes.png")
	},
	shoes_swing_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/male/swing/assets/left/shoes/shoes.png")
	}	
}
var water_draganoid_female = {
	body_idle_down = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/body/down/body.png")
	},
	body_idle_up = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/body/up/body.png")
	},
	body_idle_left = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/body/left/body.png")
	},
	body_idle_right = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/body/right/body.png")
	},

	body_walk_down = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/body/down/body.png")
	},
	body_walk_up = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/body/up/body.png")
	},
	body_walk_right = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/body/right/body.png")
	},
	body_walk_left = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/body/left/body.png")
	},

	body_swing_down = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/body/down/body.png")
	},
	body_swing_up = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/body/up/body.png")
	},
	body_swing_right = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/body/right/body.png")
	},
	body_swing_left = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/body/left/body.png")
	},


	arms_idle_down = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/body/down/arms.png")
	},
	arms_idle_up = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/body/up/arms.png")
	},
	arms_idle_left = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/body/left/arms.png")
	},
	arms_idle_right = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/body/right/arms.png")
	},

	arms_walk_down = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/body/down/arms.png")
	},
	arms_walk_up = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/body/up/arms.png")
	},
	arms_walk_right = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/body/right/arms.png")
	},
	arms_walk_left = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/body/left/arms.png")
	},

	arms_swing_down = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/body/down/arms.png")
	},
	arms_swing_up = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/body/up/arms.png")
	},
	arms_swing_right = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/body/right/arms.png")
	},
	arms_swing_left = {
		0 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/body/left/arms.png")
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
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/assets/down/head_attribute/spikes.png")
	},
	head_attribute_idle_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/assets/up/head_attribute/spikes.png")
	},
	head_attribute_idle_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/assets/left/head_attribute/spikes.png")
	},
	head_attribute_idle_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/assets/right/head_attribute/spikes.png")
	},

	head_attribute_walk_down = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/assets/down/head_attribute/spikes.png")
	},
	head_attribute_walk_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/assets/up/head_attribute/spikes.png")
	},
	head_attribute_walk_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/assets/right/head_attribute/spikes.png")
	},
	head_attribute_walk_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/assets/left/head_attribute/spikes.png")
	},

	head_attribute_swing_down = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/assets/down/head_attribute/spikes.png")
	},
	head_attribute_swing_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/assets/up/head_attribute/spikes.png")
	},
	head_attribute_swing_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/assets/right/head_attribute/spikes.png")
	},
	head_attribute_swing_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/assets/left/head_attribute/spikes.png")
	},


	pants_idle_down = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/assets/down/pants/pants.png")
	},

	pants_idle_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/assets/up/pants/pants.png")
	},
	pants_idle_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/assets/right/pants/pants.png")
	},
	pants_idle_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/assets/left/pants/pants.png")
	},

	pants_walk_down = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/assets/down/pants/pants.png")
	},
	pants_walk_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/assets/up/pants/pants.png")
	},
	pants_walk_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/assets/right/pants/pants.png")
	},
	pants_walk_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/assets/left/pants/pants.png")
	},

	pants_swing_down = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/assets/down/pants/pants.png")
	},
	pants_swing_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/assets/up/pants/pants.png")
	},
	pants_swing_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/assets/right/pants/pants.png")
	},
	pants_swing_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/assets/left/pants/pants.png")
	},


	shirts_idle_down = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/assets/down/shirts/shirt.png")
	},
	shirts_idle_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/assets/up/shirts/shirt.png")
	},
	shirts_idle_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/assets/right/shirts/shirt.png")
	},
	shirts_idle_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/assets/left/shirts/shirt.png")
	},

	shirts_walk_down = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/assets/down/shirts/shirt.png")
	},
	shirts_walk_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/assets/up/shirts/shirt.png")
	},
	shirts_walk_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/assets/right/shirts/shirt.png")
	},
	shirts_walk_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/assets/left/shirts/shirt.png")
	},

	shirts_swing_down = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/assets/down/shirts/shirt.png")
	},
	shirts_swing_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/assets/up/shirts/shirt.png")
	},
	shirts_swing_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/assets/right/shirts/shirt.png")
	},
	shirts_swing_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/assets/left/shirts/shirt.png")
	},

	shoes_idle_down = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/assets/down/shoes/shoes.png")
	},
	shoes_idle_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/assets/up/shoes/shoes.png")
	},
	shoes_idle_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/assets/left/shoes/shoes.png")
	},
	shoes_idle_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/idle/assets/right/shoes/shoes.png")
	},

	shoes_walk_down = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/assets/down/shoes/shoes.png")
	},
	shoes_walk_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/assets/up/shoes/shoes.png")
	},
	shoes_walk_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/assets/right/shoes/shoes.png")
	},
	shoes_walk_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/walk/assets/left/shoes/shoes.png")
	},

	shoes_swing_down = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/assets/down/shoes/shoes.png")
	},
	shoes_swing_up = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/assets/up/shoes/shoes.png")
	},
	shoes_swing_right = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/assets/right/shoes/shoes.png")
	},
	shoes_swing_left = {
		0 : null,
		1 : preload("res://Characters/Dragonoid/water dragonoid/female/swing/assets/left/shoes/shoes.png")
	}	
}

var ogre_male = {
	body_idle_down = {
		0 : preload("res://Characters/Ogres/Kaijin/male/idle/body/down/body.png")
	},
	body_idle_up = {
		0 : preload("res://Characters/Ogres/Kaijin/male/idle/body/up/body.png")
	},
	body_idle_left = {
		0 : preload("res://Characters/Ogres/Kaijin/male/idle/body/left/body.png")
	},
	body_idle_right = {
		0 : preload("res://Characters/Ogres/Kaijin/male/idle/body/right/body.png")
	},

	body_walk_down = {
		0 : preload("res://Characters/Ogres/Kaijin/male/walk/body/down/body.png")
	},
	body_walk_up = {
		0 : preload("res://Characters/Ogres/Kaijin/male/walk/body/up/body.png")
	},
	body_walk_right = {
		0 : preload("res://Characters/Ogres/Kaijin/male/walk/body/right/body.png")
	},
	body_walk_left = {
		0 : preload("res://Characters/Ogres/Kaijin/male/walk/body/left/body.png")
	},

	body_swing_down = {
		0 : preload("res://Characters/Ogres/Kaijin/male/swing/body/down/body.png")
	},
	body_swing_up = {
		0 : preload("res://Characters/Ogres/Kaijin/male/swing/body/up/body.png")
	},
	body_swing_right = {
		0 : preload("res://Characters/Ogres/Kaijin/male/swing/body/right/body.png")
	},
	body_swing_left = {
		0 : preload("res://Characters/Ogres/Kaijin/male/swing/body/left/body.png")
	},


	arms_idle_down = {
		0 : preload("res://Characters/Ogres/Kaijin/male/idle/body/down/arms.png")
	},
	arms_idle_up = {
		0 : preload("res://Characters/Ogres/Kaijin/male/idle/body/up/arms.png")
	},
	arms_idle_left = {
		0 : preload("res://Characters/Ogres/Kaijin/male/idle/body/left/arms.png")
	},
	arms_idle_right = {
		0 : preload("res://Characters/Ogres/Kaijin/male/idle/body/right/arms.png")
	},

	arms_walk_down = {
		0 : preload("res://Characters/Ogres/Kaijin/male/walk/body/down/arms.png")
	},
	arms_walk_up = {
		0 : preload("res://Characters/Ogres/Kaijin/male/walk/body/up/arms.png")
	},
	arms_walk_right = {
		0 : preload("res://Characters/Ogres/Kaijin/male/walk/body/right/arms.png")
	},
	arms_walk_left = {
		0 : preload("res://Characters/Ogres/Kaijin/male/walk/body/left/arms.png")
	},

	arms_swing_down = {
		0 : preload("res://Characters/Ogres/Kaijin/male/swing/body/down/arms.png")
	},
	arms_swing_up = {
		0 : preload("res://Characters/Ogres/Kaijin/male/swing/body/up/arms.png")
	},
	arms_swing_right = {
		0 : preload("res://Characters/Ogres/Kaijin/male/swing/body/right/arms.png")
	},
	arms_swing_left = {
		0 : preload("res://Characters/Ogres/Kaijin/male/swing/body/left/arms.png")
	},



	acc_idle_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/idle/assets/down/accesory/pads.png")
	},
	acc_idle_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/idle/assets/up/accesory/pads.png")
	},
	acc_idle_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/idle/assets/left/accesory/pads.png")
	},
	acc_idle_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/idle/assets/right/accesory/pads.png")
	},

	acc_walk_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/walk/assets/down/accesory/pads.png")
	},
	acc_walk_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/walk/assets/up/accesory/pads.png")
	},
	acc_walk_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/walk/assets/right/accesory/pads.png")
	},
	acc_walk_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/walk/assets/left/accesory/pads.png")
	},

	acc_swing_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/swing/assets/down/accesory/pads.png")
	},
	acc_swing_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/swing/assets/up/accesory/pads.png")
	},
	acc_swing_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/swing/assets/right/accesory/pads.png")
	},
	acc_swing_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/swing/assets/left/accesory/pads.png")
	},


	head_attribute_idle_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/idle/assets/down/accesory/pads.png")
	},
	head_attribute_idle_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/idle/assets/up/accesory/pads.png")
	},
	head_attribute_idle_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/idle/assets/left/accesory/pads.png")
	},
	head_attribute_idle_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/idle/assets/right/accesory/pads.png")
	},

	head_attribute_walk_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/walk/assets/down/accesory/pads.png")
	},
	head_attribute_walk_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/walk/assets/up/accesory/pads.png")
	},
	head_attribute_walk_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/walk/assets/right/accesory/pads.png")
	},
	head_attribute_walk_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/walk/assets/left/accesory/pads.png")
	},

	head_attribute_swing_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/swing/assets/down/accesory/pads.png")
	},
	head_attribute_swing_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/swing/assets/up/accesory/pads.png")
	},
	head_attribute_swing_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/swing/assets/right/accesory/pads.png")
	},
	head_attribute_swing_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/swing/assets/left/accesory/pads.png")
	},


	pants_idle_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/idle/assets/down/pants/pants.png")
	},

	pants_idle_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/idle/assets/up/pants/pants.png")
	},
	pants_idle_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/idle/assets/right/pants/pants.png")
	},
	pants_idle_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/idle/assets/left/pants/pants.png")
	},

	pants_walk_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/walk/assets/down/pants/pants.png")
	},
	pants_walk_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/walk/assets/up/pants/pants.png")
	},
	pants_walk_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/walk/assets/right/pants/pants.png")
	},
	pants_walk_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/walk/assets/left/pants/pants.png")
	},

	pants_swing_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/swing/assets/down/pants/pants.png")
	},
	pants_swing_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/swing/assets/up/pants/pants.png")
	},
	pants_swing_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/swing/assets/right/pants/pants.png")
	},
	pants_swing_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/swing/assets/left/pants/pants.png")
	},


	shirts_idle_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/idle/assets/down/shirts/vest.png")
	},
	shirts_idle_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/idle/assets/up/shirts/vest.png")
	},
	shirts_idle_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/idle/assets/right/shirts/vest.png")
	},
	shirts_idle_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/idle/assets/left/shirts/vest.png")
	},

	shirts_walk_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/walk/assets/down/shirts/vest.png")
	},
	shirts_walk_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/walk/assets/up/shirts/vest.png")
	},
	shirts_walk_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/walk/assets/right/shirts/vest.png")
	},
	shirts_walk_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/walk/assets/left/shirts/vest.png")
	},

	shirts_swing_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/swing/assets/down/shirts/vest.png")
	},
	shirts_swing_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/swing/assets/up/shirts/vest.png")
	},
	shirts_swing_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/swing/assets/right/shirts/vest.png")
	},
	shirts_swing_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/swing/assets/left/shirts/vest.png")
	},

	shoes_idle_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/idle/assets/down/shoes/shoes.png")
	},
	shoes_idle_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/idle/assets/up/shoes/shoes.png")
	},
	shoes_idle_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/idle/assets/left/shoes/shoes.png")
	},
	shoes_idle_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/idle/assets/right/shoes/shoes.png")
	},

	shoes_walk_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/walk/assets/down/shoes/shoes.png")
	},
	shoes_walk_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/walk/assets/up/shoes/shoes.png")
	},
	shoes_walk_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/walk/assets/right/shoes/shoes.png")
	},
	shoes_walk_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/walk/assets/left/shoes/shoes.png")
	},

	shoes_swing_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/swing/assets/down/shoes/shoes.png")
	},
	shoes_swing_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/swing/assets/up/shoes/shoes.png")
	},
	shoes_swing_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/swing/assets/right/shoes/shoes.png")
	},
	shoes_swing_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/male/swing/assets/left/shoes/shoes.png")
	}	
}
var ogre_female = {
	body_idle_down = {
		0 : preload("res://Characters/Ogres/Kaijin/female/idle/body/down/body.png")
	},
	body_idle_up = {
		0 : preload("res://Characters/Ogres/Kaijin/female/idle/body/up/body.png")
	},
	body_idle_left = {
		0 : preload("res://Characters/Ogres/Kaijin/female/idle/body/left/body.png")
	},
	body_idle_right = {
		0 : preload("res://Characters/Ogres/Kaijin/female/idle/body/right/body.png")
	},

	body_walk_down = {
		0 : preload("res://Characters/Ogres/Kaijin/female/walk/body/down/body.png")
	},
	body_walk_up = {
		0 : preload("res://Characters/Ogres/Kaijin/female/walk/body/up/body.png")
	},
	body_walk_right = {
		0 : preload("res://Characters/Ogres/Kaijin/female/walk/body/right/body.png")
	},
	body_walk_left = {
		0 : preload("res://Characters/Ogres/Kaijin/female/walk/body/left/body.png")
	},

	body_swing_down = {
		0 : preload("res://Characters/Ogres/Kaijin/female/swing/body/down/body.png")
	},
	body_swing_up = {
		0 : preload("res://Characters/Ogres/Kaijin/female/swing/body/up/body.png")
	},
	body_swing_right = {
		0 : preload("res://Characters/Ogres/Kaijin/female/swing/body/right/body.png")
	},
	body_swing_left = {
		0 : preload("res://Characters/Ogres/Kaijin/female/swing/body/left/body.png")
	},


	arms_idle_down = {
		0 : preload("res://Characters/Ogres/Kaijin/female/idle/body/down/arms.png")
	},
	arms_idle_up = {
		0 : preload("res://Characters/Ogres/Kaijin/female/idle/body/up/arms.png")
	},
	arms_idle_left = {
		0 : preload("res://Characters/Ogres/Kaijin/female/idle/body/left/arms.png")
	},
	arms_idle_right = {
		0 : preload("res://Characters/Ogres/Kaijin/female/idle/body/right/arms.png")
	},

	arms_walk_down = {
		0 : preload("res://Characters/Ogres/Kaijin/female/walk/body/down/arms.png")
	},
	arms_walk_up = {
		0 : preload("res://Characters/Ogres/Kaijin/female/walk/body/up/arms.png")
	},
	arms_walk_right = {
		0 : preload("res://Characters/Ogres/Kaijin/female/walk/body/right/arms.png")
	},
	arms_walk_left = {
		0 : preload("res://Characters/Ogres/Kaijin/female/walk/body/left/arms.png")
	},

	arms_swing_down = {
		0 : preload("res://Characters/Ogres/Kaijin/female/swing/body/down/arms.png")
	},
	arms_swing_up = {
		0 : preload("res://Characters/Ogres/Kaijin/female/swing/body/up/arms.png")
	},
	arms_swing_right = {
		0 : preload("res://Characters/Ogres/Kaijin/female/swing/body/right/arms.png")
	},
	arms_swing_left = {
		0 : preload("res://Characters/Ogres/Kaijin/female/swing/body/left/arms.png")
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
		1 : preload("res://Characters/Ogres/Kaijin/female/idle/assets/down/head_attribute/hair.png")
	},
	head_attribute_idle_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/idle/assets/up/head_attribute/hair.png")
	},
	head_attribute_idle_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/idle/assets/left/head_attribute/hair.png")
	},
	head_attribute_idle_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/idle/assets/right/head_attribute/hair.png")
	},

	head_attribute_walk_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/walk/assets/down/head_attribute/hair.png")
	},
	head_attribute_walk_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/walk/assets/up/head_attribute/hair.png")
	},
	head_attribute_walk_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/walk/assets/right/head_attribute/hair.png")
	},
	head_attribute_walk_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/walk/assets/left/head_attribute/hair.png")
	},

	head_attribute_swing_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/swing/assets/down/head_attribute/hair.png")
	},
	head_attribute_swing_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/swing/assets/up/head_attribute/hair.png")
	},
	head_attribute_swing_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/swing/assets/right/head_attribute/hair.png")
	},
	head_attribute_swing_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/swing/assets/left/head_attribute/hair.png")
	},



	pants_idle_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/idle/assets/down/pants/pants.png")
	},

	pants_idle_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/idle/assets/up/pants/pants.png")
	},
	pants_idle_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/idle/assets/right/pants/pants.png")
	},
	pants_idle_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/idle/assets/left/pants/pants.png")
	},

	pants_walk_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/walk/assets/down/pants/pants.png")
	},
	pants_walk_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/walk/assets/up/pants/pants.png")
	},
	pants_walk_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/walk/assets/right/pants/pants.png")
	},
	pants_walk_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/walk/assets/left/pants/pants.png")
	},

	pants_swing_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/swing/assets/down/pants/pants.png")
	},
	pants_swing_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/swing/assets/up/pants/pants.png")
	},
	pants_swing_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/swing/assets/right/pants/pants.png")
	},
	pants_swing_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/swing/assets/left/pants/pants.png")
	},


	shirts_idle_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/idle/assets/down/shirts/shirt.png")
	},
	shirts_idle_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/idle/assets/up/shirts/shirt.png")
	},
	shirts_idle_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/idle/assets/right/shirts/shirt.png")
	},
	shirts_idle_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/idle/assets/left/shirts/shirt.png")
	},

	shirts_walk_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/walk/assets/down/shirts/shirt.png")
	},
	shirts_walk_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/walk/assets/up/shirts/shirt.png")
	},
	shirts_walk_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/walk/assets/right/shirts/shirt.png")
	},
	shirts_walk_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/walk/assets/left/shirts/shirt.png")
	},

	shirts_swing_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/swing/assets/down/shirts/shirt.png")
	},
	shirts_swing_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/swing/assets/up/shirts/shirt.png")
	},
	shirts_swing_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/swing/assets/right/shirts/shirt.png")
	},
	shirts_swing_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/swing/assets/left/shirts/shirt.png")
	},

	shoes_idle_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/idle/assets/down/shoes/shoes.png")
	},
	shoes_idle_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/idle/assets/up/shoes/shoes.png")
	},
	shoes_idle_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/idle/assets/left/shoes/shoes.png")
	},
	shoes_idle_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/idle/assets/right/shoes/shoes.png")
	},

	shoes_walk_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/walk/assets/down/shoes/shoes.png")
	},
	shoes_walk_up = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/walk/assets/up/shoes/shoes.png")
	},
	shoes_walk_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/walk/assets/right/shoes/shoes.png")
	},
	shoes_walk_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/walk/assets/left/shoes/shoes.png")
	},

	shoes_swing_down = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/swing/assets/down/shoes/shoes.png")
	},
	shoes_swing_up = {
		0 : null,
		1 : null
		#### MISSING ####
	#	1 : preload("res://Characters/Ogres/Kaijin/female/swing/assets/up/shoes/shoes.png")
	},
	shoes_swing_right = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/swing/assets/right/shoes/shoes.png")
	},
	shoes_swing_left = {
		0 : null,
		1 : preload("res://Characters/Ogres/Kaijin/female/swing/assets/left/shoes/shoes.png")
	}	
}

# INDEX CHANGES ATTRIBUTE STYLE
var acc_index
var headAtr_index
var pants_index
var shirts_index
var shoes_index

# CREATE OBJECT OF EACH ATTRIBUTE
var body_sprites = {
	'idle_down' : null,
	'idle_up' : null,
	'idle_left' : null, 
	'idle_right' : null,
	'walk_down' : null,
	'walk_up' : null,
	'walk_left' : null,
	'walk_right' : null,
	'swing_down' : null, 
	'swing_up' : null, 
	'swing_left' : null,
	'swing_right' : null,
	'holding_down': null,
	'holding_up': null,
	'holding_left': null,
	'holding_right': null,
	'death_up': null,
	'death_down': null,
	'death_left': null,
	'death_right': null,
	}

var arms_sprites = {
	'idle_down' : null,
	'idle_up' : null,
	'idle_left' : null,
	'idle_right' : null,
	'walk_down' : null,
	'walk_up' : null,
	'walk_left' : null,
	'walk_right' : null,
	'swing_down' : null,
	'swing_up' : null,
	'swing_left' : null,
	'swing_right' : null,
	'holding_down': null,
	'holding_up': null,
	'holding_left': null,
	'holding_right': null,
	'death_up': null,
	'death_down': null,
	'death_left': null,
	'death_right': null,
	};

var acc_sprites = {
	'idle_down' : null,
	'idle_up' : null,
	'idle_left' : null,
	'idle_right' : null,
	'walk_down' : null,
	'walk_up' : null,
	'walk_left' : null,
	'walk_right' : null,
	'swing_down' : null,
	'swing_up' : null,
	'swing_left' : null,
	'swing_right' : null,
	'holding_down': null,
	'holding_up': null,
	'holding_left': null,
	'holding_right': null,
	'death_up': null,
	'death_down': null,
	'death_left': null,
	'death_right': null,
	};

var headAtr_sprites = {
	'idle_down' : null,
	'idle_up' : null,
	'idle_left' : null,
	'idle_right' : null,
	'walk_down' : null,
	'walk_up' : null,
	'walk_left' : null, 
	'walk_right' : null,
	'swing_down' : null,
	'swing_up' : null, 
	'swing_left' : null, 
	'swing_right' : null,
	'holding_down': null,
	'holding_up': null,
	'holding_left': null,
	'holding_right': null,
	'death_up': null,
	'death_down': null,
	'death_left': null,
	'death_right': null,
	};

var pants_sprites = {
	'idle_down' : null,
	'idle_up' : null, 
	'idle_left' : null, 
	'idle_right' : null, 
	'walk_down' : null, 
	'walk_up' : null, 
	'walk_left' : null, 
	'walk_right' : null,
	'swing_down' : null,
	'swing_up' : null, 
	'swing_left' : null, 
	'swing_right' : null, 
	'holding_down': null,
	'holding_up': null,
	'holding_left': null,
	'holding_right': null,
	'death_up': null,
	'death_down': null,
	'death_left': null,
	'death_right': null,
	};

var shirts_sprites = {
	'idle_down' : null, 
	'idle_up' : null, 
	'idle_left' : null, 
	'idle_right' : null,
	'walk_down' : null, 
	'walk_up' : null, 
	'walk_left' : null,
	'walk_right' : null, 
	'swing_down' : null, 
	'swing_up' : null, 
	'swing_left' : null, 
	'swing_right' : null,
	'holding_down': null,
	'holding_up': null,
	'holding_left': null,
	'holding_right': null,
	'death_up': null,
	'death_down': null,
	'death_left': null,
	'death_right': null,
	};

var shoes_sprites = {
	'idle_down' : null, 
	'idle_up' : null, 
	'idle_left' : null, 
	'idle_right' : null, 
	'walk_down' : null, 
	'walk_up' : null, 
	'walk_left' : null, 
	'walk_right' : null, 
	'swing_down' : null,
	'swing_up' : null,
	'swing_left' : null, 
	'swing_right' : null,
	'holding_down': null,
	'holding_up': null,
	'holding_left': null,
	'holding_right': null, 
	'death_up': null,
	'death_down': null,
	'death_left': null,
	'death_right': null,
	};



var set_char

var character_example = {
	"character" : "human_male",
#	"acc_index" : 0,
#	"headAtr_index" : 1,
#	"pants_index" : 1,
#	"shirts_index" :  1,
#	"shoes_index" : 1,
}

func _ready():
	### Pass server call here
	#LoadPlayerCharacter(character_example)
	pass

func LoadPlayerCharacter(character_info):
	match character_info:
		"human_male":
			set_char = Human.male
		"human_female":
			set_char = human_female
		"goblin_male":
			set_char = goblin_male
		"goblin_female":
			set_char = Goblin.female
		"ogre_male":
			set_char = ogre_male
		"ogre_female":
			set_char = ogre_female
		"lesser_demon_male":
			set_char = lesser_demon_male
		"lesser_demon_female":
			set_char = lesser_demon_female
		"water_draganoid_male":
			set_char = water_draganoid_male
		"water_draganoid_female":
			set_char = water_draganoid_female
		"seraphim_male":
			set_char = seraphim_male
		"seraphim_female":
			set_char = seraphim_female
		"demi_wolf_male":
			set_char = demi_wolf_male
		"demi_wolf_female":
			set_char = demi_wolf_female
		"lesser_spirit":
			set_char = lesser_spirit
		"succubus":
			set_char = succubus
		
	acc_index = set_char.acc_idle_down.size() - 1
	headAtr_index = set_char.head_attribute_idle_down.size() - 1
	pants_index = set_char.pants_idle_down.size() - 1
	shirts_index = set_char.shirts_idle_down.size() - 1
	shoes_index = set_char.shoes_idle_down.size() - 1
	
	
#	acc_index = character_info.acc_index
#	headAtr_index = character_info.headAtr_index
#	pants_index = character_info.pants_index
#	shirts_index =  character_info.shirts_index
#	shoes_index = character_info.shoes_index
	
	set_attributes(set_char)


func set_attributes(set_char):
	var character = set_char
	body_sprites = {
	'idle_down' : character.body_idle_down[0], 
	'idle_up' : character.body_idle_up[0], 
	'idle_left' : character.body_idle_left[0], 
	'idle_right' : character.body_idle_right[0], 
	'walk_down' : character.body_walk_down[0], 
	'walk_up' : character.body_walk_up[0], 
	'walk_left' : character.body_walk_left[0], 
	'walk_right' : character.body_walk_right[0], 
	'swing_down' : character.body_swing_down[0], 
	'swing_up' : character.body_swing_up[0], 
	'swing_left' : character.body_swing_left[0], 
	'swing_right' : character.body_swing_right[0],
	'death_down' : character.body_death_down[0],
	'death_up' : character.body_death_up[0],
	'death_right' : character.body_death_right[0],
	'death_left' : character.body_death_left[0],
	'watering_down' : character.body_watering_down[0],
	'watering_up' : character.body_watering_up[0],
	'watering_right' : character.body_watering_right[0],
	'watering_left' : character.body_watering_left[0],
#	'holding_walk_down' : character.body_holding_walk_down[0], 
#	'holding_walk_up' : character.body_holding_walk_up[0], 
#	'holding_walk_left' : character.body_holding_walk_left[0], 
#	'holding_walk_right' : character.body_holding_walk_right[0],
#	'holding_idle_down' : character.body_holding_idle_down[0], 
#	'holding_idle_up' : character.body_holding_idle_up[0], 
#	'holding_idle_left' : character.body_holding_idle_left[0], 
#	'holding_idle_right' : character.body_holding_idle_right[0]
	};
	arms_sprites = {
	'idle_down' : character.arms_idle_down[0], 
	'idle_up' : character.arms_idle_up[0], 
	'idle_left' : character.arms_idle_left[0], 
	'idle_right' : character.arms_idle_right[0], 
	'walk_down' : character.arms_walk_down[0], 
	'walk_up' : character.arms_walk_up[0], 
	'walk_left' : character.arms_walk_left[0], 
	'walk_right' : character.arms_walk_right[0], 
	'swing_down' : character.arms_swing_down[0], 
	'swing_up' : character.arms_swing_up[0], 
	'swing_left' : character.arms_swing_left[0], 
	'swing_right' : character.arms_swing_right[0],
	'death_down' : character.arms_death_down[0],
	'death_up' : character.arms_death_up[0],
	'death_right' : character.arms_death_right[0],
	'death_left' : character.arms_death_left[0],
	'watering_down' : character.arms_watering_down[0],
	'watering_up' : character.arms_watering_up[0],
	'watering_right' : character.arms_watering_right[0],
	'watering_left' : character.arms_watering_left[0],
#	'holding_walk_down' : character.arms_holding_walk_down[0], 
#	'holding_walk_up' : character.arms_holding_walk_up[0], 
#	'holding_walk_left' : character.arms_holding_walk_left[0], 
#	'holding_walk_right' : character.arms_holding_walk_right[0],
#	'holding_idle_down' : character.arms_holding_idle_down[0], 
#	'holding_idle_up' : character.arms_holding_idle_up[0], 
#	'holding_idle_left' : character.arms_holding_idle_left[0], 
#	'holding_idle_right' : character.arms_holding_idle_right[0]
	};
	acc_sprites = {
	'idle_down' : character.acc_idle_down[acc_index], 
	'idle_up' : character.acc_idle_up[acc_index], 
	'idle_left' : character.acc_idle_left[acc_index], 
	'idle_right' : character.acc_idle_right[acc_index], 
	'walk_down' : character.acc_walk_down[acc_index], 
	'walk_up' : character.acc_walk_up[acc_index], 
	'walk_left' : character.acc_walk_left[acc_index], 
	'walk_right' : character.acc_walk_right[acc_index], 
	'swing_down' : character.acc_swing_down[acc_index], 
	'swing_up' : character.acc_swing_up[acc_index], 
	'swing_left' : character.acc_swing_left[acc_index], 
	'swing_right' : character.acc_swing_right[acc_index],
	'death_down' : character.acc_death_down[acc_index],
	'death_up' : character.acc_death_up[acc_index],
	'death_right' : character.acc_death_right[acc_index],
	'death_left' : character.acc_death_left[acc_index],
	'watering_down' : character.acc_watering_down[acc_index],
	'watering_up' : character.acc_watering_up[acc_index],
	'watering_right' : character.acc_watering_right[acc_index],
	'watering_left' : character.acc_watering_left[acc_index],
#	'holding_walk_down' : character.acc_holding_walk_down[acc_index], 
#	'holding_walk_up' : character.acc_holding_walk_up[acc_index], 
#	'holding_walk_left' : character.acc_holding_walk_left[acc_index], 
#	'holding_walk_right' : character.acc_holding_walk_right[acc_index],
#	'holding_idle_down' : null, #character.acc_holding_idle_down[acc_index], 
#	'holding_idle_up' : character.acc_holding_idle_up[acc_index], 
#	'holding_idle_left' : character.acc_holding_idle_left[acc_index], 
#	'holding_idle_right' : character.acc_holding_idle_right[acc_index]
	};
	headAtr_sprites = {
	'idle_down' : character.head_attribute_idle_down[headAtr_index], 
	'idle_up' : character.head_attribute_idle_up[headAtr_index], 
	'idle_left' : character.head_attribute_idle_left[headAtr_index], 
	'idle_right' : character.head_attribute_idle_right[headAtr_index], 
	'walk_down' : character.head_attribute_walk_down[headAtr_index], 
	'walk_up' : character.head_attribute_walk_up[headAtr_index], 
	'walk_left' : character.head_attribute_walk_left[headAtr_index], 
	'walk_right' : character.head_attribute_walk_right[headAtr_index] , 
	'swing_down' : character.head_attribute_swing_down[headAtr_index], 
	'swing_up' : character.head_attribute_swing_up[headAtr_index], 
	'swing_left' : character.head_attribute_swing_left[headAtr_index], 
	'swing_right' : character.head_attribute_swing_right[headAtr_index],
	'death_down' : character.head_attribute_death_down[headAtr_index],
	'death_up' : character.head_attribute_death_up[headAtr_index],
	'death_right' : character.head_attribute_death_right[headAtr_index],
	'death_left' : character.head_attribute_death_left[headAtr_index],
	'watering_down' : character.head_attribute_watering_down[headAtr_index],
	'watering_up' : character.head_attribute_watering_up[headAtr_index],
	'watering_right' : character.head_attribute_watering_right[headAtr_index],
	'watering_left' : character.head_attribute_watering_left[headAtr_index],
#	'holding_walk_down' : character.head_attribute_holding_walk_down[headAtr_index], 
#	'holding_walk_up' : character.head_attribute_holding_walk_up[headAtr_index], 
#	'holding_walk_left' : character.head_attribute_holding_walk_left[headAtr_index], 
#	'holding_walk_right' : character.head_attribute_holding_walk_right[headAtr_index],
#	'holding_idle_down' : character.head_attribute_holding_idle_down[headAtr_index], 
#	'holding_idle_up' : character.head_attribute_holding_idle_up[headAtr_index], 
#	'holding_idle_left' : character.head_attribute_holding_idle_left[headAtr_index], 
#	'holding_idle_right' : character.head_attribute_holding_idle_right[headAtr_index]
	}
	pants_sprites = {
	'idle_down' : character.pants_idle_down[pants_index], 
	'idle_up' : character.pants_idle_up[pants_index], 
	'idle_left' : character.pants_idle_left[pants_index], 
	'idle_right' : character.pants_idle_right[pants_index],  
	'walk_down' : character.pants_walk_down[pants_index], 
	'walk_up' : character.pants_walk_up[pants_index], 
	'walk_left' : character.pants_walk_left[pants_index], 
	'walk_right' : character.pants_walk_right[pants_index],  
	'swing_down' : character.pants_swing_down[pants_index], 
	'swing_up' : character.pants_swing_up[pants_index], 
	'swing_left' : character.pants_swing_left[pants_index], 
	'swing_right' : character.pants_swing_right[pants_index],
	'death_down' : character.pants_death_down[pants_index],
	'death_up' : character.pants_death_up[pants_index],
	'death_right' : character.pants_death_right[pants_index],
	'death_left' : character.pants_death_left[pants_index],
	'watering_down' : character.pants_watering_down[pants_index],
	'watering_up' : character.pants_watering_up[pants_index],
	'watering_right' : character.pants_watering_right[pants_index],
	'watering_left' : character.pants_watering_left[pants_index],
#	'holding_walk_down' : character.pants_holding_walk_down[pants_index], 
#	'holding_walk_up' : character.pants_holding_walk_up[pants_index], 
#	'holding_walk_left' : character.pants_holding_walk_left[pants_index], 
#	'holding_walk_right' : character.pants_holding_walk_right[pants_index],
#	'holding_idle_down' : character.head_attribute_holding_idle_down[pants_index], 
#	'holding_idle_up' : character.head_attribute_holding_idle_up[pants_index], 
#	'holding_idle_left' : character.head_attribute_holding_idle_left[pants_index], 
#	'holding_idle_right' : character.head_attribute_holding_idle_right[pants_index]
	};
	shirts_sprites = {
	'idle_down' : character.shirts_idle_down[shirts_index], 
	'idle_up' : character.shirts_idle_up[shirts_index], 
	'idle_left' : character.shirts_idle_left[shirts_index], 
	'idle_right' : character.shirts_idle_right[shirts_index], 
	'walk_down' : character.shirts_walk_down[shirts_index], 
	'walk_up' : character.shirts_walk_up[shirts_index], 
	'walk_left' : character.shirts_walk_left[shirts_index], 
	'walk_right' : character.shirts_walk_right[shirts_index], 
	'swing_down' : character.shirts_swing_down[shirts_index], 
	'swing_up' : character.shirts_swing_up[shirts_index], 
	'swing_left' : character.shirts_swing_left[shirts_index], 
	'swing_right' : character.shirts_swing_right[shirts_index],
	'death_down' : character.shirts_death_down[shirts_index],
	'death_up' : character.shirts_death_up[shirts_index],
	'death_right' : character.shirts_death_right[shirts_index],
	'death_left' : character.shirts_death_left[shirts_index],
	'watering_down' : character.shirts_watering_down[shirts_index],
	'watering_up' : character.shirts_watering_up[shirts_index],
	'watering_right' : character.shirts_watering_right[shirts_index],
	'watering_left' : character.shirts_watering_left[shirts_index],
	
#	'holding_walk_down' : character.shirts_holding_walk_down[shirts_index], 
#	'holding_walk_up' : character.shirts_holding_walk_up[shirts_index], 
#	'holding_walk_left' : character.shirts_holding_walk_left[shirts_index], 
#	'holding_walk_right' : character.shirts_holding_walk_right[shirts_index],
#	'holding_idle_down' : character.shirts_holding_idle_down[shirts_index], 
#	'holding_idle_up' : character.shirts_holding_idle_up[shirts_index], 
#	'holding_idle_left' : character.shirts_holding_idle_left[shirts_index], 
#	'holding_idle_right' : character.shirts_holding_idle_right[shirts_index]
	};
	shoes_sprites = {
	'idle_down' : character.shoes_idle_down[shoes_index], 
	'idle_up' : character.shoes_idle_up[shoes_index], 
	'idle_left' : character.shoes_idle_left[shoes_index], 
	'idle_right' : character.shoes_idle_right[shoes_index], 
	'walk_down' : character.shoes_walk_down[shoes_index], 
	'walk_up' : character.shoes_walk_up[shoes_index], 
	'walk_left' : character.shoes_walk_left[shoes_index], 
	'walk_right' : character.shoes_walk_right[shoes_index], 
	'swing_down' : character.shoes_swing_down[shoes_index], 
	'swing_up' : character.shoes_swing_up[shoes_index],
	'swing_left' : character.shoes_swing_left[shoes_index], 
	'swing_right' : character.shoes_swing_right[shoes_index],
	'death_down' : character.shoes_death_down[shoes_index],
	'death_up' : character.shoes_death_up[shoes_index],
	'death_right' : character.shoes_death_right[shoes_index],
	'death_left' : character.shoes_death_left[shoes_index],
	'watering_down' : character.shoes_watering_down[shoes_index],
	'watering_up' : character.shoes_watering_up[shoes_index],
	'watering_right' : character.shoes_watering_right[shoes_index],
	'watering_left' : character.shoes_watering_left[shoes_index],
	
#	'holding_walk_down' : character.shoes_holding_walk_down[shoes_index], 
#	'holding_walk_up' : character.shoes_holding_walk_up[shoes_index], 
#	'holding_walk_left' : character.shoes_holding_walk_left[shoes_index], 
#	'holding_walk_right' : character.shoes_holding_walk_right[shoes_index],
#	'holding_idle_down' : character.shoes_holding_idle_down[shoes_index], 
#	'holding_idle_up' : character.shoes_holding_idle_up[shoes_index], 
#	'holding_idle_left' : character.shoes_holding_idle_left[shoes_index], 
#	'holding_idle_right' : character.shoes_holding_idle_right[shoes_index]
	};
	
