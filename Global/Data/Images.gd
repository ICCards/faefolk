extends Node


# IC Kitties #
var randomKitty
func _ready():
	randomize()
	KittyVariations.shuffle()
	randomKitty = KittyVariations[0]

var KittyVariations = [
	load("res://Assets/Images/IC Kitties/SpriteFrames/Blue.tres"),
	load("res://Assets/Images/IC Kitties/SpriteFrames/Green.tres"),
	load("res://Assets/Images/IC Kitties/SpriteFrames/Orange.tres"),
	load("res://Assets/Images/IC Kitties/SpriteFrames/Pink.tres"),
	load("res://Assets/Images/IC Kitties/SpriteFrames/Purple.tres"),
	load("res://Assets/Images/IC Kitties/SpriteFrames/Red.tres"),
	load("res://Assets/Images/IC Kitties/SpriteFrames/White.tres")
]


# BUNNIES #
var BunnyVariations = [
	load("res://Assets/Images/Animals/Bunny/brownBunny.tres"),
	load("res://Assets/Images/Animals/Bunny/whiteBunny.tres"),
	load("res://Assets/Images/Animals/Bunny/yellowBunny.tres")
]

# DUCKS #
var DuckVariations = [
	load("res://Assets/Images/Animals/Duck/duck1.tres"),
	load("res://Assets/Images/Animals/Duck/duck2.tres"),
	load("res://Assets/Images/Animals/Duck/duck3.tres")
]

# BIRDS #
var BirdVariations = [
	load("res://Assets/Images/Animals/Bird/bird1.tres"),
	load("res://Assets/Images/Animals/Bird/bird2.tres")
]



onready var normal_mouse = load("res://Assets/mouse cursors/Normal Selects.png")


# IC GHOSTS #

