extends Node

var body_idle_down = {
	0 : preload("res://Characters/Goblin/male/idle/body/down/body.png")
}
var body_idle_up = {
	0 : preload("res://Characters/Goblin/male/idle/body/up/body.png")
}
var body_idle_left = {
	0 : preload("res://Characters/Goblin/male/idle/body/left/body.png")
}
var body_idle_right = {
	0 : preload("res://Characters/Goblin/male/idle/body/right/body.png")
}

var body_walk_down = {
	0 : preload("res://Characters/Goblin/male/walk/body/down/body.png")
}
var body_walk_up = {
	0 : preload("res://Characters/Goblin/male/walk/body/up/body.png")
}
var body_walk_right = {
	0 : preload("res://Characters/Goblin/male/walk/body/right/body.png")
}
var body_walk_left = {
	0 : preload("res://Characters/Goblin/male/walk/body/left/body.png")
}

var body_swing_down = {
	0 : preload("res://Characters/Goblin/male/swing/body/down/body.png")
}
var body_swing_up = {
	0 : preload("res://Characters/Goblin/male/swing/body/up/body.png")
}
var body_swing_right = {
	0 : preload("res://Characters/Goblin/male/swing/body/right/body.png")
}
var body_swing_left = {
	0 : preload("res://Characters/Goblin/male/swing/body/left/body.png")
}


var arms_idle_down = {
	0 : preload("res://Characters/Goblin/male/idle/body/down/arms.png")
}
var arms_idle_up = {
	0 : preload("res://Characters/Goblin/male/idle/body/up/arms.png")
}
var arms_idle_left = {
	0 : preload("res://Characters/Goblin/male/idle/body/left/arms.png")
}
var arms_idle_right = {
	0 : preload("res://Characters/Goblin/male/idle/body/right/arms.png")
}

var arms_walk_up = {
	0 : preload("res://Characters/Goblin/male/walk/body/up/arms.png")
}
var arms_walk_down = {
	0 : preload("res://Characters/Goblin/male/walk/body/down/arms.png")
}
var arms_walk_right = {
	0 : preload("res://Characters/Goblin/male/walk/body/right/arms.png")
}
var arms_walk_left = {
	0 : preload("res://Characters/Goblin/male/walk/body/left/arms.png")
}

var arms_swing_down = {
	0 : preload("res://Characters/Goblin/male/swing/body/down/arms.png")
}
var arms_swing_up = {
	0 : preload("res://Characters/Goblin/male/swing/body/up/arms.png")
}
var arms_swing_right = {
	0 : preload("res://Characters/Goblin/male/swing/body/right/arms.png")
}
var arms_swing_left = {
	0 : preload("res://Characters/Goblin/male/swing/body/left/arms.png")
}



var acc_idle_down = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/idle/assets/down/accessory/armlet_1.png")
}
var acc_idle_up = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/idle/assets/up/accessory/armlet_1.png")
}
var acc_idle_left = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/idle/assets/left/accessory/armlet_1.png")
}
var acc_idle_right = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/idle/assets/right/accessory/armlet_1.png")
}

var acc_walk_down = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/walk/assets/down/accessory/armlet_1.png")
}
var acc_walk_up = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/walk/assets/up/accessory/armlet_1.png")
}
var acc_walk_right = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/walk/assets/right/accessory/armlet_1.png")
}
var acc_walk_left = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/walk/assets/left/accessory/armlet_1.png")
}

var acc_swing_down = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/swing/assets/down/accessory/armlet_1.png")
}
var acc_swing_up = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/swing/assets/up/accessory/armlet_1.png")
}
var acc_swing_right = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/swing/assets/right/accessory/armlet_1.png")
}
var acc_swing_left = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/swing/assets/left/accessory/armlet_1.png")
}


var head_attribute_idle_down = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/idle/assets/down/head_attribute/hair_red_1.png"),
	2 : preload("res://Characters/Goblin/male/idle/assets/down/head_attribute/hood_black_1.png")
}
var head_attribute_idle_up = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/idle/assets/up/head_attribute/hair_red_1.png"),
	2 : preload("res://Characters/Goblin/male/idle/assets/up/head_attribute/hood_black_1.png")
}
var head_attribute_idle_left = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/idle/assets/left/head_attribute/hair_red_1.png"),
	2 : preload("res://Characters/Goblin/male/idle/assets/left/head_attribute/hood_black_1.png")
}
var head_attribute_idle_right = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/idle/assets/right/head_attribute/hair_red_1.png"),
	2 : preload("res://Characters/Goblin/male/idle/assets/right/head_attribute/hood_black_1.png")
}

