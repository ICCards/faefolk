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
	$CropText.texture = load("res://Assets/Images/crop_sets/" + crop_name + "/"  + return_phase()  + ".png")
	MapData.connect("refresh_crops", self, "refresh_image")
	

func refresh_image():
	in_regrowth_phase = MapData.world["crops"][name]["rp"]
	days_until_harvest = MapData.world["crops"][name]["dh"]
	days_without_water = MapData.world["crops"][name]["dww"]
	$CropText.texture = load("res://Assets/Images/crop_sets/" + crop_name + "/"  + return_phase()  + ".png")


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
		$LeafEffect.show()
		$LeafEffect.playing = true
		$CropText.hide()
		Tiles.add_valid_tiles(location)
		isBeingHarvested = true
		yield(get_tree().create_timer(0.6), "timeout")
		intitiateItemDrop(crop_name, Vector2(16, 0), JsonData.crop_data[crop_name]["yield"])
		yield(get_tree().create_timer(1.0), "timeout")
		queue_free()
	
func harvest_and_keep_planted():
	if !isBeingHarvested:
		isBeingHarvested = true
		yield(get_tree().create_timer(0.6), "timeout")
		intitiateItemDrop(crop_name, Vector2(16, 0), JsonData.crop_data[crop_name]["yield"])
		MapData.world["crops"][name]["rp"] = true # start regrowth phase
		MapData.world["crops"][name]["dh"] = 1 # days until next harvest
		refresh_image()
		

func intitiateItemDrop(item, pos, yield_list):
	PlayerData.pick_up_item(item, 1, null)
	yield_list.shuffle()
	var amount = yield_list.front()
	PlayerData.player_data["collections"]["crops"][crop_name] += amount
	if amount > 1:
		InstancedScenes.intitiateItemDrop(item, position+Vector2(0,16), amount-1)
		

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
	MapData.remove_crop(name)
	queue_free()


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
