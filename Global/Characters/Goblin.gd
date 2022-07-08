extends Node

var female = {
	body_idle_down = {
		0 : preload("res://Characters/Goblin/female/idle/body/down/body.png")
	},
	body_idle_up = {
		0 : preload("res://Characters/Goblin/female/idle/body/up/body.png")
	},
	body_idle_left = {
		0 : preload("res://Characters/Goblin/female/idle/body/left/body.png")
	},
	body_idle_right = {
		0 : preload("res://Characters/Goblin/female/idle/body/right/body.png")
	},

	body_walk_down = {
		0 : preload("res://Characters/Goblin/female/walk/body/down/body.png")
	},
	body_walk_up = {
		0 : preload("res://Characters/Goblin/female/walk/body/up/body.png")
	},
	body_walk_right = {
		0 : preload("res://Characters/Goblin/female/walk/body/right/body.png")
	},
	body_walk_left = {
		0 : preload("res://Characters/Goblin/female/walk/body/left/body.png")
	},

	body_swing_down = {
		0 : preload("res://Characters/Goblin/female/swing/body/down/body.png")
	},
	body_swing_up = {
		0 : preload("res://Characters/Goblin/female/swing/body/up/body.png")
	},
	body_swing_right = {
		0 : preload("res://Characters/Goblin/female/swing/body/right/body.png")
	},
	body_swing_left = {
		0 : preload("res://Characters/Goblin/female/swing/body/left/body.png")
	},
	
	body_holding_walk_down = {
		0 : preload("res://Characters/Goblin/female/holding/walk/down/body.png"),
	},
	body_holding_walk_up = {
		0 : preload("res://Characters/Goblin/female/holding/walk/up/body.png"),
	},
	body_holding_walk_right = {
		0 : preload("res://Characters/Goblin/female/holding/walk/right/body copy.png"),
	},
	body_holding_walk_left = {
		0 : preload("res://Characters/Goblin/female/holding/walk/left/body.png"),
	},
	
	body_holding_idle_down = {
		0 : preload("res://Characters/Goblin/female/holding/idle/body/down/body.png"),
	},
	body_holding_idle_up = {
		0 : preload("res://Characters/Goblin/female/holding/idle/body/up/body.png"),
	},
	body_holding_idle_right = {
		0 : preload("res://Characters/Goblin/female/holding/idle/body/right/body.png"),
	},
	body_holding_idle_left = {
		0 : preload("res://Characters/Goblin/female/holding/idle/body/left/body.png"),
	},


	arms_idle_down = {
		0 : preload("res://Characters/Goblin/female/idle/body/down/arms.png")
	},
	arms_idle_up = {
		0 : preload("res://Characters/Goblin/female/idle/body/up/arms.png")
	},
	arms_idle_left = {
		0 : preload("res://Characters/Goblin/female/idle/body/left/arms.png")
	},
	arms_idle_right = {
		0 : preload("res://Characters/Goblin/female/idle/body/right/arms.png")
	},

	arms_walk_up = {
		0 : preload("res://Characters/Goblin/female/walk/body/up/arms.png")
	},
	arms_walk_down = {
		0 : preload("res://Characters/Goblin/female/walk/body/down/arms.png")
	},
	arms_walk_right = {
		0 : preload("res://Characters/Goblin/female/walk/body/right/arms.png")
	},
	arms_walk_left = {
		0 : preload("res://Characters/Goblin/female/walk/body/left/arms.png")
	},

	arms_swing_down = {
		0 : preload("res://Characters/Goblin/female/swing/body/down/arms.png")
	},
	arms_swing_up = {
		0 : preload("res://Characters/Goblin/female/swing/body/up/arms.png")
	},
	arms_swing_right = {
		0 : preload("res://Characters/Goblin/female/swing/body/right/arms.png")
	},
	arms_swing_left = {
		0 : preload("res://Characters/Goblin/female/swing/body/left/arms.png")
	},
	
	arms_holding_walk_down = {
		0 : preload("res://Characters/Goblin/female/holding/walk/down/arms.png"),
	},
	arms_holding_walk_up = {
		0 : preload("res://Characters/Goblin/female/holding/walk/up/arms.png"),
	},
	arms_holding_walk_right = {
		0 : preload("res://Characters/Goblin/female/holding/walk/right/arms copy.png"),
	},
	arms_holding_walk_left = {
		0 : preload("res://Characters/Goblin/female/holding/walk/left/arms.png"),
	},
	
	arms_holding_idle_down = {
		0 : preload("res://Characters/Goblin/female/holding/idle/body/down/arms.png"),
	},
	arms_holding_idle_up = {
		0 : preload("res://Characters/Goblin/female/holding/idle/body/up/arms.png"),
	},
	arms_holding_idle_right = {
		0 : preload("res://Characters/Goblin/female/holding/idle/body/right/arms.png"),
	},
	arms_holding_idle_left = {
		0 : preload("res://Characters/Goblin/female/holding/idle/body/left/arms.png"),
	},



	acc_idle_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/idle/assets/down/accessory/armlet.png")
	},
	acc_idle_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/idle/assets/up/accessory/armlet.png")
	},
	acc_idle_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/idle/assets/left/accessory/armlet.png")
	},
	acc_idle_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/idle/assets/right/accessory/armlet.png")
	},

	acc_walk_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/walk/assets/down/accessory/armlet.png")
	},
	acc_walk_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/walk/assets/up/accessory/armlet.png")
	},
	acc_walk_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/walk/assets/right/accessory/armlet.png")
	},
	acc_walk_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/walk/assets/left/accessory/armlet.png")
	},

	acc_swing_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/swing/assets/down/accessory/armlet.png")
	},
	acc_swing_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/swing/assets/up/accessory/armlet.png")
	},
	acc_swing_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/swing/assets/right/accessory/armlet.png")
	},
	acc_swing_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/swing/assets/left/accessory/armlet.png")
	},
	
	acc_holding_walk_down = {
		0 : null,
		1 : null
	},
	acc_holding_walk_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/walk/up/armlet.png"),
	},
	acc_holding_walk_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/walk/left/armlet.png"),
	},
	acc_holding_walk_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/walk/left/armlet.png"),
	},

	acc_holding_idle_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/idle/assets/down/accessory/armlet.png"),
	},
	acc_holding_idle_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/idle/assets/up/accessory/armlet.png"),
	},
	acc_holding_idle_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/idle/assets/right/accessory/armlet.png"),
	},
	acc_holding_idle_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/idle/assets/left/accessory/armlet.png"),
	},


	head_attribute_idle_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/idle/assets/down/head_attribute/green_hair.png"),
	},
	head_attribute_idle_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/idle/assets/up/head_attribute/green_hair.png"),
	},
	head_attribute_idle_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/idle/assets/left/head_attribute/green_hair.png"),
	},
	head_attribute_idle_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/idle/assets/right/head_attribute/green_hair.png"),
	},

	head_attribute_walk_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/walk/assets/down/head_attribute/green_hair.png"),
	},
	head_attribute_walk_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/walk/assets/up/head_attribute/green_hair.png"),
	},
	head_attribute_walk_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/walk/assets/right/head_attribute/green_hair.png"),
	},
	head_attribute_walk_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/walk/assets/left/head_attribute/green_hair.png"),
	},

	head_attribute_swing_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/swing/assets/down/head_attribute/green_hair.png"),
	},
	head_attribute_swing_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/swing/assets/up/head_attribute/green_hair.png"),
	},
	head_attribute_swing_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/swing/assets/right/head_attribute/green_hair.png"),
	},
	head_attribute_swing_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/swing/assets/left/head_attribute/green_hair.png"),
	},
	
	head_attribute_holding_walk_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/walk/down/hair.png"),
	},
	head_attribute_holding_walk_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/walk/up/hair.png"),
	},
	head_attribute_holding_walk_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/walk/left/hair.png"),
	},
	head_attribute_holding_walk_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/walk/left/hair.png"),
	},
	
	head_attribute_holding_idle_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/idle/assets/down/head_attribute/green_hair.png"),
	},
	head_attribute_holding_idle_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/idle/assets/up/head_attribute/green_hair.png"),
	},
	head_attribute_holding_idle_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/idle/assets/right/head_attribute/green_hair.png"),
	},
	head_attribute_holding_idle_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/idle/assets/left/head_attribute/green_hair.png"),
	},


	pants_idle_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/idle/assets/down/pants/dark_skirt.png")
	},
	pants_idle_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/idle/assets/up/pants/dark_skirt.png")
	},
	pants_idle_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/idle/assets/right/pants/dark_skirt.png")
	},
	pants_idle_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/idle/assets/left/pants/dark_skirt.png")
	},

	pants_walk_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/walk/assets/down/pants/dark_skirt.png")
	},
	pants_walk_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/walk/assets/up/pants/dark_skirt.png")
	},
	pants_walk_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/walk/assets/right/pants/dark_skirt.png")
	},
	pants_walk_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/walk/assets/left/pants/dark_skirt.png")
	},

	pants_swing_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/swing/assets/down/pants/dark_skirt.png")
	},
	pants_swing_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/swing/assets/up/pants/dark_skirt.png")
	},
	pants_swing_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/swing/assets/right/pants/dark_skirt.png")
	},
	pants_swing_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/swing/assets/left/pants/dark_skirt.png")
	},
	
	pants_holding_walk_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/walk/down/pants.png"),
	},
	pants_holding_walk_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/walk/up/pants.png"),
	},
	pants_holding_walk_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/walk/left/pants.png"),
	},
	pants_holding_walk_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/walk/left/pants.png"),
	},
	
	pants_holding_idle_down = {
		0 : null, 
		1 : preload("res://Characters/Goblin/female/holding/idle/assets/down/pants/dark_skirt.png"),
	},
	pants_holding_idle_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/idle/assets/up/pants/dark_skirt.png"),
	},
	pants_holding_idle_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/idle/assets/right/pants/dark_skirt.png"),
	},
	pants_holding_idle_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/idle/assets/left/pants/dark_skirt.png"),
	},
	

	shirts_idle_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/idle/assets/down/shirts/yellow_shirt.png")
	},
	shirts_idle_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/idle/assets/up/shirts/yellow_shirt.png")
	},
	shirts_idle_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/idle/assets/right/shirts/yellow_shirt.png")
	},
	shirts_idle_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/idle/assets/left/shirts/yellow_shirt.png")
	},

	shirts_walk_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/walk/assets/down/shirts/yellow_shirt.png")
	},
	shirts_walk_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/walk/assets/up/shirts/yellow_shirt.png")
	},
	shirts_walk_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/walk/assets/right/shirts/yellow_shirt.png")
	},
	shirts_walk_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/walk/assets/left/shirts/yellow_shirt.png")
	},

	shirts_swing_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/swing/assets/down/shirts/yellow_shirt.png")
	},
	shirts_swing_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/swing/assets/up/shirts/yellow_shirt.png")
	},
	shirts_swing_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/swing/assets/right/shirts/yellow_shirt.png")
	},
	shirts_swing_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/swing/assets/left/shirts/yellow_shirt.png")
	},
	shirts_holding_walk_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/walk/down/shirt.png"),
	},
	shirts_holding_walk_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/walk/up/shirt.png"),
	},
	shirts_holding_walk_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/walk/left/shirt.png"),
	},
	shirts_holding_walk_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/walk/left/shirt.png"),
	},

	shirts_holding_idle_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/idle/assets/down/shirts/yellow_shirt.png"),
	},
	shirts_holding_idle_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/idle/assets/up/shirts/yellow_shirt.png"),
	},
	shirts_holding_idle_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/idle/assets/right/shirts/yellow_shirt.png"),
	},
	shirts_holding_idle_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/idle/assets/left/shirts/yellow_shirt.png"),
	},
	

	shoes_idle_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/idle/assets/down/shoes/brown_shoes.png")
	},
	shoes_idle_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/idle/assets/up/shoes/brown_shoes.png")
	},
	shoes_idle_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/idle/assets/left/shoes/brown_shoes.png")
	},
	shoes_idle_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/idle/assets/right/shoes/brown_shoes.png")
	},

	shoes_walk_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/walk/assets/down/shoes/brown_shoes.png")
	},
	shoes_walk_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/walk/assets/up/shoes/brown_shoes.png")
	},
	shoes_walk_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/walk/assets/right/shoes/brown_shoes.png")
	},
	shoes_walk_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/walk/assets/left/shoes/brown_shoes.png")
	},

	shoes_swing_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/swing/assets/down/shoes/brown_shoes.png")
	},
	shoes_swing_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/swing/assets/up/shoes/brown_shoes.png")
	},
	shoes_swing_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/swing/assets/right/shoes/brown_shoes.png")
	},
	shoes_swing_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/swing/assets/left/shoes/brown_shoes.png")
	},
	shoes_holding_walk_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/walk/down/shoes.png"),
	},
	shoes_holding_walk_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/walk/up/shoes.png"),
	},
	shoes_holding_walk_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/walk/left/shoes.png"),
	},
	shoes_holding_walk_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/walk/left/shoes.png"),
	},

	shoes_holding_idle_down = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/idle/assets/down/shoes/brown_shoes.png"),
	},
	shoes_holding_idle_up = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/idle/assets/up/shoes/brown_shoes.png"),
	},
	shoes_holding_idle_right = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/idle/assets/right/shoes/brown_shoes.png"),
	},
	shoes_holding_idle_left = {
		0 : null,
		1 : preload("res://Characters/Goblin/female/holding/idle/assets/left/shoes/brown_shoes.png"),
	},
}
