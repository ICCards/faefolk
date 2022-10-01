extends Control


onready var cam = get_node("/root/World/Players/" + Server.player_id + "/" + Server.player_id +  "/Camera2D")

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
	cam.set_process_input(false)
	PlayerInventory.viewInventoryMode = true


func _physics_process(delta):
	if not visible:
		return
	set_icon_position()
	if current_index != -1:
		$Title.show()
		$Title.text = buttons[current_index][0].to_upper() + buttons[current_index].substr(1,-1) + ":"
		$Resources.show()
		$Resources.text = "1 x Wood ( " + PlayerInventory.total_wood() + " )"
	else:
		$Title.hide()
		$Resources.hide()
		
		
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
	cam.set_process_input(true) 
	hide()
	if is_instance_valid(tile_node):
		tile_node.remove_icon()
	if current_index != -1:
		change_tile()
		current_index = -1

func change_tile():
	Server.world.play_upgrade_building_effect(location)
	var new_tier = buttons[current_index]
	tile_node.tier = new_tier
	tile_node.set_type()


func _input(event):
	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
		if PlayerInventory.hotbar[PlayerInventory.active_item_slot][0] == "hammer":
			if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and PlayerInventory.viewInventoryMode:
				if not event.is_pressed():
					destroy()
					yield(get_tree().create_timer(0.25), "timeout")
					PlayerInventory.viewInventoryMode = false
