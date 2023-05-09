extends Node


const MIN_PLACE_OBJECT_DISTANCE = 50

const DISTANCE_TO_SPAWN_OBJECT = 30
const DISTANCE_TO_REMOVE_OBJECT = 50

const VALID_TILE_ATLAS_CORD = Vector2i(0,0)
const NAVIGATION_TILE_ATLAS_CORD = Vector2i(1,0)

const dimensions_dict = {
	"furnace" : Vector2(1,1),
	"crate" : Vector2(1,1),
	"wood fence" : Vector2(1,1),
	"wood gate": Vector2(2,1),
	"stone fence" : Vector2(1,1),
	"stone gate": Vector2(2,1),
	"metal fence" : Vector2(1,1),
	"metal gate": Vector2(2,1),
	"barrel" : Vector2(1,1),
	"display table" : Vector2(1,1),
	"campfire" : Vector2(1,1),
	"torch" : Vector2(1,1),
	"tool cabinet": Vector2(2,1),
	"chest": Vector2(2,1),
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
	"metal door": Vector2(2,1),
	"armored door": Vector2(2,1),
	"fireplace": Vector2(2,1),
	"double cabinet": Vector2(2,1),
	"single cabinet": Vector2(1,1),
	"lamp": Vector2(1,1),
	"wall art": Vector2(1,1),
}

var object_atlas_tiles = {
	"crate": Vector2i(0,0),
	"barrel": Vector2i(0,2),
	"wood fence": Vector2i(26,68),
	"stone fence": Vector2i(26,73),
	"metal fence": Vector2i(26,78),
	"well" : Vector2i(0,84),
	"display table": Vector2i(5,81),
	"campfire": Vector2i(0,64),
	"torch": Vector2i(0,62),
}

var autotile_object_atlas_tiles = {
	"wood fence": 0,
	"stone fence": 1,
	"metal fence": 2,
	"display table": 3
}

var customizable_object_atlas_tiles = {
	"bed" : {
		1: Vector2i(0,31),
		2: Vector2i(2,31),
		3: Vector2i(4,31),
		4: Vector2i(6,31),
		5: Vector2i(8,31),
		6: Vector2i(10,31),
		7: Vector2i(12,31),
		8: Vector2i(14,31),
		9: Vector2i(16,31),
		10: Vector2i(18,31),
		11: Vector2i(20,31),
	},
	"round table" : {
		1: Vector2i(0,39),
		2: Vector2i(2,39),
		3: Vector2i(4,39),
		4: Vector2i(6,39),
		5: Vector2i(8,39),
	},
	"large rug" : {
		1: Vector2i(0,50),
		2: Vector2i(7,50),
		3: Vector2i(14,50),
		4: Vector2i(21,50),
		5: Vector2i(28,50),
		6: Vector2i(35,50),
		7: Vector2i(42,50),
		8: Vector2i(49,50),
		9: Vector2i(56,50),
		10: Vector2i(63,50),
	},
	"medium rug" : {
		1: Vector2i(4,50),
		2: Vector2i(11,50),
		3: Vector2i(18,50),
		4: Vector2i(25,50),
		5: Vector2i(32,50),
		6: Vector2i(39,50),
		7: Vector2i(46,50),
		8: Vector2i(53,50),
		9: Vector2i(60,50),
		10: Vector2i(67,50),
	},
	"small rug" : {
		1: Vector2i(6,50),
		2: Vector2i(13,50),
		3: Vector2i(20,50),
		4: Vector2i(27,50),
		5: Vector2i(34,50),
		6: Vector2i(41,50),
		7: Vector2i(48,50),
		8: Vector2i(55,50),
		9: Vector2i(62,50),
		10: Vector2i(69,50),
	},
	"dresser" : {
		1: Vector2i(0,92),
		2: Vector2i(2,92),
		3: Vector2i(4,92),
		4: Vector2i(6,92),
		5: Vector2i(8,92),
		6: Vector2i(10,92),
		7: Vector2i(12,92),
		8: Vector2i(14,92),
		9: Vector2i(16,92),
		10: Vector2i(18,92),
		11: Vector2i(20,92),
		12: Vector2i(20,92),
		13: Vector2i(22,91),
		14: Vector2i(24,92),
	},
	"double cabinet" : {
		1: Vector2i(0,96),
		2: Vector2i(2,96),
		3: Vector2i(4,96),
		4: Vector2i(7,96),
		5: Vector2i(9,96),
		6: Vector2i(11,96),
		7: Vector2i(13,96),
		8: Vector2i(15,96),
		9: Vector2i(17,96),
		10: Vector2i(19,96),
		11: Vector2i(21,96),
		12: Vector2i(23,96),
	},
	"single cabinet" : {
		1: Vector2i(0,98),
		2: Vector2i(1,98),
		3: Vector2i(2,98),
		4: Vector2i(3,98),
		5: Vector2i(4,98),
		6: Vector2i(5,98),
	},
	"lamp" : {
		1: Vector2i(0,100),
		2: Vector2i(2,100),
		3: Vector2i(4,100),
		4: Vector2i(6,100),
		5: Vector2i(8,100),
		6: Vector2i(10,100),
		7: Vector2i(12,100),
		8: Vector2i(14,100),
		9: Vector2i(16,100),
		10: Vector2i(18,100),
		11: Vector2i(20,100),
		12: Vector2i(22,99),
	},
	"fireplace": {
		1: Vector2i(0,103),
		2: Vector2i(18,103)
	},
	"stool": {
		1: Vector2i(0,83),
		2: Vector2i(1,83),
		3: Vector2i(2,83)
	},
	"wall art": {
		1: Vector2i(0,108),
		2: Vector2i(1,108),
		3: Vector2i(2,108),
		4: Vector2i(3,108),
	}
	
}


