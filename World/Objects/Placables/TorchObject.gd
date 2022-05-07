extends Node2D


onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")

var position_of_object

func initialize(pos):
	position_of_object = pos


func _on_BreakObjectBox_area_entered(area):
	PlayerInventory.remove_farm_object(position_of_object)
	var itemDrop = ItemDrop.instance()
	itemDrop.initItemDropType("torch")
	get_parent().call_deferred("add_child", itemDrop)
	itemDrop.global_position = global_position 
	queue_free()	
