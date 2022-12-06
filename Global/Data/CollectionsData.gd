extends Node


var skills = {
	"sword": 1,
	"bow": 1,
	"dark": 0,
	"electric": 0,
	"earth": 0,
	"fire": 0,
	"wind": 0,
	"ice": 0,
}

var skill_descriptions = {
	"sword": {1:{"n":"Sword swing","c":"1 energy","d":"A fast sword swipe."}, 2: {"n":"Sword defense","c":"1 energy","d":"Protects against incoming enemy projectiles."}, 3: {"n":"Enchantment","c":"1 mana","d":"Allows poison, ice or fire attacks."}, 4: {"n":"TBD","c":"TBD","d":"TBD"}},
	"bow": {1:{"n":"Single-shot","c":"1 energy, 1 arrow","d":"Shoots a single arrow projectile."}, 2: {"n":"Multi-shot","c":"1 energy, 3 arrows","d":"Shoots three arrow projectiles."}, 3: {"n":"Enchantment","c":"1 mana","d":"Allows poison, ice or fire attacks."}, 4: {"n":"Ricochet shot","c":"1 energy, 1 arrow","d":"Makes arrows bounce between close targets"}},
	"dark": {1:{"n":"Demon warrior","c":"1 mana","d":"..."}, 2: {"n":"Invisibility","c":"2 mana","d":"..."}, 3: {"n":"Demon mage","c":"5 mana","d":"..."}, 4: {"n":"Portal","c":"10 mana","d":"..."}},
	"electric": {1:{"n":"Electric chain","c":"1 mana","d":"..."}, 2: {"n":"Flash-step","c":"2 mana","d":"..."}, 3: {"n":"Stunned electric chain","c":"5 mana","d":"..."}, 4: {"n":"Lightning strike","c":"10 mana","d":"..."}},
	"earth": {1:{"n":"Electric chain","c":"1 mana","d":"..."}, 2: {"n":"Flash-step","c":"2 mana","d":"..."}, 3: {"n":"Stunned electric chain","c":"5 mana","d":"..."}, 4: {"n":"Lightning strike","c":"10 mana","d":"..."}},
	"fire": 0,
	"wind": 0,
	"ice": 0,
}

var forage = {
	"purple flower": 0,
	"blue flower": 0,
	"green flower": 0,
	"red flower": 0,
	"red clam": 0,
	"blue clam": 0,
	"pink clam": 0,
	"starfish": 0,
	"baby starfish": 0,
	"white pearl": 0,
	"blue pearl": 0,
	"pink pearl": 0,
	"dark green grass": 0,
	"green grass": 0,
	"red grass": 0,
	"yellow grass": 0,
}

var resources = {
	"wood": 0,
	"stone": 0,
	"coal": 0,
	"rope": 0,
	"bronze ore": 0,
	"iron ore": 0,
	"gold ore": 0,
	"aquamarine": 0,
	"emerald": 0,
	"ruby": 0,
	"sapphire": 0,
}

var crops = {
	"asparagus": 0,
	"blueberry": 0,
	"cabbage": 0,
	"carrot": 0,
	"cauliflower": 0,
	"corn": 0,
	"garlic": 0,
	"grape": 0,
	"green bean": 0,
	"honeydew melon": 0,
	"green pepper": 0,
	"jalapeno": 0,
	"potato": 0,
	"radish": 0,
	"red pepper": 0,
	"strawberry": 0,
	"sugar cane": 0,
	"tomato": 0,
	"wheat": 0,
	"yellow onion": 0,
	"yellow pepper": 0,
	"zucchini": 0,
}

var fish = {
	"eel": 0,
	"clownfish": 0,
	"halibut": 0,
	"anchovy": 0,
	"cisco": 0,
	"goldfish": 0,
	"betta": 0,
	"siberian whitefish": 0,
	"red salmon": 0,
	"catfish": 0,
	"koi": 0,
	"purple salmon": 0,
	"lingcod": 0,
	"tilapia": 0,
	"albacore": 0,
	"purple carp": 0,
	"dorado": 0,
	"blowfish": 0,
	"angler": 0,
	"seaweed": 0,
	"octopus": 0,
	"shrimp": 0,
	"crab": 0,
	"nelma": 0
}

var food = {
	"asparagus omelette": 0,
	"baked catfish": 0,
	"baked dorado": 0,
	"baked zucchini": 0,
	"blowfish tails": 0,
	"blueberry cake": 0,
	"blueberry pie": 0,
	"bread": 0,
	"calamari with tomatoes": 0,
	"cauliflower soup": 0,
	"cooked filet": 0,
	"cooked green beans": 0,
	"cooked wing": 0,
	"crab cakes": 0,
	"filet mignon": 0,
	"filet soup": 0,
	"filet with garlic mash": 0,
	"filet with tomatoes": 0,
	"grape pastry": 0,
	"green pepper soup": 0,
	"honeydew melon with sugar": 0,
	"mini grape tarts": 0,
	"mushroom soup": 0,
	"pepper and asparagus stir fry": 0,
	"potato soup": 0,
	"potatoes with asparagus": 0,
	"potatoes with green beans": 0,
	"radish soup": 0,
	"red pepper soup": 0,
	"sashimi": 0,
	"sauteed cabbage with garlic": 0,
	"scrambled eggs": 0,
	"seaweed salad": 0,
	"sliced tomatoes and potatoes": 0,
	"smoked jalapeno with eggs": 0,
	"spaghetti": 0,
	"spicy eel": 0,
	"spicy shrimps": 0,
	"strawberry cake": 0,
	"strawberry tart": 0,
	"sugar cane kheer": 0,
	"tomato sandwich": 0,
	"tomato soup": 0,
	"vegetable soup": 0,
	"wings with corn": 0,
	"yellow onion soup": 0,
	"yellow pepper soup": 0,
	"zucchini soup": 0
	
}


