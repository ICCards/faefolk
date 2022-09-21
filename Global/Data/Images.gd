extends Node


# IC Kitties #
var randomKitty
func _ready():
	randomize()
	KittyVariations.shuffle()
	randomKitty = KittyVariations[0]

var KittyVariations = [
	preload("res://Assets/Images/IC Kitties/SpriteFrames/Blue.tres"),
	preload("res://Assets/Images/IC Kitties/SpriteFrames/Green.tres"),
	preload("res://Assets/Images/IC Kitties/SpriteFrames/Orange.tres"),
	preload("res://Assets/Images/IC Kitties/SpriteFrames/Pink.tres"),
	preload("res://Assets/Images/IC Kitties/SpriteFrames/Purple.tres"),
	preload("res://Assets/Images/IC Kitties/SpriteFrames/Red.tres"),
	preload("res://Assets/Images/IC Kitties/SpriteFrames/White.tres")
]


func returnRandomSnake():
	SnakeVariations.shuffle()
	return SnakeVariations[0]

# SNAKES #
var SnakeVariations = [
	preload("res://Assets/Images/Animals/Snake/brown.tres"),
	preload("res://Assets/Images/Animals/Snake/brownBlack.tres"),
	preload("res://Assets/Images/Animals/Snake/green.tres"),
	preload("res://Assets/Images/Animals/Snake/greenYellow.tres")
]

# BUNNIES #
var BunnyVariations = [
	preload("res://Assets/Images/Animals/Bunny/brownBunny.tres"),
	preload("res://Assets/Images/Animals/Bunny/whiteBunny.tres"),
	preload("res://Assets/Images/Animals/Bunny/yellowBunny.tres")
]

# DUCKS #
var DuckVariations = [
	preload("res://Assets/Images/Animals/Duck/duck1.tres"),
	preload("res://Assets/Images/Animals/Duck/duck2.tres")
]

# BIRDS #
var BirdVariations = [
	preload("res://Assets/Images/Animals/Bird/bird1.tres"),
	preload("res://Assets/Images/Animals/Bird/bird2.tres")
]


# IC GHOSTS #

func returnICGhostBackground(bg):
	match bg:
		"black":
			return preload("res://Assets/Images/IC Ghost Elements/Background/black.png")
		"blue-linear-gradient":
			return preload("res://Assets/Images/IC Ghost Elements/Background/blue-linear-gradient.png")
		"Flesh-color":
			return preload("res://Assets/Images/IC Ghost Elements/Background/Flesh-color.png")
		"gray":
			return preload("res://Assets/Images/IC Ghost Elements/Background/gray.png")
		"Green-gradient":
			return preload("res://Assets/Images/IC Ghost Elements/Background/Green-gradient.png")
		"green": 
			return preload("res://Assets/Images/IC Ghost Elements/Background/green.png")
		"Jigsaw-puzzle":
			return preload("res://Assets/Images/IC Ghost Elements/Background/Jigsaw-puzzle.png")
		"light-blue":
			return preload("res://Assets/Images/IC Ghost Elements/Background/light-blue.png")
		"Light-grey":
			return preload("res://Assets/Images/IC Ghost Elements/Background/Light-grey.png")
		"light-pink":
			return preload("res://Assets/Images/IC Ghost Elements/Background/light-pink.png")
		"Light-yellow":
			return preload("res://Assets/Images/IC Ghost Elements/Background/Light-yellow.png")
		"orange-gradient":
			return preload("res://Assets/Images/IC Ghost Elements/Background/orange-gradient.png")
		"orange":
			return preload("res://Assets/Images/IC Ghost Elements/Background/orange.png")
		"pink-linear-gradient":
			return preload("res://Assets/Images/IC Ghost Elements/Background/pink-linear-gradient.png")
		"purple":
			return preload("res://Assets/Images/IC Ghost Elements/Background/purple.png")
		"Sky-blue":
			return preload("res://Assets/Images/IC Ghost Elements/Background/Sky-blue.png")
			
func returnICGhostBody(body):
	match body:
		"blue-pink":
			return preload("res://Assets/Images/IC Ghost Elements/Body/blue-pink.png")
		"blue-pink2":
			return preload("res://Assets/Images/IC Ghost Elements/Body/blue-pink2.png")
		"blue-purple":
			return preload("res://Assets/Images/IC Ghost Elements/Body/blue-purple.png")
		"blue":
			return preload("res://Assets/Images/IC Ghost Elements/Body/blue.png")
		"coffee":
			return preload("res://Assets/Images/IC Ghost Elements/Body/coffee.png")
		"dark-pink":
			return preload("res://Assets/Images/IC Ghost Elements/Body/dark-pink.png")
		"Dfinity":
			return preload("res://Assets/Images/IC Ghost Elements/Body/Dfinity.png")
		"Dfinity2":
			return preload("res://Assets/Images/IC Ghost Elements/Body/Dfinity2.png")
		"Dfinity3":
			return preload("res://Assets/Images/IC Ghost Elements/Body/Dfinity3.png")
		"Dfinity4":
			return preload("res://Assets/Images/IC Ghost Elements/Body/Dfinity4.png")
		"Green-gradient":
			return preload("res://Assets/Images/IC Ghost Elements/Body/Green-gradient.png")
		"green":
			return preload("res://Assets/Images/IC Ghost Elements/Body/green.png")
		"green2":
			return preload("res://Assets/Images/IC Ghost Elements/Body/green2.png")
		"light-blue":
			return preload("res://Assets/Images/IC Ghost Elements/Body/light-blue.png")
		"light-green":
			return preload("res://Assets/Images/IC Ghost Elements/Body/light-green.png")
		"light-pink":
			return preload("res://Assets/Images/IC Ghost Elements/Body/light-pink.png")
		"light-purple":
			return preload("res://Assets/Images/IC Ghost Elements/Body/light-purple.png")
		"orange":
			return preload("res://Assets/Images/IC Ghost Elements/Body/orange.png")
		"pink-blue":
			return preload("res://Assets/Images/IC Ghost Elements/Body/pink-blue.png")
		"pink":
			return preload("res://Assets/Images/IC Ghost Elements/Body/pink.png")
		"purple":
			return preload("res://Assets/Images/IC Ghost Elements/Body/purple.png")
		"purple2":
			return preload("res://Assets/Images/IC Ghost Elements/Body/purple2.png")
		"yellow":
			return preload("res://Assets/Images/IC Ghost Elements/Body/yellow.png")
		"yellow2":
			return preload("res://Assets/Images/IC Ghost Elements/Body/yellow2.png")

