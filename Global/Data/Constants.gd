extends Node


const MIN_PLACE_OBJECT_DISTANCE = 100

const DISTANCE_TO_SPAWN_OBJECT = 40

var dimensions_dict = {
	"furnace" : Vector2(1,1),
	"wood box" : Vector2(1,1),
	"wood fence" : Vector2(1,1),
	"wood barrel" : Vector2(1,1),
	"display table" : Vector2(1,1),
	"campfire" : Vector2(1,1),
	"torch" : Vector2(1,1),
	"tool cabinet": Vector2(2,1),
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




