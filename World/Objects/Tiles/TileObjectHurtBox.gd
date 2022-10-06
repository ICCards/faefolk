extends Node2D


onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")

var rng = RandomNumberGenerator.new()
var location
var item_name
var id
var direction


func _ready():
	set_dimensions()
	#set_navigation_cutout()

func set_navigation_cutout():
	var polygon = get_node("/root/World/NavPolygon").get_navigation_polygon()
	var cutout = PoolVector2Array([position + Vector2(-16,-16), position + Vector2(-16,16), position + Vector2(16,16), position + Vector2(16,-16)])
	for new_point in cutout:
		for current_cutouts in Server.cutout_points:
			if current_cutouts.has(new_point):
				
				#add_points_to_existing_cutout()
				print("FOUND NEIGHBORING VERTICE")
				var new_cutout = current_cutouts
				for point in cutout:
					print("CHECK POINT " + str(point))
					if current_cutouts.has(new_point):
						new_cutout.append(point)
						print("NEW POINT " + str(point))
				new_cutout = remove_duplicate_vals(new_cutout)
				polygon.set_outline(Server.cutout_points.find(current_cutouts) + 1, new_cutout)
				polygon.make_polygons_from_outlines()
				get_node("/root/World/NavPolygon").set_navigation_polygon(polygon)
				return
	Server.cutout_points.append(cutout)
	polygon.add_outline(cutout)
	polygon.make_polygons_from_outlines()
	get_node("/root/World/NavPolygon").set_navigation_polygon(polygon)

func remove_duplicate_vals(array):
	var unique: PoolVector2Array = []

	for item in array:
		if not unique.has(item):
			unique.append(item)
		else:
			unique.remove(unique.find(item))
	print(unique)
	return unique

#			var cutout = PoolVector2Array([pos + Vector2(-31,-31), pos + Vector2(-31,31), pos + Vector2(31,31), pos + Vector2(31,-31)])
#			polygon.add_outline(cutout)
#			polygon.make_polygons_from_outlines()
#	$NavPolygon.set_navigation_polygon(polygon)
func PlayEffect(_player_id):
	$Light2D.enabled = false
	$HurtBox/CollisionShape2D.set_deferred("disabled", true)
	$DetectObjectOverPathBox/CollisionShape2D.set_deferred("disabled", true)
	Tiles.reset_valid_tiles(location, item_name)
	if item_name == "stone path" or item_name == "fire pedestal" or item_name == "tall fire pedestal":
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break stone.mp3")
	else: 
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break wood.mp3")
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
	$SoundEffects.play()
	yield($SoundEffects, "finished")
	queue_free()

func set_dimensions():
	rng.randomize()
	id = str(rng.randi_range(0, 100000))
	if item_name == "torch" or item_name == "campfire" or item_name == "fire pedestal" or item_name == "tall fire pedestal":
		$Light2D.enabled = true
	elif item_name == "wood chest" or item_name == "stone chest":
		$InteractiveArea/CollisionShape2D.disabled = false
		$InteractiveArea.collision_mask = 65536
		$InteractiveArea.name = id
		PlayerInventory.chests[id] = {}
		scale.x = 2.0
		position = position +  Vector2(16, 0)
	elif item_name == "workbench #1" or item_name == "workbench #2" or item_name == "workbench #3":
		$InteractiveArea/CollisionShape2D.disabled = false
		$InteractiveArea.collision_mask = 131072
		$InteractiveArea.name = item_name
		scale.x = 2.0
		position = position +  Vector2(16, 0)
	elif item_name == "stove #1" or item_name == "stove #2" or item_name == "stove #3":
		$InteractiveArea/CollisionShape2D.disabled = false
		$InteractiveArea.collision_mask = 262144
		$InteractiveArea.name = str(item_name.substr(7) + " " + id)
		PlayerInventory.stoves[id] = {}
		scale.x = 2.0
		position = position +  Vector2(16, 0)
	elif item_name == "grain mill #1" or item_name == "grain mill #2" or item_name == "grain mill #3":
		$InteractiveArea/CollisionShape2D.disabled = false
		$InteractiveArea.collision_mask = 524288
		$InteractiveArea.name = str(item_name.substr(12) + " " + id)
		PlayerInventory.grain_mills[id] = {}
		scale.x = 2.0
		position = position +  Vector2(16, 0)
	elif item_name == "furnace":
		$InteractiveArea/CollisionShape2D.disabled = false
		$InteractiveArea.collision_mask = 2097152
		$InteractiveArea.name = str(id)
		PlayerInventory.furnaces[id] = {}



func _on_HurtBox_area_entered(area):
	if area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	$Light2D.enabled = false
	$HurtBox/CollisionShape2D.set_deferred("disabled", true)
	$DetectObjectOverPathBox/CollisionShape2D.set_deferred("disabled", true)
	var data = {"id": name, "n": "decorations","t":"ON_HIT","name":item_name,"item":"placable"}
	Server.action("ON_HIT", data)
	if item_name == "stone path" or item_name == "fire pedestal" or item_name == "tall fire pedestal":
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break stone.mp3")
	elif item_name == "wood chest" or item_name == "stone chest":
		drop_items_in_chest()
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break wood.mp3")
	elif item_name == "grain mill #1" or item_name == "grain mill #2" or item_name == "grain mill #3":
		drop_items_in_grain_mill()
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break wood.mp3")
	elif item_name == "stove #1" or item_name == "stove #2" or item_name == "stove #3":
		drop_items_in_stove()
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break wood.mp3")
	else: 
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break wood.mp3")
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
	$SoundEffects.play()
	Tiles.reset_valid_tiles(location, item_name)
	InstancedScenes.intitiateItemDrop(item_name, position, 1)
	yield($SoundEffects, "finished")
	queue_free()


func drop_items_in_stove():
	for item in PlayerInventory.stoves[id].keys():
		InstancedScenes.initiateInventoryItemDrop(PlayerInventory.chests[id][item], position)
	PlayerInventory.stoves.erase(id)

func drop_items_in_grain_mill():
	for item in PlayerInventory.grain_mills[id].keys():
		InstancedScenes.initiateInventoryItemDrop(PlayerInventory.chests[id][item], position)
	PlayerInventory.grain_mills.erase(id)

func drop_items_in_chest():
	for item in PlayerInventory.chests[id].keys():
		InstancedScenes.initiateInventoryItemDrop(PlayerInventory.chests[id][item], position)
	PlayerInventory.chests.erase(id)


func _on_DetectObjectOverPathBox_area_entered(area):
	if item_name == "wood path" or item_name == "stone path":
		$HurtBox/CollisionShape2D.set_deferred("disabled", true)


func _on_DetectObjectOverPathBox_area_exited(area):
	if item_name == "wood path" or item_name == "stone path":
		yield(get_tree().create_timer(0.25), "timeout")
		$HurtBox/CollisionShape2D.set_deferred("disabled", false)

func _on_VisibilityNotifier2D_screen_entered():
	visible = true

func _on_VisibilityNotifier2D_screen_exited():
	visible = false