var head_attribute_walk_down = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/walk/assets/down/head_attribute/hair_red_1.png"),
	2 : preload("res://Characters/Goblin/male/walk/assets/down/head_attribute/hood_black_1.png")
}
var head_attribute_walk_up = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/walk/assets/up/head_attribute/hair_red_1.png"),
	2 : preload("res://Characters/Goblin/male/walk/assets/up/head_attribute/hood_black_1.png")
}
var head_attribute_walk_right = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/walk/assets/right/head_attribute/hair_red_1.png"),
	2 : preload("res://Characters/Goblin/male/walk/assets/right/head_attribute/hood_black_1.png")
}
var head_attribute_walk_left = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/walk/assets/left/head_attribute/hair_red_1.png"),
	2 : preload("res://Characters/Goblin/male/walk/assets/left/head_attribute/hood_black_1.png")
}

var head_attribute_swing_down = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/swing/assets/down/head_attribute/hair_red_1.png"),
	2 : preload("res://Characters/Goblin/male/swing/assets/down/head_attribute/hood_black_1.png")
}
var head_attribute_swing_up = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/swing/assets/up/head_attribute/hair_red_1.png"),
	2 : preload("res://Characters/Goblin/male/swing/assets/up/head_attribute/hood_black_1.png")
}
var head_attribute_swing_right = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/swing/assets/right/head_attribute/hair_red_1.png"),
	2 : preload("res://Characters/Goblin/male/swing/assets/right/head_attribute/hood_black_1.png")
}
var head_attribute_swing_left = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/swing/assets/left/head_attribute/hair_red_1.png"),
	2 : preload("res://Characters/Goblin/male/swing/assets/left/head_attribute/hood_black_1.png")
}


var pants_idle_down = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/idle/assets/down/pants/pants_black_1.png")
}
var pants_idle_up = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/idle/assets/up/pants/pants_black_1.png")
}
var pants_idle_right = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/idle/assets/right/pants/pants_black_1.png")
}
var pants_idle_left = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/idle/assets/left/pants/pants_black_1.png")
}

var pants_walk_down = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/walk/assets/down/pants/pants_black_1.png")
}
var pants_walk_up = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/walk/assets/up/pants/pants_black_1.png")
}
var pants_walk_right = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/walk/assets/right/pants/pants_black_1.png")
}
var pants_walk_left = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/walk/assets/left/pants/pants_black_1.png")
}

var pants_swing_down = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/swing/assets/down/pants/pants_black_1.png")
}
var pants_swing_up = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/swing/assets/up/pants/pants_black_1.png")
}
var pants_swing_right = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/swing/assets/right/pants/pants_black_1.png")
}
var pants_swing_left = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/swing/assets/left/pants/pants_black_1.png")
}


var shirts_idle_down = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/idle/assets/down/shirts/shirt_white_1.png")
}
var shirts_idle_up = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/idle/assets/up/shirts/shirt_white_1.png")
}
var shirts_idle_right = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/idle/assets/right/shirts/shirt_white_1.png")
}
var shirts_idle_left = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/idle/assets/left/shirts/shirt_white_1.png")
}

var shirts_walk_down = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/walk/assets/down/shirts/shirt_white_1.png")
}
var shirts_walk_up = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/walk/assets/up/shirts/shirt_white_1.png")
}
var shirts_walk_right = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/walk/assets/right/shirts/shirt_white_1.png")
}
var shirts_walk_left = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/walk/assets/left/shirts/shirt_white_1.png")
}

var shirts_swing_down = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/swing/assets/down/shirts/shirt_white_1.png")
}
var shirts_swing_up = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/swing/assets/up/shirts/shirt_white_1.png")
}
var shirts_swing_right = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/swing/assets/right/shirts/shirt_white_1.png")
}
var shirts_swing_left = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/swing/assets/left/shirts/shirt_white_1.png")
}



