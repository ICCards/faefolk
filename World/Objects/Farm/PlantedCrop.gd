extends Node2D

var crop_name
var days_until_harvest
var loc
var phase
var is_in_regrowth_phase
var crop_is_dead 
onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")


func PlayEffect(player_id):
	queue_free()

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

func refresh_image():
	phase = return_phase()
	$CropText.texture = load("res://Assets/Images/crop_sets/" + crop_name + "/"  + phase  + ".png")

func delete_crop():
	queue_free() 

#func return_if_crop_is_dead(if_crop_is_already_dead):
#	if if_crop_is_already_dead: #or !JsonData.crop_data[crop_name]["Seasons"].has(DayNightTimer.season):
#		PlayerFarmApi.set_crop_dead(loc)
#		return true
#	else:
#		return false

func return_phase():
	if crop_is_dead:
		return "dead"
	elif days_until_harvest != 0: 
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
	else:
		return "harvest"


func _on_Area2D_mouse_entered():
	if days_until_harvest == 0:
		Input.set_custom_mouse_cursor(preload("res://Assets/mouse cursors/Help Select.png"))


func _on_Area2D_mouse_exited():
	Input.set_custom_mouse_cursor(preload("res://Assets/mouse cursors/Normal Selects.png"))


func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("mouse_click") and phase == "harvest":
		if JsonData.crop_data[crop_name]["Perennial"]:
			harvest_and_keep_planted()
		else:
			harvest_and_remove()
	
var isBeingHarvested = false	
func harvest_and_remove():
	if !isBeingHarvested:
		var data = {"id": name, "n": "decorations","t":"seed"}
		Server.action("ON_HIT", data)
		$HarvestSound.play()
		$CropText.visible = false
		isBeingHarvested = true
		intitiateItemDrop(crop_name, Vector2(16, 0), JsonData.crop_data[crop_name]["yield"])
		Input.set_custom_mouse_cursor(preload("res://Assets/mouse cursors/Normal Selects.png"))
		yield($HarvestSound, "finished")
		queue_free()
	
func harvest_and_keep_planted():
	pass
#	if !isBeingHarvested:
#		$HarvestSound.volume_db = Sounds.return_adjusted_sound_db("sound", -24)
#		$HarvestSound.play()
#		isBeingHarvested = true
#		intitiateItemDrop(crop_name, Vector2(16, 0), JsonData.crop_data[crop_name]["yield"])
#		Input.set_custom_mouse_cursor(preload("res://Assets/mouse cursors/Normal Selects.png"))
#		PlayerFarmApi.set_crop_regrowth_phase(crop_name, location)
#		phase = "empty"
#		$CropText.texture = load("res://Assets/Images/crop_sets/" + crop_name + "/"  + phase  + ".png")
#		isBeingHarvested = false
		

func intitiateItemDrop(item, pos, yield_list):
	yield_list.shuffle()
	for _i in range(yield_list[0]):
		var itemDrop = ItemDrop.instance()
		itemDrop.initItemDropType(item)
		get_parent().call_deferred("add_child", itemDrop)
		itemDrop.global_position = global_position + pos 


var bodyEnteredFlag = false

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
	var data = {"id": name, "n": "decorations", "t":"seed"}
	Server.action("ON_HIT", data)
	queue_free()
