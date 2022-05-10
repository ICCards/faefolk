extends Node2D

var cropName
var daysUntilHarvest
var location
var phase
onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")

func initialize(cropNameInput, locationInput, daysUntilHarvestInput):
	cropName = cropNameInput
	location = locationInput
	daysUntilHarvest = daysUntilHarvestInput
	phase = return_phase(daysUntilHarvest)

func _ready():
	add_to_group("active_crops")
	$CropText.texture = load("res://Assets/Images/crop_sets/" + cropName + "/"  + phase  + ".png")


func delete_crop():
	queue_free() 
	

func return_phase(daysUntilHarvest):
	if daysUntilHarvest != 0: 
		var phase = daysUntilHarvest /  JsonData.crop_data[cropName]["DaysToGrow"] 
		if phase == 1:
			return "1"
		elif phase >= 0.75:
			return "2"
		elif phase >= 0.5:
			return "3"
		elif phase > 0:
			return "4"
	else:
		return "5"


func _on_Area2D_mouse_entered():
	if daysUntilHarvest == 0:
		Input.set_custom_mouse_cursor(preload("res://Assets/mouse cursors/Help Select.png"))


func _on_Area2D_mouse_exited():
	Input.set_custom_mouse_cursor(preload("res://Assets/mouse cursors/Normal Selects.png"))


func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("mouse_click") and daysUntilHarvest == 0:
		harvest()
	
var isBeingHarvested = false	
func harvest():
	if !isBeingHarvested:
		isBeingHarvested = true
		intitiateItemDrop(cropName, Vector2(), 1)
		Input.set_custom_mouse_cursor(preload("res://Assets/mouse cursors/Normal Selects.png"))
		PlayerFarmApi.remove_crop(location)
		queue_free()
		
		
func intitiateItemDrop(item, pos, amt):
	for _i in range(amt):
		var itemDrop = ItemDrop.instance()
		itemDrop.initItemDropType(item)
		get_parent().call_deferred("add_child", itemDrop)
		itemDrop.global_position = global_position + pos 


var bodyEnteredFlag = false

func play_sound_effect():
	if !bodyEnteredFlag and phase == "4" or phase == "5":
		#$SoundEffects.play()
		$AnimationPlayer.play("animate")


func _on_PlayAnimBox_body_entered(body):
	play_sound_effect()
	bodyEnteredFlag = true


func _on_PlayAnimBox_body_exited(body):
	bodyEnteredFlag = false
