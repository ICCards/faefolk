extends Node2D

onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")

var direction = "left"

func _ready():
	pass 


func _on_HurtBox_area_entered(area):
	var itemDrop = ItemDrop.instance()
	itemDrop.initItemDropType("sleeping bag")
	get_parent().call_deferred("add_child", itemDrop)
	itemDrop.global_position = global_position 
	queue_free()