func returnICGhostEars(ear):
	match ear:
		"blue":
			return preload("res://Assets/Images/IC Ghost Elements/Ears/blue.png")
		"dark-gray":
			return preload("res://Assets/Images/IC Ghost Elements/Ears/dark-gray.png")
		"dark-red":
			return preload("res://Assets/Images/IC Ghost Elements/Ears/dark-red.png")
		"green":
			return preload("res://Assets/Images/IC Ghost Elements/Ears/green.png")
		"purple":
			return preload("res://Assets/Images/IC Ghost Elements/Ears/purple.png")
		"red":
			return preload("res://Assets/Images/IC Ghost Elements/Ears/red.png")
		"vertical-blue":
			return preload("res://Assets/Images/IC Ghost Elements/Ears/vertical-blue.png")
		"vertical-dark-gray":
			return preload("res://Assets/Images/IC Ghost Elements/Ears/vertical-dark-gray.png")
		"vertical-dark-red":
			return preload("res://Assets/Images/IC Ghost Elements/Ears/vertical-dark-red.png")
		"vertical-green":
			return preload("res://Assets/Images/IC Ghost Elements/Ears/vertical-green.png")
		"vertical-light-yellow":
			return preload("res://Assets/Images/IC Ghost Elements/Ears/vertical-light-yellow.png")
		"vertical-purple":
			return preload("res://Assets/Images/IC Ghost Elements/Ears/vertical-purple.png")
		"vertical-red":
			return preload("res://Assets/Images/IC Ghost Elements/Ears/vertical-red.png")
		"vertical-white":
			return preload("res://Assets/Images/IC Ghost Elements/Ears/vertical-white.png")
		"vertical-yellow":
			return preload("res://Assets/Images/IC Ghost Elements/Ears/vertical-yellow.png")
		"white":
			return preload("res://Assets/Images/IC Ghost Elements/Ears/white.png")
		"yellow":
			return preload("res://Assets/Images/IC Ghost Elements/Ears/yellow.png")

func returnICGhostEyes(eye):
	match eye:
		"black":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/black.png")
		"blue":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/blue.png")
		"cry-light-gray":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/cry-light-gray.png")
		"cry-red":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/cry-red.png")
		"cry-white":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/cry-white.png")
		"dark-red":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/dark-red.png")
		"Eyes-blue":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/Eyes-blue.png")
		"Eyes-green":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/Eyes-green.png")
		"Eyes-orange":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/Eyes-orange.png")
		"Eyes-purple":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/Eyes-purple.png")
		"Eyes-red":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/Eyes-red.png")
		"glasses":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/glasses.png")
		"green":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/green.png")
		"orange":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/orange.png")
		"pink":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/pink.png")
		"purple":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/purple.png")
		"right-black":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/right-black.png")
		"right-blue":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/right-blue2.png")
		"right-blue2":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/right-blue.png")
		"right-green":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/right-green.png")
		"right-green2":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/right-green2.png")
		"right-pink2":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/right-pink2.png")
		"right-purple":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/right-purple.png")
		"right-purple2":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/right-purple2.png")
		"right-white":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/right-white.png")
		"right-white2":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/right-white2.png")
		"Sunglasses-back":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/Sunglasses-back.png")
		"Sunglasses-blue":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/Sunglasses-blue.png")
		"Sunglasses-green":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/Sunglasses-green.png")
		"Sunglasses-purple":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/Sunglasses-purple.png")
		"Sunglasses-red":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/Sunglasses-red.png")
		"Sunglasses-yellow":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/Sunglasses-yellow.png")
		"Sunglasses":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/Sunglasses.png")
		"white":
			return preload("res://Assets/Images/IC Ghost Elements/Eyes/white.png")

func returnICGhostFace(face):
	match face:
		"face-blue":
			return preload("res://Assets/Images/IC Ghost Elements/Face/face-blue.png")
		"face-green":
			return preload("res://Assets/Images/IC Ghost Elements/Face/face-green.png")
		"face-orange":
			return preload("res://Assets/Images/IC Ghost Elements/Face/face-orange.png")
		"face-pink":
			return preload("res://Assets/Images/IC Ghost Elements/Face/face-pink.png")
		"face-red":
			return preload("res://Assets/Images/IC Ghost Elements/Face/face-red.png")
		"light-blue":
			return preload("res://Assets/Images/IC Ghost Elements/Face/light-blue.png")
		"yellow":
			return preload("res://Assets/Images/IC Ghost Elements/Face/yellow.png")

func returnICGhostHat(hat):
	match hat:
		"an-crown-blue":
			return preload("res://Assets/Images/IC Ghost Elements/Hat/an-crown-blue.png")
		"an-crown-pink":
			return preload("res://Assets/Images/IC Ghost Elements/Hat/an-crown-pink.png")
		"an-crown-yellow":
			return preload("res://Assets/Images/IC Ghost Elements/Hat/an-crown-yellow.png")
		"hat-blue":
			return preload("res://Assets/Images/IC Ghost Elements/Hat/hat-blue.png")
		"hat-orange":
			return preload("res://Assets/Images/IC Ghost Elements/Hat/hat-orange.png")
		"hat-yellow":
			return preload("res://Assets/Images/IC Ghost Elements/Hat/hat-yellow.png")
		"Scarf-blue":
			return preload("res://Assets/Images/IC Ghost Elements/Hat/Scarf-blue.png")
		"Scarf-orange":
			return preload("res://Assets/Images/IC Ghost Elements/Hat/Scarf-orange.png")
		"Scarf-red": 
			return preload("res://Assets/Images/IC Ghost Elements/Hat/Scarf-red.png")
		"Stetson-blue":
			return preload("res://Assets/Images/IC Ghost Elements/Hat/Stetson-blue.png")
		"Stetson-yellow":
			return preload("res://Assets/Images/IC Ghost Elements/Hat/Stetson-yellow.png")
		"Stetson":
			return preload("res://Assets/Images/IC Ghost Elements/Hat/Stetson.png")
		"witch-blue":
			return preload("res://Assets/Images/IC Ghost Elements/Hat/witch-blue.png")
		"witch-purple":
			return preload("res://Assets/Images/IC Ghost Elements/Hat/witch-purple.png")
		"witch-red":
			return preload("res://Assets/Images/IC Ghost Elements/Hat/witch-red.png")

