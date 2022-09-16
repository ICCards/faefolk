extends Node

var rng = RandomNumberGenerator.new()

func returnOceanDay():
	rng.randomize()
	var randomNumber = rng.randi_range(0,100)
	if randomNumber == 1:
		return ["octopus", "very hard"]
	elif randomNumber <= 3:
		return ["angler", "very hard"]
	elif randomNumber <= 13:
		return ["seaweed", "very easy"]
	elif randomNumber <= 28:
		return ["shrimp", "easy"]
	elif randomNumber <= 43:
		return ["anchovy", "easy"]
	elif randomNumber <= 53:
		return ["crab", "easy"]
	elif randomNumber <= 68:
		return ["tilapia", "medium2"]
	elif randomNumber <= 73:
		return ["eel", "medium1"]
	elif randomNumber <= 83:
		return ["blowfish", "medium1"]
	elif randomNumber <= 95:
		return ["halibut", "medium2"]
	else: 
		return ["clownfish", "hard"]

