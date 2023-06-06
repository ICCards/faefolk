extends Resource

class_name GameState

@export var player_state = {}
@export var world = {}
@export var terrain = {}
## any other object here  and the the save and load methods that needs to be save

const GAME_STATE_PATH = "user://gamestate.tres"

var game_state: GameState

static func save_exists():
	return ResourceLoader.exists(GAME_STATE_PATH)

func save_state():
	var result = ResourceSaver.save(self, GAME_STATE_PATH, ResourceSaver.FLAG_NONE)
	if(result == OK):
		print("saved player data")

func load_state():
	if ResourceLoader.exists(GAME_STATE_PATH):
		var game_State = ResourceLoader.load(GAME_STATE_PATH)
		if game_State: #is GameState: # Check that the data is valid
			player_state = game_State.player_state
			world = game_State.world
			terrain = game_State.terrain
		PlayerData.player_data = player_state
		MapData.world = world
		MapData.terrain = terrain