var shoes_idle_down = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/idle/assets/down/shoes/shoes_brown_1.png")
}
var shoes_idle_up = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/idle/assets/up/shoes/shoes_brown_1.png")
}
var shoes_idle_left = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/idle/assets/left/shoes/shoes_brown_1.png")
}
var shoes_idle_right = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/idle/assets/right/shoes/shoes_brown_1.png")
}

var shoes_walk_down = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/walk/assets/down/shoes/shoes_brown_1.png")
}
var shoes_walk_up = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/walk/assets/up/shoes/shoes_brown_1.png")
}
var shoes_walk_right = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/walk/assets/right/shoes/shoes_brown_1.png")
}
var shoes_walk_left = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/walk/assets/left/shoes/shoes_brown_1.png")
}

var shoes_swing_down = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/swing/assets/down/shoes/shoes_brown_1.png")
}
var shoes_swing_up = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/swing/assets/up/shoes/shoes_brown_1.png")
}
var shoes_swing_right = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/swing/assets/right/shoes/shoes_brown_1.png")
}
var shoes_swing_left = {
	0 : null,
	1 : preload("res://Characters/Goblin/male/swing/assets/left/shoes/shoes_brown_1.png")
}

# INDEX CHANGES ATTRIBUTE STYLE
var body_index: int = 0
var arms_index: int = 0
var acc_index: int = 1
var headAtr_index: int = 2
var pants_index: int = 1
var shirts_index: int = 1
var shoes_index: int = 1

# CREATE OBJECT OF EACH ATTRIBUTE
var body_sprites = {
	'idle_down' : body_idle_down[body_index], 
	'idle_up' : body_idle_up[body_index],
	'idle_left' : body_idle_left[body_index], 
	'idle_right' : body_idle_right[body_index], 
	'walk_down' : body_walk_down[body_index], 
	'walk_up' : body_walk_up[body_index], 
	'walk_left' : body_walk_left[body_index], 
	'walk_right' : body_walk_right[body_index],  
	'swing_down' : body_swing_down[body_index], 
	'swing_up' : body_swing_up[body_index], 
	'swing_left' : body_swing_left[body_index], 
	'swing_right' : body_swing_right[body_index]
	}
	
var arms_sprites = {
	'idle_down' : arms_idle_down[arms_index], 
	'idle_up' : arms_idle_up[arms_index], 
	'idle_left' : arms_idle_left[arms_index], 
	'idle_right' : arms_idle_right[arms_index], 
	'walk_down' : arms_walk_down[arms_index], 
	'walk_up' : arms_walk_up[arms_index], 
	'walk_left' : arms_walk_left[arms_index], 
	'walk_right' : arms_walk_right[arms_index], 
	'swing_down' : arms_swing_down[arms_index], 
	'swing_up' : arms_swing_up[arms_index], 
	'swing_left' : arms_swing_left[arms_index], 
	'swing_right' : arms_swing_right[arms_index]
	};
	
var acc_sprites = {
	'idle_down' : acc_idle_down[acc_index], 
	'idle_up' : acc_idle_up[acc_index], 
	'idle_left' : acc_idle_left[acc_index], 
	'idle_right' : acc_idle_right[acc_index], 
	'walk_down' : acc_walk_down[acc_index], 
	'walk_up' : acc_walk_up[acc_index], 
	'walk_left' : acc_walk_left[acc_index], 
	'walk_right' : acc_walk_right[acc_index], 
	'swing_down' : acc_swing_down[acc_index], 
	'swing_up' : acc_swing_up[acc_index], 
	'swing_left' : acc_swing_left[acc_index], 
	'swing_right' : acc_swing_right[acc_index]
	};
	
var headAtr_sprites = {
	'idle_down' : head_attribute_idle_down[headAtr_index], 
	'idle_up' : head_attribute_idle_up[headAtr_index], 
	'idle_left' : head_attribute_idle_left[headAtr_index], 
	'idle_right' : head_attribute_idle_right[headAtr_index], 
	'walk_down' : head_attribute_walk_down[headAtr_index], 
	'walk_up' : head_attribute_walk_up[headAtr_index], 
	'walk_left' : head_attribute_walk_left[headAtr_index], 
	'walk_right' : head_attribute_walk_right[headAtr_index] , 
	'swing_down' : head_attribute_swing_down[headAtr_index], 
	'swing_up' : head_attribute_swing_up[headAtr_index], 
	'swing_left' : head_attribute_swing_left[headAtr_index], 
	'swing_right' : head_attribute_swing_right[headAtr_index]
	};
	
