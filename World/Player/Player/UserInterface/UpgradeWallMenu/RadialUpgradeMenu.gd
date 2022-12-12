extends Control


onready var sound_effects: AudioStreamPlayer = $SoundEffects
var buttons = ["wood", "stone", "metal", "armored", "demolish"]
var current_index = -1
var location
var tile_node

func _ready():
	hide()

func initialize(_loc, _node):
	current_index = -1
	location = _loc
	tile_node = _node
	set_active_buttons()
	show()
	$Circle/AnimationPlayer.play("zoom")
	Server.player_node.get_node("Camera2D").set_process_input(false)
	PlayerData.viewInventoryMode = true


func _physics_process(delta):
	if not visible:
		return
	set_icon_position()
	if current_index != -1:
		$Title.show()
		$Title.text = buttons[current_index][0].to_upper() + buttons[current_index].substr(1,-1) + ":"
		$Resources.show()
		$Resources.bbcode_text = return_resource_cost_string(current_index)
	else:
		$Title.hide()
		$Resources.hide()
		
		
func return_resource_cost_string(index):
	match index:
		0:
			if PlayerData.return_resource_total("wood") >= 20:
				return "[center]20 x Wood ( [color=#00ff00]" + str(PlayerData.return_resource_total("wood")) + "[/color] )[/center]"
			else:
				return "[center]20 x Wood ( [color=#ff0000]" + str(PlayerData.return_resource_total("wood")) + "[/color] )[/center]"
		1:
			if PlayerData.return_resource_total("stone") >= 30:
				return "[center]30 x Stone ( [color=#00ff00]" + str(PlayerData.return_resource_total("stone")) + "[/color] )[/center]"
			else:
				return "[center]30 x Stone ( [color=#ff0000]" + str(PlayerData.return_resource_total("stone")) + "[/color] )[/center]"
		2:
			if PlayerData.return_resource_total("bronze ingot") >= 20:
				return "[center]20 x Bronze ingot ( [color=#00ff00]" + str(PlayerData.return_resource_total("bronze ingot")) + "[/color] )[/center]"
			else:
				return "[center]20 x Bronze ingot ( [color=#ff0000]" + str(PlayerData.return_resource_total("bronze ingot")) + "[/color] )[/center]"
		3:
			if PlayerData.return_resource_total("iron ingot") >= 25:
				return "[center]25 x Iron ingot ( [color=#00ff00]" + str(PlayerData.return_resource_total("iron ingot")) + "[/color] )[/center]"
			else:
				return "[center]25 x Iron ingot ( [color=#ff0000]" + str(PlayerData.return_resource_total("iron ingot")) + "[/color] )[/center]"
		4:
			return ""
	

func set_icon_position():
	match current_index:
		-1:
			$Circle/Icons/Wood.position = Vector2(0,-162)
			$Circle/Icons/Stone.position = Vector2(125, -75)
			$Circle/Icons/Demolish.position = Vector2(-125, -75)
			$Circle/Icons/Metal.position = Vector2(80,70)
			$Circle/Icons/Armored.position = Vector2(-80,70)
		0:
			$Circle/Icons/Wood.position = Vector2(0,-178)
			$Circle/Icons/Stone.position = Vector2(125, -75)
			$Circle/Icons/Demolish.position = Vector2(-125, -75)
			$Circle/Icons/Metal.position = Vector2(80,70)
			$Circle/Icons/Armored.position = Vector2(-80,70)
		1:
			$Circle/Icons/Wood.position = Vector2(0,-162)
			$Circle/Icons/Stone.position = Vector2(140, -82)
			$Circle/Icons/Demolish.position = Vector2(-125, -75)
			$Circle/Icons/Metal.position = Vector2(80,70)
			$Circle/Icons/Armored.position = Vector2(-80,70)
		2: 
			$Circle/Icons/Wood.position = Vector2(0,-162)
			$Circle/Icons/Stone.position = Vector2(125, -75)
			$Circle/Icons/Demolish.position = Vector2(-125, -75)
			$Circle/Icons/Metal.position = Vector2(90,80)
			$Circle/Icons/Armored.position = Vector2(-80,70)
		3:
			$Circle/Icons/Wood.position = Vector2(0,-162)
			$Circle/Icons/Stone.position = Vector2(125, -75)
			$Circle/Icons/Demolish.position = Vector2(-125, -75)
			$Circle/Icons/Metal.position = Vector2(80,70)
			$Circle/Icons/Armored.position = Vector2(-90,80)
		4: 
			$Circle/Icons/Wood.position = Vector2(0,-162)
			$Circle/Icons/Stone.position = Vector2(125, -75)
			$Circle/Icons/Demolish.position = Vector2(-140, -82)
			$Circle/Icons/Metal.position = Vector2(80,70)
			$Circle/Icons/Armored.position = Vector2(-80,70)