#func returnICGhostBackground(bg):
#	match bg:
#		"black":
#			return load("res://Assets/Images/IC Ghost Elements/Background/black.png")
#		"blue-linear-gradient":
#			return load("res://Assets/Images/IC Ghost Elements/Background/blue-linear-gradient.png")
#		"Flesh-color":
#			return load("res://Assets/Images/IC Ghost Elements/Background/Flesh-color.png")
#		"gray":
#			return load("res://Assets/Images/IC Ghost Elements/Background/gray.png")
#		"Green-gradient":
#			return load("res://Assets/Images/IC Ghost Elements/Background/Green-gradient.png")
#		"green": 
#			return load("res://Assets/Images/IC Ghost Elements/Background/green.png")
#		"Jigsaw-puzzle":
#			return load("res://Assets/Images/IC Ghost Elements/Background/Jigsaw-puzzle.png")
#		"light-blue":
#			return load("res://Assets/Images/IC Ghost Elements/Background/light-blue.png")
#		"Light-grey":
#			return load("res://Assets/Images/IC Ghost Elements/Background/Light-grey.png")
#		"light-pink":
#			return load("res://Assets/Images/IC Ghost Elements/Background/light-pink.png")
#		"Light-yellow":
#			return load("res://Assets/Images/IC Ghost Elements/Background/Light-yellow.png")
#		"orange-gradient":
#			return load("res://Assets/Images/IC Ghost Elements/Background/orange-gradient.png")
#		"orange":
#			return load("res://Assets/Images/IC Ghost Elements/Background/orange.png")
#		"pink-linear-gradient":
#			return load("res://Assets/Images/IC Ghost Elements/Background/pink-linear-gradient.png")
#		"purple":
#			return load("res://Assets/Images/IC Ghost Elements/Background/purple.png")
#		"Sky-blue":
#			return load("res://Assets/Images/IC Ghost Elements/Background/Sky-blue.png")
#
#func returnICGhostBody(body):
#	match body:
#		"blue-pink":
#			return load("res://Assets/Images/IC Ghost Elements/Body/blue-pink.png")
#		"blue-pink2":
#			return load("res://Assets/Images/IC Ghost Elements/Body/blue-pink2.png")
#		"blue-purple":
#			return load("res://Assets/Images/IC Ghost Elements/Body/blue-purple.png")
#		"blue":
#			return load("res://Assets/Images/IC Ghost Elements/Body/blue.png")
#		"coffee":
#			return load("res://Assets/Images/IC Ghost Elements/Body/coffee.png")
#		"dark-pink":
#			return load("res://Assets/Images/IC Ghost Elements/Body/dark-pink.png")
#		"Dfinity":
#			return load("res://Assets/Images/IC Ghost Elements/Body/Dfinity.png")
#		"Dfinity2":
#			return load("res://Assets/Images/IC Ghost Elements/Body/Dfinity2.png")
#		"Dfinity3":
#			return load("res://Assets/Images/IC Ghost Elements/Body/Dfinity3.png")
#		"Dfinity4":
#			return load("res://Assets/Images/IC Ghost Elements/Body/Dfinity4.png")
#		"Green-gradient":
#			return load("res://Assets/Images/IC Ghost Elements/Body/Green-gradient.png")
#		"green":
#			return load("res://Assets/Images/IC Ghost Elements/Body/green.png")
#		"green2":
#			return load("res://Assets/Images/IC Ghost Elements/Body/green2.png")
#		"light-blue":
#			return load("res://Assets/Images/IC Ghost Elements/Body/light-blue.png")
#		"light-green":
#			return load("res://Assets/Images/IC Ghost Elements/Body/light-green.png")
#		"light-pink":
#			return load("res://Assets/Images/IC Ghost Elements/Body/light-pink.png")
#		"light-purple":
#			return load("res://Assets/Images/IC Ghost Elements/Body/light-purple.png")
#		"orange":
#			return load("res://Assets/Images/IC Ghost Elements/Body/orange.png")
#		"pink-blue":
#			return load("res://Assets/Images/IC Ghost Elements/Body/pink-blue.png")
#		"pink":
#			return load("res://Assets/Images/IC Ghost Elements/Body/pink.png")
#		"purple":
#			return load("res://Assets/Images/IC Ghost Elements/Body/purple.png")
#		"purple2":
#			return load("res://Assets/Images/IC Ghost Elements/Body/purple2.png")
#		"yellow":
#			return load("res://Assets/Images/IC Ghost Elements/Body/yellow.png")
#		"yellow2":
#			return load("res://Assets/Images/IC Ghost Elements/Body/yellow2.png")
#
#func returnICGhostEars(ear):
#	match ear:
#		"blue":
#			return load("res://Assets/Images/IC Ghost Elements/Ears/blue.png")
#		"dark-gray":
#			return load("res://Assets/Images/IC Ghost Elements/Ears/dark-gray.png")
#		"dark-red":
#			return load("res://Assets/Images/IC Ghost Elements/Ears/dark-red.png")
#		"green":
#			return load("res://Assets/Images/IC Ghost Elements/Ears/green.png")
#		"purple":
#			return load("res://Assets/Images/IC Ghost Elements/Ears/purple.png")
#		"red":
#			return load("res://Assets/Images/IC Ghost Elements/Ears/red.png")
#		"vertical-blue":
#			return load("res://Assets/Images/IC Ghost Elements/Ears/vertical-blue.png")
#		"vertical-dark-gray":
#			return load("res://Assets/Images/IC Ghost Elements/Ears/vertical-dark-gray.png")
#		"vertical-dark-red":
#			return load("res://Assets/Images/IC Ghost Elements/Ears/vertical-dark-red.png")
#		"vertical-green":
#			return load("res://Assets/Images/IC Ghost Elements/Ears/vertical-green.png")
#		"vertical-light-yellow":
#			return load("res://Assets/Images/IC Ghost Elements/Ears/vertical-light-yellow.png")
#		"vertical-purple":
#			return load("res://Assets/Images/IC Ghost Elements/Ears/vertical-purple.png")
#		"vertical-red":
#			return load("res://Assets/Images/IC Ghost Elements/Ears/vertical-red.png")
#		"vertical-white":
#			return load("res://Assets/Images/IC Ghost Elements/Ears/vertical-white.png")
#		"vertical-yellow":
#			return load("res://Assets/Images/IC Ghost Elements/Ears/vertical-yellow.png")
#		"white":
#			return load("res://Assets/Images/IC Ghost Elements/Ears/white.png")
#		"yellow":
#			return load("res://Assets/Images/IC Ghost Elements/Ears/yellow.png")
#
#func returnICGhostEyes(eye):
#	match eye:
#		"black":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/black.png")
#		"blue":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/blue.png")
#		"cry-light-gray":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/cry-light-gray.png")
#		"cry-red":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/cry-red.png")
#		"cry-white":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/cry-white.png")
#		"dark-red":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/dark-red.png")
#		"Eyes-blue":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/Eyes-blue.png")
#		"Eyes-green":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/Eyes-green.png")
#		"Eyes-orange":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/Eyes-orange.png")
#		"Eyes-purple":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/Eyes-purple.png")
#		"Eyes-red":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/Eyes-red.png")
#		"glasses":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/glasses.png")
#		"green":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/green.png")
#		"orange":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/orange.png")
#		"pink":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/pink.png")
#		"purple":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/purple.png")
#		"right-black":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/right-black.png")
#		"right-blue":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/right-blue2.png")
#		"right-blue2":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/right-blue.png")
#		"right-green":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/right-green.png")
#		"right-green2":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/right-green2.png")
#		"right-pink2":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/right-pink2.png")
#		"right-purple":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/right-purple.png")
#		"right-purple2":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/right-purple2.png")
#		"right-white":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/right-white.png")
#		"right-white2":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/right-white2.png")
#		"Sunglasses-back":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/Sunglasses-back.png")
#		"Sunglasses-blue":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/Sunglasses-blue.png")
#		"Sunglasses-green":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/Sunglasses-green.png")
#		"Sunglasses-purple":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/Sunglasses-purple.png")
#		"Sunglasses-red":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/Sunglasses-red.png")
#		"Sunglasses-yellow":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/Sunglasses-yellow.png")
#		"Sunglasses":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/Sunglasses.png")
#		"white":
#			return load("res://Assets/Images/IC Ghost Elements/Eyes/white.png")
#
#func returnICGhostFace(face):
#	match face:
#		"face-blue":
#			return load("res://Assets/Images/IC Ghost Elements/Face/face-blue.png")
#		"face-green":
#			return load("res://Assets/Images/IC Ghost Elements/Face/face-green.png")
#		"face-orange":
#			return load("res://Assets/Images/IC Ghost Elements/Face/face-orange.png")
#		"face-pink":
#			return load("res://Assets/Images/IC Ghost Elements/Face/face-pink.png")
#		"face-red":
#			return load("res://Assets/Images/IC Ghost Elements/Face/face-red.png")
#		"light-blue":
#			return load("res://Assets/Images/IC Ghost Elements/Face/light-blue.png")
#		"yellow":
#			return load("res://Assets/Images/IC Ghost Elements/Face/yellow.png")
#
#func returnICGhostHat(hat):
#	match hat:
#		"an-crown-blue":
#			return load("res://Assets/Images/IC Ghost Elements/Hat/an-crown-blue.png")
#		"an-crown-pink":
#			return load("res://Assets/Images/IC Ghost Elements/Hat/an-crown-pink.png")
#		"an-crown-yellow":
#			return load("res://Assets/Images/IC Ghost Elements/Hat/an-crown-yellow.png")
#		"hat-blue":
#			return load("res://Assets/Images/IC Ghost Elements/Hat/hat-blue.png")
#		"hat-orange":
#			return load("res://Assets/Images/IC Ghost Elements/Hat/hat-orange.png")
#		"hat-yellow":
#			return load("res://Assets/Images/IC Ghost Elements/Hat/hat-yellow.png")
#		"Scarf-blue":
#			return load("res://Assets/Images/IC Ghost Elements/Hat/Scarf-blue.png")
#		"Scarf-orange":
#			return load("res://Assets/Images/IC Ghost Elements/Hat/Scarf-orange.png")
#		"Scarf-red": 
#			return load("res://Assets/Images/IC Ghost Elements/Hat/Scarf-red.png")
#		"Stetson-blue":
#			return load("res://Assets/Images/IC Ghost Elements/Hat/Stetson-blue.png")
#		"Stetson-yellow":
#			return load("res://Assets/Images/IC Ghost Elements/Hat/Stetson-yellow.png")
#		"Stetson":
#			return load("res://Assets/Images/IC Ghost Elements/Hat/Stetson.png")
#		"witch-blue":
#			return load("res://Assets/Images/IC Ghost Elements/Hat/witch-blue.png")
#		"witch-purple":
#			return load("res://Assets/Images/IC Ghost Elements/Hat/witch-purple.png")
#		"witch-red":
#			return load("res://Assets/Images/IC Ghost Elements/Hat/witch-red.png")
#
#func returnICGhostMouth(mouth):
#	match mouth:
#		"blue":
#			return load("res://Assets/Images/IC Ghost Elements/Mouth/blue.png")
#		"close-blue":
#			return load("res://Assets/Images/IC Ghost Elements/Mouth/close-blue.png")
#		"close-orange":
#			return load("res://Assets/Images/IC Ghost Elements/Mouth/close-orange.png")
#		"close-purple":
#			return load("res://Assets/Images/IC Ghost Elements/Mouth/close-purple.png")
#		"close-red":
#			return load("res://Assets/Images/IC Ghost Elements/Mouth/close-red.png")
#		"close-white":
#			return load("res://Assets/Images/IC Ghost Elements/Mouth/close-white.png")
#		"cry-blue":
#			return load("res://Assets/Images/IC Ghost Elements/Mouth/cry-blue.png")
#		"cry-pink":
#			return load("res://Assets/Images/IC Ghost Elements/Mouth/cry-pink.png")
#		"cry-yellow":
#			return load("res://Assets/Images/IC Ghost Elements/Mouth/cry-yellow.png")
#		"green":
#			return load("res://Assets/Images/IC Ghost Elements/Mouth/green.png")
#		"light-blue":
#			return load("res://Assets/Images/IC Ghost Elements/Mouth/light-blue.png")
#		"light-green":
#			return load("res://Assets/Images/IC Ghost Elements/Mouth/light-green.png")
#		"pink":
#			return load("res://Assets/Images/IC Ghost Elements/Mouth/pink.png")
#		"purple":
#			return load("res://Assets/Images/IC Ghost Elements/Mouth/purple.png")
#		"red":
#			return load("res://Assets/Images/IC Ghost Elements/Mouth/red.png")
#		"white":
#			return load("res://Assets/Images/IC Ghost Elements/Mouth/white.png")
#		"yellow":
#			return load("res://Assets/Images/IC Ghost Elements/Mouth/yellow.png")
#
#func returnICGhostProp(prop):
#	match prop:
#		"blue":
#			return load("res://Assets/Images/IC Ghost Elements/Prop/blue.png")
#		"green":
#			return load("res://Assets/Images/IC Ghost Elements/Prop/green.png")
#		"orange":
#			return load("res://Assets/Images/IC Ghost Elements/Prop/orange.png")
#		"pink":
#			return load("res://Assets/Images/IC Ghost Elements/Prop/pink.png")
#		"purple":
#			return load("res://Assets/Images/IC Ghost Elements/Prop/purple.png")
#		"run-blue":
#			return load("res://Assets/Images/IC Ghost Elements/Prop/run-blue.png")
#		"run-green":
#			return load("res://Assets/Images/IC Ghost Elements/Prop/run-green.png")
#		"run-light-green":
#			return load("res://Assets/Images/IC Ghost Elements/Prop/run-light-green.png")
#		"run-orange":
#			return load("res://Assets/Images/IC Ghost Elements/Prop/run-orange.png")
#		"run-purple":
#			return load("res://Assets/Images/IC Ghost Elements/Prop/run-purple.png")
#		"run-white":
#			return load("res://Assets/Images/IC Ghost Elements/Prop/run-white.png")
#		"ship-blue":
#			return load("res://Assets/Images/IC Ghost Elements/Prop/ship-blue.png")
#		"ship-green":
#			return load("res://Assets/Images/IC Ghost Elements/Prop/ship-green .png")
#		"ship-light green":
#			return load("res://Assets/Images/IC Ghost Elements/Prop/ship-light green.png")
#		"ship-pink":
#			return load("res://Assets/Images/IC Ghost Elements/Prop/ship-pink.png")
#		"skate":
#			return load("res://Assets/Images/IC Ghost Elements/Prop/skate.png")
#
#func returnICGhostUnique(unique):
#	match unique:
#		"Unique1":
#			return load("res://Assets/Images/IC Ghost Elements/Uniques/Unique1.png")
#		"Unique2":
#			return load("res://Assets/Images/IC Ghost Elements/Uniques/Unique2.png")
#		"Unique3":
#			return load("res://Assets/Images/IC Ghost Elements/Uniques/Unique3.png")
#		"Unique4":
#			return load("res://Assets/Images/IC Ghost Elements/Uniques/Unique4.png")
#		"Unique5":
#			return load("res://Assets/Images/IC Ghost Elements/Uniques/Unique5.png")
#		"Unique6":
#			return load("res://Assets/Images/IC Ghost Elements/Uniques/Unique6.png")
#		"Unique7":
#			return load("res://Assets/Images/IC Ghost Elements/Uniques/Unique7.png")
#		"Unique8":
#			return load("res://Assets/Images/IC Ghost Elements/Uniques/Unique8.png")
#		"Unique9":
#			return load("res://Assets/Images/IC Ghost Elements/Uniques/Unique9.png")
#		"Unique10":
#			return load("res://Assets/Images/IC Ghost Elements/Uniques/Unique10.png")
#		"Unique11":
#			return load("res://Assets/Images/IC Ghost Elements/Uniques/Unique11.png")
#		"Unique12":
#			return load("res://Assets/Images/IC Ghost Elements/Uniques/Unique12.png")
#		"Unique13":
#			return load("res://Assets/Images/IC Ghost Elements/Uniques/Unique13.png")
#		"Unique14":
#			return load("res://Assets/Images/IC Ghost Elements/Uniques/Unique14.png")
#		"Unique15":
#			return load("res://Assets/Images/IC Ghost Elements/Uniques/Unique15.png")
#