func returnICGhostMouth(mouth):
	match mouth:
		"blue":
			return preload("res://Assets/Images/IC Ghost Elements/Mouth/blue.png")
		"close-blue":
			return preload("res://Assets/Images/IC Ghost Elements/Mouth/close-blue.png")
		"close-orange":
			return preload("res://Assets/Images/IC Ghost Elements/Mouth/close-orange.png")
		"close-purple":
			return preload("res://Assets/Images/IC Ghost Elements/Mouth/close-purple.png")
		"close-red":
			return preload("res://Assets/Images/IC Ghost Elements/Mouth/close-red.png")
		"close-white":
			return preload("res://Assets/Images/IC Ghost Elements/Mouth/close-white.png")
		"cry-blue":
			return preload("res://Assets/Images/IC Ghost Elements/Mouth/cry-blue.png")
		"cry-pink":
			return preload("res://Assets/Images/IC Ghost Elements/Mouth/cry-pink.png")
		"cry-yellow":
			return preload("res://Assets/Images/IC Ghost Elements/Mouth/cry-yellow.png")
		"green":
			return preload("res://Assets/Images/IC Ghost Elements/Mouth/green.png")
		"light-blue":
			return preload("res://Assets/Images/IC Ghost Elements/Mouth/light-blue.png")
		"light-green":
			return preload("res://Assets/Images/IC Ghost Elements/Mouth/light-green.png")
		"pink":
			return preload("res://Assets/Images/IC Ghost Elements/Mouth/pink.png")
		"purple":
			return preload("res://Assets/Images/IC Ghost Elements/Mouth/purple.png")
		"red":
			return preload("res://Assets/Images/IC Ghost Elements/Mouth/red.png")
		"white":
			return preload("res://Assets/Images/IC Ghost Elements/Mouth/white.png")
		"yellow":
			return preload("res://Assets/Images/IC Ghost Elements/Mouth/yellow.png")
			
func returnICGhostProp(prop):
	match prop:
		"blue":
			return preload("res://Assets/Images/IC Ghost Elements/Prop/blue.png")
		"green":
			return preload("res://Assets/Images/IC Ghost Elements/Prop/green.png")
		"orange":
			return preload("res://Assets/Images/IC Ghost Elements/Prop/orange.png")
		"pink":
			return preload("res://Assets/Images/IC Ghost Elements/Prop/pink.png")
		"purple":
			return preload("res://Assets/Images/IC Ghost Elements/Prop/purple.png")
		"run-blue":
			return preload("res://Assets/Images/IC Ghost Elements/Prop/run-blue.png")
		"run-green":
			return preload("res://Assets/Images/IC Ghost Elements/Prop/run-green.png")
		"run-light-green":
			return preload("res://Assets/Images/IC Ghost Elements/Prop/run-light-green.png")
		"run-orange":
			return preload("res://Assets/Images/IC Ghost Elements/Prop/run-orange.png")
		"run-purple":
			return preload("res://Assets/Images/IC Ghost Elements/Prop/run-purple.png")
		"run-white":
			return preload("res://Assets/Images/IC Ghost Elements/Prop/run-white.png")
		"ship-blue":
			return preload("res://Assets/Images/IC Ghost Elements/Prop/ship-blue.png")
		"ship-green":
			return preload("res://Assets/Images/IC Ghost Elements/Prop/ship-green .png")
		"ship-light green":
			return preload("res://Assets/Images/IC Ghost Elements/Prop/ship-light green.png")
		"ship-pink":
			return preload("res://Assets/Images/IC Ghost Elements/Prop/ship-pink.png")
		"skate":
			return preload("res://Assets/Images/IC Ghost Elements/Prop/skate.png")
	
func returnICGhostUnique(unique):
	match unique:
		"Unique1":
			return preload("res://Assets/Images/IC Ghost Elements/Uniques/Unique1.png")
		"Unique2":
			return preload("res://Assets/Images/IC Ghost Elements/Uniques/Unique2.png")
		"Unique3":
			return preload("res://Assets/Images/IC Ghost Elements/Uniques/Unique3.png")
		"Unique4":
			return preload("res://Assets/Images/IC Ghost Elements/Uniques/Unique4.png")
		"Unique5":
			return preload("res://Assets/Images/IC Ghost Elements/Uniques/Unique5.png")
		"Unique6":
			return preload("res://Assets/Images/IC Ghost Elements/Uniques/Unique6.png")
		"Unique7":
			return preload("res://Assets/Images/IC Ghost Elements/Uniques/Unique7.png")
		"Unique8":
			return preload("res://Assets/Images/IC Ghost Elements/Uniques/Unique8.png")
		"Unique9":
			return preload("res://Assets/Images/IC Ghost Elements/Uniques/Unique9.png")
		"Unique10":
			return preload("res://Assets/Images/IC Ghost Elements/Uniques/Unique10.png")
		"Unique11":
			return preload("res://Assets/Images/IC Ghost Elements/Uniques/Unique11.png")
		"Unique12":
			return preload("res://Assets/Images/IC Ghost Elements/Uniques/Unique12.png")
		"Unique13":
			return preload("res://Assets/Images/IC Ghost Elements/Uniques/Unique13.png")
		"Unique14":
			return preload("res://Assets/Images/IC Ghost Elements/Uniques/Unique14.png")
		"Unique15":
			return preload("res://Assets/Images/IC Ghost Elements/Uniques/Unique15.png")





# WEAPONS #
func returnToolSprite(toolName, animation):
	match toolName:
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

var wood_pickaxe = {
	down = preload("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/wood/down.png"), 
	up = preload("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/wood/up.png"), 
	left = preload("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/wood/left.png"), 
	right = preload("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/wood/right.png")
}
var stone_pickaxe = {
	down = preload("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/stone/down.png"), 
	up = preload("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/stone/up.png"), 
	left = preload("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/stone/left.png"), 
	right = preload("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/stone/right.png")
}
var bronze_pickaxe = {
	down = preload("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/bronze/down.png"), 
	up = preload("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/bronze/up.png"), 
	left = preload("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/bronze/left.png"), 
	right = preload("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/bronze/right.png")
}
var iron_pickaxe = {
	down = preload("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/iron/down.png"), 
	up = preload("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/iron/up.png"), 
	left = preload("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/iron/left.png"), 
	right = preload("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/iron/right.png")
}
var gold_pickaxe = {
	down = preload("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/gold/down.png"), 
	up = preload("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/gold/up.png"), 
	left = preload("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/gold/left.png"), 
	right = preload("res://Characters/Weapon swings/axe pickaxe swing/pickaxe/gold/right.png")
}

