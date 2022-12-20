extends Resource

class_name GameState

export var player_state = {}
export var world_state = {}
export var cave_state = {}

const GAME_STATE_PATH = "user://game_state.tres"

func save_state():
	var result = ResourceSaver.save(GAME_STATE_PATH, self)
	if(result == OK):
		print("saved player data")
	
func load_state():
	if ResourceLoader.exists(GAME_STATE_PATH):
		var playerState = ResourceLoader.load(GAME_STATE_PATH)
		if playerState is GameState: # Check that the data is valid
			return playerState
		else:
			return self		
	else:
		return self	