# WEAPONS #
func returnToolSprite(toolName, animation):
	if toolName == "health potion I" or toolName == "health potion II" or toolName == "health potion III" or \
	toolName == "regeneration potion I" or toolName == "regeneration potion II" or toolName == "regeneration potion III" :
		match animation:
			"throw_down":
				return red_potion_throw.down
			"throw_up":
				return red_potion_throw.up
			"throw_left":
				return red_potion_throw.left
			"throw_right":
				return red_potion_throw.right
	elif toolName == "poison potion I" or toolName == "poison potion II" or toolName == "poison potion III":
		match animation:
			"throw_down":
				return green_potion_throw.down
			"throw_up":
				return green_potion_throw.up
			"throw_left":
				return green_potion_throw.left
			"throw_right":
				return green_potion_throw.right
	elif toolName == "destruction potion I" or toolName == "destruction potion II" or toolName == "destruction potion III":
		match animation:
			"throw_down":
				return black_potion_throw.down
			"throw_up":
				return black_potion_throw.up
			"throw_left":
				return black_potion_throw.left
			"throw_right":
				return black_potion_throw.right
	elif toolName == "speed potion I" or toolName == "speed potion II" or toolName == "speed potion III":
		match animation:
			"throw_down":
				return blue_potion_throw.down
			"throw_up":
				return blue_potion_throw.up
			"throw_left":
				return blue_potion_throw.left
			"throw_right":
				return blue_potion_throw.right
	match toolName:
		"hammer":
			match animation: 
				"swing_down":
					 return hammer.down
				"swing_up":
					 return hammer.up
				"swing_left":
					 return hammer.left
				"swing_right":
					 return hammer.right
		"wood pickaxe":
			match animation: 
				"swing_down":
					 return wood_pickaxe.down
				"swing_up":
					 return wood_pickaxe.up
				"swing_left":
					 return wood_pickaxe.left
				"swing_right":
					 return wood_pickaxe.right
		"stone pickaxe":
			match animation: 
				"swing_down":
					 return stone_pickaxe.down
				"swing_up":
					 return stone_pickaxe.up
				"swing_left":
					 return stone_pickaxe.left
				"swing_right":
					 return stone_pickaxe.right
		"bronze pickaxe":
			match animation: 
				"swing_down":
					 return bronze_pickaxe.down
				"swing_up":
					 return bronze_pickaxe.up
				"swing_left":
					 return bronze_pickaxe.left
				"swing_right":
					 return bronze_pickaxe.right
		"iron pickaxe":
			match animation: 
				"swing_down":
					 return iron_pickaxe.down
				"swing_up":
					 return iron_pickaxe.up
				"swing_left":
					 return iron_pickaxe.left
				"swing_right":
					 return iron_pickaxe.right
		"gold pickaxe":
			match animation: 
				"swing_down":
					 return gold_pickaxe.down
				"swing_up":
					 return gold_pickaxe.up
				"swing_left":
					 return gold_pickaxe.left
				"swing_right":
					 return gold_pickaxe.right
		"wood hoe":
			match animation: 
				"swing_down":
					 return wood_hoe.down
				"swing_up":
					 return wood_hoe.up
				"swing_left":
					 return wood_hoe.left
				"swing_right":
					 return wood_hoe.right
		"stone hoe":
			match animation: 
				"swing_down":
					 return stone_hoe.down
				"swing_up":
					 return stone_hoe.up
				"swing_left":
					 return stone_hoe.left
				"swing_right":
					 return stone_hoe.right
		"bronze hoe":
			match animation: 
				"swing_down":
					 return bronze_hoe.down
				"swing_up":
					 return bronze_hoe.up
				"swing_left":
					 return bronze_hoe.left
				"swing_right":
					 return bronze_hoe.right
		"iron hoe":
			match animation: 
				"swing_down":
					 return iron_hoe.down
				"swing_up":
					 return iron_hoe.up
				"swing_left":
					 return iron_hoe.left
				"swing_right":
					 return iron_hoe.right
		"gold hoe":
			match animation: 
				"swing_down":
					 return gold_hoe.down
				"swing_up":
					 return gold_hoe.up
				"swing_left":
					 return gold_hoe.left
				"swing_right":
					 return gold_hoe.right
		"wood axe":
			match animation: 
				"swing_down":
					 return wood_axe.down
				"swing_up":
					 return wood_axe.up
				"swing_left":
					 return wood_axe.left
				"swing_right":
					return wood_axe.right
		"stone axe":
			match animation: 
				"swing_down":
					 return stone_axe.down
				"swing_up":
					 return stone_axe.up
				"swing_left":
					 return stone_axe.left
				"swing_right":
					return stone_axe.right
		"iron axe":
			match animation: 
				"swing_down":
					 return iron_axe.down
				"swing_up":
					 return iron_axe.up
				"swing_left":
					 return iron_axe.left
				"swing_right":
					return iron_axe.right
		"bronze axe":
			match animation: 
				"swing_down":
					 return bronze_axe.down
				"swing_up":
					 return bronze_axe.up
				"swing_left":
					 return bronze_axe.left
				"swing_right":
					return bronze_axe.right
		"gold axe":
			match animation: 
				"swing_down":
					 return gold_axe.down
				"swing_up":
					 return gold_axe.up
				"swing_left":
					 return gold_axe.left
				"swing_right":
					return gold_axe.right
		"wood sword":
			match animation: 
				"sword_swing_down":
					 return wood_sword.down
				"sword_swing_up":
					 return wood_sword.up
				"sword_swing_left":
					 return wood_sword.left
				"sword_swing_right":
					return wood_sword.right
		"stone sword":
			match animation: 
				"sword_swing_down":
					 return stone_sword.down
				"sword_swing_up":
					 return stone_sword.up
				"sword_swing_left":
					 return stone_sword.left
				"sword_swing_right":
					return stone_sword.right
		"bronze sword":
			match animation: 
				"sword_swing_down":
					 return bronze_sword.down
				"sword_swing_up":
					 return bronze_sword.up
				"sword_swing_left":
					 return bronze_sword.left
				"sword_swing_right":
					return bronze_sword.right
		"iron sword":
			match animation: 
				"sword_swing_down":
					 return iron_sword.down
				"sword_swing_up":
					 return iron_sword.up
				"sword_swing_left":
					 return iron_sword.left
				"sword_swing_right":
					return iron_sword.right
		"gold sword":
			match animation: 
				"sword_swing_down":
					 return gold_sword.down
				"sword_swing_up":
					 return gold_sword.up
				"sword_swing_left":
					 return gold_sword.left
				"sword_swing_right":
					return gold_sword.right
		"stone watering can":
			match animation:
				"watering_down":
					 return stone_watering_can.down
				"watering_up":
					 return null
				"watering_left":
					 return stone_watering_can.left
				"watering_right":
					 return stone_watering_can.right
		"bronze watering can":
			match animation:
				"watering_down":
					 return bronze_watering_can.down
				"watering_up":
					 return null
				"watering_left":
					 return bronze_watering_can.left
				"watering_right":
					 return bronze_watering_can.right
		"gold watering can":
			match animation:
				"watering_down":
					 return gold_watering_can.down
				"watering_up":
					 return null
				"watering_left":
					 return gold_watering_can.left
				"watering_right":
					 return gold_watering_can.right
		"fishing rod cast":
			match animation:
				"cast_down":
					return fishing_rod_cast.up
				"cast_up":
					return fishing_rod_cast.down
				"cast_left":
					return fishing_rod_cast.left
				"cast_right":
					return fishing_rod_cast.right
		"fishing rod retract":
			match animation:
				"retract_down":
					return fishing_rod_retract.down
				"retract_up":
					return fishing_rod_retract.up
				"retract_left":
					return fishing_rod_retract.left
				"retract_right":
					return fishing_rod_retract.right
		"fishing rod struggle":
			match animation:
				"struggle_down":
					return fishing_rod_struggle.down
				"struggle_up":
					return fishing_rod_struggle.up
				"struggle_left":
					return fishing_rod_struggle.left
				"struggle_right":
					return fishing_rod_struggle.right
		"swim":
			match animation:
				"swim_down":
					return ripples.down
				"swim_up":
					return ripples.up
				"swim_left":
					return ripples.left
				"swim_right":
					return ripples.right
		"scythe":
			match animation:
				"sword_swing_down":
					return scythe.down
				"sword_swing_up":
					return scythe.up
				"sword_swing_left":
					return scythe.left
				"sword_swing_right":
					return scythe.right
		"bow":
			match animation:
				"draw_down":
					return bow_draw.down
				"draw_up":
					return bow_draw.up
				"draw_right":
					return bow_draw.right
				"draw_left":
					return bow_draw.left
		"bow release":
			match animation:
				"release_down":
					return bow_release.down
				"release_up":
					return bow_release.up
				"release_right":
					return bow_release.right
				"release_left":
					return bow_release.left
		"magic staff":
			animation = animation.substr(0,13)
			match animation:
				"magic_cast_do":
					return magic_staff.down
				"magic_cast_up":
					return magic_staff.up
				"magic_cast_ri":
					return magic_staff.right
				"magic_cast_le":
					return magic_staff.left


