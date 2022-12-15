extends Node2D

onready var ItemDrop = load("res://InventoryLogic/ItemDrop.tscn")

var id
var crop_name
var days_until_harvest
var loc
var phase
var is_in_regrowth_phase
var crop_is_dead 
var valid_tiles
var isBeingHarvested = false
var bodyEnteredFlag = false


func initialize(_crop_name, _loc, _days_until_harvest, _is_in_regrowth_phase, _is_crop_dead):
	crop_name = _crop_name
	loc = _loc
	days_until_harvest = _days_until_harvest
	is_in_regrowth_phase = _is_in_regrowth_phase
	crop_is_dead = false # return_if_crop_is_dead(_is_crop_dead)
	phase = return_phase()

func _ready():
	add_to_group("active_crops")
	$CropText.texture = load("res://Assets/Images/crop_sets/" + crop_name + "/"  + phase  + ".png")
	MapData.connect("refresh_crops", self, "refresh_image")
	

func refresh_image():
	days_until_harvest = MapData.world["crops"][id]["d"]
	phase = return_phase()
	$CropText.texture = load("res://Assets/Images/crop_sets/" + crop_name + "/"  + phase  + ".png")


#func return_if_crop_is_dead(if_crop_is_already_dead):
#	if if_crop_is_already_dead: #or !JsonData.crop_data[crop_name]["Seasons"].has(DayNightTimer.season):
#		PlayerFarmApi.set_crop_dead(loc)
#		return true
#	else:
#		return false

func return_phase():
	if crop_is_dead:
		return "dead"
	elif days_until_harvest > 0: 
		if is_in_regrowth_phase:
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
	return "harvest"


func _on_Area2D_input_event(viewport, event, shape_idx):
	pass
#	if Input.is_action_pressed("mouse_click") and phase == "harvest":
#		if JsonData.crop_data[crop_name]["Perennial"]:
#			harvest_and_keep_planted()
#		else:
#			harvest_and_remove()
	
func harvest_and_remove():
	if !isBeingHarvested:
		$LeafEffect.show()
		$LeafEffect.playing = true
		$HarvestSound.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
		$HarvestSound.play()
		$CropText.visible = false
		Tiles.add_valid_tiles(loc)
		isBeingHarvested = true
		yield(get_tree().create_timer(0.6), "timeout")
		phase = ""
		Input.set_custom_mouse_cursor(load("res://Assets/mouse cursors/Normal Selects.png"))
		intitiateItemDrop(crop_name, Vector2(16, 0), JsonData.crop_data[crop_name]["yield"])
		yield(get_tree().create_timer(1.0), "timeout")
		queue_free()
	
func harvest_and_keep_planted():
	if !isBeingHarvested:
		$HarvestSound.volume_db = Sounds.return_adjusted_sound_db("sound", -24)
		$HarvestSound.play()
		isBeingHarvested = true
		yield(get_tree().create_timer(0.6), "timeout")
		intitiateItemDrop(crop_name, Vector2(16, 0), JsonData.crop_data[crop_name]["yield"])
		phase = "empty"
		Input.set_custom_mouse_cursor(load("res://Assets/mouse cursors/Normal Selects.png"))
		$CropText.texture = load("res://Assets/Images/crop_sets/" + crop_name + "/"  + phase  + ".png")
		isBeingHarvested = false
		

func intitiateItemDrop(item, pos, yield_list):
	PlayerData.add_item_to_hotbar(item, 1, null)
	yield_list.shuffle()
	var amount = yield_list.front()
	if amount > 1:
		InstancedScenes.intitiateItemDrop(item, position+Vector2(0,16), amount-1)
		

func play_effect():
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
	Tiles.add_valid_tiles(loc)
	MapData.remove_crop(id)
	queue_free()



func _on_Harvest_pressed():
	if phase == "harvest" and \
	position.distance_to(Server.player_node.position) < 100 and \
	Server.player_node.state == 0 and \
	not isBeingHarvested:
		CollectionsData.crops[crop_name] += 1
		if JsonData.crop_data[crop_name]["Perennial"]:
			harvest_and_keep_planted()
		else:
			harvest_and_remove()
		Server.player_node.actions.harvest_crop(crop_name)


func _on_Harvest_mouse_entered():
	if phase == "harvest":
		set_mouse_cursor_type()

func set_mouse_cursor_type():
	if not $Harvest.disabled:
		if $DetectPlayer.get_overlapping_areas().size() >= 1:
			Input.set_custom_mouse_cursor(load("res://Assets/mouse cursors/harvest.png"))
		else:
			Input.set_custom_mouse_cursor(load("res://Assets/mouse cursors/harvest transparent.png"))

func _on_Harvest_mouse_exited():
	Input.set_custom_mouse_cursor(load("res://Assets/mouse cursors/Normal Selects.png"))


func _on_DetectPlayer_area_entered(area):
	if phase == "harvest" and $Harvest.is_hovered():
		set_mouse_cursor_type()

func _on_DetectPlayer_area_exited(area):
	if phase == "harvest" and $Harvest.is_hovered():
		set_mouse_cursor_type()

func _on_VisibilityNotifier2D_screen_entered():
	show()

func _on_VisibilityNotifier2D_screen_exited():
	hide()
