extends Node


const MIN_PLACE_OBJECT_DISTANCE = 50

const DISTANCE_TO_SPAWN_OBJECT = 40
const DISTANCE_TO_REMOVE_OBJECT = 80

const VALID_TILE_ATLAS_CORD = Vector2i(0,0)
const NAVIGATION_TILE_ATLAS_CORD = Vector2i(0,1)

const dimensions_dict = {
	"furnace" : Vector2(1,1),
	"wood box" : Vector2(1,1),
	"wood fence" : Vector2(1,1),
	"wood barrel" : Vector2(1,1),
	"display table" : Vector2(1,1),
	"campfire" : Vector2(1,1),
	"torch" : Vector2(1,1),
	"tool cabinet": Vector2(2,1),
	"preset stone chest": Vector2(2,1),
	"stone chest": Vector2(2,1),
	"wood chest": Vector2(2,1),
	"workbench #1": Vector2(2,1),
	"workbench #2": Vector2(2,1),
	"workbench #3": Vector2(2,1),
	"stove #1": Vector2(2,1),
	"stove #2": Vector2(2,1),
	"stove #3": Vector2(2,1),
	"grain mill #1": Vector2(2,1),
	"grain mill #2": Vector2(2,1),
	"grain mill #3": Vector2(2,1),
	"brewing table #1": Vector2(2,1),
	"brewing table #2": Vector2(2,1),
	"brewing table #3": Vector2(2,1),
	"chair": Vector2(1,1),
	"stool": Vector2(1,1),
	"well": Vector2(3,2),
	"dresser": Vector2(2,1),
	"table": Vector2(3,2),
	"couch": Vector2(3,2),
	"armchair": Vector2(2,2),
	"bed": Vector2(2,2),
	"large rug": Vector2(4,3),
	"medium rug": Vector2(2,2),
	"small rug": Vector2(1,1),
	"sleeping bag": Vector2(1,2),
	"round table": Vector2(2,2),
	"wood door": Vector2(2,1),
	"wood door side": Vector2(1,2),
	"metal door": Vector2(2,1),
	"metal door side": Vector2(1,2),
	"armored door": Vector2(2,1),
	"armored door side": Vector2(1,2),
	"wood gate": Vector2(2,1),
	"wood gate side": Vector2(1,2),
	
}



func return_crop_atlas_tile(crop_name,phase):
	match crop_name:
		"wheat":
			match phase:
				"seeds":
					return Vector2i(23,0)
				"1":
					return Vector2i(22,1)
				"2":
					return Vector2i(23,1)
				"3":
					return Vector2i(24,0)
				"harvest":
					return Vector2i(25,0)
				"dead":
					return Vector2i(26,0)
		"potato":
			match phase:
				"seeds":
					return Vector2i(23,2)
				"1":
					return Vector2i(22,3)
				"2":
					return Vector2i(23,3)
				"3":
					return Vector2i(24,2)
				"harvest":
					return Vector2i(25,2)
				"dead":
					return Vector2i(26,2)
		"yellow onion":
			match phase:
				"seeds":
					return Vector2i(23,4)
				"1":
					return Vector2i(22,5)
				"2":
					return Vector2i(23,5)
				"3":
					return Vector2i(24,4)
				"harvest":
					return Vector2i(25,4)
				"dead":
					return Vector2i(26,4)
		"garlic":
			match phase:
				"seeds":
					return Vector2i(23,6)
				"1":
					return Vector2i(22,7)
				"2":
					return Vector2i(23,7)
				"3":
					return Vector2i(24,6)
				"harvest":
					return Vector2i(25,6)
				"dead":
					return Vector2i(26,6)
		"radish":
			match phase:
				"seeds":
					return Vector2i(23,8)
				"1":
					return Vector2i(22,9)
				"2":
					return Vector2i(23,9)
				"3":
					return Vector2i(24,8)
				"harvest":
					return Vector2i(25,8)
				"dead":
					return Vector2i(26,8)
		"carrot":
			match phase:
				"seeds":
					return Vector2i(23,10)
				"1":
					return Vector2i(22,11)
				"2":
					return Vector2i(23,11)
				"3":
					return Vector2i(24,10)
				"harvest":
					return Vector2i(25,10)
				"dead":
					return Vector2i(26,10)
		"cauliflower":
			match phase:
				"seeds":
					return Vector2i(23,12)
				"1":
					return Vector2i(22,13)
				"2":
					return Vector2i(23,13)
				"3":
					return Vector2i(24,13)
				"harvest":
					return Vector2i(25,13)
				"dead":
					return Vector2i(26,12)
		"lettuce":
			match phase:
				"seeds":
					return Vector2i(23,14)
				"1":
					return Vector2i(22,15)
				"2":
					return Vector2i(23,15)
				"3":
					return Vector2i(24,15)
				"harvest":
					return Vector2i(25,15)
				"dead":
					return Vector2i(26,14)
		"corn":
			match phase:
				"seeds":
					return Vector2i(29,0)
				"1":
					return Vector2i(28,1)
				"2":
					return Vector2i(23,15)
				"3":
					return Vector2i(24,15)
				"harvest":
					return Vector2i(25,15)
				"dead":
					return Vector2i(26,14)
		