var red_potion_throw = {
	down = load("res://Characters/Weapon swings/potions/red/down.png"),
	up = load("res://Characters/Weapon swings/potions/red/up.png"),
	left = load("res://Characters/Weapon swings/potions/red/left.png"),
	right = load("res://Characters/Weapon swings/potions/red/right.png")
}

var black_potion_throw = {
	down = load("res://Characters/Weapon swings/potions/black/down.png"),
	up = load("res://Characters/Weapon swings/potions/black/up.png"),
	left = load("res://Characters/Weapon swings/potions/black/left.png"),
	right = load("res://Characters/Weapon swings/potions/black/right.png")
}
var green_potion_throw = {
	down = load("res://Characters/Weapon swings/potions/green/down.png"),
	up = load("res://Characters/Weapon swings/potions/green/up.png"),
	left = load("res://Characters/Weapon swings/potions/green/left.png"),
	right = load("res://Characters/Weapon swings/potions/green/right.png")
}
var blue_potion_throw = {
	down = load("res://Characters/Weapon swings/potions/blue/down.png"),
	up = load("res://Characters/Weapon swings/potions/blue/up.png"),
	left = load("res://Characters/Weapon swings/potions/blue/left.png"),
	right = load("res://Characters/Weapon swings/potions/blue/right.png")
}

