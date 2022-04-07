extends Node2D

var cropName
var daysUntilHarvest
var location

func init(cropNameInput, locationInput):
	cropName = cropNameInput
	location = locationInput
	daysUntilHarvest = JsonData.crop_data[cropName]["DaysToGrow"]
	
func _ready():
	add_to_group("crops")
	$CropText.texture = load("res://Assets/crop_sets/" + cropName + "/1.png")

func advance_day():
	for i in range(200):
		if PlayerInventory.plantedCrops.has(i):
			if PlayerInventory.plantedCrops[i][1] == location and PlayerInventory.plantedCrops[i][2] == true and daysUntilHarvest != 0:
				daysUntilHarvest -= 1
				PlayerInventory.plantedCrops[i][2] = false
				$CropText.texture = load("res://Assets/crop_sets/" + cropName + "/" + return_phase(daysUntilHarvest) +  ".png")


func return_phase(daysUntilHarvest):
	if daysUntilHarvest != 0: 
		var phase = daysUntilHarvest /  JsonData.crop_data[cropName]["DaysToGrow"] 
		print(phase)
		if phase >= 0.75:
			return "2"
		elif phase >= 0.5:
			return "3"
		elif phase > 0:
			return "4"
	else:
		return "5"
