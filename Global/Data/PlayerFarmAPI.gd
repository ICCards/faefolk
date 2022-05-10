extends Node


# Name // Variety // Position // If grown tree or large ore
var player_farm_objects = []
func remove_farm_object(pos):
	for i in range(player_farm_objects.size()):
		if player_farm_objects[i][2] == pos:
			player_farm_objects.remove(i)
			return
	
# For large ore or trees
func set_farm_object_break(pos):
	for i in range(player_farm_objects.size() - 1):
		if player_farm_objects[i][2] == pos:
			player_farm_objects[i][3] = false

# Name // Location // IsWatered // DaysUntilHarvest
var planted_crops = []
func advance_day():
	for i in range(planted_crops.size()):
		if planted_crops[i][2]:
			planted_crops[i][2] = false
			if planted_crops[i][3] != 0:
				planted_crops[i][3] -= 1
			
func add_watered_tile(location):
	for i in range(planted_crops.size()):
		if planted_crops[i][1] == location:
			planted_crops[i][2] = true
			return
			
func remove_crop(location):
	for i in range(planted_crops.size()):
		if planted_crops[i][1] == location:
			planted_crops.remove(i)
			return