var wood_axe = {
	down = preload("res://Characters/Weapon swings/axe pickaxe swing/axe/wood/down.png"), 
	up =  preload("res://Characters/Weapon swings/axe pickaxe swing/axe/wood/up.png"), 
	left = preload("res://Characters/Weapon swings/axe pickaxe swing/axe/wood/left.png"), 
	right = preload("res://Characters/Weapon swings/axe pickaxe swing/axe/wood/right.png")
}
var stone_axe = {
	down = preload("res://Characters/Weapon swings/axe pickaxe swing/axe/stone/down.png"), 
	up =  preload("res://Characters/Weapon swings/axe pickaxe swing/axe/stone/up.png"), 
	left = preload("res://Characters/Weapon swings/axe pickaxe swing/axe/stone/left.png"), 
	right = preload("res://Characters/Weapon swings/axe pickaxe swing/axe/stone/right.png")
}
var bronze_axe = {
	down = preload("res://Characters/Weapon swings/axe pickaxe swing/axe/bronze/down.png"), 
	up =  preload("res://Characters/Weapon swings/axe pickaxe swing/axe/bronze/up.png"), 
	left = preload("res://Characters/Weapon swings/axe pickaxe swing/axe/bronze/left.png"), 
	right = preload("res://Characters/Weapon swings/axe pickaxe swing/axe/bronze/right.png")
}
var iron_axe = {
	down = preload("res://Characters/Weapon swings/axe pickaxe swing/axe/iron/down.png"), 
	up =  preload("res://Characters/Weapon swings/axe pickaxe swing/axe/iron/up.png"), 
	left = preload("res://Characters/Weapon swings/axe pickaxe swing/axe/iron/left.png"), 
	right = preload("res://Characters/Weapon swings/axe pickaxe swing/axe/iron/right.png")
}
var gold_axe = {
	down = preload("res://Characters/Weapon swings/axe pickaxe swing/axe/gold/down.png"), 
	up =  preload("res://Characters/Weapon swings/axe pickaxe swing/axe/gold/up.png"), 
	left = preload("res://Characters/Weapon swings/axe pickaxe swing/axe/gold/left.png"), 
	right = preload("res://Characters/Weapon swings/axe pickaxe swing/axe/gold/right.png")
}

var wood_hoe = {
	down = preload("res://Characters/Weapon swings/axe pickaxe swing/hoe/wood/down.png"), 
	up =  preload("res://Characters/Weapon swings/axe pickaxe swing/hoe/wood/up.png"), 
	left = preload("res://Characters/Weapon swings/axe pickaxe swing/hoe/wood/left.png"), 
	right = preload("res://Characters/Weapon swings/axe pickaxe swing/hoe/wood/right.png")
}
var stone_hoe = {
	down = preload("res://Characters/Weapon swings/axe pickaxe swing/hoe/stone/down.png"), 
	up =  preload("res://Characters/Weapon swings/axe pickaxe swing/hoe/stone/up.png"), 
	left = preload("res://Characters/Weapon swings/axe pickaxe swing/hoe/stone/left.png"), 
	right = preload("res://Characters/Weapon swings/axe pickaxe swing/hoe/stone/right.png")
}
var bronze_hoe = {
	down = preload("res://Characters/Weapon swings/axe pickaxe swing/hoe/bronze/down.png"), 
	up =  preload("res://Characters/Weapon swings/axe pickaxe swing/hoe/bronze/up.png"), 
	left = preload("res://Characters/Weapon swings/axe pickaxe swing/hoe/bronze/left.png"), 
	right = preload("res://Characters/Weapon swings/axe pickaxe swing/hoe/bronze/right.png")
}
var iron_hoe = {
	down = preload("res://Characters/Weapon swings/axe pickaxe swing/hoe/iron/down.png"), 
	up =  preload("res://Characters/Weapon swings/axe pickaxe swing/hoe/iron/up.png"), 
	left = preload("res://Characters/Weapon swings/axe pickaxe swing/hoe/iron/left.png"), 
	right = preload("res://Characters/Weapon swings/axe pickaxe swing/hoe/iron/right.png")
}
var gold_hoe = {
	down = preload("res://Characters/Weapon swings/axe pickaxe swing/hoe/gold/down.png"), 
	up =  preload("res://Characters/Weapon swings/axe pickaxe swing/hoe/gold/up.png"), 
	left = preload("res://Characters/Weapon swings/axe pickaxe swing/hoe/gold/left.png"), 
	right = preload("res://Characters/Weapon swings/axe pickaxe swing/hoe/gold/right.png")
}
var wood_sword = {
	down = preload("res://Characters/Weapon swings/scythe sword swing/sword/wood/down.png"), 
	up =  preload("res://Characters/Weapon swings/scythe sword swing/sword/wood/up.png"), 
	left = preload("res://Characters/Weapon swings/scythe sword swing/sword/wood/left.png"), 
	right = preload("res://Characters/Weapon swings/scythe sword swing/sword/wood/right.png")
}
var stone_sword = {
	down = preload("res://Characters/Weapon swings/scythe sword swing/sword/stone/down.png"), 
	up =  preload("res://Characters/Weapon swings/scythe sword swing/sword/stone/up.png"), 
	left = preload("res://Characters/Weapon swings/scythe sword swing/sword/stone/left.png"), 
	right = preload("res://Characters/Weapon swings/scythe sword swing/sword/stone/right.png")
}
var bronze_sword = {
	down = preload("res://Characters/Weapon swings/scythe sword swing/sword/bronze/down.png"), 
	up =  preload("res://Characters/Weapon swings/scythe sword swing/sword/bronze/up.png"), 
	left = preload("res://Characters/Weapon swings/scythe sword swing/sword/bronze/left.png"), 
	right = preload("res://Characters/Weapon swings/scythe sword swing/sword/bronze/right.png")
}
var iron_sword = {
	down = preload("res://Characters/Weapon swings/scythe sword swing/sword/iron/down.png"), 
	up =  preload("res://Characters/Weapon swings/scythe sword swing/sword/iron/up.png"), 
	left = preload("res://Characters/Weapon swings/scythe sword swing/sword/iron/left.png"), 
	right = preload("res://Characters/Weapon swings/scythe sword swing/sword/iron/right.png")
}
var gold_sword = {
	down = preload("res://Characters/Weapon swings/scythe sword swing/sword/gold/down.png"), 
	up =  preload("res://Characters/Weapon swings/scythe sword swing/sword/gold/up.png"), 
	left = preload("res://Characters/Weapon swings/scythe sword swing/sword/gold/left.png"), 
	right = preload("res://Characters/Weapon swings/scythe sword swing/sword/gold/right.png")
}

