extends Control
#
#
#onready var cam = get_node("/root/World/Players/" + Server.player_id + "/" + Server.player_id +  "/Camera2D")
#
#var buttons = [null, "wood", "stone", "metal", "armored", "demolish"]
#var current_index = -1
#var location
#var tile_node
#
#func _ready():
#	hide()
#
#func initialize(_loc, _node):
#	current_index = -1
#	location = _loc
#	tile_node = _node
#	set_active_buttons()
#	show()
#	$Circle/AnimationPlayer.play("zoom")
#	cam.set_process_input(false)
#	PlayerInventory.viewInventoryMode = true
#
#
#func set_active_buttons():
#	match tile_node.tier:
#		"twig":
#			get_node("Circle/0").set_disabled()
#			get_node("Circle/1").set_enabled()
#			get_node("Circle/2").set_enabled()
#			get_node("Circle/3").set_enabled()
#			get_node("Circle/4").set_enabled()
#		"wood":
#			get_node("Circle/0").set_disabled()
#			get_node("Circle/1").set_disabled()
#			get_node("Circle/2").set_enabled()
#			get_node("Circle/3").set_enabled()
#			get_node("Circle/4").set_enabled()
#		"stone":
#			get_node("Circle/0").set_disabled()
#			get_node("Circle/1").set_disabled()
#			get_node("Circle/2").set_disabled()
#			get_node("Circle/3").set_enabled()
#			get_node("Circle/4").set_enabled()
#		"metal":
#			get_node("Circle/0").set_disabled()
#			get_node("Circle/1").set_disabled()
#			get_node("Circle/2").set_disabled()
#			get_node("Circle/3").set_disabled()
#			get_node("Circle/4").set_enabled()
#		"armored":
#			get_node("Circle/0").set_disabled()
#			get_node("Circle/1").set_disabled()
#			get_node("Circle/2").set_disabled()
#			get_node("Circle/3").set_disabled()
#			get_node("Circle/4").set_disabled()
#
#
#
#func destroy():
#	cam.set_process_input(true) 
#	hide()
#	if is_instance_valid(tile_node):
#		tile_node.remove_icon()
#	if current_index != -1:
#		change_tile()
#		current_index = -1
#
#func change_tile():
#	Server.world.play_upgrade_building_effect(location)
#	var new_tier = buttons[current_index]
#	tile_node.tier = new_tier
#	tile_node.set_type()
#
#
#func _input(event):
#	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
#		if PlayerInventory.hotbar[PlayerInventory.active_item_slot][0] == "hammer":
#			if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and PlayerInventory.viewInventoryMode:
#				if not event.is_pressed():
#					destroy()
#					yield(get_tree().create_timer(0.25), "timeout")
#					PlayerInventory.viewInventoryMode = false
