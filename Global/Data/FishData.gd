extends Node

var rng = RandomNumberGenerator.new()

func returnOceanDay():
	rng.randomize()
	var randomNumber = rng.randi_range(0,100)
	if randomNumber == 1:
		return ["octopus", "hard"]
	elif randomNumber <= 3:
		return ["angler", "hard"]
	elif randomNumber <= 13:
		return ["seaweed", "easy"]
	elif randomNumber <= 28:
		return ["shrimp", "easy"]
	elif randomNumber <= 43:
		return ["anchovy", "easy"]
	elif randomNumber <= 53:
		return ["crab", "easy"]
	elif randomNumber <= 68:
		return ["tilapia", "medium"]
	elif randomNumber <= 73:
		return ["eel", "medium"]
	elif randomNumber <= 83:
		return ["blowfish", "medium"]
	elif randomNumber <= 95:
		return ["halibut", "medium"]
	else: 
		return ["clownfish", "hard"]