var scythe = {
	down = preload("res://Characters/Weapon swings/scythe sword swing/scythe/down.png"), 
	up =  preload("res://Characters/Weapon swings/scythe sword swing/scythe/up.png"), 
	left = preload("res://Characters/Weapon swings/scythe sword swing/scythe/left.png"), 
	right = preload("res://Characters/Weapon swings/scythe sword swing/scythe/right.png")
}

var bow_draw = {
	down = preload("res://Characters/Weapon swings/bow/draw/down.png"),
	up = preload("res://Characters/Weapon swings/bow/draw/up.png"),
	left = preload("res://Characters/Weapon swings/bow/draw/left.png"),
	right = preload("res://Characters/Weapon swings/bow/draw/right.png")
}
var bow_release = {
	down = preload("res://Characters/Weapon swings/bow/release/down.png"),
	up = preload("res://Characters/Weapon swings/bow/release/up.png"),
	left = preload("res://Characters/Weapon swings/bow/release/left.png"),
	right = preload("res://Characters/Weapon swings/bow/release/right.png")
}

var stone_watering_can = {
	down = preload("res://Characters/Weapon swings/watering cans/stone/down.png"),
	left = preload("res://Characters/Weapon swings/watering cans/stone/left.png"),
	right = preload("res://Characters/Weapon swings/watering cans/stone/right.png")
}
var bronze_watering_can = {
	down = preload("res://Characters/Weapon swings/watering cans/bronze/down.png"),
	left = preload("res://Characters/Weapon swings/watering cans/bronze/left.png"),
	right = preload("res://Characters/Weapon swings/watering cans/bronze/right.png")
}
var gold_watering_can = {
	down = preload("res://Characters/Weapon swings/watering cans/gold/down.png"),
	left = preload("res://Characters/Weapon swings/watering cans/gold/left.png"),
	right = preload("res://Characters/Weapon swings/watering cans/gold/right.png")
}


var fishing_rod_cast = {
	down = preload("res://Characters/Weapon swings/fishing rod cast/down.png"),
	left = preload("res://Characters/Weapon swings/fishing rod cast/left.png"),
	right = preload("res://Characters/Weapon swings/fishing rod cast/right.png"),
	up = preload("res://Characters/Weapon swings/fishing rod cast/up.png")
}

var fishing_rod_retract = {
	down = preload("res://Characters/Weapon swings/fishing rod retract/down.png"),
	left = preload("res://Characters/Weapon swings/fishing rod retract/left.png"),
	right = preload("res://Characters/Weapon swings/fishing rod retract/right.png"),
	up = preload("res://Characters/Weapon swings/fishing rod retract/up.png")
}

var fishing_rod_struggle = {
	down = preload("res://Characters/Weapon swings/fishing rod struggle/down.png"),
	left = preload("res://Characters/Weapon swings/fishing rod struggle/left.png"),
	right = preload("res://Characters/Weapon swings/fishing rod struggle/right.png"),
	up = preload("res://Characters/Weapon swings/fishing rod struggle/up.png")
}

var ripples = {
	down = preload("res://Characters/Weapon swings/ripples/down.png"),
	left = preload("res://Characters/Weapon swings/ripples/left.png"),
	right = preload("res://Characters/Weapon swings/ripples/right.png"),
	up = preload("res://Characters/Weapon swings/ripples/up.png")
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
	preload("res://Assets/Images/tall grass sets/dark green.png"),
	preload("res://Assets/Images/tall grass sets/dark green back.png"),
]
var green_grass = [
	preload("res://Assets/Images/tall grass sets/green.png"),
	preload("res://Assets/Images/tall grass sets/green back.png")
]
var red_grass = [
	preload("res://Assets/Images/tall grass sets/red.png"),
	preload("res://Assets/Images/tall grass sets/red back.png")
]
var yellow_grass = [
	preload("res://Assets/Images/tall grass sets/yellow.png"),
	preload("res://Assets/Images/tall grass sets/yellow back.png")
]


var dark_green_grass_winter = [
	preload("res://Assets/Images/tall grass sets/winter/dark green.png"),
	preload("res://Assets/Images/tall grass sets/winter/dark green back.png")
]
var green_grass_winter = [
	preload("res://Assets/Images/tall grass sets/winter/green.png"),
	preload("res://Assets/Images/tall grass sets/winter/green back.png")
]
var red_grass_winter = [
	preload("res://Assets/Images/tall grass sets/winter/red.png"),
	preload("res://Assets/Images/tall grass sets/winter/red back.png")
]
var yellow_grass_winter = [
	preload("res://Assets/Images/tall grass sets/winter/yellow.png"),
	preload("res://Assets/Images/tall grass sets/winter/yellow back.png")
]


# DESERT TREES #

var desert_trees = [
	preload("res://Assets/Images/tree_sets/desert/1a.tres"),
	preload("res://Assets/Images/tree_sets/desert/1b.tres"),
	preload("res://Assets/Images/tree_sets/desert/2a.tres"),
	preload("res://Assets/Images/tree_sets/desert/2b.tres")
]

func returnDesertTree(type):
	match type:
		"1a":
			return desert_trees[0]
		"1b":
			return desert_trees[1]
		"2a":
			return desert_trees[2]
		"2b":
			return desert_trees[3]

# FRUITLESS TREES #

func returnTreeObject(treeType):
	match treeType:
		"A":
			return A_tree 
		"B":
			return B_tree
		"C":
			return C_tree 
		"D":
			return D_tree 
		"E":
			return E_tree

var A_tree = {
	growingStages = {
		0 : preload("res://Assets/Images/tree_sets/A/A_sapling.png"),
		1 : preload("res://Assets/Images/tree_sets/A/1.png"),
		2 : preload("res://Assets/Images/tree_sets/A/2.png"),
		3 : preload("res://Assets/Images/tree_sets/A/3.png"),
		4 : preload("res://Assets/Images/tree_sets/A/4.png"),
	},
	stump = preload("res://Assets/Images/tree_sets/A/stump.png"),
	bottomTree = preload("res://Assets/Images/tree_sets/A/bottom.png"),
	topTree = preload("res://Assets/Images/tree_sets/A/top.png"),
	chip = preload("res://Assets/Images/tree_sets/A/chip.png"),
	leaves = preload("res://Assets/Images/tree_sets/A/leaves.png"),
	largeStump = preload("res://Assets/Images/tree_sets/A/large_stumpA.png"),
	topTreeWinter = preload("res://Assets/Images/tree_sets/A/A winter.png")
}