func set_active_buttons():
	match tile_node.tier:
		"twig":
			get_node("Circle/0").set_enabled()
			get_node("Circle/1").set_enabled()
			get_node("Circle/2").set_enabled()
			get_node("Circle/3").set_enabled()
			get_node("Circle/4").initialize()
		"wood":
			get_node("Circle/0").set_disabled()
			get_node("Circle/1").set_enabled()
			get_node("Circle/2").set_enabled()
			get_node("Circle/3").set_enabled()
			get_node("Circle/4").initialize()
		"stone":
			get_node("Circle/0").set_disabled()
			get_node("Circle/1").set_disabled()
			get_node("Circle/2").set_enabled()
			get_node("Circle/3").set_enabled()
			get_node("Circle/4").initialize()
		"metal":
			get_node("Circle/0").set_disabled()
			get_node("Circle/1").set_disabled()
			get_node("Circle/2").set_disabled()
			get_node("Circle/3").set_enabled()
			get_node("Circle/4").initialize()
		"armored":
			get_node("Circle/0").set_disabled()
			get_node("Circle/1").set_disabled()
			get_node("Circle/2").set_disabled()
			get_node("Circle/3").set_disabled()
			get_node("Circle/4").initialize()



func destroy():
	Server.player_node.get_node("Camera2D").set_process_input(true) 
	hide()
	if is_instance_valid(tile_node):
		tile_node.remove_icon()
	if current_index != -1:
		change_tile()
		current_index = -1

func change_tile():
	if return_valid_building_upgrade(current_index):
		var new_tier = buttons[current_index]
		tile_node.tier = new_tier
		tile_node.set_type()
		remove_materials(current_index)
		sound_effects.stream = load("res://Assets/Sound/Sound effects/Building/crafting.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects.play()
		if new_tier != "demolish":
			InstancedScenes.play_upgrade_building_effect(location)
		else:
			InstancedScenes.play_remove_building_effect(location)
	else:
		sound_effects.stream = load("res://Assets/Sound/Sound effects/Farming/ES_Error Tone Chime 6 - SFX Producer.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -20)
		sound_effects.play()

func _input(event):
	if PlayerData.player_data["hotbar"].has(PlayerData.active_item_slot):
		if PlayerData.player_data["hotbar"][PlayerData.active_item_slot][0] == "hammer":
			if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and PlayerData.viewInventoryMode:
				if not event.is_pressed():
					destroy()
					yield(get_tree().create_timer(0.25), "timeout")
					PlayerData.viewInventoryMode = false

func remove_materials(index):
	match index:
		0:
			PlayerData.remove_material("wood", 20)
		1:
			PlayerData.remove_material("stone", 30)
		2:
			PlayerData.remove_material("bronze ingot", 20)
		3:
			PlayerData.remove_material("iron ingot", 25)
		4:
			pass # de,olish
			

func return_valid_building_upgrade(index):
	match index:
		0:
			return PlayerData.returnSufficentCraftingMaterial("wood", 20)
		1:
			return PlayerData.returnSufficentCraftingMaterial("stone", 30)
		2:
			return PlayerData.returnSufficentCraftingMaterial("bronze ingot", 20)
		3:
			return PlayerData.returnSufficentCraftingMaterial("iron ingot", 25)
		4:
			return true
