extends Node2D


var image 
var pos


func init(new_image, new_pos):
	pos = new_pos
	image = new_image



func _ready():
	$HouseImageTextureRect.texture = load("res://Assets/house_objects/" + image +  ".png")
	$CollisionBox.scale.x = JsonData.house_objects_data[image]["X"]
	$CollisionBox.scale.y = JsonData.house_objects_data[image]["Y"]
	$CollisionBox.position.x += (JsonData.house_objects_data[image]["X"] - 1) * 16
	$CollisionBox.position.y -= (JsonData.house_objects_data[image]["Y"] - 1) * 16
	$MouseInputBox.scale.x = JsonData.house_objects_data[image]["X"]
	$MouseInputBox.scale.y = JsonData.house_objects_data[image]["Y"]
	$MouseInputBox.position.x += (JsonData.house_objects_data[image]["X"] - 1) * 16
	$MouseInputBox.position.y -= (JsonData.house_objects_data[image]["Y"] - 1) * 16
	$ColorIndicator.scale.x = JsonData.house_objects_data[image]["X"]
	$ColorIndicator.scale.y = JsonData.house_objects_data[image]["Y"]
	$ColorIndicator.position = $ColorIndicator.position + Vector2(32, 0) + Vector2((JsonData.house_objects_data[image]["X"] - 1) * 32, 0 )
	$MovementCollision/CollisionShape2D.position.x += (JsonData.house_objects_data[image]["X"] - 1) * 16
	$MovementCollision/CollisionShape2D.position.y -= (JsonData.house_objects_data[image]["Y"] - 1) * 16
	$MovementCollision/CollisionShape2D.scale.x = JsonData.house_objects_data[image]["X"]
	$MovementCollision/CollisionShape2D.scale.y = JsonData.house_objects_data[image]["Y"]
	$MovementCollision/CollisionShape2D.disabled = !JsonData.house_objects_data[image]["CollisionEnabled"]
	# rug disable ysort
	if !JsonData.house_objects_data[image]["CollisionEnabled"]:
		z_index -= 1
	if image == "Fireplace":
		$LightFireplaceUI/LightFireplaceBox/CollisionShape2D.disabled = false
		$LightFireplaceUI/FireStone.visible = true
		if PlayerInventory.isFireplaceLit:
			$LightFireplaceUI/Fire.visible = true
			$LightFireplaceUI/Fire.playing = true
			$LightFireplaceUI/FireplaceLight.visible = true
			$LightFireplaceUI/FireCrackleSoundEffects.play()
	if image == "Window 1" or image == "Window 2":
		$WindowLightingUI/LargeLight.visible = true
		$WindowLightingUI/SmallLight.visible = true



func _on_MouseInputBox_input_event(viewport, event, shape_idx):
	var mousePos = get_global_mouse_position() + Vector2(-16, 16)
	mousePos = mousePos.snapped(Vector2(32,32))
	if event.is_action_pressed("mouse_click"):
		if moveItemFlag:
			for i in range(PlayerInventory.player_home.size()):
				if PlayerInventory.player_home[i][0] == image and !is_colliding_other_object and !validateTileBoundary(position / 32):
					PlayerInventory.player_home[i][1] = (mousePos / 32 - Vector2(0, 5))
					$ColorIndicator.visible = false
					moveItemFlag = false
					find_parent("InsidePlayerHome").is_moving_object = null
					$SoundEffects.play()
		elif !moveItemFlag and find_parent("InsidePlayerHome").is_moving_object == null:
			moveItemFlag = true
			find_parent("InsidePlayerHome").is_moving_object = true
			$SoundEffects.play()

var moveItemFlag = false

func validateTileBoundary(pos):
	if JsonData.house_objects_data[image]["FloorObject"]:
		if pos.x < 0 or pos.x + JsonData.house_objects_data[image]["X"] - 1 > 19 or pos.y - (JsonData.house_objects_data[image]["Y"] - 1) < 5 or pos.y > 14:
			return true
		else: 
			return false
	else:
		if pos.x < 0 or pos.x + JsonData.house_objects_data[image]["X"] - 1 > 19 or pos.y - (JsonData.house_objects_data[image]["Y"] - 1) < 2 or pos.y > 4:
			return true
		else:
			return false
		

func _physics_process(evemt):
	if moveItemFlag:
		$ColorIndicator.visible = true
		var mousePos = get_global_mouse_position() + Vector2(-16, 16)
		mousePos = mousePos.snapped(Vector2(32,32))
		position = mousePos 
		if is_colliding_other_object or validateTileBoundary(position / 32):
			$ColorIndicator.texture = load("res://Assets/red_square.png" )
		else:
			$ColorIndicator.texture = load("res://Assets/green_square.png")
	elif insideLightFireplaceArea:
		if Input.is_action_just_pressed("action"):
			light_fire()

var is_colliding_other_object = false

func _on_CollisionBox_area_exited(area):
	if $CollisionBox.get_overlapping_areas().size() <= 0:
		is_colliding_other_object = false

func _on_CollisionBox_area_entered(area):
	is_colliding_other_object = true



func light_fire():
	PlayerInventory.isFireplaceLit = !PlayerInventory.isFireplaceLit
	if PlayerInventory.isFireplaceLit:
		$LightFireplaceUI/Fire.visible = true
		$LightFireplaceUI/FireplaceLight.visible = true
		$LightFireplaceUI/Fire.playing = true
		$LightFireplaceUI/FireStartSoundEffects.play()
		yield(get_tree().create_timer(0.75), "timeout")
		$LightFireplaceUI/FireCrackleSoundEffects.play()
	else:
		$LightFireplaceUI/FireCrackleSoundEffects.stop()
		$LightFireplaceUI/Fire.visible = false
		$LightFireplaceUI/FireplaceLight.visible = false
		$LightFireplaceUI/Fire.playing = false
		
var insideLightFireplaceArea = false

func _on_LightFireplaceBox_area_entered(area):
	insideLightFireplaceArea = true


func _on_LightFireplaceBox_area_exited(area):
	insideLightFireplaceArea = false