var B_tree = {
	growingStages = {
		0 : preload("res://Assets/Images/tree_sets/B/sapling.png"),
		1 : preload("res://Assets/Images/tree_sets/B/1.png"),
		2 : preload("res://Assets/Images/tree_sets/B/2.png"),
		3 : preload("res://Assets/Images/tree_sets/B/3.png"),
		4 : preload("res://Assets/Images/tree_sets/B/4.png"),
	},
	stump = preload("res://Assets/Images/tree_sets/B/stump.png"),
	bottomTree = preload("res://Assets/Images/tree_sets/B/bottom.png"),
	topTree = preload("res://Assets/Images/tree_sets/B/top.png"),
	chip = preload("res://Assets/Images/tree_sets/B/chip.png"),
	leaves = preload("res://Assets/Images/tree_sets/B/leaves.png"),
	largeStump = preload("res://Assets/Images/tree_sets/B/large_stumpB.png"),
	topTreeWinter = preload("res://Assets/Images/tree_sets/B/B winter.png")
}

var C_tree = {
	growingStages = {
		0 : preload("res://Assets/Images/tree_sets/C/sapling.png"),
		1 : preload("res://Assets/Images/tree_sets/C/1.png"),
		2 : preload("res://Assets/Images/tree_sets/C/2.png"),
		3 : preload("res://Assets/Images/tree_sets/C/3.png"),
		4 : preload("res://Assets/Images/tree_sets/C/4.png"),
	},
	stump = preload("res://Assets/Images/tree_sets/C/stump.png"),
	bottomTree = preload("res://Assets/Images/tree_sets/C/bottom.png"),
	topTree = preload("res://Assets/Images/tree_sets/C/top.png"),
	chip = preload("res://Assets/Images/tree_sets/C/chip.png"),
	leaves = preload("res://Assets/Images/tree_sets/C/leaves.png"),
	largeStump = preload("res://Assets/Images/tree_sets/C/large_stumpC.png"),
	topTreeWinter = preload("res://Assets/Images/tree_sets/C/C winter.png")
}

var D_tree = {
	growingStages = {
		0 : preload("res://Assets/Images/tree_sets/D/sapling.png"),
		1 : preload("res://Assets/Images/tree_sets/D/1.png"),
		2 : preload("res://Assets/Images/tree_sets/D/2.png"),
		3 : preload("res://Assets/Images/tree_sets/D/3.png"),
		4 : preload("res://Assets/Images/tree_sets/D/4.png"),
	},
	stump = preload("res://Assets/Images/tree_sets/D/stump.png"),
	bottomTree = preload("res://Assets/Images/tree_sets/D/bottom.png"),
	topTree = preload("res://Assets/Images/tree_sets/D/top.png"),
	chip = preload("res://Assets/Images/tree_sets/D/chip.png"),
	leaves = preload("res://Assets/Images/tree_sets/D/leaves.png"),
	largeStump = preload("res://Assets/Images/tree_sets/D/large_stumpD.png"),
	topTreeWinter = preload("res://Assets/Images/tree_sets/D/D winter.png")
}

var E_tree = {
	growingStages = {
		0 : preload("res://Assets/Images/tree_sets/E/sapling.png"),
		1 : preload("res://Assets/Images/tree_sets/E/1.png"),
		2 : preload("res://Assets/Images/tree_sets/E/2.png"),
		3 : preload("res://Assets/Images/tree_sets/E/3.png"),
		4 : preload("res://Assets/Images/tree_sets/E/4.png"),
	},
	stump = preload("res://Assets/Images/tree_sets/E/stump.png"),
	bottomTree = preload("res://Assets/Images/tree_sets/E/bottom.png"),
	topTree = preload("res://Assets/Images/tree_sets/E/top.png"),
	chip = preload("res://Assets/Images/tree_sets/E/chip.png"),
	leaves = preload("res://Assets/Images/tree_sets/E/leaves.png"),
	largeStump = preload("res://Assets/Images/tree_sets/E/large_stumpE.png"),
	topTreeWinter = preload("res://Assets/Images/tree_sets/E/E winter.png")
}


# BRANCH OBJECTS #
var tree_branch_objects = {
	0 : preload("res://Assets/Images/tree_sets/branch_objects/branch1.png"),
	1 : preload("res://Assets/Images/tree_sets/branch_objects/branch2.png"),
	2 : preload("res://Assets/Images/tree_sets/branch_objects/branch3.png"),
	3 : preload("res://Assets/Images/tree_sets/branch_objects/branch4.png"),
	4 : preload("res://Assets/Images/tree_sets/branch_objects/branch5.png"),
	5 : preload("res://Assets/Images/tree_sets/branch_objects/branch6.png"),
	6 : preload("res://Assets/Images/tree_sets/branch_objects/branch7.png"),
	7 : preload("res://Assets/Images/tree_sets/branch_objects/branch8.png"),
	8 : preload("res://Assets/Images/tree_sets/branch_objects/branch9.png"),
	9 : preload("res://Assets/Images/tree_sets/branch_objects/branch10.png"),
	10 : preload("res://Assets/Images/tree_sets/branch_objects/branch11.png"),
	11 : preload("res://Assets/Images/tree_sets/branch_objects/branch12.png"),
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
		0 : preload("res://Assets/Images/tree_sets/plum/growing/sapling.png"),
		1 : preload("res://Assets/Images/tree_sets/plum/growing/1.png"),
		2 : preload("res://Assets/Images/tree_sets/plum/growing/2.png"),
		3 : preload("res://Assets/Images/tree_sets/plum/growing/3.png"),
		4 : preload("res://Assets/Images/tree_sets/plum/growing/4.png"),
	},
	stump = preload("res://Assets/Images/tree_sets/plum/stump.png"),
	bottomTree = preload("res://Assets/Images/tree_sets/plum/bottom.png"),
	middleTree = preload("res://Assets/Images/tree_sets/plum/middle.png"),
	topTree = {
		0 : preload("res://Assets/Images/tree_sets/plum/tops/1.png"),
		1 : preload("res://Assets/Images/tree_sets/plum/tops/2.png"),
		2 : preload("res://Assets/Images/tree_sets/plum/tops/3.png"),
		3 : preload("res://Assets/Images/tree_sets/plum/tops/harvested.png"),
	},
	chip = preload("res://Assets/Images/tree_sets/plum/chip.png"),
	leaves = null,
}

