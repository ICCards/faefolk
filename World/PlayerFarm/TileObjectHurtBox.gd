extends Node2D


onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
onready var fence_tiles = get_node("/root/PlayerHomeFarm/DecorationTiles/FenceAutoTile")
onready var placable_object_tiles = get_node("/root/PlayerHomeFarm/DecorationTiles/PlacableObjectTiles")
onready var valid_tiles = get_node("/root/PlayerHomeFarm/GroundTiles/ValidTilesForObjectPlacement")
onready var path_tiles = get_node("/root/PlayerHomeFarm/DecorationTiles/PlacablePathTiles")

var location
var item_name
var occupied_tiles


func initialize(name, loc):
	item_name = name
	location = loc
	
func _ready():
	set_dimensions()

func set_dimensions():
	if item_name == "large wood chest":
		scale.x = 2.0
		position = position +  Vector2(16, 0)

func _on_HurtBox_area_entered(area):
	$HurtBox/CollisionShape2D.set_deferred("disabled", true)
	$DetectObjectOverPathBox/CollisionShape2D.set_deferred("disabled", true)
	if item_name == "stone path":
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break stone.mp3")
	else: 
		$SoundEffects.stream = preload("res://Assets/Sound/Sound effects/objects/break wood.mp3")
	$SoundEffects.play()
	if item_name == "wood fence":
		PlayerFarmApi.remove_placable_object(location)
		fence_tiles.set_cellv(location, -1)
		fence_tiles.update_bitmask_region()
	elif item_name == "wood path" or item_name == "stone path":
		PlayerFarmApi.remove_path_object(location)
		path_tiles.set_cellv(location, -1)
	else:
		PlayerFarmApi.remove_placable_object(location)
		placable_object_tiles.set_cellv(location, -1)
	var itemDrop = ItemDrop.instance()
	itemDrop.initItemDropType(item_name)
	get_parent().call_deferred("add_child", itemDrop)
	itemDrop.global_position = global_position 
	yield($SoundEffects, "finished")
	queue_free()	



func _on_DetectObjectOverPathBox_area_entered(area):
	if item_name == "wood path" or item_name == "stone path":
		$HurtBox/CollisionShape2D.set_deferred("disabled", true)



func _on_DetectObjectOverPathBox_area_exited(area):
	if item_name == "wood path" or item_name == "stone path":
		yield(get_tree().create_timer(0.25), "timeout")
		$HurtBox/CollisionShape2D.set_deferred("disabled", false)
