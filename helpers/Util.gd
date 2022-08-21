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
	
func string_to_vector2(string := "") -> Vector2:
	if string:
		var new_string: String = string
		new_string.erase(0, 1)
		new_string.erase(new_string.length() - 1, 1)
		var array: Array = new_string.split(", ")

		return Vector2(array[0], array[1])

	return Vector2.ZERO

		
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
			return Vector2(24, -20)
		"LEFT":
			return Vector2(-24, -20)
		"DOWN":
			return Vector2(0, -15)