var Pear_tree = {
	growingStages = {
		0 : preload("res://Assets/Images/tree_sets/pear/growing/sapling.png"),
		1 : preload("res://Assets/Images/tree_sets/pear/growing/1.png"),
		2 : preload("res://Assets/Images/tree_sets/pear/growing/2.png"),
		3 : preload("res://Assets/Images/tree_sets/pear/growing/3.png"),
		4 : preload("res://Assets/Images/tree_sets/pear/growing/4.png"),
	},
	stump = preload("res://Assets/Images/tree_sets/pear/stump.png"),
	bottomTree = preload("res://Assets/Images/tree_sets/pear/bottom.png"),
	middleTree = preload("res://Assets/Images/tree_sets/pear/middle.png"),
	topTree = {
		0 : preload("res://Assets/Images/tree_sets/pear/tops/1.png"),
		1 : preload("res://Assets/Images/tree_sets/pear/tops/2.png"),
		2 : preload("res://Assets/Images/tree_sets/pear/tops/3.png"),
		3 : preload("res://Assets/Images/tree_sets/pear/tops/harvested.png"),
	},
	chip = preload("res://Assets/Images/tree_sets/pear/chip.png"),
	leaves = null,
}

var Cherry_tree = {
	growingStages = {
		0 : preload("res://Assets/Images/tree_sets/cherry/growing/sapling.png"),
		1 : preload("res://Assets/Images/tree_sets/cherry/growing/1.png"),
		2 : preload("res://Assets/Images/tree_sets/cherry/growing/2.png"),
		3 : preload("res://Assets/Images/tree_sets/cherry/growing/3.png"),
		4 : preload("res://Assets/Images/tree_sets/cherry/growing/4.png"),
	},
	stump = preload("res://Assets/Images/tree_sets/cherry/stump.png"),
	bottomTree = preload("res://Assets/Images/tree_sets/cherry/bottom.png"),
	middleTree = preload("res://Assets/Images/tree_sets/cherry/middle.png"),
	topTree = {
		0 : preload("res://Assets/Images/tree_sets/cherry/tops/1.png"),
		1 : preload("res://Assets/Images/tree_sets/cherry/tops/2.png"),
		2 : preload("res://Assets/Images/tree_sets/cherry/tops/3.png"),
		3 : preload("res://Assets/Images/tree_sets/cherry/tops/harvested.png"),
	},
	chip = preload("res://Assets/Images/tree_sets/cherry/tree_chip.png"),
	leaves = null,
}

var Apple_tree = {
	growingStages = {
		0 : preload("res://Assets/Images/tree_sets/apple/growing/sapling.png"),
		1 : preload("res://Assets/Images/tree_sets/apple/growing/1.png"),
		2 : preload("res://Assets/Images/tree_sets/apple/growing/2.png"),
		3 : preload("res://Assets/Images/tree_sets/apple/growing/3.png"),
		4 : preload("res://Assets/Images/tree_sets/apple/growing/4.png"),
	},
	stump = preload("res://Assets/Images/tree_sets/apple/stump.png"),
	bottomTree = preload("res://Assets/Images/tree_sets/apple/bottom.png"),
	middleTree = preload("res://Assets/Images/tree_sets/apple/middle.png"),
	topTree = {
		0 : preload("res://Assets/Images/tree_sets/apple/tops/1.png"),
		1 : preload("res://Assets/Images/tree_sets/apple/tops/2.png"),
		2 : preload("res://Assets/Images/tree_sets/apple/tops/3.png"),
		3 : preload("res://Assets/Images/tree_sets/apple/tops/harvested.png"),
	},
	chip = preload("res://Assets/Images/tree_sets/apple/chip.png"),
	leaves = null,
}

# ORE OBJECTS #

func returnOreObject(oreType):
	match oreType:
		"Red gem":
			return Red_ore
		"Cyan gem": 
			return Cyan_ore
		"Dark blue gem":
			return Dark_blue_ore
		"Green gem":
			return Green_ore
		"Iron ore":
			return Iron_ore
		"Gold ore":
			return Gold_ore
		"Stone":
			return Stone_ore
		"Cobblestone":
			return Cobblestone_ore

var Red_ore = {
	largeOre = preload("res://Assets/Images/ore_sets/red/red_gemstone_large.png"),
	mediumOres = {
		0 : preload("res://Assets/Images/ore_sets/red/medium/red_gemstone_1.png"),
		1 : preload("res://Assets/Images/ore_sets/red/medium/red_gemstone_2.png"),
		2 : preload("res://Assets/Images/ore_sets/red/medium/red_gemstone_3.png"),
		3 : preload("res://Assets/Images/ore_sets/red/medium/red_gemstone_4.png"),
		4 : preload("res://Assets/Images/ore_sets/red/medium/red_gemstone_5.png"),
		5 : preload("res://Assets/Images/ore_sets/red/medium/red_gemstone_6.png"),
	},
	chip = preload("res://Assets/Images/ore_sets/red/red_chip.png")
}

var Cyan_ore = {
	largeOre = preload("res://Assets/Images/ore_sets/cyan/cyan_gemstone_large.png"),
	mediumOres = {
		0 : preload("res://Assets/Images/ore_sets/cyan/medium/cyan_gemstone_1.png"),
		1 : preload("res://Assets/Images/ore_sets/cyan/medium/teal_gemstone_2.png"),
		2 : preload("res://Assets/Images/ore_sets/cyan/medium/teal_gemstone_3.png"),
		3 : preload("res://Assets/Images/ore_sets/cyan/medium/teal_gemstone_4.png"),
		4 : preload("res://Assets/Images/ore_sets/cyan/medium/teal_gemstone_5.png"),
		5 : preload("res://Assets/Images/ore_sets/cyan/medium/teal_gemstone_6.png"),
	},
	chip = preload("res://Assets/Images/ore_sets/cyan/cyan_chip.png")
}