var pants_sprites = {
	'idle_down' : pants_idle_down[pants_index], 
	'idle_up' : pants_idle_up[pants_index], 
	'idle_left' : pants_idle_left[pants_index], 
	'idle_right' : pants_idle_right[pants_index],  
	'walk_down' : pants_walk_down[pants_index], 
	'walk_up' : pants_walk_up[pants_index], 
	'walk_left' : pants_walk_left[pants_index], 
	'walk_right' : pants_walk_right[pants_index],  
	'swing_down' : pants_swing_down[pants_index], 
	'swing_up' : pants_swing_up[pants_index], 
	'swing_left' : pants_swing_left[pants_index], 
	'swing_right' : pants_swing_right[pants_index]
	};
	
var shirts_sprites = {
	'idle_down' : shirts_idle_down[shirts_index], 
	'idle_up' : shirts_idle_up[shirts_index], 
	'idle_left' : shirts_idle_left[shirts_index], 
	'idle_right' : shirts_idle_right[shirts_index], 
	'walk_down' : shirts_walk_down[shirts_index], 
	'walk_up' : shirts_walk_up[shirts_index], 
	'walk_left' : shirts_walk_left[shirts_index], 
	'walk_right' : shirts_walk_right[shirts_index], 
	'swing_down' : shirts_swing_down[shirts_index], 
	'swing_up' : shirts_swing_up[shirts_index], 
	'swing_left' : shirts_swing_left[shirts_index], 
	'swing_right' : shirts_swing_right[shirts_index]
	};
	
var shoes_sprites = {
	'idle_down' : shoes_idle_down[shoes_index], 
	'idle_up' : shoes_idle_up[shoes_index], 
	'idle_left' : shoes_idle_left[shoes_index], 
	'idle_right' : shoes_idle_right[shoes_index], 
	'walk_down' : shoes_walk_down[shoes_index], 
	'walk_up' : shoes_walk_up[shoes_index], 
	'walk_left' : shoes_walk_left[shoes_index], 
	'walk_right' : shoes_walk_right[shoes_index], 
	'swing_down' : shoes_swing_down[shoes_index], 
	'swing_up' : shoes_swing_up[shoes_index],
	'swing_left' : shoes_swing_left[shoes_index], 
	'swing_right' : shoes_swing_right[shoes_index]
	};
	
var pickaxe_sprites = {
	'idle_down' : null,
	'idle_up' : null,
	'idle_left' : null,
	'idle_right' : null,
	'walk_down' : null,
	'walk_up' : null,
	'walk_left' : null,
	'walk_right' : null,
	'swing_down' : preload("res://Characters/Goblin/male/swing/assets/down/pickaxe/pickaxe_swing_1.png"), 
	'swing_up' : preload("res://Characters/Goblin/male/swing/assets/up/pickaxe/pickaxe_swing_1.png"), 
	'swing_left' : preload("res://Characters/Goblin/male/swing/assets/left/pickaxe/pickaxe_swing_1.png"), 
	'swing_right' :  preload("res://Characters/Goblin/male/swing/assets/right/pickaxe/pickaxe_swing_1.png")
}

var axe_sprites = {
	'idle_down' : null,
	'idle_up' : null,
	'idle_left' : null,
	'idle_right' : null,
	'walk_down' : null,
	'walk_up' : null,
	'walk_left' : null,
	'walk_right' : null,
	'swing_down' : preload("res://Characters/Goblin/male/swing/assets/down/pickaxe/goblin_front_SWING_axe.png"), 
	'swing_up' : preload("res://Characters/Goblin/male/swing/assets/up/pickaxe/goblin_back_SWING_axe.png"), 
	'swing_left' : preload("res://Characters/Goblin/male/swing/assets/left/pickaxe/axe_swing_1.png"), 
	'swing_right' :  preload("res://Characters/Goblin/male/swing/assets/right/pickaxe/axe_swing_1.png")
}




var rng = RandomNumberGenerator.new()