var customizable_rotatable_object_atlas_tiles = {
	"chair" : {
		1 : {
			"left": Vector2i(0,34),
			"right": Vector2i(1,34),
			"down": Vector2i(2,34),
			"up": Vector2i(3,34),
		},
		2 : {
			"left": Vector2i(4,34),
			"right": Vector2i(5,34),
			"down": Vector2i(6,34),
			"up": Vector2i(7,34),
		},
		3 : {
			"left": Vector2i(8,34),
			"right": Vector2i(9,34),
			"down": Vector2i(10,34),
			"up": Vector2i(11,34),
		},
		4 : {
			"left": Vector2i(12,34),
			"right": Vector2i(13,34),
			"down": Vector2i(14,34),
			"up": Vector2i(15,34),
		},
		5 : {
			"left": Vector2i(16,34),
			"right": Vector2i(17,34),
			"down": Vector2i(18,34),
			"up": Vector2i(19,34),
		},
		6 : {
			"left": Vector2i(20,34),
			"right": Vector2i(21,34),
			"down": Vector2i(22,34),
			"up": Vector2i(23,34),
		},
		7 : {
			"left": Vector2i(24,34),
			"right": Vector2i(25,34),
			"down": Vector2i(26,34),
			"up": Vector2i(27,34),
		},
	},
	"armchair" : {
		1 : {
			"left": Vector2i(0,36),
			"right": Vector2i(2,36),
			"down": Vector2i(4,36),
			"up": Vector2i(6,36),
		},
		2 : {
			"left": Vector2i(8,36),
			"right": Vector2i(10,36),
			"down": Vector2i(12,36),
			"up": Vector2i(14,36),
		},
		3 : {
			"left": Vector2i(16,36),
			"right": Vector2i(18,36),
			"down": Vector2i(20,36),
			"up": Vector2i(22,36),
		},
		4 : {
			"left": Vector2i(24,36),
			"right": Vector2i(26,36),
			"down": Vector2i(28,36),
			"up": Vector2i(30,36),
		},
		5 : {
			"left": Vector2i(32,36),
			"right": Vector2i(34,36),
			"down": Vector2i(36,36),
			"up": Vector2i(38,36),
		},
	},
	"table": {
		1 : {
			"left": Vector2i(2,43),
			"right": Vector2i(2,43),
			"down": Vector2i(0,42),
			"up": Vector2i(0,42),
		},
		2 : {
			"left": Vector2i(7,43),
			"right": Vector2i(7,43),
			"down": Vector2i(5,42),
			"up": Vector2i(5,42),
		},
		3 : {
			"left": Vector2i(12,43),
			"right": Vector2i(12,43),
			"down": Vector2i(10,42),
			"up": Vector2i(10,42),
		},
		4 : {
			"left": Vector2i(17,43),
			"right": Vector2i(17,43),
			"down": Vector2i(15,42),
			"up": Vector2i(15,42),
		},
		5 : {
			"left": Vector2i(22,43),
			"right": Vector2i(22,43),
			"down": Vector2i(20,42),
			"up": Vector2i(20,42),
		},
	},
	"couch": {
		1 : {
			"left": Vector2i(8,46),
			"right": Vector2i(6,46),
			"down": Vector2i(0,47),
			"up": Vector2i(3,47),
		},
		2 : {
			"left": Vector2i(18,46),
			"right": Vector2i(16,46),
			"down": Vector2i(10,47),
			"up": Vector2i(13,47),
		},
		3 : {
			"left": Vector2i(28,46),
			"right": Vector2i(26,46),
			"down": Vector2i(20,47),
			"up": Vector2i(23,47),
		},
	},
	"wood door": {
		1: {
			"down": Vector2i(0,53),
			"up": Vector2i(0,53),
			"right": Vector2i(0,57),
			"left": Vector2i(0,57)
		},
		2: {
			"down": Vector2i(25,53),
			"up": Vector2i(25,53),
			"right": Vector2i(25,57),
			"left": Vector2i(25,57)
		},
	},
	"metal door": {
		1: {
			"down": Vector2i(5,53),
			"up": Vector2i(5,53),
			"right": Vector2i(5,57),
			"left": Vector2i(5,57)
		},
	},
	"armored door": {
		1: {
			"down": Vector2i(10,53),
			"up": Vector2i(10,53),
			"right": Vector2i(10,57),
			"left": Vector2i(10,57)
		},
		2: {
			"down": Vector2i(15,53),
			"up": Vector2i(15,53),
			"right": Vector2i(15,57),
			"left": Vector2i(15,57)
		},
		3: {
			"down": Vector2i(20,53),
			"up": Vector2i(20,53),
			"right": Vector2i(20,57),
			"left": Vector2i(20,57)
		},
	},
	"chest": {
		1: {
			"up": Vector2i(6,12),
			"right": Vector2i(19,11),
			"down": Vector2i(0,12),
			"left": Vector2i(12,11)
			},
		2: {
			"up": Vector2i(6,15),
			"right": Vector2i(19,14),
			"down": Vector2i(0,15),
			"left": Vector2i(12,14)
		},
		3: {
			"up": Vector2i(26,12),
			"right": Vector2i(39,11),
			"down": Vector2i(20,12),
			"left": Vector2i(32,11)
			},
		4: {
			"up": Vector2i(26,15),
			"right": Vector2i(39,14),
			"down": Vector2i(20,15),
			"left": Vector2i(32,14)
		}
	},
	"furnace": {
		1: {
			"up": Vector2i(0,4),
			"right": Vector2i(1,4),
			"down": Vector2i(2,4),
			"left": Vector2i(3,4)
		},
		2: {
			"up": Vector2i(4,4),
			"right": Vector2i(5,4),
			"down": Vector2i(6,4),
			"left": Vector2i(7,4)
		},
		
	},
}