var Green_ore = {
	largeOre = preload("res://Assets/Images/ore_sets/green/green_gemstone_large.png"),
	mediumOres = {
		0 : preload("res://Assets/Images/ore_sets/green/medium/green_gemstone_1.png"),
		1 : preload("res://Assets/Images/ore_sets/green/medium/green_gemstone_2.png"),
		2 : preload("res://Assets/Images/ore_sets/green/medium/green_gemstone_3.png"),
		3 : preload("res://Assets/Images/ore_sets/green/medium/green_gemstone_4.png"),
		4 : preload("res://Assets/Images/ore_sets/green/medium/green_gemstone_5.png"),
		5 : preload("res://Assets/Images/ore_sets/green/medium/green_gemstone_6.png"),
	},
	chip = preload("res://Assets/Images/ore_sets/cyan/cyan_chip.png")
}

var Dark_blue_ore = {
	largeOre =  preload("res://Assets/Images/ore_sets/dark_blue/dark_blue_gemstone_large.png"),
	mediumOres = {
	0 : preload("res://Assets/Images/ore_sets/dark_blue/medium/dark_blue_gemstone_1.png"),
	1 : preload("res://Assets/Images/ore_sets/dark_blue/medium/dark_blue_gemstone_2.png"),
	2 : preload("res://Assets/Images/ore_sets/dark_blue/medium/dark_blue_gemstone_3.png"),
	3 : preload("res://Assets/Images/ore_sets/dark_blue/medium/dark_blue_gemstone_4.png"),
	4 : preload("res://Assets/Images/ore_sets/dark_blue/medium/dark_blue_gemstone_5.png"),
	5 : preload("res://Assets/Images/ore_sets/dark_blue/medium/dark_blue_gemstone_6.png"),
	},
	chip = preload("res://Assets/Images/ore_sets/dark_blue/chip.png")
}

var Iron_ore = {
	largeOre = preload("res://Assets/Images/ore_sets/iron/large.png"),
	mediumOres = {
	0 : preload("res://Assets/Images/ore_sets/iron/medium/1.png"),
	1 : preload("res://Assets/Images/ore_sets/iron/medium/2.png"),
	2 : preload("res://Assets/Images/ore_sets/iron/medium/3.png"),
	3 : preload("res://Assets/Images/ore_sets/iron/medium/4.png"),
	4 : preload("res://Assets/Images/ore_sets/iron/medium/5.png"),
	5 : preload("res://Assets/Images/ore_sets/iron/medium/6.png"),
	},
	chip = preload("res://Assets/Images/ore_sets/iron/chip.png")
}

var Gold_ore = {
	largeOre = preload("res://Assets/Images/ore_sets/gold/large.png"), 
	mediumOres = {
		0 : preload("res://Assets/Images/ore_sets/gold/medium/1.png"),
		1 : preload("res://Assets/Images/ore_sets/gold/medium/2.png"),
		2 : preload("res://Assets/Images/ore_sets/gold/medium/3.png"),
		3 : preload("res://Assets/Images/ore_sets/gold/medium/4.png"),
		4 : preload("res://Assets/Images/ore_sets/gold/medium/5.png"),
		5 : preload("res://Assets/Images/ore_sets/gold/medium/6.png"),
	},
	chip = preload("res://Assets/Images/ore_sets/gold/chip.png")
}

var Stone_ore = {
	largeOre = preload("res://Assets/Images/ore_sets/stone/stone_gemstone_large.png"),
	mediumOres = {
		0 : preload("res://Assets/Images/ore_sets/stone/medium/stone_gemstone_1.png"),
		1 : preload("res://Assets/Images/ore_sets/stone/medium/stone_gemstone_2.png"),
		2 : preload("res://Assets/Images/ore_sets/stone/medium/stone_gemstone_3.png"),
		3 : preload("res://Assets/Images/ore_sets/stone/medium/stone_gemstone_4.png"),
		4 : preload("res://Assets/Images/ore_sets/stone/medium/stone_gemstone_5.png"),
		5 : preload("res://Assets/Images/ore_sets/stone/medium/stone_gemstone_6.png"),
	},
	chip = preload("res://Assets/Images/ore_sets/stone/beige_stone_chip.png")
}

var Cobblestone_ore = {
	largeOre = preload("res://Assets/Images/ore_sets/cobblestone/cobblestone_gemstone_large.png"),
	mediumOres = {
		0 : preload("res://Assets/Images/ore_sets/cobblestone/medium/cobblestone_gemstone_1.png"),
		1 : preload("res://Assets/Images/ore_sets/cobblestone/medium/cobblestone_gemstone_2.png"),
		2 : preload("res://Assets/Images/ore_sets/cobblestone/medium/cobblestone_gemstone_3.png"),
		3 : preload("res://Assets/Images/ore_sets/cobblestone/medium/cobblestone_gemstone_4.png"),
		4 : preload("res://Assets/Images/ore_sets/cobblestone/medium/cobblestone_gemstone_5.png"),
		5 : preload("res://Assets/Images/ore_sets/cobblestone/medium/cobblestone_gemstone_6.png"),
	},
	chip = preload("res://Assets/Images/ore_sets/cobblestone/stone_chip.png")
}

func return_house_object(item_name):
	print(item_name)
	match item_name:
		"Bed":
			return bed
		"Crafting_table": 
			return crafting_table
		"Fireplace":
			return fireplace
		"Left_chair":
			return left_chair
		"Middle_chair":
			return middle_chair
		"Painting1":
			return painting1
		"Right_chair":
			return right_chair
		"Rug":
			return rug
		"Shelves":
			return shelves
		"Side_dresser":
			return side_dresser
		"Stool":
			return stool
		"Table":
			return table
		"Window 1":
			return window1
		"Window 2":
			return window2

var bed = preload("res://Assets/Images/house_objects/bed.png")
var crafting_table = preload("res://Assets/Images/house_objects/crafting_table.png")
var fireplace = preload("res://Assets/Images/house_objects/fireplace.png")
var left_chair = preload("res://Assets/Images/house_objects/left_chair.png")
var middle_chair = preload("res://Assets/Images/house_objects/middle_chair.png")
var painting1 = preload("res://Assets/Images/house_objects/painting1.png")
var right_chair = preload("res://Assets/Images/house_objects/right_chair.png")
var rug = preload("res://Assets/Images/house_objects/rug.png")
var shelves = preload("res://Assets/Images/house_objects/shelves.png")
var side_dresser = preload("res://Assets/Images/house_objects/side_dresser.png")
var small_dresser = preload("res://Assets/Images/house_objects/small_dresser.png")
var stool = preload("res://Assets/Images/house_objects/stool.png")
var table = preload("res://Assets/Images/house_objects/table.png")
var window1 = preload("res://Assets/Images/house_objects/window 1.png")
var window2 = preload("res://Assets/Images/house_objects/window 2.png")

