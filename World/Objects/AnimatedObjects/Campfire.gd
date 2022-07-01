extends Node2D


onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
onready var valid_tiles = get_node("/root/World/GeneratedTiles/ValidTiles")

var loc
var item_name = "campfire"
func initialize(_loc):
	loc = _loc

func PlayEffect(player_id):
	valid_tiles.set_cellv(loc, 0)
	queue_free()

func _on_BreakObjectBox_area_entered(area):
	var data = {"id": name, "n": "decorations","t":"ON_HIT","name":item_name,"item":"placable"}
	print("sending ON_HIT")
	Server.action("ON_HIT", data)
	valid_tiles.set_cellv(loc, 0)
	var itemDrop = ItemDrop.instance()
	itemDrop.initItemDropType(item_name)
	get_parent().call_deferred("add_child", itemDrop)
	itemDrop.global_position = global_position 
	queue_free()
