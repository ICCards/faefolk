extends Node


var thread = Thread.new()
#onready var api = Api

var mint_objects_queue = []

func _whoAmI(_value):
	print("THREAD FUNC!")
	#var result = api.mint(mint_objects_queue[0], "43emf-jxwxr-zvbvb-vojch-3a6um-mhe2d-if2bh-wefw3-3g52d-gjfos-vqe")
	call_deferred("loadDone")
	#return result

var wood_minted = 0
var stone_minted = 0

func loadDone():
	var value = thread.wait_to_finish()
	print(value)	
	if mint_objects_queue[0] == "wood":
		wood_minted += 1
	elif mint_objects_queue[0] == "stone ore":
		stone_minted += 1
	print("Wood minted: " + str(wood_minted) + " - Stone minted: " + str(stone_minted))
	mint_objects_queue.remove_at(0)
	if mint_objects_queue.size() > 0:
		if (thread.is_active()):
			# Already working
			return
		print("START THREAD!")
		thread.start(Callable(self,"_whoAmI").bind(null))
	

func mint_object(item_name):
	if mint_objects_queue.is_empty():
		mint_objects_queue.append(item_name)
		if (thread.is_active()):
			# Already working
			return
		print("START THREAD!")
		thread.start(Callable(self,"_whoAmI").bind(null))
	else: 
		mint_objects_queue.append(item_name)
