extends Node2D


onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
onready var fence_tiles = get_node("/root/PlayerHomeFarm/DecorationTiles/FenceAutoTile")
onready var placable_object_tiles = get_node("/root/PlayerHomeFarm/DecorationTiles/PlacableObjectTiles")
onready var valid_tiles = get_node("/root/PlayerHomeFarm/GroundTiles/ValidTilesForObjectPlacement")


var location
var item_name

func initialize(name, loc):
	item_name = name
	location = loc


func _on_HurtBox_area_entered(area):
	PlayerFarmApi.remove_placable_object(location)
	if item_name == "wood fence":
		fence_tiles.set_cellv(location, -1)
		fence_tiles.update_bitmask_region()
	else:
		placable_object_tiles.set_cellv(location, -1)
	var itemDrop = ItemDrop.instance()
	itemDrop.initItemDropType(item_name)
	get_parent().call_deferred("add_child", itemDrop)
	itemDrop.global_position = global_position 
	queue_free()	