var magic_staff = {
	down = load("res://Characters/Weapon swings/magic staff/down.png"),
	up = load("res://Characters/Weapon swings/magic staff/up.png"),
	left = load("res://Characters/Weapon swings/magic staff/left.png"),
	right = load("res://Characters/Weapon swings/magic staff/right.png")
}

var wood_pickaxe = {
	down = load("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/wood/down.png"), 
	up = load("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/wood/up.png"), 
	left = load("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/wood/left.png"), 
	right = load("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/wood/right.png")
}
var stone_pickaxe = {
	down = load("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/stone/down.png"), 
	up = load("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/stone/up.png"), 
	left = load("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/stone/left.png"), 
	right = load("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/stone/right.png")
}
var bronze_pickaxe = {
	down = load("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/bronze/down.png"), 
	up = load("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/bronze/up.png"), 
	left = load("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/bronze/left.png"), 
	right = load("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/bronze/right.png")
}
var iron_pickaxe = {
	down = load("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/iron/down.png"), 
	up = load("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/iron/up.png"), 
	left = load("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/iron/left.png"), 
	right = load("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/iron/right.png")
}
var gold_pickaxe = {
	down = load("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/gold/down.png"), 
	up = load("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/gold/up.png"), 
	left = load("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/gold/left.png"), 
	right = load("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/gold/right.png")
}

var wood_axe = {
	down = load("res://Characters/Weapon swings/axe pickaxe swing/axe/wood/down.png"), 
	up =  load("res://Characters/Weapon swings/axe pickaxe swing/axe/wood/up.png"), 
	left = load("res://Characters/Weapon swings/axe pickaxe swing/axe/wood/left.png"), 
	right = load("res://Characters/Weapon swings/axe pickaxe swing/axe/wood/right.png")
}
var stone_axe = {
	down = load("res://Characters/Weapon swings/axe pickaxe swing/axe/stone/down.png"), 
	up =  load("res://Characters/Weapon swings/axe pickaxe swing/axe/stone/up.png"), 
	left = load("res://Characters/Weapon swings/axe pickaxe swing/axe/stone/left.png"), 
	right = load("res://Characters/Weapon swings/axe pickaxe swing/axe/stone/right.png")
}
var bronze_axe = {
	down = load("res://Characters/Weapon swings/axe pickaxe swing/axe/bronze/down.png"), 
	up =  load("res://Characters/Weapon swings/axe pickaxe swing/axe/bronze/up.png"), 
	left = load("res://Characters/Weapon swings/axe pickaxe swing/axe/bronze/left.png"), 
	right = load("res://Characters/Weapon swings/axe pickaxe swing/axe/bronze/right.png")
}
var iron_axe = {
	down = load("res://Characters/Weapon swings/axe pickaxe swing/axe/iron/down.png"), 
	up =  load("res://Characters/Weapon swings/axe pickaxe swing/axe/iron/up.png"), 
	left = load("res://Characters/Weapon swings/axe pickaxe swing/axe/iron/left.png"), 
	right = load("res://Characters/Weapon swings/axe pickaxe swing/axe/iron/right.png")
}
var gold_axe = {
	down = load("res://Characters/Weapon swings/axe pickaxe swing/axe/gold/down.png"), 
	up =  load("res://Characters/Weapon swings/axe pickaxe swing/axe/gold/up.png"), 
	left = load("res://Characters/Weapon swings/axe pickaxe swing/axe/gold/left.png"), 
	right = load("res://Characters/Weapon swings/axe pickaxe swing/axe/gold/right.png")
}

var wood_hoe = {
	down = load("res://Characters/Weapon swings/axe pickaxe swing/hoe/wood/down.png"), 
	up =  load("res://Characters/Weapon swings/axe pickaxe swing/hoe/wood/up.png"), 
	left = load("res://Characters/Weapon swings/axe pickaxe swing/hoe/wood/left.png"), 
	right = load("res://Characters/Weapon swings/axe pickaxe swing/hoe/wood/right.png")
}
var stone_hoe = {
	down = load("res://Characters/Weapon swings/axe pickaxe swing/hoe/stone/down.png"), 
	up =  load("res://Characters/Weapon swings/axe pickaxe swing/hoe/stone/up.png"), 
	left = load("res://Characters/Weapon swings/axe pickaxe swing/hoe/stone/left.png"), 
	right = load("res://Characters/Weapon swings/axe pickaxe swing/hoe/stone/right.png")
}
var bronze_hoe = {
	down = load("res://Characters/Weapon swings/axe pickaxe swing/hoe/bronze/down.png"), 
	up =  load("res://Characters/Weapon swings/axe pickaxe swing/hoe/bronze/up.png"), 
	left = load("res://Characters/Weapon swings/axe pickaxe swing/hoe/bronze/left.png"), 
	right = load("res://Characters/Weapon swings/axe pickaxe swing/hoe/bronze/right.png")
}
var iron_hoe = {
	down = load("res://Characters/Weapon swings/axe pickaxe swing/hoe/iron/down.png"), 
	up =  load("res://Characters/Weapon swings/axe pickaxe swing/hoe/iron/up.png"), 
	left = load("res://Characters/Weapon swings/axe pickaxe swing/hoe/iron/left.png"), 
	right = load("res://Characters/Weapon swings/axe pickaxe swing/hoe/iron/right.png")
}
var gold_hoe = {
	down = load("res://Characters/Weapon swings/axe pickaxe swing/hoe/gold/down.png"), 
	up =  load("res://Characters/Weapon swings/axe pickaxe swing/hoe/gold/up.png"), 
	left = load("res://Characters/Weapon swings/axe pickaxe swing/hoe/gold/left.png"), 
	right = load("res://Characters/Weapon swings/axe pickaxe swing/hoe/gold/right.png")
}
var wood_sword = {
	down = load("res://Characters/Weapon swings/scythe sword swing/sword/wood/down.png"), 
	up =  load("res://Characters/Weapon swings/scythe sword swing/sword/wood/up.png"), 
	left = load("res://Characters/Weapon swings/scythe sword swing/sword/wood/left.png"), 
	right = load("res://Characters/Weapon swings/scythe sword swing/sword/wood/right.png")
}
var stone_sword = {
	down = load("res://Characters/Weapon swings/scythe sword swing/sword/stone/down.png"), 
	up =  load("res://Characters/Weapon swings/scythe sword swing/sword/stone/up.png"), 
	left = load("res://Characters/Weapon swings/scythe sword swing/sword/stone/left.png"), 
	right = load("res://Characters/Weapon swings/scythe sword swing/sword/stone/right.png")
}
var bronze_sword = {
	down = load("res://Characters/Weapon swings/scythe sword swing/sword/bronze/down.png"), 
	up =  load("res://Characters/Weapon swings/scythe sword swing/sword/bronze/up.png"), 
	left = load("res://Characters/Weapon swings/scythe sword swing/sword/bronze/left.png"), 
	right = load("res://Characters/Weapon swings/scythe sword swing/sword/bronze/right.png")
}
var iron_sword = {
	down = load("res://Characters/Weapon swings/scythe sword swing/sword/iron/down.png"), 
	up =  load("res://Characters/Weapon swings/scythe sword swing/sword/iron/up.png"), 
	left = load("res://Characters/Weapon swings/scythe sword swing/sword/iron/left.png"), 
	right = load("res://Characters/Weapon swings/scythe sword swing/sword/iron/right.png")
}
var gold_sword = {
	down = load("res://Characters/Weapon swings/scythe sword swing/sword/gold/down.png"), 
	up =  load("res://Characters/Weapon swings/scythe sword swing/sword/gold/up.png"), 
	left = load("res://Characters/Weapon swings/scythe sword swing/sword/gold/left.png"), 
	right = load("res://Characters/Weapon swings/scythe sword swing/sword/gold/right.png")
}

