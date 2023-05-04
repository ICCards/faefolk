extends Node

var item_data: Dictionary
var crop_data: Dictionary
var world_data: Dictionary
#var player_data: Dictionary

var game_state: GameState

func _ready():
	item_data = LoadData("res://JSONData/ItemData.json")
	crop_data = LoadData("res://JSONData/CropData.json")
#	if not GameState.save_exists(): # Initial launch
#		world_data = LoadData("res://JSONData/NewWorld.json")
#		game_state = GameState.new()
#		game_state.world_state = world_data
#		game_state.player_state = PlayerData.starting_player_data
#		game_state.save_state()

func LoadData(file_path):
	var file_data = FileAccess.open(file_path, FileAccess.READ)
	var j = JSON.new()
	j.parse(file_data.get_as_text())
	return j.get_data()

