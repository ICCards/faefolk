extends Node

var thread := Thread.new()

var built_chunks = []
var current_chunks = []

func initialize():
	get_chunks()

func get_chunks():
	if Server.player_node:
		var loc = Server.player_node.position / 32
		var columns
		var rows
		var new_chunks = []
		var chunks_to_remove = []
		if loc.x < 218.75:
			columns = [1,2]
		elif loc.x < 281.25:
			columns = [2,3]
		elif loc.x < 343.75:
			columns = [3,4]
		elif loc.x < 406.25:
			columns = [4,5]
		elif loc.x < 468.75:
			columns = [5,6]
		elif loc.x < 531.25:
			columns = [6,7]
		elif loc.x < 593.75:
			columns = [7,8]
		elif loc.x < 656.25:
			columns = [8,9]
		elif loc.x < 718.75:
			columns = [9,10]
		elif loc.x < 781.25:
			columns = [10,11]
		else:
			columns = [11, 12]

		if loc.y < 218.75:
			rows = ["A","B"]
		elif loc.y < 281.25:
			rows = ["B","C"]
		elif loc.y < 343.75:
			rows = ["C","D"]
		elif loc.y < 406.25:
			rows = ["D","E"]
		elif loc.y < 468.75:
			rows = ["E","F"]
		elif loc.y < 531.25:
			rows = ["F","G"]
		elif loc.y < 593.75:
			rows = ["G","H"]
		elif loc.y < 656.25:
			rows = ["H","I"]
		elif loc.y < 718.75:
			rows = ["I","J"]
		elif loc.y < 781.25:
			rows = ["J","K"]
		else:
			rows = ["K","L"]
		for column in columns:
			for row in rows:
				new_chunks.append(row+str(column))
		if current_chunks == new_chunks:
			return
		current_chunks = new_chunks
		for new_chunk in new_chunks:
			if not built_chunks.has(new_chunk):
				built_chunks.append(new_chunk)
				print("SPAWN CHUNK " + new_chunk)