var scythe = {
	down = load("res://Characters/Weapon swings/scythe sword swing/scythe/down.png"), 
	up =  load("res://Characters/Weapon swings/scythe sword swing/scythe/up.png"), 
	left = load("res://Characters/Weapon swings/scythe sword swing/scythe/left.png"), 
	right = load("res://Characters/Weapon swings/scythe sword swing/scythe/right.png")
}

var bow_draw = {
	down = load("res://Characters/Weapon swings/bow/draw/down.png"),
	up = load("res://Characters/Weapon swings/bow/draw/up.png"),
	left = load("res://Characters/Weapon swings/bow/draw/left.png"),
	right = load("res://Characters/Weapon swings/bow/draw/right.png")
}
var bow_release = {
	down = load("res://Characters/Weapon swings/bow/release/down.png"),
	up = load("res://Characters/Weapon swings/bow/release/up.png"),
	left = load("res://Characters/Weapon swings/bow/release/left.png"),
	right = load("res://Characters/Weapon swings/bow/release/right.png")
}

var stone_watering_can = {
	down = load("res://Characters/Weapon swings/watering cans/stone/down.png"),
	left = load("res://Characters/Weapon swings/watering cans/stone/left.png"),
	right = load("res://Characters/Weapon swings/watering cans/stone/right.png")
}
var bronze_watering_can = {
	down = load("res://Characters/Weapon swings/watering cans/bronze/down.png"),
	left = load("res://Characters/Weapon swings/watering cans/bronze/left.png"),
	right = load("res://Characters/Weapon swings/watering cans/bronze/right.png")
}
var gold_watering_can = {
	down = load("res://Characters/Weapon swings/watering cans/gold/down.png"),
	left = load("res://Characters/Weapon swings/watering cans/gold/left.png"),
	right = load("res://Characters/Weapon swings/watering cans/gold/right.png")
}


var fishing_rod_cast = {
	down = load("res://Characters/Weapon swings/fishing rod cast/down.png"),
	left = load("res://Characters/Weapon swings/fishing rod cast/left.png"),
	right = load("res://Characters/Weapon swings/fishing rod cast/right.png"),
	up = load("res://Characters/Weapon swings/fishing rod cast/up.png")
}

var fishing_rod_retract = {
	down = load("res://Characters/Weapon swings/fishing rod retract/down.png"),
	left = load("res://Characters/Weapon swings/fishing rod retract/left.png"),
	right = load("res://Characters/Weapon swings/fishing rod retract/right.png"),
	up = load("res://Characters/Weapon swings/fishing rod retract/up.png")
}

var fishing_rod_struggle = {
	down = load("res://Characters/Weapon swings/fishing rod struggle/down.png"),
	left = load("res://Characters/Weapon swings/fishing rod struggle/left.png"),
	right = load("res://Characters/Weapon swings/fishing rod struggle/right.png"),
	up = load("res://Characters/Weapon swings/fishing rod struggle/up.png")
}

var ripples = {
	down = load("res://Characters/Weapon swings/ripples/down.png"),
	left = load("res://Characters/Weapon swings/ripples/left.png"),
	right = load("res://Characters/Weapon swings/ripples/right.png"),
	up = load("res://Characters/Weapon swings/ripples/up.png")
}

var hammer = {
	down = load("res://Characters/Weapon swings/axe pickaxe swing/hammer/iron/down.png"),
	left = load("res://Characters/Weapon swings/axe pickaxe swing/hammer/iron/left.png"),
	right = load("res://Characters/Weapon swings/axe pickaxe swing/hammer/iron/right.png"),
	up = load("res://Characters/Weapon swings/axe pickaxe swing/hammer/iron/up.png")
}

# TALL GRASS #

func returnTallGrassObject(biome, variety):
	match variety:
		"1":
			return dark_green_grass 
		"2":
			return green_grass
		"3":
			return red_grass 
		"4":
			return yellow_grass 
			
var dark_green_grass = [
	load("res://Assets/Images/tall grass sets/dark green.png"),
	load("res://Assets/Images/tall grass sets/dark green back.png"),
]
var green_grass = [
	load("res://Assets/Images/tall grass sets/green.png"),
	load("res://Assets/Images/tall grass sets/green back.png")
]
var red_grass = [
	load("res://Assets/Images/tall grass sets/red.png"),
	load("res://Assets/Images/tall grass sets/red back.png")
]
var yellow_grass = [
	load("res://Assets/Images/tall grass sets/yellow.png"),
	load("res://Assets/Images/tall grass sets/yellow back.png")
]


var dark_green_grass_winter = [
	load("res://Assets/Images/tall grass sets/winter/dark green.png"),
	load("res://Assets/Images/tall grass sets/winter/dark green back.png")
]
var green_grass_winter = [
	load("res://Assets/Images/tall grass sets/winter/green.png"),
	load("res://Assets/Images/tall grass sets/winter/green back.png")
]
var red_grass_winter = [
	load("res://Assets/Images/tall grass sets/winter/red.png"),
	load("res://Assets/Images/tall grass sets/winter/red back.png")
]
var yellow_grass_winter = [
	load("res://Assets/Images/tall grass sets/winter/yellow.png"),
	load("res://Assets/Images/tall grass sets/winter/yellow back.png")
]


# DESERT TREES #