func randomizeAttributes():
	acc_index = rng.randi_range(0, acc_idle_down.size() - 1)
	headAtr_index = rng.randi_range(0, head_attribute_idle_down.size() - 1)
	pants_index = rng.randi_range(0, pants_idle_down.size() - 1)
	shirts_index = rng.randi_range(0, shirts_idle_down.size() - 1)
	shoes_index = rng.randi_range(0, shoes_idle_down.size() - 1)
	
	acc_sprites = {
	'idle_down' : acc_idle_down[acc_index], 
	'idle_up' : acc_idle_up[acc_index], 
	'idle_left' : acc_idle_left[acc_index], 
	'idle_right' : acc_idle_right[acc_index], 
	'walk_down' : acc_walk_down[acc_index], 
	'walk_up' : acc_walk_up[acc_index], 
	'walk_left' : acc_walk_left[acc_index], 
	'walk_right' : acc_walk_right[acc_index], 
	'swing_down' : acc_swing_down[acc_index], 
	'swing_up' : acc_swing_up[acc_index], 
	'swing_left' : acc_swing_left[acc_index], 
	'swing_right' : acc_swing_right[acc_index]
	};
	headAtr_sprites = {
	'idle_down' : head_attribute_idle_down[headAtr_index], 
	'idle_up' : head_attribute_idle_up[headAtr_index], 
	'idle_left' : head_attribute_idle_left[headAtr_index], 
	'idle_right' : head_attribute_idle_right[headAtr_index], 
	'walk_down' : head_attribute_walk_down[headAtr_index], 
	'walk_up' : head_attribute_walk_up[headAtr_index], 
	'walk_left' : head_attribute_walk_left[headAtr_index], 
	'walk_right' : head_attribute_walk_right[headAtr_index] , 
	'swing_down' : head_attribute_swing_down[headAtr_index], 
	'swing_up' : head_attribute_swing_up[headAtr_index], 
	'swing_left' : head_attribute_swing_left[headAtr_index], 
	'swing_right' : head_attribute_swing_right[headAtr_index]
	}
	pants_sprites = {
	'idle_down' : pants_idle_down[pants_index], 
	'idle_up' : pants_idle_up[pants_index], 
	'idle_left' : pants_idle_left[pants_index], 
	'idle_right' : pants_idle_right[pants_index],  
	'walk_down' : pants_walk_down[pants_index], 
	'walk_up' : pants_walk_up[pants_index], 
	'walk_left' : pants_walk_left[pants_index], 
	'walk_right' : pants_walk_right[pants_index],  
	'swing_down' : pants_swing_down[pants_index], 
	'swing_up' : pants_swing_up[pants_index], 
	'swing_left' : pants_swing_left[pants_index], 
	'swing_right' : pants_swing_right[pants_index]
	};
	shirts_sprites = {
	'idle_down' : shirts_idle_down[shirts_index], 
	'idle_up' : shirts_idle_up[shirts_index], 
	'idle_left' : shirts_idle_left[shirts_index], 
	'idle_right' : shirts_idle_right[shirts_index], 
	'walk_down' : shirts_walk_down[shirts_index], 
	'walk_up' : shirts_walk_up[shirts_index], 
	'walk_left' : shirts_walk_left[shirts_index], 
	'walk_right' : shirts_walk_right[shirts_index], 
	'swing_down' : shirts_swing_down[shirts_index], 
	'swing_up' : shirts_swing_up[shirts_index], 
	'swing_left' : shirts_swing_left[shirts_index], 
	'swing_right' : shirts_swing_right[shirts_index]
	};
	shoes_sprites = {
	'idle_down' : shoes_idle_down[shoes_index], 
	'idle_up' : shoes_idle_up[shoes_index], 
	'idle_left' : shoes_idle_left[shoes_index], 
	'idle_right' : shoes_idle_right[shoes_index], 
	'walk_down' : shoes_walk_down[shoes_index], 
	'walk_up' : shoes_walk_up[shoes_index], 
	'walk_left' : shoes_walk_left[shoes_index], 
	'walk_right' : shoes_walk_right[shoes_index], 
	'swing_down' : shoes_swing_down[shoes_index], 
	'swing_up' : shoes_swing_up[shoes_index],
	'swing_left' : shoes_swing_left[shoes_index], 
	'swing_right' : shoes_swing_right[shoes_index]
	};
	
