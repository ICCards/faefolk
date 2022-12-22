extends Resource

class_name GameState

export var player_state = {}
export var world_state = {}
export var cave_state = {}

const GAME_STATE_PATH = "user://game_state.tres"

func save_player_state(value):
	player_state = player_state
	save_state()
	
func save_world_state(value):
	player_state = player_state
	save_state()
	
func save_cave_state(value):
	player_state = player_state
	save_state()
		


func save_state():
	var result = ResourceSaver.save(GAME_STATE_PATH, self)
	if(result == OK):
		print("saved player data")
	
func load_state():
	if ResourceLoader.exists(GAME_STATE_PATH):
		var game_State = ResourceLoader.load(GAME_STATE_PATH)
		if game_State is GameState: # Check that the data is valid
			player_state = game_State.player_state
			world_state = game_State.world_state
			cave_state = game_State.cave_state
