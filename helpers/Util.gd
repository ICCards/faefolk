tool
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
  var jsonParseResult: JSONParseResult = JSON.parse(body)
  return jsonParseResult.result	
	
func jsonParse(body):
  var stringResult: String = body.get_string_from_utf8()
  var jsonParseResult: JSONParseResult = JSON.parse(stringResult)
  return jsonParseResult.result

func toMessage(name, data):
	data["n"] = name
	return JSON.print(data).to_utf8()
	
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
		new_string.erase(0, 1)
		new_string.erase(new_string.length() - 1, 1)
		var array: Array = new_string.split(", ")

		return Vector2(array[0], array[1])

	return string


		
func set_swing_position(_pos, _direction):
	match _direction:
		"UP":
			_pos += Vector2(0, -32)
		"DOWN":
			_pos += Vector2(0, 20)
		"LEFT":
			_pos += Vector2(-32, -8)
		"RIGHT":
			_pos += Vector2(32, -8)
	return _pos
	
func returnAdjustedWateringCanPariclePos(direction):
	match direction:
		"RIGHT":
			return Vector2(28, -20)
		"LEFT":
			return Vector2(-28, -20)
		"DOWN":
			return Vector2(0, -15)
			
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
	var random1 = rand_range(max_move_dist-200,max_move_dist)
	var random2 = rand_range(max_move_dist-200,max_move_dist)
	if Util.chance(50):
		random1*=-1
	if Util.chance(50):
		random2*=-1
	if Tiles.valid_tiles.get_cellv(Tiles.valid_tiles.world_to_map(pos+Vector2(random1,random2))) != -1:
		return pos+Vector2(random1,random2)
	elif Tiles.valid_tiles.get_cellv(Tiles.valid_tiles.world_to_map(pos-Vector2(random1,random2))) != -1:
		return pos-Vector2(random1,random2)
	else:
		return pos


func add_to_collection(type, amt):
	if type != "stone1" and type != "stone2":
		PlayerData.player_data["collections"]["resources"][type] += amt
	else:
		PlayerData.player_data["collections"]["resources"]["stone"] += amt
