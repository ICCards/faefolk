extends Node


const MIN_PLACE_OBJECT_DISTANCE = 50

const DISTANCE_TO_SPAWN_OBJECT = 40
const DISTANCE_TO_REMOVE_OBJECT = 80

const VALID_TILE_ATLAS_CORD = Vector2i(0,0)
const NAVIGATION_TILE_ATLAS_CORD = Vector2i(1,0)

const dimensions_dict = {
	"furnace" : Vector2(1,1),
	"crate" : Vector2(1,1),
	"wood fence" : Vector2(1,1),
	"barrel" : Vector2(1,1),
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

var object_atlas_tiles = {
	"crate": Vector2i(0,0),
	"barrel": Vector2i(0,2),
	"wood fence": Vector2i(26,67),
}

var autotile_object_atlas_tiles = {
	"wood fence": 0,
	"stone fence": 1,
	"metal fence": 2
}

var rotatable_atlas_tiles = {
	"furnace": {
		"up": Vector2i(0,2),
		"right": Vector2i(1,2),
		"down": Vector2i(2,2),
		"left": Vector2i(3,2)
	},
	"wood chest": {
		"up": Vector2i(6,12),
		"right": Vector2i(19,11),
		"down": Vector2i(0,12),
		"left": Vector2i(12,11)
	},
}


var crop_atlas_tiles = {
	"wheat" : {
		"seeds" : Vector2i(23,0),
		"1" : Vector2i(22,1),
		"2" : Vector2i(23,1),
		"3" : Vector2i(24,0),
		"harvest" : Vector2i(25,0),
		"dead" : Vector2i(26,0)
	},
	"potato": {
		"seeds": Vector2i(23,2),
		"1": Vector2i(22,3),
		"2": Vector2i(23,3),
		"3": Vector2i(24,2),
		"harvest": Vector2i(25,2),
		"dead": Vector2i(26,2)
		},
	"yellow onion": {
		"seeds": Vector2i(23,4),
		"1": Vector2i(22,5),
		"2": Vector2i(23,5),
		"3": Vector2i(24,4),
		"harvest": Vector2i(25,4),
		"dead": Vector2i(26,4)
		},
	"garlic": {
		"seeds": Vector2i(23,6),
		"1": Vector2i(22,7),
		"2": Vector2i(23,7),
		"3": Vector2i(24,6),
		"harvest": Vector2i(25,6),
		"dead": Vector2i(26,6),
		},
	"radish": {
		"seeds": Vector2i(23,8),
		"1": Vector2i(22,9),
		"2": Vector2i(23,9),
		"3": Vector2i(24,8),
		"harvest": Vector2i(25,8),
		"dead": Vector2i(26,8),
		},
	"carrot": {
		"seeds": Vector2i(23,10),
		"1": Vector2i(22,11),
		"2": Vector2i(23,11),
		"3": Vector2i(24,10),
		"harvest": Vector2i(25,10),
		"dead": Vector2i(26,10),
		},
	"cauliflower": {
		"seeds": Vector2i(23,12),
		"1": Vector2i(22,13),
		"2": Vector2i(23,13),
		"3": Vector2i(24,13),
		"harvest": Vector2i(25,13),
		"dead": Vector2i(26,12)
		},
	"lettuce": {
		"seeds": Vector2i(23,14),
		"1": Vector2i(22,15),
		"2": Vector2i(23,15),
		"3": Vector2i(24,15),
		"harvest": Vector2i(25,15),
		"dead": Vector2i(26,14)
		},
	"corn": {
		"seeds": Vector2i(29,0),
		"1": Vector2i(28,1),
		"2": Vector2i(29,1),
		"3": Vector2i(30,0),
		"4": Vector2i(31,0),
		"harvest": Vector2i(32,0),
		"empty": Vector2i(33,0),
		"dead": Vector2i(34,0)
		},
	"tomato": {
		"seeds": Vector2i(29,2),
		"1": Vector2i(28,3),
		"2": Vector2i(29,3),
		"3": Vector2i(30,2),
		"4": Vector2i(31,2),
		"harvest": Vector2i(32,2),
		"empty": Vector2i(33,2),
		"dead": Vector2i(34,2)
		},
	"red pepper": {
		"seeds": Vector2i(29,4),
		"1": Vector2i(28,5),
		"2": Vector2i(29,5),
		"3": Vector2i(30,4),
		"4": Vector2i(31,4),
		"harvest": Vector2i(32,4),
		"empty": Vector2i(33,4),
		"dead": Vector2i(34,4)
		},
	"yellow pepper": {
		"seeds": Vector2i(29,6),
		"1": Vector2i(28,7),
		"2": Vector2i(29,7),
		"3": Vector2i(30,6),
		"4": Vector2i(31,6),
		"harvest": Vector2i(32,6),
		"empty": Vector2i(33,6),
		"dead": Vector2i(34,6)
		},
	"green pepper": {
		"seeds": Vector2i(29,8),
		"1": Vector2i(28,9),
		"2": Vector2i(29,9),
		"3": Vector2i(30,8),
		"4": Vector2i(31,8),
		"harvest": Vector2i(32,8),
		"empty": Vector2i(33,8),
		"dead": Vector2i(34,8)
		},
	"zucchini": {
		"seeds": Vector2i(29,10),
		"1": Vector2i(28,11),
		"2": Vector2i(29,11),
		"3": Vector2i(30,10),
		"4": Vector2i(31,10),
		"harvest": Vector2i(32,10),
		"empty": Vector2i(33,10),
		"dead": Vector2i(34,10)
		},
	"asparagus": {
		"seeds": Vector2i(29,12),
		"1": Vector2i(28,13),
		"2": Vector2i(29,13),
		"3": Vector2i(30,12),
		"4": Vector2i(31,12),
		"harvest": Vector2i(32,12),
		"dead": Vector2i(33,12)
		},
	"strawberry": {
		"seeds": Vector2i(29,14),
		"1": Vector2i(28,15),
		"2": Vector2i(29,15),
		"3": Vector2i(30,14),
		"4": Vector2i(31,14),
		"harvest": Vector2i(32,14),
		"empty": Vector2i(33,14),
		"dead": Vector2i(34,14)
		},
	"grape": {
		"seeds": Vector2i(37,0),
		"1": Vector2i(38,0),
		"2": Vector2i(39,0),
		"3": Vector2i(40,0),
		"4": Vector2i(41,0),
		"harvest": Vector2i(42,0),
		"empty": Vector2i(43,0),
		"dead": Vector2i(44,0)
		},
	"green bean": {
		"seeds": Vector2i(37,2),
		"1": Vector2i(38,2),
		"2": Vector2i(39,2),
		"3": Vector2i(40,2),
		"4": Vector2i(41,2),
		"harvest": Vector2i(42,2),
		"empty": Vector2i(43,2),
		"dead": Vector2i(44,2)
		},
	"jalapeno": {
		"seeds": Vector2i(37,4),
		"1": Vector2i(38,4),
		"2": Vector2i(39,4),
		"3": Vector2i(40,4),
		"4": Vector2i(41,4),
		"harvest": Vector2i(42,4),
		"empty": Vector2i(43,4),
		"dead": Vector2i(44,4)
		},
	"honeydew melon": {
		"seeds": Vector2i(37,6),
		"1": Vector2i(36,7),
		"2": Vector2i(37,7),
		"3": Vector2i(38,6),
		"4": Vector2i(39,6),
		"5": Vector2i(40,6),
		"harvest": Vector2i(41,6),
		"empty": Vector2i(42,6),
		"dead": Vector2i(43,6)
		},
	"blueberry": {
		"seeds": Vector2i(37,8),
		"1": Vector2i(36,9),
		"2": Vector2i(37,9),
		"3": Vector2i(38,8),
		"4": Vector2i(39,8),
		"5": Vector2i(40,8),
		"harvest": Vector2i(41,8),
		"empty": Vector2i(42,8),
		"dead": Vector2i(43,8)
		},
	"sugar cane": {
		"seeds": Vector2i(37,10),
		"1": Vector2i(36,11),
		"2": Vector2i(37,11),
		"3": Vector2i(38,10),
		"4": Vector2i(39,10),
		"5": Vector2i(40,10),
		"harvest": Vector2i(41,10),
		"dead": Vector2i(42,10)
		},
		
}