var rotatable_object_atlas_tiles = {
	"tool cabinet": {
		"up": Vector2i(3,8),
		"right": Vector2i(0,7),
		"down": Vector2i(1,8),
		"left": Vector2i(5,7)
	},
	"workbench #1": {
		"down": Vector2i(0,17),
		"up": Vector2i(2,17),
		"right": Vector2i(4,17),
		"left": Vector2i(5,17)
	},
	"workbench #2": {
		"down": Vector2i(6,17),
		"up": Vector2i(8,17),
		"right": Vector2i(10,17),
		"left": Vector2i(11,17)
	},
	"workbench #3": {
		"down": Vector2i(12,17),
		"up": Vector2i(14,17),
		"right": Vector2i(16,17),
		"left": Vector2i(17,17)
	},
	"stove #1": {
		"down": Vector2i(0,20),
		"up": Vector2i(2,20),
		"right": Vector2i(4,20),
		"left": Vector2i(5,20)
	},
	"stove #2": {
		"down": Vector2i(6,20),
		"up": Vector2i(8,20),
		"right": Vector2i(10,20),
		"left": Vector2i(11,20)
	},
	"stove #3": {
		"down": Vector2i(12,20),
		"up": Vector2i(14,20),
		"right": Vector2i(16,20),
		"left": Vector2i(17,20)
	},
	"grain mill #1": {
		"down": Vector2i(0,24),
		"up": Vector2i(2,24),
		"right": Vector2i(4,24),
		"left": Vector2i(5,24)
	},
	"grain mill #2": {
		"down": Vector2i(6,24),
		"up": Vector2i(8,24),
		"right": Vector2i(10,24),
		"left": Vector2i(11,24)
	},
	"grain mill #3": {
		"down": Vector2i(12,24),
		"up": Vector2i(14,24),
		"right": Vector2i(16,24),
		"left": Vector2i(17,24)
	},
	"brewing table #1": {
		"down": Vector2i(0,27),
		"up": Vector2i(2,27),
		"right": Vector2i(4,27),
		"left": Vector2i(5,27)
	},
	"brewing table #2": {
		"down": Vector2i(6,27),
		"up": Vector2i(8,27),
		"right": Vector2i(10,27),
		"left": Vector2i(11,27)
	},
	"brewing table #3": {
		"down": Vector2i(12,27),
		"up": Vector2i(14,27),
		"right": Vector2i(16,27),
		"left": Vector2i(17,27)
	},
	"wood gate": {
		"down": Vector2i(0,68),
		"up": Vector2i(0,68),
		"right": Vector2i(12,66),
		"left": Vector2i(12,66)
	},
	"stone gate": {
		"down": Vector2i(0,73),
		"up": Vector2i(0,73),
		"right": Vector2i(12,71),
		"left": Vector2i(12,71)
	},
	"metal gate": {
		"down": Vector2i(0,78),
		"up": Vector2i(0,78),
		"right": Vector2i(12,76),
		"left": Vector2i(12,76)
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


var log_atlas_tile_cords = {
	1: Vector2i(13,31),
	2: Vector2i(14,31),
	3: Vector2i(15,31),
	4: Vector2i(13,32),
	5: Vector2i(14,32),
	6: Vector2i(15,32),
	7: Vector2i(13,33),
	8: Vector2i(14,33),
	9: Vector2i(15,33),
	10: Vector2i(13,34),
	11: Vector2i(14,34),
	12: Vector2i(15,34)
}

var large_ore_atlas_cords = {
	"stone1": Vector2i(8,2),
	"stone2": Vector2i(8,4),
	"bronze ore": Vector2i(8,6),
	"gold ore": Vector2i(3,2),
	"iron ore": Vector2i(3,4)
}

var small_ore_atlas_cords = {
	"stone1": {
		1: Vector2i(5,2),
		2: Vector2i(6,2),
		3: Vector2i(7,2),
		4: Vector2i(5,3),
		5: Vector2i(6,3),
		6: Vector2i(7,3),
	},
	"stone2": {
		1: Vector2i(5,4),
		2: Vector2i(6,4),
		3: Vector2i(7,4),
		4: Vector2i(5,5),
		5: Vector2i(6,5),
		6: Vector2i(7,5),
	},
	"gold ore": {
		1: Vector2i(0,2),
		2: Vector2i(1,2),
		3: Vector2i(2,2),
		4: Vector2i(0,3),
		5: Vector2i(1,3),
		6: Vector2i(2,3),
	},
	"iron ore": {
		1: Vector2i(0,4),
		2: Vector2i(1,4),
		3: Vector2i(2,4),
		4: Vector2i(0,5),
		5: Vector2i(1,5),
		6: Vector2i(2,5),
	},
	"bronze ore": {
		1: Vector2i(5,6),
		2: Vector2i(6,6),
		3: Vector2i(7,6),
		4: Vector2i(5,7),
		5: Vector2i(6,7),
		6: Vector2i(7,7),
	},
}

var weed_atlas_cords = {
	"A1": Vector2i(14,2),
	"A2": Vector2i(15,2),
	"A3": Vector2i(14,3),
	"A4": Vector2i(15,3),
	"B1": Vector2i(14,4),
	"B2": Vector2i(15,4),
	"B3": Vector2i(14,5),
	"B4": Vector2i(15,5),
	"C1": Vector2i(14,6),
	"C2": Vector2i(15,6),
	"C3": Vector2i(14,7),
	"C4": Vector2i(15,7),
	"D1": Vector2i(14,8),
	"D2": Vector2i(15,8),
	"D3": Vector2i(14,9),
	"D4": Vector2i(15,9),
}

