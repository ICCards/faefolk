extends Node2D

onready var branch = $Branch

onready var TrunkHitEffect = preload("res://Globals/Effects/TrunkHitEffect.tscn")
onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
var rng = RandomNumberGenerator.new()
onready var world = get_tree().current_scene

var randomNum
var treeObject
var location

func initialize(variety, inputPos):
	randomNum = variety
	location = inputPos

func _ready():
	setTreeBranchType(randomNum)

func setTreeBranchType(num):
	if num <= 2:
		treeObject = Images.returnTreeObject('D')
	elif num <= 5:
		treeObject = Images.returnTreeObject('B')
	elif num <= 8:
		treeObject = Images.returnTreeObject('B')
	else:
		treeObject = Images.returnTreeObject('C')
	$Branch.texture = Images.tree_branch_objects[num]

func _on_BranchHurtBox_area_entered(area):
	$SoundEffects.stream = Global.stump_break
	$SoundEffects.play()
	$AnimationPlayer.play("break")
	initiateTreeHitEffect(treeObject, "trunk break", Vector2(-16, 32))
	intitiateItemDrop("Wood", Vector2(0, 0))
	PlayerInventory.remove_farm_object(location)
	yield($SoundEffects, "finished")
	queue_free()


### Effect functions		
		
func initiateTreeHitEffect(tree, effect, pos):
	var trunkHitEffect = TrunkHitEffect.instance()
	trunkHitEffect.init(tree, effect)
	add_child(trunkHitEffect)
	trunkHitEffect.global_position = global_position + pos 
	
func intitiateItemDrop(item, pos):
	var itemDrop = ItemDrop.instance()
	itemDrop.initItemDropType(item)
	world.call_deferred("add_child", itemDrop)
	itemDrop.global_position = global_position + pos
