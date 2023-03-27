extends Node

var item_data: Dictionary
var crop_data: Dictionary
var world_data: Dictionary
var player_data: Dictionary

func _ready():
	item_data = LoadData("res://JSONData/ItemData.json")
	crop_data = LoadData("res://JSONData/CropData.json")

func LoadData(file_path):
	var file_data = FileAccess.open(file_path, FileAccess.READ)
	var j = JSON.new()
	j.parse(file_data.get_as_text())
	return j.get_data()

