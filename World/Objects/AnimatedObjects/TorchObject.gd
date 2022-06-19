extends Node2D


onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
onready var valid_tiles = get_node("/root/World/GeneratedTiles/ValidTiles")

var position_of_object

func initialize(pos):
	position_of_object = pos

func PlayEffect(player_id):
	valid_tiles.set_cellv(position_of_object, 0)
	queue_free()

func _on_BreakObjectBox_area_entered(area):
	var data = {"id": name}
	Server.action("ON_HIT", data)
	valid_tiles.set_cellv(position_of_object, 0)
	var itemDrop = ItemDrop.instance()
	itemDrop.initItemDropType("torch")
	get_parent().call_deferred("add_child", itemDrop)
	itemDrop.global_position = global_position 
	queue_free()	
