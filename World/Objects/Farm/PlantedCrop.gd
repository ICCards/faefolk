extends Node2D

var crop_name
var days_until_harvest
var days_without_water
var in_regrowth_phase
var location

var valid_tiles
var isBeingHarvested = false
var bodyEnteredFlag = false

var object_name = "crop"

func _ready():
	Tiles.remove_valid_tiles(location)
	$Crop/TileMap.set_cell(0,Vector2i(0,-1),0,Constants.crop_atlas_tiles[crop_name][return_phase()])
	#MapData.connect("refresh_crops",Callable(self,"refresh_crop"))


func refresh_crop():
	in_regrowth_phase = MapData.world["crop"][name]["rp"]
	days_until_harvest = MapData.world["crop"][name]["dh"]
	days_without_water = MapData.world["crop"][name]["dww"]
	$Crop/TileMap.set_cell(0,Vector2i(0,-1),0,Constants.crop_atlas_tiles[crop_name][return_phase()])


func return_phase():
	if days_without_water == 2 or not JsonData.crop_data[crop_name]["Seasons"].has(PlayerData.player_data["season"]):
		$CollisionShape2D.set_deferred("disabled", true)
		return "dead"
	elif days_until_harvest > 0: 
		$CollisionShape2D.set_deferred("disabled", true)
		if in_regrowth_phase:
			return "empty"
		else:
			var phase = days_until_harvest /  JsonData.crop_data[crop_name]["DaysToGrow"] 
			if phase == 1:
				return "seeds"
			elif JsonData.crop_data[crop_name]["GrowthImages"] == 3: 
				if phase >= 0.67:
					return "1"
				elif phase >= 0.33:
					return "2"
				elif phase > 0:
					return "3"
			elif JsonData.crop_data[crop_name]["GrowthImages"] == 4: 
				if phase >= 0.75:
					return "1"
				elif phase >= 0.5:
					return "2"
				elif phase > 0.25:
					return "3"
				elif phase > 0:
					return "4"
			elif JsonData.crop_data[crop_name]["GrowthImages"] == 5: 
				if phase >= 0.8:
					return "1"
				elif phase >= 0.6:
					return "2"
				elif phase > 0.4:
					return "3"
				elif phase > 0.2:
					return "4"
				elif phase > 0:
					return "5"
	$CollisionShape2D.set_deferred("disabled", false)
	return "harvest"

	
func harvest_and_remove():
	if !isBeingHarvested:
		crop_name
		$LeafEffect.show()
		$LeafEffect.play("havest")
		$Crop/TileMap.hide()
		Tiles.add_valid_tiles(location)
		isBeingHarvested = true
		await get_tree().create_timer(0.6).timeout
		yield_harvest(JsonData.crop_data[crop_name]["yield"])
		await get_tree().create_timer(1.0).timeout
		queue_free()
	
func harvest_and_keep_planted():
	if !isBeingHarvested:
		isBeingHarvested = true
		await get_tree().create_timer(0.6).timeout
		yield_harvest(JsonData.crop_data[crop_name]["yield"])
		MapData.world["crops"][name]["rp"] = true # start regrowth phase
		MapData.world["crops"][name]["dh"] = 1 # days until next harvest
		refresh_crop()
		

func yield_harvest(yield_list):
	yield_list.shuffle()
	var yield_amount = yield_list.front()
	PlayerData.player_data["collections"]["crops"][crop_name] += yield_amount
	if PlayerDataHelpers.can_item_be_added_to_inventory(crop_name, 1):
		Server.player_node.user_interface.get_node("ItemPickUpDialogue").item_picked_up(crop_name, 1)
		PlayerData.pick_up_item(crop_name, 1, null)
	else:
		Server.player_node.user_interface.get_node("ItemPickUpDialogue").item_picked_up("Inventory full!", 1)
		InstancedScenes.intitiateItemDrop(crop_name,position+Vector2(0,8),1)
	if yield_amount > 1:
		InstancedScenes.intitiateItemDrop(crop_name,position+Vector2(0,8),yield_amount-1)


func play_effect():
	var phase = return_phase()
	if !bodyEnteredFlag and phase == "3" or phase == "4" or phase == "5" or phase == "harvest" or phase == "empty":
		$RustleSound.volume_db = Sounds.return_adjusted_sound_db("sound", -24)
		$RustleSound.play()
		$AnimationPlayer.play("animate")
		
func _on_PlayAnimBox_body_entered(body):
	play_effect()
	bodyEnteredFlag = true


func _on_PlayAnimBox_body_exited(body):
	bodyEnteredFlag = false


func _on_HurtBox_area_entered(area):
	Tiles.add_valid_tiles(location)
	MapData.remove_object("crop",name,location)
	call_deferred("queue_free")


func harvest():
	$CollisionShape2D.set_deferred("disabled", true)
	if JsonData.crop_data[crop_name]["Perennial"]:
		harvest_and_keep_planted()
	else:
		harvest_and_remove()


func _on_VisibilityNotifier2D_screen_entered():
	show()

func _on_VisibilityNotifier2D_screen_exited():
	hide()
