extends Node

var rng = RandomNumberGenerator.new()

func returnOceanDay():
	rng.randomize()
	var temp = rng.randi_range(0, 100)
	if temp >= 80:
		return ["red snapper", "easy"]
	elif temp >= 65:
		return ["garden flounder", "easy"]
	elif temp >= 55:
		return ["blue crab", "medium"]
	elif temp >= 40:
		return ["royal red shrimp", "easy"]
	elif temp >= 32:
		return ["mahi mahi", "medium"]
	elif temp >= 25:
		return ["blue ribbon eel", "medium"]
	elif temp >= 17:
		return ["box turtle", "medium"]
	elif temp >= 10:
		return ["lobster", "medium"]
	elif temp >= 4:
		return ["man o' war jelly", "hard"]
	else:
		return ["blue ringed octopus", "hard"]

func returnOceanNight():
	rng.randomize()
	var temp = rng.randi_range(0, 100)
	if temp >= 75:
		return ["common sardine", "easy"]
	elif temp >= 55:
		return ["albino cichilid", "easy"]
	elif temp >= 40:
		return ["yellowtail amberjack", "medium"]
	elif temp >= 32:
		return ["baby clownfish", "easy"]
	elif temp >= 25:
		return ["golden seahorse", "medium"]
	elif temp >= 17:
		return ["rainbow trout", "medium"]
	elif temp >= 10:
		return ["royal starfish", "medium"]
	elif temp >= 4:
		return ["man o' war jelly", "hard"]
	else:
		return ["blue ringed octopus", "hard"]