#var desert_trees = [
#	load("res://Assets/Images/tree_sets/desert/1a.tres"),
#	load("res://Assets/Images/tree_sets/desert/1b.tres"),
#	load("res://Assets/Images/tree_sets/desert/2a.tres"),
#	load("res://Assets/Images/tree_sets/desert/2b.tres")
#]

#func returnDesertTree(type):
#	match type:
#		"1a":
#			return desert_trees[0]
#		"1b":
#			return desert_trees[1]
#		"2a":
#			return desert_trees[2]
#		"2b":
#			return desert_trees[3]




# BRANCH OBJECTS #
var tree_branch_objects = {
	12 : load("res://Assets/Images/tree_sets/branch_objects/branch1.png"),
	1 : load("res://Assets/Images/tree_sets/branch_objects/branch2.png"),
	2 : load("res://Assets/Images/tree_sets/branch_objects/branch3.png"),
	3 : load("res://Assets/Images/tree_sets/branch_objects/branch4.png"),
	4 : load("res://Assets/Images/tree_sets/branch_objects/branch5.png"),
	5 : load("res://Assets/Images/tree_sets/branch_objects/branch6.png"),
	6 : load("res://Assets/Images/tree_sets/branch_objects/branch7.png"),
	7 : load("res://Assets/Images/tree_sets/branch_objects/branch8.png"),
	8 : load("res://Assets/Images/tree_sets/branch_objects/branch9.png"),
	9 : load("res://Assets/Images/tree_sets/branch_objects/branch10.png"),
	10 : load("res://Assets/Images/tree_sets/branch_objects/branch11.png"),
	11 : load("res://Assets/Images/tree_sets/branch_objects/branch12.png"),
}


# FRUIT TREES #
func returnFruitTree(treeType):
	match treeType:
		"plum":
			return Plum_tree
		"pear":
			return Pear_tree
		"cherry":
			return Cherry_tree
		"apple":
			return Apple_tree
		
var Plum_tree = {
	growingStages = {
		0 : load("res://Assets/Images/tree_sets/plum/growing/sapling.png"),
		1 : load("res://Assets/Images/tree_sets/plum/growing/1.png"),
		2 : load("res://Assets/Images/tree_sets/plum/growing/2.png"),
		3 : load("res://Assets/Images/tree_sets/plum/growing/3.png"),
		4 : load("res://Assets/Images/tree_sets/plum/growing/4.png"),
	},
	stump = load("res://Assets/Images/tree_sets/plum/stump.png"),
	bottomTree = load("res://Assets/Images/tree_sets/plum/bottom.png"),
	middleTree = load("res://Assets/Images/tree_sets/plum/middle.png"),
	topTree = {
		0 : load("res://Assets/Images/tree_sets/plum/tops/1.png"),
		1 : load("res://Assets/Images/tree_sets/plum/tops/2.png"),
		2 : load("res://Assets/Images/tree_sets/plum/tops/3.png"),
		3 : load("res://Assets/Images/tree_sets/plum/tops/harvested.png"),
	},
	chip = load("res://Assets/Images/tree_sets/plum/chip.png"),
	leaves = null,
}

var Pear_tree = {
	growingStages = {
		0 : load("res://Assets/Images/tree_sets/pear/growing/sapling.png"),
		1 : load("res://Assets/Images/tree_sets/pear/growing/1.png"),
		2 : load("res://Assets/Images/tree_sets/pear/growing/2.png"),
		3 : load("res://Assets/Images/tree_sets/pear/growing/3.png"),
		4 : load("res://Assets/Images/tree_sets/pear/growing/4.png"),
	},
	stump = load("res://Assets/Images/tree_sets/pear/stump.png"),
	bottomTree = load("res://Assets/Images/tree_sets/pear/bottom.png"),
	middleTree = load("res://Assets/Images/tree_sets/pear/middle.png"),
	topTree = {
		0 : load("res://Assets/Images/tree_sets/pear/tops/1.png"),
		1 : load("res://Assets/Images/tree_sets/pear/tops/2.png"),
		2 : load("res://Assets/Images/tree_sets/pear/tops/3.png"),
		3 : load("res://Assets/Images/tree_sets/pear/tops/harvested.png"),
	},
	chip = load("res://Assets/Images/tree_sets/pear/chip.png"),
	leaves = null,
}

var Cherry_tree = {
	growingStages = {
		0 : load("res://Assets/Images/tree_sets/cherry/growing/sapling.png"),
		1 : load("res://Assets/Images/tree_sets/cherry/growing/1.png"),
		2 : load("res://Assets/Images/tree_sets/cherry/growing/2.png"),
		3 : load("res://Assets/Images/tree_sets/cherry/growing/3.png"),
		4 : load("res://Assets/Images/tree_sets/cherry/growing/4.png"),
	},
	stump = load("res://Assets/Images/tree_sets/cherry/stump.png"),
	bottomTree = load("res://Assets/Images/tree_sets/cherry/bottom.png"),
	middleTree = load("res://Assets/Images/tree_sets/cherry/middle.png"),
	topTree = {
		0 : load("res://Assets/Images/tree_sets/cherry/tops/1.png"),
		1 : load("res://Assets/Images/tree_sets/cherry/tops/2.png"),
		2 : load("res://Assets/Images/tree_sets/cherry/tops/3.png"),
		3 : load("res://Assets/Images/tree_sets/cherry/tops/harvested.png"),
	},
	chip = load("res://Assets/Images/tree_sets/cherry/tree_chip.png"),
	leaves = null,
}

var Apple_tree = {
	growingStages = {
		0 : load("res://Assets/Images/tree_sets/apple/growing/sapling.png"),
		1 : load("res://Assets/Images/tree_sets/apple/growing/1.png"),
		2 : load("res://Assets/Images/tree_sets/apple/growing/2.png"),
		3 : load("res://Assets/Images/tree_sets/apple/growing/3.png"),
		4 : load("res://Assets/Images/tree_sets/apple/growing/4.png"),
	},
	stump = load("res://Assets/Images/tree_sets/apple/stump.png"),
	bottomTree = load("res://Assets/Images/tree_sets/apple/bottom.png"),
	middleTree = load("res://Assets/Images/tree_sets/apple/middle.png"),
	topTree = {
		0 : load("res://Assets/Images/tree_sets/apple/tops/1.png"),
		1 : load("res://Assets/Images/tree_sets/apple/tops/2.png"),
		2 : load("res://Assets/Images/tree_sets/apple/tops/3.png"),
		3 : load("res://Assets/Images/tree_sets/apple/tops/harvested.png"),
	},
	chip = load("res://Assets/Images/tree_sets/apple/chip.png"),
	leaves = null,
}

# ORE OBJECTS #

func returnOreObject(oreType):
	match oreType:
		"bronze ore":
			return Bronze_ore
		"iron ore":
			return Iron_ore
		"gold ore":
			return Gold_ore
		"stone1":
			return Stone_ore1
		"stone2":
			return Stone_ore2

