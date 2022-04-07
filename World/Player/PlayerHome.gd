extends Node2D

onready var PlantCrop = preload("res://PlantCrop.gd")

func _ready():
	setup_crops()


func setup_crops():
	for i in range(200):
		if PlayerInventory.plantedCrops.has(i):
			var plantCrop = PlantCrop.instance()
			
	
