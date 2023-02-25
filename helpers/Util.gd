@tool
extends Node


# the percent chance something happens
func chance(num):
	randomize()

	if randi() % 100 <= num:  return true
	else:                     return false

# Util.choose(["one", "two"])   returns one or two
func choose(choices):
	randomize()

	var rand_index = randi() % choices.size()
	return choices[rand_index]

func tojson(body):
	var test_json_conv = JSON.new()
	test_json_conv.parse(body)
	var jsonParseResult: JSON = test_json_conv.get_data()
	return jsonParseResult.result	
	
func jsonParse(body):
	var stringResult: String = body.get_string_from_utf8()
	var test_json_conv = JSON.new()
	test_json_conv.parse(stringResult)
	var jsonParseResult: JSON = test_json_conv.get_data()
	return jsonParseResult.result

func toMessage(name, data):
	data["n"] = name
	return JSON.stringify(data).to_utf8_buffer()
	
#func string_to_vector2(string := "") -> Vector2:
#	if string:
#		var new_string: String = string
#		new_string.erase(0, 1)
#		new_string.erase(new_string.length() - 1, 1)
#		var array: Array = new_string.split(", ")
#
#		return Vector2(array[0], array[1])
#
#	return Vector2.ZERO

func string_to_vector2(string) -> Vector2:
	if string is String:
		var new_string: String = string
		new_string.left(1)
		new_string.left(-1)
		var array: Array = new_string.split(", ")

		return Vector2(array[0], array[1])

	return string


func capitalizeFirstLetter(string) -> String:
	return string.left(1).to_upper() + string.substr(1,-1)
	
func set_swing_position(_pos, _direction):
	match _direction:
		"UP":
			_pos += Vector2(0, -16)
		"DOWN":
			_pos += Vector2(0, 10)
		"LEFT":
			_pos += Vector2(-16, -4)
		"RIGHT":
			_pos += Vector2(16, -4)
	return _pos
	
func returnAdjustedWateringCanPariclePos(direction):
	match direction:
		"RIGHT":
			return Vector2(14, -10)
		"LEFT":
			return Vector2(-14, -10)
		"DOWN":
			return Vector2(0, -8)
			
func returnCategoryColor(category):
	match category:
		"Tool":
			return Color("ff2525")
		"Resource":
			return Color("00ffc3")
		"Crop":
			return Color("fffb00")
		"Seed":
			return Color("26ff00")
		"Food":
			return Color("eb00ff")
		"Placable object":
			return Color("806aff")
		"Construction":
			return Color("ff25f1")
		"Fish":
			return Color("ff6d00")
		"Forage":
			return Color("ffc500")
		"Magic":
			return Color("ff006c")
		"Potion":
			return Color("ff006c")
		"Mob":
			return Color("bb61ff")

func valid_holding_item_category(item_category):
	if item_category == "Resource" or item_category == "Seed" or item_category == "Food" or item_category == "Fish" or item_category == "Crop" or item_category == "Forage":
		return true
	return false
	
func return_adjusted_item_name(item_name):
	if item_name.substr(0,5) == "couch":
		return "couch"
	elif item_name.substr(0,5) == "chair":
		return "chair"
	elif item_name.substr(0,8) == "armchair":
		return "armchair"
	elif item_name.substr(0,9) == "large rug":
		return "large rug"
	elif item_name.substr(0,10) == "medium rug":
		return "medium rug"
	elif item_name.substr(0,9) == "small rug":
		return "small rug"
	elif item_name.substr(0,5) == "table":
		return "table"
	elif item_name.substr(0,3) == "bed":
		return "bed"
	elif item_name.substr(0,11) == "round table":
		return "round table"
	return item_name
	

func get_random_idle_pos(pos,max_move_dist):
	var random1 = randf_range(max_move_dist-200,max_move_dist)
	var random2 = randf_range(max_move_dist-200,max_move_dist)
	if Util.chance(50):
		random1*=-1
	if Util.chance(50):
		random2*=-1
	if Tiles.valid_tiles.get_cellv(Tiles.valid_tiles.local_to_map(pos+Vector2(random1,random2))) != -1:
		return pos+Vector2(random1,random2)
	elif Tiles.valid_tiles.get_cellv(Tiles.valid_tiles.local_to_map(pos-Vector2(random1,random2))) != -1:
		return pos-Vector2(random1,random2)
	else:
		return pos


func add_to_collection(type, amt):
	if type != "stone1" and type != "stone2":
		PlayerData.player_data["collections"]["resources"][type] += amt
	else:
		PlayerData.player_data["collections"]["resources"]["stone"] += amt
		
		
func isFruitTree(tree_name):
	if tree_name == "cherry" or tree_name == "apple" or tree_name == "plum" or tree_name == "pear":
		return true
	return false

func isNonFruitTree(tree_name):
	if tree_name == "oak" or tree_name == "pine" or tree_name == "birch" or tree_name == "spruce" or tree_name == "evergreen":
		return true
	return false

func return_advanced_tree_phase(current_phase):
	match current_phase:
		"sapling":
			return "1"
		"1":
			return "2"
		"2":
			return "3"
		"3":
			return "4"
		"4":
			return "5"

func return_advanced_fruit_tree_phase(current_phase):
	match current_phase:
		"sapling":
			return "1"
		"1":
			return "2"
		"2":
			return "3"
		"3":
			return "4"
		"4":
			return "empty"
		"empty":
			if PlayerData.player_data["season"] == "fall":
				return "mature1"
			return "empty"
		"mature1":
			if PlayerData.player_data["season"] == "fall":
				return "mature2"
			return "empty"
		"mature2":
			if PlayerData.player_data["season"] == "fall":
				return "harvest"
			return "empty"


func isStorageItem(item_name):
	if item_name == "wood box" or item_name == "wood barrel" or item_name == "wood chest" or \
	item_name == "stone chest" or item_name == "tool cabinet" or item_name == "furnace" or \
	item_name == "stove #1" or item_name == "stove #2" or item_name == "stove #3" or \
	item_name == "grain mill #1" or item_name == "grain mill #2" or item_name == "grain mill #3" or \
	item_name == "campfire":
		return true
	return false


func isSword(item_name):
	if item_name == "wood sword" or item_name == "stone sword" or item_name == "iron sword" or item_name == "bronze sword" or item_name == "gold sword":
		return true
	return false


func isValidEnemyAttack(los) -> bool:
	var collider = los.get_collider()
	if collider and (collider.name == "WallTiles" or collider.name == "DoorMovementCollision" or collider.name == "SwordBlock"):
		return false
	return true

func is_border_tile(_pos, _tiles):
	var count = 0
	if not _tiles.has(_pos+Vector2(1,0)):
		return true
	if not _tiles.has(_pos+Vector2(-1,0)):
		return true
	if not  _tiles.has(_pos+Vector2(0,1)):
		return true
	if not _tiles.has(_pos+Vector2(0,-1)):
		return true
	return false