#var red_gemstone = {
#	largeOre = load("res://Assets/Images/ore_sets/red/red_gemstone_large.png"),
#	mediumOres = {
#		0 : load("res://Assets/Images/ore_sets/red/medium/red_gemstone_1.png"),
#		1 : load("res://Assets/Images/ore_sets/red/medium/red_gemstone_2.png"),
#		2 : load("res://Assets/Images/ore_sets/red/medium/red_gemstone_3.png"),
#		3 : load("res://Assets/Images/ore_sets/red/medium/red_gemstone_4.png"),
#		4 : load("res://Assets/Images/ore_sets/red/medium/red_gemstone_5.png"),
#		5 : load("res://Assets/Images/ore_sets/red/medium/red_gemstone_6.png"),
#	},
#	chip = load("res://Assets/Images/ore_sets/red/red_chip.png")
#}
#
#var Cyan_ore = {
#	largeOre = load("res://Assets/Images/ore_sets/cyan/cyan_gemstone_large.png"),
#	mediumOres = {
#		0 : load("res://Assets/Images/ore_sets/cyan/medium/cyan_gemstone_1.png"),
#		1 : load("res://Assets/Images/ore_sets/cyan/medium/teal_gemstone_2.png"),
#		2 : load("res://Assets/Images/ore_sets/cyan/medium/teal_gemstone_3.png"),
#		3 : load("res://Assets/Images/ore_sets/cyan/medium/teal_gemstone_4.png"),
#		4 : load("res://Assets/Images/ore_sets/cyan/medium/teal_gemstone_5.png"),
#		5 : load("res://Assets/Images/ore_sets/cyan/medium/teal_gemstone_6.png"),
#	},
#	chip = load("res://Assets/Images/ore_sets/cyan/cyan_chip.png")
#}
#
#var Green_ore = {
#	largeOre = load("res://Assets/Images/ore_sets/green/green_gemstone_large.png"),
#	mediumOres = {
#		0 : load("res://Assets/Images/ore_sets/green/medium/green_gemstone_1.png"),
#		1 : load("res://Assets/Images/ore_sets/green/medium/green_gemstone_2.png"),
#		2 : load("res://Assets/Images/ore_sets/green/medium/green_gemstone_3.png"),
#		3 : load("res://Assets/Images/ore_sets/green/medium/green_gemstone_4.png"),
#		4 : load("res://Assets/Images/ore_sets/green/medium/green_gemstone_5.png"),
#		5 : load("res://Assets/Images/ore_sets/green/medium/green_gemstone_6.png"),
#	},
#	chip = load("res://Assets/Images/ore_sets/cyan/cyan_chip.png")
#}
#
#var Dark_blue_ore = {
#	largeOre =  load("res://Assets/Images/ore_sets/dark_blue/dark_blue_gemstone_large.png"),
#	mediumOres = {
#	0 : load("res://Assets/Images/ore_sets/dark_blue/medium/dark_blue_gemstone_1.png"),
#	1 : load("res://Assets/Images/ore_sets/dark_blue/medium/dark_blue_gemstone_2.png"),
#	2 : load("res://Assets/Images/ore_sets/dark_blue/medium/dark_blue_gemstone_3.png"),
#	3 : load("res://Assets/Images/ore_sets/dark_blue/medium/dark_blue_gemstone_4.png"),
#	4 : load("res://Assets/Images/ore_sets/dark_blue/medium/dark_blue_gemstone_5.png"),
#	5 : load("res://Assets/Images/ore_sets/dark_blue/medium/dark_blue_gemstone_6.png"),
#	},
#	chip = load("res://Assets/Images/ore_sets/dark_blue/chip.png")
#}

var Bronze_ore = {
	largeOre = load("res://Assets/Images/Ores/bronze/large.png"),
	mediumOres = {
	0 : load("res://Assets/Images/Ores/bronze/medium/1.png"),
	1 : load("res://Assets/Images/Ores/bronze/medium/2.png"),
	2 : load("res://Assets/Images/Ores/bronze/medium/3.png"),
	3 : load("res://Assets/Images/Ores/bronze/medium/4.png"),
	4 : load("res://Assets/Images/Ores/bronze/medium/5.png"),
	5 : load("res://Assets/Images/Ores/bronze/medium/6.png"),
	},
	chip = load("res://Assets/Images/Ores/bronze/chip.png")
}

var Iron_ore = {
	largeOre = load("res://Assets/Images/Ores/iron/large.png"),
	mediumOres = {
	0 : load("res://Assets/Images/Ores/iron/medium/1.png"),
	1 : load("res://Assets/Images/Ores/iron/medium/2.png"),
	2 : load("res://Assets/Images/Ores/iron/medium/3.png"),
	3 : load("res://Assets/Images/Ores/iron/medium/4.png"),
	4 : load("res://Assets/Images/Ores/iron/medium/5.png"),
	5 : load("res://Assets/Images/Ores/iron/medium/6.png"),
	},
	chip = load("res://Assets/Images/Ores/iron/chip.png")
}

var Gold_ore = {
	largeOre = load("res://Assets/Images/Ores/gold/large.png"), 
	mediumOres = {
		0 : load("res://Assets/Images/Ores/gold/medium/1.png"),
		1 : load("res://Assets/Images/Ores/gold/medium/2.png"),
		2 : load("res://Assets/Images/Ores/gold/medium/3.png"),
		3 : load("res://Assets/Images/Ores/gold/medium/4.png"),
		4 : load("res://Assets/Images/Ores/gold/medium/5.png"),
		5 : load("res://Assets/Images/Ores/gold/medium/6.png"),
	},
	chip = load("res://Assets/Images/Ores/gold/chip.png")
}

var Stone_ore1 = {
	largeOre = load("res://Assets/Images/Ores/stone1/large.png"),
	mediumOres = {
		0 : load("res://Assets/Images/Ores/stone1/medium/1.png"),
		1 : load("res://Assets/Images/Ores/stone1/medium/2.png"),
		2 : load("res://Assets/Images/Ores/stone1/medium/3.png"),
		3 : load("res://Assets/Images/Ores/stone1/medium/4.png"),
		4 : load("res://Assets/Images/Ores/stone1/medium/5.png"),
		5 : load("res://Assets/Images/Ores/stone1/medium/6.png"),
	},
	chip = load("res://Assets/Images/Ores/stone1/chip.png")
}

var Stone_ore2 = {
	largeOre = load("res://Assets/Images/Ores/stone2/large.png"),
	mediumOres = {
		0 : load("res://Assets/Images/Ores/stone2/medium/1.png"),
		1 : load("res://Assets/Images/Ores/stone2/medium/2.png"),
		2 : load("res://Assets/Images/Ores/stone2/medium/3.png"),
		3 : load("res://Assets/Images/Ores/stone2/medium/4.png"),
		4 : load("res://Assets/Images/Ores/stone2/medium/5.png"),
		5 : load("res://Assets/Images/Ores/stone2/medium/6.png"),
	},
	chip = load("res://Assets/Images/Ores/stone2/chip.png")
}
